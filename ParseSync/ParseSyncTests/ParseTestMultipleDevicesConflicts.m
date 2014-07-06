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
#import "TKAttendanceType.h"
#import "TKLesson.h"
#import "TKAttendance.h"

TKDB *currentDB;
TKDBCacheManager *currentCacheManager;

typedef enum : NSUInteger {
    TKDevice1,
    TKDevice2,
} TKDevice;

@implementation TKDB (Multiple)

#define LAST_SYNC_DATE_HASH [NSString stringWithFormat:@"%lu-%@", (unsigned long)self.hash, @"lastSyncDate"]

#if MULTIPLE_DEVICES

+ (TKDB *)defaultDB {
    if (!currentDB) {
        currentDB = [[TKDB alloc] init];
    }
    return currentDB;
}

- (NSDate*) lastSyncDate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SYNC_DATE_HASH];
    if (!date) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:LAST_SYNC_DATE_HASH];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SYNC_DATE_HASH];
}

- (void) setLastSyncDate:(NSDate*)date {
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:LAST_SYNC_DATE_HASH];
}

#endif

@end

@implementation TKDBCacheManager (Multiple)

#if MULTIPLE_DEVICES
+ (TKDBCacheManager *)sharedManager {
    if (!currentCacheManager) {
        currentCacheManager = [[TKDBCacheManager alloc] init];
    }
    return currentCacheManager;
}

#endif

@end

@interface ParseTestMultipleDevicesConflicts : ParseMultipleDeviceTestCase
@end

@implementation ParseTestMultipleDevicesConflicts

