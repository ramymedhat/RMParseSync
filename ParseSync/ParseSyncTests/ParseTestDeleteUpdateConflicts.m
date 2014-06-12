//
//  ParseTestDeleteUpdateConflicts.m
//  ParseSync
//
//  Created by Ahmed AlMoraly on 6/11/14.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseMultipleDeviceTestCase.h"
#import "TKDB+Multiple.h"

TKDB *currentDB;
TKDBCacheManager *currentCacheManager;

@implementation TKDB (Multiple)

+ (TKDB *)defaultDB {
    return currentDB;
}

@end

@implementation TKDBCacheManager (Multiple)

+ (TKDBCacheManager *)sharedManager {
    return currentCacheManager;
}

@end

@interface ParseTestDeleteUpdateConflicts : ParseMultipleDeviceTestCase
@end

@implementation ParseTestDeleteUpdateConflicts


- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    /*
     1- create template on D1
     2- sync D1
     3- sync D2
     
     ensure D2 is synchronized with D1
     */
    
    currentDB = self.d1_db;
    currentCacheManager = self.d1_cacheManager;
    
    [self createTemplateObjectsInContext:self.d1_db.rootContext];
    
    StartBlock();
    
    [[self.d1_db sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"setup test failed with error: %@", task.error);
            EndBlock();
        }
        else {
            currentDB = self.d2_db;
            currentCacheManager = self.d2_cacheManager;
            return [[self.d2_db sync] continueWithBlock:^id(BFTask *task) {
                if (task.isCancelled) {
                    
                }
                else if (task.error) {
                    
                    XCTFail(@"setup test failed with error: %@", task.error);
                    EndBlock();
                }
                else {
                    EndBlock();
                }
                return nil;
            }];
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testDeleteUpdateConflict {
    
    /*
     1-  Delete Behavior from D1
     2-  Update Same Behavior from D2
     3-  Sync D1
     4-  Sync D2
     */
    
    NSString *behaviorServerID;
    
    // Device one ==> Delete
    {
        currentDB = self.d1_db;
        currentCacheManager = self.d1_cacheManager;
        TKBehavior *behavior = [self getbehaviorFromContext:self.d1_db.rootContext];
        behaviorServerID = behavior.serverObjectID;
        
        // delete
        NSError *error;
        [self.d1_db.rootContext deleteObject:behavior];
        [self.d1_db.rootContext save:&error];
        if (error) {
            XCTFail(@"Couldn't save Deletion in Device one :%@", error);
        }
    }
    
    // Device two ==> Update
    {
        currentDB = self.d2_db;
        currentCacheManager = self.d2_cacheManager;
        NSError *error;
        TKBehavior *behavior = [self getbehaviorFromContext:self.d2_db.rootContext];
        // update
        behavior.notes = @"edited notes";
        
        [self.d2_db.rootContext save:&error];
        if (error) {
            XCTFail(@"Couldn't save Deletion in Device two");
        }
    }
    
    // Sync Device one
    
    StartBlock();
    
    currentDB = self.d1_db;
    currentCacheManager = self.d1_cacheManager;
    [[self.d1_db sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Device one failed with error: %@", task.error);
            EndBlock();
        }
        else {
            // check for deleted object on Parse
            PFObject *PF_Behavior = [PFObject objectWithoutDataWithClassName:[TKBehavior entityName] objectId:behaviorServerID];
            
            [PF_Behavior fetchIfNeeded];
            
            XCTAssertTrue([[PF_Behavior valueForKey:kTKDBIsDeletedField] boolValue], @"Device one failure: Behavior object is not deleted on cloud.");
            
            currentDB = self.d2_db;
            currentCacheManager = self.d2_cacheManager;
            // Sync Device two
            return [[self.d2_db sync] continueWithBlock:^id(BFTask *task) {
                if (task.isCancelled) {
                    
                }
                else if (task.error) {
                    NSCoreDataError
                    XCTFail(@"Sync Device two failed with error: %@", task.error);
                    EndBlock();
                }
                else {
                    // check for updated object Device two
                    
                    // check for deleted object on Parse
                    PFObject *PF_Behavior = [PFObject objectWithoutDataWithClassName:[TKBehavior entityName] objectId:behaviorServerID];
                    
                    [PF_Behavior fetchIfNeeded];
                    
                    XCTAssertFalse([[PF_Behavior valueForKey:kTKDBIsDeletedField] boolValue], @"Device two failure: Behavior object is deleted on cloud.");
                    
                    TKBehavior *behavior = [self getbehaviorFromContext:self.d2_db.rootContext];
                    XCTAssertEqual(behavior.notes, @"edited notes", @"Device two failure: sync override my updates :(");
                    
                    currentDB = self.d1_db;
                    currentCacheManager = self.d1_cacheManager;
                    // Sync Device one again
                    return [[self.d1_db sync] continueWithBlock:^id(BFTask *task) {
                        if (task.isCancelled) {
                            
                        }
                        else if (task.error) {
                            XCTFail(@"Sync Device one failed with error: %@", task.error);
                            EndBlock();
                        }
                        else {
                            // check for updated object Device one
                            TKBehavior *behavior = [self getbehaviorFromContext:self.d1_db.rootContext];
                            XCTAssertNotNil(behavior, @"Device one stage 2 failure: couldn't found any behavior  :(");
                            XCTAssertEqual(behavior.notes, @"edited notes", @"Device one stage 2 failure: sync override my updates :(");
                            
                        }
                        
                        EndBlock();
                        return nil;
                    }];
                }
                return nil;
            }];
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
    
}

- (void)createTemplateObjectsInContext:(NSManagedObjectContext *)context {
    TKClassroom *classroom = [TKClassroom insertInManagedObjectContext:context];
    classroom.title = @"Mathematics";
    classroom.classroomId = [self getAUniqueID];
    classroom.tkID = [self getAUniqueID];
    
    TKStudent *student = [TKStudent insertInManagedObjectContext:context];
    student.firstName = @"Walter";
    student.lastName = @"White";
    student.studentId = [self getAUniqueID];
    student.tkID = [self getAUniqueID];
    
    TKStudent *student2 = [TKStudent insertInManagedObjectContext:context];
    student2.firstName = @"Skylar";
    student2.lastName = @"White";
    student2.studentId = [self getAUniqueID];
    student2.tkID = [self getAUniqueID];
    
    [classroom addStudentsObject:student];
    [classroom addStudentsObject:student2];
    
    TKBehaviorType *positive = [TKBehaviorType insertInManagedObjectContext:context];
    positive.behaviortypeId = [self getAUniqueID];
    positive.isPositive = @YES;
    positive.title = @"Good";
    positive.behaviortypeId = [self getAUniqueID];
    positive.tkID = [self getAUniqueID];

    TKBehavior *behavior = [TKBehavior insertInManagedObjectContext:context];
    [behavior setBehaviorType:positive];
    behavior.notes = @"good boy";
    behavior.behaviorDate = [NSDate date];
    behavior.behaviorId = [self getAUniqueID];
    behavior.student = student;
    behavior.classroom = classroom;
    behavior.tkID = [self getAUniqueID];
    
    NSError *error;
    BOOL saved = [context save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
}

- (id)getbehaviorFromContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[TKBehavior entityName]];
    // Specify criteria for filtering which objects to fetch
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return [fetchedObjects lastObject];
}

@end
