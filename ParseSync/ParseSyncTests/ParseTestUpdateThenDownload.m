//
//  ParseTestUpdateThenDownload.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-29.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"
#import "TKDBCacheManager.h"

@interface ParseTestUpdateThenDownload : ParseBaseTestCase

@end

@implementation ParseTestUpdateThenDownload

- (void)setUp
{
    [super setUp];
    
    [super createTemplateObjects];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAttributeUpdate
{
    [self.parse_attendanceType setValue:@"Absent" forKeyPath:@"title"];
    [self.parse_attendanceType setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    
    BOOL saved = [self.parse_attendanceType save];
    
    if (!saved) {
        XCTFail(@"Sync Failed");
        return;
    }
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        XCTAssertEqualObjects(self.attendanceType.title, @"Absent", @"Title field of object is not correct on cloud.");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqualObjects(self.attendanceType.title, @"Absent", @"Title field of object is not correct on cloud.");
            EndBlock();
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToManyRelationshipUpdateAddChild {
    [[self.parse_classroom relationForKey:@"students"] addObject:self.parse_student2];
    [self.parse_classroom setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [[self.parse_student2 relationForKey:@"classes"] addObject:self.parse_classroom];
    [self.parse_student2 setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [PFObject saveAll:@[self.parse_classroom,self.parse_student2]];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        NSArray *arr = [self.classroom.students allObjects];
//        XCTAssert([arr count] == 2, @"Classroom not linked to student");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSArray *arr = [self.classroom.students allObjects];
            XCTAssert([arr count] == 2, @"Classroom not linked to student");
            EndBlock();
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToManyRelationshipUpdateRemoveChild {
    [self.classroom removeStudentsObject:self.student];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_student];
    [self.parse_classroom setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [[self.parse_student relationForKey:@"classes"] removeObject:self.parse_classroom];
    [self.parse_student setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [PFObject saveAll:@[self.parse_classroom,self.parse_student]];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        NSArray *arr = [self.classroom.students allObjects];
//        XCTAssert([arr count] == 0, @"Classroom still linked to student");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSArray *arr = [self.classroom.students allObjects];
            XCTAssert([arr count] == 0, @"Classroom still linked to student");
            EndBlock();
        }
        return nil;
    }];
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipSet {
    [self.parse_attendance1 setValue:self.parse_attendanceType forKey:@"attendanceType"];
    [self.parse_attendance1 setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [[self.parse_attendanceType relationForKey:@"attendances"] addObject:self.parse_attendance1];
    [self.parse_attendanceType setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [PFObject saveAll:@[self.parse_attendance1,self.parse_attendanceType]];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        XCTAssertNotNil(self.attendance1.attendanceType, @"Linking to One object failed on cloud.");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertNotNil(self.attendance1.attendanceType, @"Linking to One object failed on cloud.");
            EndBlock();
        }
        return nil;
    }];
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipClear {
    [self.parse_attendance2 removeObjectForKey:@"attendanceType"];
    [self.parse_attendance2 setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [[self.parse_attendanceType relationForKey:@"attendances"] removeObject:self.parse_attendance2];
    [self.parse_attendanceType setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [PFObject saveAll:@[self.parse_attendance2,self.parse_attendanceType]];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        XCTAssertNil(self.attendance2.attendanceType, @"Removing link to One object failed on cloud.");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertNil(self.attendance2.attendanceType, @"Removing link to One object failed on cloud.");
            EndBlock();
        }
        return nil;
    }];
    WaitUntilBlockCompletes();
}

- (void) testSimpleDeleteObject {
    [self.parse_attendance1 setValue:@YES forKey:kTKDBIsDeletedField];
    [self.parse_attendance1 setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [self.parse_attendance1 save];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        [[TKDB defaultDB].rootContext refreshObject:self.attendance1 mergeChanges:YES];
//        XCTAssertNil(self.attendance1.managedObjectContext, @"Object not deleted locally");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            [[TKDB defaultDB].rootContext refreshObject:self.attendance1 mergeChanges:YES];
            XCTAssertNil(self.attendance1.managedObjectContext, @"Object not deleted locally");
            EndBlock();
        }
        return nil;
    }];
    WaitUntilBlockCompletes();
}

- (void) testDeleteObjectWithRelationships {
    [self.parse_attendance2 setValue:@YES forKey:kTKDBIsDeletedField];
    [self.parse_attendance2 setValue:[NSDate date] forKeyPath:@"lastModifiedDate"];
    [self.parse_attendance2 save];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        [[TKDB defaultDB].rootContext refreshObject:self.attendance1 mergeChanges:YES];
//        XCTAssertNil(self.attendance2.managedObjectContext, @"Object not deleted locally");
//        XCTAssert([self.attendanceType.attendances count] == 0, @"Relationship not deleted.");
//        
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            [[TKDB defaultDB].rootContext refreshObject:self.attendance1 mergeChanges:YES];
            XCTAssertNil(self.attendance2.managedObjectContext, @"Object not deleted locally");
            XCTAssert([self.attendanceType.attendances count] == 0, @"Relationship not deleted.");
            
            EndBlock();
        }
        return nil;
    }];
    WaitUntilBlockCompletes();
}

@end