- (void)setCurrentDevice:(TKDevice)device {
    switch (device) {
        case TKDevice1:
            currentDB = self.d1_db;
            currentCacheManager = self.d1_cacheManager;
            break;
        case TKDevice2:
            currentDB = self.d2_db;
            currentCacheManager = self.d2_cacheManager;
            break;
            
        default:
            break;
    }
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [self setCurrentDevice:TKDevice1];
    
    TKAttendanceType *present = [TKAttendanceType insertInManagedObjectContext:currentDB.rootContext];
    present.title = @"Present";
    present.color = @"001100";
    present.attendancetypeId = [self getAUniqueID];
    present.createdDate = [NSDate date];
    
    TKAttendanceType *absent = [TKAttendanceType insertInManagedObjectContext:currentDB.rootContext];
    absent.title = @"Absent";
    absent.color = @"110000";
    absent.attendancetypeId = [self getAUniqueID];
    absent.createdDate = [NSDate date];
    
    TKBehaviorType *positive = [TKBehaviorType insertInManagedObjectContext:currentDB.rootContext];
    positive.title = @"Positive";
    positive.isPositive = @YES;
    positive.behaviortypeId = [self getAUniqueID];
    
    TKBehaviorType *negative = [TKBehaviorType insertInManagedObjectContext:currentDB.rootContext];
    negative.title = @"Negative";
    negative.isPositive = @NO;
    negative.behaviortypeId = [self getAUniqueID];
    
    
    NSError *error;
    BOOL saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }

    StartBlock();
    [[self.d1_db sync] continueWithSuccessBlock:^id(BFTask *task) {
        EndBlock();
        return nil;
    }];
    WaitUntilBlockCompletes();
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDeleteCascades {
    [self setUpDevicesWithClassrooms];
    
    [self setCurrentDevice:TKDevice1];
    // delete classroom 1
    {
        TKClassroom *classroom = [[self getObjectsForEntity:@"Classroom" predicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"] inContext:currentDB.rootContext] lastObject];
        [currentDB.rootContext deleteObject:classroom];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    [self setCurrentDevice:TKDevice2];
    {
        TKClassroom *classroom = [[self getObjectsForEntity:@"Classroom" predicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"] inContext:currentDB.rootContext] lastObject];
        
        classroom.title = @"Mathimatics Edited";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // check for lessons
        [self setCurrentDevice:TKDevice1];
        TKClassroom *classroom = [[self getObjectsForEntity:@"Classroom" predicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"] inContext:currentDB.rootContext] lastObject];
        XCTAssertNotNil(classroom, @"D1: Failed to update deleted classroom");
        // check for lessons
        NSSet *lessons = classroom.lessons;
        XCTAssert(lessons.count > 0, @"D1: Fialed to update cascaded deleted lesosns");
        
        
    }];
    WaitUntilBlockCompletes();
}

- (void)testAddClassroomWithImage {
    TKClassroom *classroom;
    [self setCurrentDevice:TKDevice1];
    {
        classroom = [self createClassroomWithImageInContext:currentDB.rootContext];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithBlock:^id(BFTask *task) {
        
        [self setCurrentDevice:TKDevice1];
        classroom.image_BinaryPathKey = [self newImagePath];
        [currentDB.rootContext save:nil];
        
        return [[self runSyncWithStartingDevice:TKDevice1] continueWithBlock:^id(BFTask *task) {
            EndBlock();
            return nil;
        }];
        
    }];
    
    WaitUntilBlockCompletes();
}


//Add Class1 in TK1, Add Class2 in TK2, Sync TK1, Sync TK2
- (void)testAddClassroom {
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        TKClassroom *classroom = [self createClassroomInContext:currentDB.rootContext];
        classroom.image_BinaryPathKey = [self newImagePath];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        TKClassroom *classroom = [self createClassroomInContext:currentDB.rootContext];
        classroom.image_BinaryPathKey = [self newImagePath];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKClassroom entityName]];
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 2, @"Sync Failuer: Server should have 2 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d1_count, 2, @"Sync Failuer: D1 should have 2 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d2_count, 2, @"Sync Failuer: D2 should have 2 objects got: %li instead", (long)d2_count);
        EndBlock();
        return nil;
    }];

    WaitUntilBlockCompletes();
}
- (void)testAddClassroomLatestSyncFirst {
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        TKClassroom *classroom = [self createClassroomInContext:currentDB.rootContext];
        classroom.image_BinaryPathKey = [self newImagePath];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        TKClassroom *classroom = [self createClassroomInContext:currentDB.rootContext];
        classroom.image_BinaryPathKey = [self newImagePath];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKClassroom entityName]];
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 2, @"Sync Failuer: Server should have 2 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d1_count, 2, @"Sync Failuer: D1 should have 2 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d2_count, 2, @"Sync Failuer: D2 should have 2 objects got: %li instead", (long)d2_count);
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Edit Class1 in TK1, Edit Class2 in TK2, Sync TK1, Sync TK2
- (void)testEditClassroom {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Edited1";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        
        class.title = @"Edited2";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *firstClass = [d1_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"");
        TKClassroom *secondClass = [d1_classes lastObject];
        XCTAssert([secondClass.title isEqualToString:@"Edited1"], @"");
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        firstClass = [d2_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"");
        secondClass = [d2_classes lastObject];
        XCTAssert([secondClass.title isEqualToString:@"Edited1"], @"Sync");
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}
- (void)testEditClassroomLatestSyncFirst {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];

        class.title = @"Edited1";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        
        class.title = @"Edited2";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *firstClass = [d1_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"");
        TKClassroom *secondClass = [d1_classes lastObject];
        XCTAssert([secondClass.title isEqualToString:@"Edited1"], @"");
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        firstClass = [d2_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"");
        secondClass = [d2_classes lastObject];
        XCTAssert([secondClass.title isEqualToString:@"Edited1"], @"Sync");
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Edit Class1 in TK1, Edit Class1 in TK2, Sync TK1, Sync TK2, Sync TK1: Last Synced Data should win (TK2 Wins)
- (void)testEditSameClassroom {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Edited1";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Edited2";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *firstClass = [d1_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"D1 Failed: classroom title should be 'Edited2' instead of :%@", firstClass.title);

        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        firstClass = [d2_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"D2 Failed: classroom title should be 'Edited2' instead of :%@", firstClass.title);
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}
- (void)testEditSameClassroomLatestSyncFirst {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Edited1";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Edited2";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *firstClass = [d1_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"D1 Failed: classroom title should be 'Edited2' instead of :%@", firstClass.title);
        
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        firstClass = [d2_classes firstObject];
        XCTAssert([firstClass.title isEqualToString:@"Edited2"], @"D2 Failed: classroom title should be 'Edited2' instead of :%@", firstClass.title);
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Delete Class1 in TK1, Delete Class2 in TK2, Sync TK1, Sync TK2
- (void)testDeleteClassroom {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        [currentDB.rootContext deleteObject:class];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        
        [currentDB.rootContext deleteObject:class];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKClassroom entityName]];
        [query whereKey:@"isDeleted" equalTo:@NO];
        
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 0, @"Sync Failuer: Server should have 0 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d1_count, 0, @"Sync Failuer: D1 should have 0 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d2_count, 0, @"Sync Failuer: D2 should have 0 objects got: %li instead", (long)d2_count);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}
- (void)testDeleteClassroomLatestSyncFirst {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        [currentDB.rootContext deleteObject:class];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        
        [currentDB.rootContext deleteObject:class];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKClassroom entityName]];
        [query whereKey:@"isDeleted" equalTo:@NO];
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 0, @"Sync Failuer: Server should have 0 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d1_count, 0, @"Sync Failuer: D1 should have 0 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d2_count, 0, @"Sync Failuer: D2 should have 0 objects got: %li instead", (long)d2_count);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Edit Class1 in TK1, Delete Class1 in TK2, Sync TK1, Sync TK2, Sync TK1: Last Synced Data should win (TK2 Wins, Class is deleted)
- (void)testUpdateDeleteClassroom {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Update";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        [currentDB.rootContext deleteObject:class];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKClassroom entityName]];
        [query whereKey:@"isDeleted" equalTo:@NO];
        
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 1, @"Sync Failure: Server should have 1 objects got: %lu instead", (unsigned long)parseObjs.count);
        XCTAssert([[parseObjs lastObject][@"title"] isEqualToString:@"Physics"], @"Sync Failure: Server object should be named Physics instead of: %@", [parseObjs lastObject][@"title"]);
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d1_count, 1, @"Sync Failuer: D1 should have 1 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d2_count, 1, @"Sync Failuer: D2 should have 1 objects got: %li instead", (long)d2_count);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}
- (void)testUpdateDeleteClassroomLatestSyncFirst {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.title == %@", @"Mathematics"]] lastObject];
        
        class.title = @"Update";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        [currentDB.rootContext deleteObject:class];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKClassroom entityName]];
        [query whereKey:@"isDeleted" equalTo:@NO];
        
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 1, @"Sync Failure: Server should have 1 objects got: %lu instead", (unsigned long)parseObjs.count);
        XCTAssert([[parseObjs lastObject][@"title"] isEqualToString:@"Physics"], @"Sync Failure: Server object should be named Physics instead of: %@", [parseObjs lastObject][@"title"]);
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d1_count, 1, @"Sync Failuer: D1 should have 1 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKClassroom entityName]] error:nil];
        XCTAssertEqual(d2_count, 1, @"Sync Failuer: D2 should have 1 objects got: %li instead", (long)d2_count);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Add Student1 - Class1 in TK1, Add Student2 - Class2 in TK2, Sync TK1, Sync TK2
