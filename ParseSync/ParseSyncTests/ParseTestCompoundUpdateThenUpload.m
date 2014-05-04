//
//  ParseTestCompoundUpdateThenUpload.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-29.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"

@interface ParseTestCompoundUpdateThenUpload : ParseBaseTestCase

@end

@implementation ParseTestCompoundUpdateThenUpload

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

- (void)testToManyRelationshipUpdateAddNewChild {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Jesse";
    student3.lastName = @"Pinkman";
    [self.classroom addStudentsObject:student3];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:self.classroom.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"students"] query];
        NSArray *arr = [query findObjects];
        XCTAssert([arr count] == 2, @"Classroom not linked to student");
        
        object = [[PFQuery queryWithClassName:@"Student"] getObjectWithId:student3.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        query = [[object relationForKey:@"classes"] query];
        arr = [query findObjects];
        XCTAssertEqualObjects([object valueForKey:@"firstName"], @"Jesse", @"Attributes of new object not set");
        XCTAssert([arr count] == 1, @"Student not linked to classroom");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testToManyRelationshipUpdateRemoveDeleteChild {
    NSString *serverID = self.student.serverObjectID;
    [[TKDB defaultDB].rootContext deleteObject:self.student];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:self.classroom.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"students"] query];
        NSArray *arr = [query findObjects];
        XCTAssert([arr count] == 0, @"Classroom not linked to student");
        object = [[PFQuery queryWithClassName:@"Student"] getObjectWithId:serverID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testToManyRelationshipUpdateReplaceChild {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Jesse";
    student3.lastName = @"Pinkman";
    [self.classroom addStudentsObject:student3];
    NSString *serverID = self.student.serverObjectID;
    [[TKDB defaultDB].rootContext deleteObject:self.student];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:self.classroom.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"students"] query];
        NSArray *arr = [query findObjects];
        XCTAssert([arr count] == 1, @"Error in classroom relationships");
        
        object = [[PFQuery queryWithClassName:@"Student"] getObjectWithId:student3.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        query = [[object relationForKey:@"classes"] query];
        arr = [query findObjects];
        XCTAssertEqualObjects([object valueForKey:@"firstName"], @"Jesse", @"Attributes of new object not set");
        XCTAssert([arr count] == 1, @"Student not linked to classroom");
        
        object = [[PFQuery queryWithClassName:@"Student"] getObjectWithId:serverID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertEqualObjects([object valueForKey:@"isDeleted"], @YES, @"Object not marked as deleted");
        
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipSetNewObject {
    AttendanceType *attendanceType2 = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceType" inManagedObjectContext:[TKDB defaultDB].rootContext];
    attendanceType2.title = @"Absent";
    self.attendance1.attendanceType = attendanceType2;
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:self.attendance1.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertNotNil([object valueForKey:@"attendanceType"], @"No foreign key set");
        
        object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:attendanceType2.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"attendances"] query];
        NSArray *arr = [query findObjects];
        XCTAssertEqualObjects([object valueForKey:@"title"], @"Absent", @"Attributes of new object not set");
        XCTAssert([arr count] == 1, @"Attendance linked to type");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipClearDeleteObject {
    NSString *serverID = self.attendanceType.serverObjectID;
    [[TKDB defaultDB].rootContext deleteObject:self.attendanceType];
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:self.attendance2.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertNil([object valueForKey:@"attendanceType"], @"Deleted object foreign key still set");
        
        object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:serverID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertEqualObjects([object valueForKey:@"isDeleted"], @YES, @"Object not marked as deleted");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipReplaceObject {
    AttendanceType *attendanceType2 = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceType" inManagedObjectContext:[TKDB defaultDB].rootContext];
    attendanceType2.title = @"Absent";
    NSString *serverID = self.attendanceType.serverObjectID;
    [[TKDB defaultDB].rootContext deleteObject:self.attendanceType];
    self.attendance2.attendanceType = attendanceType2;
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *object = [[PFQuery queryWithClassName:@"Attendance"] getObjectWithId:self.attendance2.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertNotNil([object valueForKey:@"attendanceType"], @"Foreign key still set");
        PFObject *relatedObject = [object valueForKey:@"attendanceType"];
        [relatedObject fetchIfNeeded];
        XCTAssertEqualObjects([relatedObject valueForKey:@"title"], @"Absent", @"Foreign key still set");
        
        object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:attendanceType2.serverObjectID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        
        PFQuery *query = [[object relationForKey:@"attendances"] query];
        NSArray *arr = [query findObjects];
        XCTAssertEqualObjects([object valueForKey:@"title"], @"Absent", @"Attributes of new object not set");
        XCTAssert([arr count] == 1, @"Attendance linked to type");
        
        object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:serverID];
        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
        XCTAssertEqualObjects([object valueForKey:@"isDeleted"], @YES, @"Object not marked as deleted");
        EndBlock();
        
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

@end
