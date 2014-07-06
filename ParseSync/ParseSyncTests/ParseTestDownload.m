//
//  ParseTestDownload.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-28.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"
#import <Bolts/Bolts.h>

@interface ParseTestDownload : ParseBaseTestCase

@end

@implementation ParseTestDownload

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

- (void)testSimpleDownload
{
    PFObject *object = [PFObject objectWithClassName:@"AttendanceType"];
    [object setValue:@"Present" forKeyPath:@"title"];
    [object setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [object setValue:[NSDate date] forKeyPath:kTKDBUpdatedDateField];
    [object setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object save];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AttendanceType"];
            NSArray *array = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
            XCTAssert([array count] == 1, @"No object downloaded");
            XCTAssertNotNil([array[0] valueForKey:kTKDBServerIDField], @"No server ID for Object");
            XCTAssertEqualObjects([array[0] valueForKey:@"title"], @"Present", @"Title not downloaded correctly");
            EndBlock();
        }
        return nil;
    }];
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AttendanceType"];
//        NSArray *array = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
//        XCTAssert([array count] == 1, @"No object downloaded");
//        XCTAssertNotNil([array[0] valueForKey:kTKDBServerIDField], @"No server ID for Object");
//        XCTAssertEqualObjects([array[0] valueForKey:@"title"], @"Present", @"Title not downloaded correctly");
//        EndBlock();
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    WaitUntilBlockCompletes();
}

- (void)testManyToManyObjectsDownload {
    PFObject *object1 = [PFObject objectWithClassName:@"Classroom"];
    [object1 setValue:@"Mathematics" forKeyPath:@"title"];
    [object1 setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [object1 setValue:[NSDate date] forKeyPath:kTKDBUpdatedDateField];
    [object1 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object1 save];
    
    PFObject *object2 = [PFObject objectWithClassName:@"Student"];
    [object2 setValue:@"Walter" forKeyPath:@"firstName"];
    [object2 setValue:@"White" forKeyPath:@"lastName"];
    [object2 setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [object2 setValue:[NSDate date] forKeyPath:kTKDBUpdatedDateField];
    [object2 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object2 save];
    
    PFRelation *relation1 = [object1 relationForKey:@"students"];
    [relation1 addObject:object2];
    
    PFRelation *relation2 = [object2 relationForKey:@"classes"];
    [relation2 addObject:object1];
    
    [PFObject saveAll:@[object1, object2]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Classroom"];
            NSArray *array = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
            XCTAssert([array count] == 1, @"No object downloaded");
            Classroom *classroom = array[0];
            XCTAssertNotNil([classroom valueForKey:kTKDBServerIDField], @"No server ID for Object");
            XCTAssertEqualObjects([classroom valueForKey:@"title"], @"Mathematics", @"Title not downloaded correctly");
            
            fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
            array = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
            XCTAssert([array count] == 1, @"No object downloaded");
            Student *student = array[0];
            XCTAssertNotNil([student valueForKey:kTKDBServerIDField], @"No server ID for Object");
            XCTAssertEqualObjects([student valueForKey:@"firstName"], @"Walter", @"First name not downloaded correctly");
            
            XCTAssert([classroom.students count] == 1, @"No students linked to classroom.");
            XCTAssert([student.classes count] == 1, @"No classes linked to student.");
            XCTAssertEqualObjects([classroom.students anyObject], student, @"Error in join.");
            XCTAssertEqualObjects([student.classes anyObject], classroom, @"Error in join.");
            EndBlock();
        }
        
        return nil;
    }];
    
//    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Classroom"];
//        NSArray *array = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
//        XCTAssert([array count] == 1, @"No object downloaded");
//        Classroom *classroom = array[0];
//        XCTAssertNotNil([classroom valueForKey:kTKDBServerIDField], @"No server ID for Object");
//        XCTAssertEqualObjects([classroom valueForKey:@"title"], @"Mathematics", @"Title not downloaded correctly");
//        
//        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
//        array = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
//        XCTAssert([array count] == 1, @"No object downloaded");
//        Student *student = array[0];
//        XCTAssertNotNil([student valueForKey:kTKDBServerIDField], @"No server ID for Object");
//        XCTAssertEqualObjects([student valueForKey:@"firstName"], @"Walter", @"First name not downloaded correctly");
//        
//        XCTAssert([classroom.students count] == 1, @"No students linked to classroom.");
//        XCTAssert([student.classes count] == 1, @"No classes linked to student.");
//        XCTAssertEqualObjects([classroom.students anyObject], student, @"Error in join.");
//        XCTAssertEqualObjects([student.classes anyObject], classroom, @"Error in join.");
//        
//        EndBlock();
//    } andFailureBlock:^(NSArray *objects, NSError *error) {
//        XCTFail(@"Sync Failed");
//        EndBlock();
//    }];
    
    WaitUntilBlockCompletes();
}

@end