- (void)testAddStudentInClassroom {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKStudent *student1 = [self createStudentInContext:currentDB.rootContext];
        student1.image_BinaryPathKey = [self newImagePath];
        student1.firstName = @"student";
        student1.lastName = @"1";
        
        [student1 addClassroomsObject:class];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        
        TKStudent *student2 = [self createStudentInContext:currentDB.rootContext];
        student2.firstName = @"student";
        student2.lastName = @"2";
        student2.image_BinaryPathKey = [self newImagePath];

        [student2 addClassroomsObject:class];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKStudent entityName]];
        
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 3, @"Sync Failure: Server should have 3 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSInteger d1_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKStudent entityName]] error:nil];
        XCTAssertEqual(d1_count, 3, @"Sync Failuer: D1 should have 3 objects got: %li instead", (long)d1_count);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSInteger d2_count = [currentDB.rootContext countForFetchRequest:[NSFetchRequest fetchRequestWithEntityName:[TKStudent entityName]] error:nil];
        XCTAssertEqual(d2_count, 3, @"Sync Failuer: D2 should have 3 objects got: %li instead", (long)d2_count);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Add Student1 - Class1 in TK1, Add Student2 - Class1 in TK2, Sync TK1, Sync TK2
- (void)testAddStudentInSameClassroom {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKStudent *student1 = [self createStudentInContext:currentDB.rootContext];
        student1.firstName = @"student";
        student1.lastName = @"1";
        student1.image_BinaryPathKey = [self newImagePath];

        [student1 addClassroomsObject:class];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKStudent *student2 = [self createStudentInContext:currentDB.rootContext];
        student2.firstName = @"student";
        student2.lastName = @"2";
        student2.image_BinaryPathKey = [self newImagePath];

        [student2 addClassroomsObject:class];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKStudent entityName]];
        
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 3, @"Sync Failure: Server should have 3 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *firstClass = [[d1_classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        XCTAssertEqual([firstClass.students count], 3, @"Sync Failuer: D1 classroom should have 3 students got: %lu instead", (unsigned long)[firstClass.students count]);

        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        firstClass = [[d2_classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        XCTAssertEqual([firstClass.students count], 3, @"Sync Failuer: D2 classroom should have 3 students got: %lu instead", (unsigned long)[firstClass.students count]);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}
- (void)testAddStudentInSameClassroomLatestSyncFirst {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKStudent *student1 = [self createStudentInContext:currentDB.rootContext];
        student1.firstName = @"student";
        student1.lastName = @"1";
        student1.image_BinaryPathKey = [self newImagePath];

        [student1 addClassroomsObject:class];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *class = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKStudent *student2 = [self createStudentInContext:currentDB.rootContext];
        student2.firstName = @"student";
        student2.lastName = @"2";
        student2.image_BinaryPathKey = [self newImagePath];

        [student2 addClassroomsObject:class];
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // both devices should be in sync now
        // check Parse
        PFQuery *query = [PFQuery queryWithClassName:[TKStudent entityName]];
        
        NSArray *parseObjs = [query findObjects];
        XCTAssertEqual(parseObjs.count, 3, @"Sync Failure: Server should have 3 objects got: %lu instead", (unsigned long)parseObjs.count);
        
        
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *firstClass = [[d1_classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        XCTAssertEqual([firstClass.students count], 3, @"Sync Failuer: D1 classroom should have 3 students got: %lu instead", (unsigned long)[firstClass.students count]);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        firstClass = [[d2_classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        XCTAssertEqual([firstClass.students count], 3, @"Sync Failuer: D2 classroom should have 3 students got: %lu instead", (unsigned long)[firstClass.students count]);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

//Edit Student1 in TK1, Edit Student1 in TK2, Sync TK1, Sync TK2, Sync TK1: Last Synced Data should win (TK2 Wins)
- (void)testEditSameStudent {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [[students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        student.firstName = @"EditedWalter";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [[students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        student.lastName = @"EditedWhite";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [d1_students firstObject];
        XCTAssert([student.firstName isEqualToString:@"EditedWalter"], @"D1 Failed: student firstname should be 'EditedWalter' got '%@' instead", student.firstName);
        XCTAssert([student.lastName isEqualToString:@"EditedWhite"], @"D1 Failed: student firstname should be 'EditedWhite' got '%@' instead", student.lastName);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        student = [d2_students firstObject];
        XCTAssert([student.firstName isEqualToString:@"EditedWalter"], @"D2 Failed: student firstname should be 'EditedWalter' got '%@' instead", student.firstName);
        XCTAssert([student.lastName isEqualToString:@"EditedWhite"], @"D2 Failed: student firstname should be 'EditedWhite' got '%@' instead", student.lastName);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}
- (void)testEditSameStudentLatestSyncFirst {
    
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [[students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        student.firstName = @"EditedWalter";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [[students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        student.lastName = @"EditedWhite";
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice2] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [d1_students firstObject];
        XCTAssert([student.firstName isEqualToString:@"EditedWalter"], @"D1 Failed: student firstname should be 'EditedWalter' got '%@' instead", student.firstName);
        XCTAssert([student.lastName isEqualToString:@"EditedWhite"], @"D1 Failed: student firstname should be 'EditedWhite' got '%@' instead", student.lastName);
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        student = [d2_students firstObject];
        XCTAssert([student.firstName isEqualToString:@"EditedWalter"], @"D2 Failed: student firstname should be 'EditedWalter' got '%@' instead", student.firstName);
        XCTAssert([student.lastName isEqualToString:@"EditedWhite"], @"D2 Failed: student firstname should be 'EditedWhite' got '%@' instead", student.lastName);
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testDeleteUpdateStudent {
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [[students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        [currentDB.rootContext deleteObject:student];
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [[students filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        student.lastName = @"EditedWhite";
        TKAttendance *attendance = [student.attendances anyObject];
        NSArray *types = [self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName]];
        TKAttendanceType *type = [[types filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Late"]] lastObject];
        attendance.type = type;
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }

    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // check D1
        [self setCurrentDevice:TKDevice1];
        NSArray *d1_students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        TKStudent *student = [d1_students firstObject];
        XCTAssert([student.lastName isEqualToString:@"EditedWhite"], @"D1 Failed: student firstname should be 'EditedWhite' got '%@' instead", student.lastName);
        TKAttendance *attendance = [student.attendances anyObject];
        XCTAssert([attendance.type.title isEqualToString:@"Late"] , @"");
        
        // check D2
        [self setCurrentDevice:TKDevice2];
        NSArray *d2_students = [self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]];
        student = [d2_students firstObject];
        XCTAssert([student.lastName isEqualToString:@"EditedWhite"], @"D2 Failed: student firstname should be 'EditedWhite' got '%@' instead", student.lastName);
        
        attendance = [student.attendances anyObject];
        XCTAssert([attendance.type.title isEqualToString:@"Late"] , @"");
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();
    
}

- (void)testDeleteUpdateBehavior {
    [self setCurrentDevice:TKDevice1];
    // create Classroom, student then sync
    TKClassroom *class = [self createClassroomWithImageInContext:currentDB.rootContext];
    class.title = @"AYA";
    
    NSError *error;
    BOOL saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    TKStudent *student = [self createStudentInContext:currentDB.rootContext];
    student.firstName = @"AYA";
    
    [class addStudentsObject:student];
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }

    TKBehaviorType *positive = [[self getObjectsInCurrentDeviceForEntity:[TKBehaviorType entityName] withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKBehaviorTypeAttributes.isPositive, @YES]] lastObject];
    
    TKBehavior *behavior = [TKBehavior insertInManagedObjectContext:currentDB.rootContext];
    behavior.behaviorId = [self getAUniqueID];
    behavior.behaviorType = positive;
    behavior.student = student;
    behavior.behaviorDate = [NSDate date];
    behavior.classroom = class;
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithBlock:^id(BFTask *task) {
        [self setCurrentDevice:TKDevice1];
        {
            // get the student
            TKStudent *student = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]] lastObject];
            TKBehavior *behavior = [student.behaviors anyObject];
            
            [currentDB.rootContext deleteObject:behavior];
            NSError *error;
            BOOL saved = [currentDB.rootContext save:&error];
            if (error || !saved) {
                XCTFail(@"Faild to save %@", error);
            }

        }
        [self setCurrentDevice:TKDevice2];
        {
            // get the student
            TKStudent *student = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]] lastObject];
            TKBehavior *behavior = [student.behaviors anyObject];
            
            behavior.notes = @"I AM RIGHT";
            
            NSError *error;
            BOOL saved = [currentDB.rootContext save:&error];
            if (error || !saved) {
                XCTFail(@"Faild to save %@", error);
            }
            
        }
        return [[self runSyncWithStartingDevice:TKDevice1] continueWithBlock:^id(BFTask *task) {
            
            [self setCurrentDevice:TKDevice1];
            {
                // get the student
                TKStudent *student = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]] lastObject];
                TKBehavior *behavior = [student.behaviors anyObject];
                
                XCTAssertNotNil(behavior, @"Faild to revive the behavior on Device 1");
                
            }
            
            [self setCurrentDevice:TKDevice2];
            {
                // get the student
                TKStudent *student = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]] lastObject];
                TKBehavior *behavior = [student.behaviors anyObject];
                
                XCTAssertNotNil(behavior, @"Faild to update the behavior on Device 2");
                
            }

            
            EndBlock();
            return nil;
        }];
    }];
    
    WaitUntilBlockCompletes();
    

}

- (void)testAddLessonWithAttendance {
    [self setCurrentDevice:TKDevice1];
    // create Classroom, student then sync
    TKClassroom *class = [self createClassroomWithImageInContext:currentDB.rootContext];
    class.title = @"AYA";

    NSError *error;
    BOOL saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    TKStudent *student = [self createStudentInContext:currentDB.rootContext];
    student.firstName = @"AYA";
    
    [class addStudentsObject:student];
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    TKLesson *lesson = [TKLesson insertInManagedObjectContext:currentDB.rootContext];
    lesson.lessonStartDate = [NSDate date];
    lesson.lessonStartTime = [NSDate date];
    lesson.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson.lessonId = [self getAUniqueID];
    lesson.createdDate = [NSDate date];
    
    [class addLessonsObject:lesson];
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    // get type
    TKAttendanceType *type = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName]] lastObject];
    
    // create attendance
    TKAttendance *attendance = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
    attendance.attendanceId = [self getAUniqueID];
    
    attendance.student = student;
    attendance.lesson = lesson;
    attendance.type = type;
    attendance.classroom = class;
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        
        [self setCurrentDevice:TKDevice1];
        {
            // get classroom
            NSArray *attendances = [self getObjectsInCurrentDeviceForEntity:[TKAttendance entityName]];
            
            for (TKAttendance *attendance in attendances) {
                XCTAssertNotNil(attendance.lesson, @"Failed: all attendances should have a lesson");
                TKLesson *lesson = attendance.lesson;
                XCTAssertNotNil(lesson.lessonStartTime, @"Failed: lesson must have a start time");
            }
        }
        
        [self setCurrentDevice:TKDevice2];
        {
            // get classroom
            NSArray *attendances = [self getObjectsInCurrentDeviceForEntity:[TKAttendance entityName]];
            
            for (TKAttendance *attendance in attendances) {
                XCTAssertNotNil(attendance.lesson, @"Failed: all attendances should have a lesson");
                TKLesson *lesson = attendance.lesson;
                XCTAssertNotNil(lesson.lessonStartTime, @"Failed: lesson must have a start time");
            }
        }
        EndBlock();
        return nil;
    }];

    
    WaitUntilBlockCompletes();
}

