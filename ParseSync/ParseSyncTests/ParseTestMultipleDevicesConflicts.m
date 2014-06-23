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
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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
    lesson.lessonStartDate = [NSDate date];
    lesson.lessonStartTime = [NSDate date];
    lesson.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson.lessonId = [self getAUniqueID];
    lesson.createdDate = [NSDate date];
    
    [classroom addLessonsObject:lesson];
    
    TKAttendance *attendance = [TKAttendance insertInManagedObjectContext:context];
    attendance.type = type;
    attendance.lesson = lesson;
    attendance.student = student;
    
    TKClassroom *classroom2 = [self createClassroomInContext:context];
    classroom2.image_BinaryPathKey = [self newImagePath];
    classroom2.title = @"Physics";
    
    TKStudent *student2 = [self createStudentInContext:context];
    student2.image_BinaryPathKey = [self newImagePath];
    student2.firstName = @"Matt";
    student2.lastName = @"Thompson";
    
    [classroom2 addStudentsObject:student2];
    
    TKLesson *lesson2 = [TKLesson insertInManagedObjectContext:context];
    lesson2.lessonStartDate = [NSDate date];
    lesson2.lessonStartTime = [NSDate date];
    lesson2.lessonEndTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    lesson2.lessonId = [self getAUniqueID];
    lesson2.createdDate = [NSDate date];
    
    [classroom2 addLessonsObject:lesson2];

    
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

- (NSArray *)getObjectsForEntity:(NSString *)entityName inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:TKClassroomAttributes.lastModifiedDate ascending:NO]]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

@end
