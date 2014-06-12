//
//  ParseTestInsertThenUpload.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-28.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"
#import "TKClassroom.h"
#import "TKStudent.h"
#import "TKBehavior.h"

@interface ParseTestInsertThenUpload : ParseBaseTestCase

@end

@implementation ParseTestInsertThenUpload

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

- (void)testSimpleInsert
{
    AttendanceType *attendanceType = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceType" inManagedObjectContext:[TKDB defaultDB].rootContext];
    attendanceType.title = @"Present";
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertNotNil(attendanceType.serverObjectID, @"Object did not acquire a server ID");
            
            PFObject *object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:attendanceType.serverObjectID];
            XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
            
            XCTAssertEqualObjects([object valueForKey:@"title"], @"Present", @"Title field of object is not correct on cloud.");
            
            EndBlock();
            
        }
        return nil;
    }];
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        XCTAssertNotNil(attendanceType.serverObjectID, @"Object did not acquire a server ID");
//        
//        PFObject *object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:attendanceType.serverObjectID];
//        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
//        
//        XCTAssertEqualObjects([object valueForKey:@"title"], @"Present", @"Title field of object is not correct on cloud.");
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
//    
    WaitUntilBlockCompletes();
}

- (void)testSimpleInsertFailed
{
    AttendanceType *attendanceType = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceType" inManagedObjectContext:[TKDB defaultDB].rootContext];
    attendanceType.title = @"Present";
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertNotNil(attendanceType.serverObjectID, @"Object did not acquire a server ID");
            
            PFObject *object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:attendanceType.serverObjectID];
            XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
            
            XCTAssertEqualObjects([object valueForKey:@"title"], @"Present", @"Title field of object is not correct on cloud.");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    //    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
    //        XCTAssertNotNil(attendanceType.serverObjectID, @"Object did not acquire a server ID");
    //
    //        PFObject *object = [[PFQuery queryWithClassName:@"AttendanceType"] getObjectWithId:attendanceType.serverObjectID];
    //        XCTAssertNotNil(object, @"Object with server ID doesn't exist on Parse");
    //
    //        XCTAssertEqualObjects([object valueForKey:@"title"], @"Present", @"Title field of object is not correct on cloud.");
    //        EndBlock();
    //
    //    } andFailureBlock:^(NSArray *objects, NSError *error) {
    //        XCTFail(@"Sync Failed");
    //        EndBlock();
    //    }];
    //    
    WaitUntilBlockCompletes();
}

- (void) testRelationshipDualInsert {
    Classroom *classroom = [NSEntityDescription insertNewObjectForEntityForName:@"Classroom" inManagedObjectContext:[TKDB defaultDB].rootContext];
    classroom.title = @"Mathematics";
    classroom.serverObjectID = nil;
    
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student.firstName = @"Walter";
    student.lastName = @"White";
    student.serverObjectID = nil;
    [student addClassesObject:classroom];
    
    [[TKDB defaultDB].rootContext save:nil];
    
    StartBlock();
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        XCTAssertNotNil(classroom.serverObjectID, @"Classroom Object did not acquire a server ID");
//        XCTAssertNotNil(student.serverObjectID, @"Student Object did not acquire a server ID");
//        
//        PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:classroom.serverObjectID];
//        XCTAssertNotNil(object, @"Classroom Object with server ID doesn't exist on Parse");
//        XCTAssertEqualObjects([object valueForKey:@"title"], @"Mathematics", @"Title field of classroom object is not correct on cloud.");
//        
//        object = [[PFQuery queryWithClassName:@"Student"] getObjectWithId:student.serverObjectID];
//        XCTAssertNotNil(object, @"Student Object with server ID doesn't exist on Parse");
//        XCTAssertEqualObjects([object valueForKey:@"firstName"], @"Walter", @"Student field of classroom object is not correct on cloud.");
//        
//        EndBlock();
//        
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertNotNil(classroom.serverObjectID, @"Classroom Object did not acquire a server ID");
            XCTAssertNotNil(student.serverObjectID, @"Student Object did not acquire a server ID");
            
            PFObject *object = [[PFQuery queryWithClassName:@"Classroom"] getObjectWithId:classroom.serverObjectID];
            XCTAssertNotNil(object, @"Classroom Object with server ID doesn't exist on Parse");
            XCTAssertEqualObjects([object valueForKey:@"title"], @"Mathematics", @"Title field of classroom object is not correct on cloud.");
            
            object = [[PFQuery queryWithClassName:@"Student"] getObjectWithId:student.serverObjectID];
            XCTAssertNotNil(object, @"Student Object with server ID doesn't exist on Parse");
            XCTAssertEqualObjects([object valueForKey:@"firstName"], @"Walter", @"Student field of classroom object is not correct on cloud.");
            
            EndBlock();
            
        }
        return nil;
    }];

    WaitUntilBlockCompletes();
}

@end