- (void)testAddAttendanceDifferentSutdentsDifferentClasses {
    [self setUpDevicesWithClassrooms];
    
    // Device 1
    [self setCurrentDevice:TKDevice1];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *classroom = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        NSArray *types = [self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName]];
        TKAttendanceType *type = [[types filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Late"]] lastObject];
        // get a student
        TKStudent *student = [classroom.students anyObject];
        // get a lesson
        TKLesson *lesson = [classroom.lessons anyObject];
        
        
        TKAttendance *absent = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        absent.student = student;
        absent.lesson = lesson;
        absent.type = type;
        absent.classroom = classroom;
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    // Device 2
    [self setCurrentDevice:TKDevice2];
    {
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *classroom = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        
        NSArray *types = [self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName]];
        TKAttendanceType *type = [[types filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Sick"]] lastObject];
        // get a student
        TKStudent *student = [classroom.students anyObject];
        // get a lesson
        TKLesson *lesson = [classroom.lessons anyObject];
        
        
        TKAttendance *absent = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        absent.student = student;
        absent.lesson = lesson;
        absent.type = type;
        absent.classroom = classroom;
        
        NSError *error;
        [currentDB.rootContext save:&error];
        if (error) {
            XCTFail(@"Failed to save to database with error: %@", error);
        }
    }
    
    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithBlock:^id(BFTask *task) {

        [self setCurrentDevice:TKDevice1];
        // check for attendance
        NSArray *classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        TKClassroom *classroom = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        NSSet *attendances = classroom.attendances;
        XCTAssertEqual(attendances.count, 1, @"Failed to upload attendance");
        
        
        [self setCurrentDevice:TKDevice2];
        // check for attendance
        classes = [self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]];
        classroom = [[classes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Physics"]] lastObject];
        attendances = classroom.attendances;
        XCTAssertEqual(attendances.count, 1, @"Failed to upload attendance");
        
        EndBlock();
        return nil;
    }];
    
    WaitUntilBlockCompletes();

}

- (void)testEditAttendanceSameClassroom {
    [self setUpDevicesWithClassrooms];
    
    // take attendance and syn
    [self setCurrentDevice:TKDevice1];
    {
        TKClassroom *classroom = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName] withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKClassroomAttributes.title, @"Mathematics"]] lastObject];
        NSArray *types = [self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName]];
        TKAttendanceType *type = [[types filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Late"]] lastObject];
        
        // get a student
        TKStudent *student = [[classroom.students allObjects] firstObject];
        // get a lesson
        TKLesson *lesson = [[classroom.lessons allObjects] firstObject];
        
        TKAttendance *late = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        late.student = student;
        late.lesson = lesson;
        late.type = type;
        late.classroom = classroom;
        
        TKStudent *student2 = [[classroom.students allObjects] lastObject];
        // get a lesson
        TKLesson *lesson2 = [[classroom.lessons allObjects] lastObject];
        
        late = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        late.student = student2;
        late.lesson = lesson2;
        late.type = type;
        late.classroom = classroom;
        
        NSError *error;
        BOOL saved = [currentDB.rootContext save:&error];
        if (error || !saved) {
            XCTFail(@"Faild to save %@", error);
        }
    }
    
    [self setCurrentDevice:TKDevice2];
    {
        TKClassroom *classroom = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName] withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKClassroomAttributes.title, @"Physics"]] lastObject];
        NSArray *types = [self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName]];
        TKAttendanceType *type = [[types filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Sick"]] lastObject];
        
        // get a student
        TKStudent *student = [[classroom.students allObjects] firstObject];
        // get a lesson
        TKLesson *lesson = [[classroom.lessons allObjects] firstObject];
        
        TKAttendance *sick = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        sick.student = student;
        sick.lesson = lesson;
        sick.type = type;
        sick.classroom = classroom;
        
        NSError *error;
        BOOL saved = [currentDB.rootContext save:&error];
        if (error || !saved) {
            XCTFail(@"Faild to save %@", error);
        }
    }

    StartBlock();
    
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // Edit Attendance
        
        [self setCurrentDevice:TKDevice1];
        {
            TKClassroom *classroom = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName] withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKClassroomAttributes.title, @"Mathematics"]] lastObject];
            TKAttendanceType *sick = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Sick"]] lastObject];
            
            // get a student
            TKStudent *student = [[classroom.students filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKStudentAttributes.firstName, @"Walter"]] anyObject];
            
            TKAttendance *attendance = [student.attendances anyObject];
            attendance.type = sick;
            
            NSError *error;
            BOOL saved = [currentDB.rootContext save:&error];
            if (error || !saved) {
                XCTFail(@"Faild to save %@", error);
            }
        }
        [self setCurrentDevice:TKDevice2];
        {
            TKClassroom *classroom = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName] withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKClassroomAttributes.title, @"Mathematics"]] lastObject];
            TKAttendanceType *late = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Sick"]] lastObject];
            
            // get a student
            TKStudent *student = [[classroom.students filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", TKStudentAttributes.firstName, @"1-Walter"]] anyObject];
            
            TKAttendance *attendance = [student.attendances anyObject];
            attendance.type = late;
            
            NSError *error;
            BOOL saved = [currentDB.rootContext save:&error];
            if (error || !saved) {
                XCTFail(@"Faild to save %@", error);
            }
        }
        
        return [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
            // test
            [self setCurrentDevice:TKDevice1];
            TKAttendanceType *sick = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Sick"]] lastObject];
            XCTAssertEqual([sick.attendances count], 3, @"D1: failed to edit attendances");
            
            [self setCurrentDevice:TKDevice2];
            sick = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Sick"]] lastObject];
            XCTAssertEqual([sick.attendances count], 3, @"D1: failed to edit attendances");
            
            EndBlock();
            return nil;
        }];
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testEditSameLessonAddAttendance {
    [self setCurrentDevice:TKDevice1];
    // create Classroom, student then sync
    TKClassroom *class = [self createClassroomWithImageInContext:currentDB.rootContext];
    class.title = @"AYA";
    
    NSError *error;
    BOOL saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    TKStudent *student = [self createStudentInContext:currentDB.rootContext];
    student.firstName = @"AYA";
    
    [class addStudentsObject:student];
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    TKLesson *lesson = [TKLesson insertInManagedObjectContext:currentDB.rootContext];
    lesson.lessonStartDate = [NSDate date];
    lesson.lessonStartTime = [NSDate date];
    lesson.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson.lessonId = [self getAUniqueID];
    lesson.createdDate = [NSDate date];
    
    [class addLessonsObject:lesson];
    
    saved = [currentDB.rootContext save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
    
    StartBlock();
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        [self setCurrentDevice:TKDevice1];
        {
            // edit lesson
            TKLesson *lesson = [[self getObjectsInCurrentDeviceForEntity:[TKLesson entityName]] lastObject];
            lesson.lessonTitle = @"Edit 1";
            
            // add attendance
            TKClassroom *classroom = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName]] lastObject];
            TKStudent *student = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName]] lastObject];
            TKAttendanceType *type = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Present"]] lastObject];
            
            TKAttendance *attendance = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
            attendance.attendanceId = [self getAUniqueID];
            
            attendance.student = student;
            attendance.lesson = lesson;
            attendance.type = type;
            attendance.classroom = classroom;
            
            NSError *error;
            BOOL saved = [currentDB.rootContext save:&error];
            if (error || !saved) {
                XCTFail(@"Faild to save %@", error);
            }
        }
        
        [self setCurrentDevice:TKDevice2];
        {
            // edit lesson
            TKLesson *lesson = [[self getObjectsInCurrentDeviceForEntity:[TKLesson entityName]] lastObject];
            lesson.lessonTitle = @"Edit 2";
            
            NSError *error;
            BOOL saved = [currentDB.rootContext save:&error];
            if (error || !saved) {
                XCTFail(@"Faild to save %@", error);
            }
        }
        
        return [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
            // check Device 1
            [self setCurrentDevice:TKDevice1];
            
            NSArray *attendances = [self getObjectsInCurrentDeviceForEntity:[TKAttendance entityName]];
            XCTAssertEqual(attendances.count, 1, @"D1 attendance gets deleted");
            
            TKAttendance *attendance = [attendances lastObject];
            XCTAssertNotNil(attendance.lesson, @"Attendance don't have lesson");
            XCTAssertNotNil(attendance.classroom, @"Attendance don't have classroom");
            XCTAssertNotNil(attendance.type, @"Attendance don't have type");
            XCTAssertNotNil(attendance.student, @"Attendance don't have student");
            
            TKLesson *lesson = attendance.lesson;
            XCTAssertEqualObjects(lesson.lessonTitle, @"Edit 2", @"Faild to update d1 with d2 changes");
            
            [self setCurrentDevice:TKDevice2];
            
            attendances = [self getObjectsInCurrentDeviceForEntity:[TKAttendance entityName]];
            XCTAssertEqual(attendances.count, 1, @"D2 attendance gets deleted");
            
            attendance = [attendances lastObject];
            XCTAssertNotNil(attendance.lesson, @"Attendance don't have lesson");
            XCTAssertNotNil(attendance.classroom, @"Attendance don't have classroom");
            XCTAssertNotNil(attendance.type, @"Attendance don't have type");
            XCTAssertNotNil(attendance.student, @"Attendance don't have student");
            
            lesson = attendance.lesson;
            XCTAssertEqualObjects(lesson.lessonTitle, @"Edit 2", @"Faild to update d2. d1 chaneges wins");
            
            EndBlock();
            return nil;
        }];
    }];
    WaitUntilBlockCompletes();
}

