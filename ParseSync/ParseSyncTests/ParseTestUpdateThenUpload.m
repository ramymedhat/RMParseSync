//
//  ParseTestUpdateThenUpload.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-28.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"
#import "TKDBCacheManager.h"

@interface ParseTestUpdateThenUpload : ParseBaseTestCase

@end

@implementation ParseTestUpdateThenUpload

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
    self.attendanceType.title = @"Absent";
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:self.attendanceType.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        XCTAssertEqualObjects([object valueForKey:@"title"], @"Absent", @"Title field of object is not correct on cloud.");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToManyRelationshipUpdateAddChild {
    [self.classroom addStudentsObject:self.student2];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:self.classroom.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"students"] query];
        NSArray *arr = [query findObjects];
        XCTAssert([arr count] == 2, @"Classroom not linked to student");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToManyRelationshipUpdateRemoveChild {
    [self.classroom removeStudentsObject:self.student];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:self.classroom.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"students"] query];
        NSArray *arr = [query findObjects];
        XCTAssert([arr count] == 0, @"Classroom still linked to student");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipSet {
    self.attendance1.attendanceType = self.attendanceType;
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:self.attendance1.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertNotNil([object valueForKey:@"attendanceType"], @"Linking to One object failed on cloud.");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipClear {
    self.attendance2.attendanceType = nil;
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:self.attendance2.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertNil([object valueForKey:@"attendanceType"], @"Linking to One object failed on cloud.");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testSimpleDeleteObject {
    NSString __weak *serverID = self.attendance1.serverObjectID;
    [[TKDB defaultDB].rootContext deleteObject:self.attendance1];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:serverID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertEqualObjects([object valueForKey:kTKDBIsDeletedField],@YES, @"Object with server ID not deleted");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testDeleteObjectWithRelationships {
    NSString __weak *serverID = self.attendance2.serverObjectID;
    [[TKDB defaultDB].rootContext deleteObject:self.attendance2];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:serverID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertEqualObjects([object valueForKey:kTKDBIsDeletedField],@YES, @"Object with server ID not deleted");
        
        object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:self.attendanceType.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        NSArray *attendances = [[[object relationForKey:@"attendances"] query] findObjects];
        XCTAssert([attendances count] == 0, @"Relationship not deleted.");
        
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

@end