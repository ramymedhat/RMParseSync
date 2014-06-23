//
//  ParseTestCompoundUpdateThenDownload.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-29.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"

@interface ParseTestCompoundUpdateThenDownload : ParseBaseTestCase

@end

@implementation ParseTestCompoundUpdateThenDownload

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
    PFObject *parse_student3 = [PFObject objectWithClassName:@"Student"];
    [parse_student3 setValue:@"Jesse" forKey:@"firstName"];
    [parse_student3 setValue:@"Pinkman" forKey:@"lastName"];
    [parse_student3 setValue:[super getAUniqueID] forKey:kTKDBUniqueIDField];
    [parse_student3 setValue:@NO forKey:@"isDeleted"];
    [parse_student3 save];
    [[parse_student3 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:parse_student3];
    [PFObject saveAll:@[parse_student3,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSArray *results = [[TKDB defaultDB].rootContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Student"] error:nil];
            
            XCTAssert([results count] == 3, @"New student not added");
            XCTAssert([self.classroom.students count] == 2, @"Classroom not wired to new student");
            
            Student *newStudent = nil;
            
            for (NSManagedObject *student in results) {
                if ([[student valueForKey:@"firstName"] isEqualToString:@"Jesse"]) {
                    newStudent = (Student*)student;
                    break;
                }
            }
            
            XCTAssertNotNil(newStudent, @"Can't find new student");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testToManyRelationshipUpdateRemoveDeleteChild {
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_student];
    [self.parse_student setValue:@YES forKey:@"isDeleted"];
    [self.parse_classroom setValue:[NSDate date] forKey:@"lastModifiedDate"];
    [self.parse_student setValue:[NSDate date] forKey:@"lastModifiedDate"];
    [PFObject saveAll:@[self.parse_student,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssert([self.classroom.students count] == 0, @"Deleted student still wired");
            XCTAssertNil(self.student.managedObjectContext, @"Student not deleted");
            EndBlock();
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void)testToManyRelationshipUpdateReplaceChild {
    PFObject *parse_student3 = [PFObject objectWithClassName:@"Student"];
    [parse_student3 setValue:@"Jesse" forKey:@"firstName"];
    [parse_student3 setValue:@"Pinkman" forKey:@"lastName"];
    [parse_student3 setValue:[super getAUniqueID] forKey:kTKDBUniqueIDField];
    [parse_student3 setValue:@NO forKey:@"isDeleted"];
    [parse_student3 save];
    [[parse_student3 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:parse_student3];
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_student];
    [self.parse_student setValue:@YES forKey:@"isDeleted"];
    [PFObject saveAll:@[parse_student3,self.parse_classroom,self.parse_student]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSArray *results = [[TKDB defaultDB].rootContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Student"] error:nil];
            
            XCTAssert([results count] == 2, @"Replace not successful");
            XCTAssert([self.classroom.students count] == 1, @"Replace not successful");
            
            Student *newStudent = nil;
            
            for (NSManagedObject *student in results) {
                if ([[student valueForKey:@"firstName"] isEqualToString:@"Jesse"]) {
                    newStudent = (Student*)student;
                    break;
                }
            }
            
            XCTAssertNotNil(newStudent, @"Can't find new student");
            
            XCTAssertNil(self.student.managedObjectContext, @"Student not deleted");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipSetNewObject {
    PFObject *parse_attendanceType2 = [PFObject objectWithClassName:@"AttendanceType"];
    [parse_attendanceType2 setValue:@"Absent" forKey:@"title"];
    [parse_attendanceType2 setValue:[super getAUniqueID] forKey:kTKDBUniqueIDField];
    [parse_attendanceType2 save];
    
    [self.parse_attendance1 setValue:parse_attendanceType2 forKey:@"attendanceType"];
    [[parse_attendanceType2 relationForKey:@"attendances"] addObject:self.parse_attendance1];
    [PFObject saveAll:@[self.parse_attendance1,parse_attendanceType2]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSArray *results = [[TKDB defaultDB].rootContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"AttendanceType"] error:nil];
            
            XCTAssert([results count] == 2, @"New attendance type not added");
            XCTAssertNotNil(self.attendance1.attendanceType, @"Attendance not wired to new type");
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipClearDeleteObject {
    [self.parse_attendanceType setValue:@YES forKey:@"isDeleted"];
    [self.parse_attendance2 removeObjectForKey:@"attendanceType"];
    [PFObject saveAll:@[self.parse_attendance2,self.parse_attendanceType]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertNil(self.attendanceType.managedObjectContext, @"Object not removed");
            XCTAssertNil(self.attendance2.attendanceType, @"Wiring not removed");
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testToOneRelationshipReplaceObject {
    PFObject *parse_attendanceType2 = [PFObject objectWithClassName:@"AttendanceType"];
    [parse_attendanceType2 setValue:@"Absent" forKey:@"title"];
    [parse_attendanceType2 setValue:[super getAUniqueID] forKey:kTKDBUniqueIDField];
    [parse_attendanceType2 save];
    
    [self.parse_attendance2 setValue:parse_attendanceType2 forKey:@"attendanceType"];
    [[parse_attendanceType2 relationForKey:@"attendances"] addObject:self.parse_attendance2];
    
    [self.parse_attendanceType setValue:@YES forKey:@"isDeleted"];
    
    [PFObject saveAll:@[self.parse_attendanceType,self.parse_attendance2,parse_attendanceType2]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            NSArray *results = [[TKDB defaultDB].rootContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"AttendanceType"] error:nil];
            
            XCTAssert([results count] == 1, @"New attendance type not added");
            XCTAssertNotNil(self.attendance2.attendanceType, @"Attendance not wired to new type");
            XCTAssertNil(self.attendanceType.managedObjectContext, @"Object not removed");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

@end