- (void)testAttendanceShouldBeUniquePerLesson {
    [self setUpDevicesWithClassrooms];
    
    [self setCurrentDevice:TKDevice1];
    {
        TKClassroom *math = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKAttendanceType *present = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Present"]] lastObject];
        
        TKLesson *lesson = [[self getObjectsInCurrentDeviceForEntity:[TKLesson entityName] withPredicate:[NSPredicate predicateWithFormat:@"lessonTitle == %@", @"Quiz"]] lastObject];
        
        TKStudent *walter = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName] withPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        // create attendance
        TKAttendance *attendance = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        attendance.lesson = lesson;
        attendance.classroom = math;
        attendance.student = walter;
        attendance.type = present;
        
        NSError *error;
        BOOL saved = [currentDB.rootContext save:&error];
        if (error || !saved) {
            XCTFail(@"Faild to save %@", error);
        }

    }
    
    [self setCurrentDevice:TKDevice2];
    {
        TKClassroom *math = [[self getObjectsInCurrentDeviceForEntity:[TKClassroom entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Mathematics"]] lastObject];
        
        TKAttendanceType *absent = [[self getObjectsInCurrentDeviceForEntity:[TKAttendanceType entityName] withPredicate:[NSPredicate predicateWithFormat:@"title == %@", @"Absent"]] lastObject];
        
        TKLesson *lesson = [[self getObjectsInCurrentDeviceForEntity:[TKLesson entityName] withPredicate:[NSPredicate predicateWithFormat:@"lessonTitle == %@", @"Quiz"]] lastObject];
        
        TKStudent *walter = [[self getObjectsInCurrentDeviceForEntity:[TKStudent entityName] withPredicate:[NSPredicate predicateWithFormat:@"firstName == %@", @"Walter"]] lastObject];
        
        // create attendance
        TKAttendance *attendance = [TKAttendance insertInManagedObjectContext:currentDB.rootContext];
        attendance.lesson = lesson;
        attendance.classroom = math;
        attendance.student = walter;
        attendance.type = absent;
        
        NSError *error;
        BOOL saved = [currentDB.rootContext save:&error];
        if (error || !saved) {
            XCTFail(@"Faild to save %@", error);
        }
        
    }
    
    StartBlock();
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        // local should have only one object
        [self setCurrentDevice:TKDevice1];
        {
            NSArray *attendances = [self getObjectsInCurrentDeviceForEntity:[TKAttendance entityName]];
            
            XCTAssert(attendances.count == 1, @"Failed to update attendance type");
            
            TKAttendance *attendance = [attendances lastObject];
            XCTAssertNotNil(attendance.classroom, @"Attendance should have a classroom");
            XCTAssertNotNil(attendance.student, @"Attendance should have a student");
            XCTAssertNotNil(attendance.lesson, @"Attendance should have a lesson");
            XCTAssertNotNil(attendance.type, @"Attendance should have a type");
            
            TKAttendanceType *type = attendance.type;
            XCTAssertEqualObjects(type.title, @"Absent", @"Failed to update attendance type");
        }
        
        [self setCurrentDevice:TKDevice2];
        {
            NSArray *attendances = [self getObjectsInCurrentDeviceForEntity:[TKAttendance entityName]];
            
            XCTAssert(attendances.count == 1, @"Failed to update attendance type");
            
            TKAttendance *attendance = [attendances lastObject];
            XCTAssertNotNil(attendance.classroom, @"Attendance should have a classroom");
            XCTAssertNotNil(attendance.student, @"Attendance should have a student");
            XCTAssertNotNil(attendance.lesson, @"Attendance should have a lesson");
            XCTAssertNotNil(attendance.type, @"Attendance should have a type");
            
            TKAttendanceType *type = attendance.type;
            XCTAssertEqualObjects(type.title, @"Absent", @"Failed to update attendance type");
        }
        
        // server should have only one object with the latest type (absent)
        PFQuery *query = [PFQuery queryWithClassName:@"Attendance"];
        NSArray *attendances = [query findObjects];
        XCTAssert(attendances.count == 1, @"Failed to update server's attendance");
        
        PFObject *attendance = [attendances lastObject];
        [attendance fetchIfNeeded];
        XCTAssertNotNil(attendance[@"classroom"], @"Attendance should have a classroom");
        XCTAssertNotNil(attendance[@"student"], @"Attendance should have a student");
        XCTAssertNotNil(attendance[@"lesson"], @"Attendance should have a lesson");
        XCTAssertNotNil(attendance[@"type"], @"Attendance should have a type");
        
        PFObject *type = attendance[@"type"];
        [type fetchIfNeeded];
        XCTAssertEqualObjects(type[@"title"], @"Absent", @"Failed to update attendance type");
        
        EndBlock();
        return nil;
    }];
    WaitUntilBlockCompletes();
}

#pragma mark - Utilities

- (BFTask *)runSyncWithStartingDevice:(TKDevice) startingDevice {
    
    StartBlock();
    
    TKDevice secondDevice = !startingDevice;
    [self setCurrentDevice:startingDevice];
    return [[currentDB sync] continueWithBlock:^id(BFTask *task) {
        if (task.error || task.exception) {
            XCTFail(@"Sync D%lu: failed with Error: %@ | Exception: %@", startingDevice, task.error, task.exception);
            EndBlock();
            return nil;
        }
        else {
            [self setCurrentDevice:secondDevice];
            return [[currentDB sync] continueWithBlock:^id(BFTask *task) {
                if (task.error || task.exception) {
                    XCTFail(@"Sync D%lu: failed with Error: %@ | Exception: %@", secondDevice, task.error, task.exception);
                    EndBlock();
                    return nil;
                }
                else {
                    [self setCurrentDevice:startingDevice];
                    return [[currentDB sync] continueWithBlock:^id(BFTask *task) {
                        if (task.error || task.exception) {
                            XCTFail(@"Sync D%lu again: failed with Error: %@ | Exception: %@", startingDevice, task.error, task.exception);
                        }
                        EndBlock();
                        return nil;
                    }];
                }
            }];
        }
    }];
    WaitUntilBlockCompletes();

}

- (void)setUpDevicesWithClassrooms {
    
    [self setCurrentDevice:TKDevice1];
    [self createTemplateObjectsInContext:currentDB.rootContext];
    
    StartBlock();
    [[self runSyncWithStartingDevice:TKDevice1] continueWithSuccessBlock:^id(BFTask *task) {
        EndBlock();
        return nil;
    }];
    WaitUntilBlockCompletes();
    
}

- (void)createTemplateObjectsInContext:(NSManagedObjectContext *)context {
    
    TKClassroom *classroom = [self createClassroomInContext:context];
    classroom.image_BinaryPathKey = [self newImagePath];
    classroom.title = @"Mathematics";
    
    TKStudent *student = [self createStudentInContext:context];
    student.image_BinaryPathKey = [self newImagePath];
    student.firstName = @"Walter";
    student.lastName = @"White";
    
    [classroom addStudentsObject:student];
    
    TKStudent *student1 = [self createStudentInContext:context];
    student1.image_BinaryPathKey = [self newImagePath];
    student1.firstName = @"1-Walter";
    student1.lastName = @"1-White";
    
    [classroom addStudentsObject:student1];
    
    TKAttendanceType *type = [TKAttendanceType insertInManagedObjectContext:context];
    type.title = @"Sick";
    type.color = @"000000";
    type.attendancetypeId = [self getAUniqueID];
    type.createdDate = [NSDate date];
    
    TKAttendanceType *type2 = [TKAttendanceType insertInManagedObjectContext:context];
    type2.title = @"Late";
    type2.color = @"001100";
    type2.attendancetypeId = [self getAUniqueID];
    type2.createdDate = [NSDate date];
    
    TKLesson *lesson = [TKLesson insertInManagedObjectContext:context];
    lesson.lessonTitle = @"Quiz";
    lesson.lessonStartDate = [NSDate date];
    lesson.lessonStartTime = [NSDate date];
    lesson.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson.lessonId = [self getAUniqueID];
    lesson.createdDate = [NSDate date];
    
    [classroom addLessonsObject:lesson];
    
    TKLesson *lesson2 = [TKLesson insertInManagedObjectContext:context];
    lesson2.lessonStartDate = [NSDate date];
    lesson2.lessonStartTime = [NSDate date];
    lesson2.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson2.lessonId = [self getAUniqueID];
    lesson2.createdDate = [NSDate date];
    
    [classroom addLessonsObject:lesson2];
    
     
    TKClassroom *classroom2 = [self createClassroomInContext:context];
    classroom2.image_BinaryPathKey = [self newImagePath];
    classroom2.title = @"Physics";
    
    TKStudent *student2 = [self createStudentInContext:context];
    student2.image_BinaryPathKey = [self newImagePath];
    student2.firstName = @"Matt";
    student2.lastName = @"Thompson";
    
    [classroom2 addStudentsObject:student2];
    
    TKLesson *lesson3 = [TKLesson insertInManagedObjectContext:context];
    lesson3.lessonStartDate = [NSDate date];
    lesson3.lessonStartTime = [NSDate date];
    lesson3.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson3.lessonId = [self getAUniqueID];
    lesson3.createdDate = [NSDate date];
    
    [classroom2 addLessonsObject:lesson3];

    
    NSError *error;
    BOOL saved = [context save:&error];
    if (error || !saved) {
        XCTFail(@"Faild to save %@", error);
    }
}

- (id)getLessonFromContext:(NSManagedObjectContext *)context {
    return [[self getObjectsForEntity:[TKLesson entityName] inContext:context] lastObject];
}

- (id)getbehaviorFromContext:(NSManagedObjectContext *)context {
    return [[self getObjectsForEntity:[TKBehavior entityName] inContext:context] lastObject];
}

- (NSArray *)getObjectsInCurrentDeviceForEntity:(NSString *)entityName {
    return [self getObjectsForEntity:entityName inContext:currentDB.rootContext];
}

- (NSArray *)getObjectsInCurrentDeviceForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    return [self getObjectsForEntity:entityName predicate:predicate inContext:currentDB.rootContext];
}

- (NSArray *)getObjectsForEntity:(NSString *)entityName inContext:(NSManagedObjectContext *)context {
    return [self getObjectsForEntity:entityName predicate:nil inContext:context];
}

- (NSArray *)getObjectsForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:TKClassroomAttributes.lastModifiedDate ascending:NO]]];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

@end
