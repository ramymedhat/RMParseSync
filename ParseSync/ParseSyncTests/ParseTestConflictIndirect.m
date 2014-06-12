//
//  ParseTestConflictIndirect.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-30.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"

@interface ParseTestConflictIndirect : ParseBaseTestCase

@end

@implementation ParseTestConflictIndirect

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

/**
 *  Insert two objects on local and server that point to
 *  the same object.
 */
- (void) testInsertInsertSameRelatedObject {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Jesse"; student3.lastName = @"Pinkman";
    [student3 addClassesObject:self.classroom];
    [[TKDB defaultDB].rootContext save:nil];
    
    PFObject *parse_student4 = [PFObject objectWithClassName:@"Student"];
    [parse_student4 setValue:@"Hank" forKey:@"firstName"];
    [parse_student4 setValue:@"Shrader" forKey:@"lastName"];
    [parse_student4 setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [parse_student4 save];
    
    [[parse_student4 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:parse_student4];
    [PFObject saveAll:@[parse_student4,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            PFObject *parse_student3 = [super searchCloudDBForObjectWithUniqueID:student3.tk_uniqueObjectID entity:@"Student"];
            XCTAssertNotNil(parse_student3, @"Local insert not saved to cloud");
            
            XCTAssert([[[[parse_student3 relationForKey:@"classes"] query] findObjects] count] == 1, @"New student not wired to class on server");
            
            Student *student4 = (Student*)[super searchLocalDBForObjectWithUniqueID:[parse_student4 valueForKey:kTKDBUniqueIDField] entity:@"Student"];
            XCTAssertNotNil(student4, @"Server insert not saved to local");
            
            XCTAssert([student4.classes count] == 1, @"New student not wired to class on local");
            
            XCTAssert([self.classroom.students count] == 3, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 3, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
    
}
/**
 *  Insert an object and establish a relation to an existing object
 *  Update another object on the cloud to point to the same existing
 *  object.
 */
- (void) testInsertUpdateSameRelatedObject {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Jesse"; student3.lastName = @"Pinkman";
    [student3 addClassesObject:self.classroom];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_student2 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:self.parse_student2];
    [PFObject saveAll:@[self.parse_student2,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            PFObject *parse_student3 = [super searchCloudDBForObjectWithUniqueID:student3.tk_uniqueObjectID entity:@"Student"];
            XCTAssertNotNil(parse_student3, @"Local insert not saved to cloud");
            
            XCTAssert([[[[parse_student3 relationForKey:@"classes"] query] findObjects] count] == 1, @"New student not wired to class on server");
            
            XCTAssert([self.student2.classes count] == 1, @"existing student not wired to class on local");
            
            XCTAssert([self.classroom.students count] == 3, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 3, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
}

/**
 *  Locally, insert object a, link to object c. On server, delete object
 *  b that was linked to object c.
 */
- (void) testInsertDeleteSameRelatedObject {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Jesse"; student3.lastName = @"Pinkman";
    [student3 addClassesObject:self.classroom];
    [[TKDB defaultDB].rootContext save:nil];
    
    [self.parse_student setValue:@YES forKeyPath:kTKDBIsDeletedField];
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_student];
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
            PFObject *parse_student3 = [super searchCloudDBForObjectWithUniqueID:student3.tk_uniqueObjectID entity:@"Student"];
            XCTAssertNotNil(parse_student3, @"Local insert not saved to cloud");
            
            XCTAssert([[[[parse_student3 relationForKey:@"classes"] query] findObjects] count] == 1, @"New student not wired to class on server");
            
            XCTAssertNil(self.student.managedObjectContext, @"existing student not deleted");
            
            XCTAssert([self.classroom.students count] == 1, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 1, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
}

/**
 *  On server, insert an object and establish a relation to an existing object
 *  Update another object locally to point to the same existing
 *  object.
 */
- (void) testUpdateInsertSameRelatedObject {
    [self.student2 addClassesObject:self.classroom];
    [[TKDB defaultDB].rootContext save:nil];
    
    PFObject *parse_student4 = [PFObject objectWithClassName:@"Student"];
    [parse_student4 setValue:@"Hank" forKey:@"firstName"];
    [parse_student4 setValue:@"Shrader" forKey:@"lastName"];
    [parse_student4 setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [parse_student4 save];
    
    [[parse_student4 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:parse_student4];
    [PFObject saveAll:@[parse_student4,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssert([[[[self.parse_student2 relationForKey:@"classes"] query] findObjects] count] == 1, @"Updated student not wired to class on server");
            
            Student *student4 = (Student*)[super searchLocalDBForObjectWithUniqueID:[parse_student4 valueForKey:kTKDBUniqueIDField] entity:@"Student"];
            XCTAssertNotNil(student4, @"Server insert not saved to local");
            
            XCTAssert([student4.classes count] == 1, @"New student not wired to class on local");
            
            XCTAssert([self.classroom.students count] == 3, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 3, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
}

/**
 *  Locally, update object a, link to object c. On server, delete object
 *  b that was linked to object c.
 */
- (void) testUpdateDeleteSameRelatedObject {
    [self.student2 addClassesObject:self.classroom];
    [[TKDB defaultDB].rootContext save:nil];
    
    [self.parse_student setValue:@YES forKeyPath:kTKDBIsDeletedField];
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_student];
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
            XCTAssert([[[[self.parse_student2 relationForKey:@"classes"] query] findObjects] count] == 1, @"Updated student not wired to class on server");
            
            XCTAssertNil(self.student.managedObjectContext, @"existing student not deleted");
            
            XCTAssert([self.classroom.students count] == 1, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 1, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
}

/**
 *  Locally, delete object a which was linked to object c. On server, insert
 *  object b and link to object c.
 */
- (void) testDeleteInsertSameRelatedObject {
    [[TKDB defaultDB].rootContext deleteObject:self.student];
    [[TKDB defaultDB].rootContext save:nil];
    
    PFObject *parse_student4 = [PFObject objectWithClassName:@"Student"];
    [parse_student4 setValue:@"Hank" forKey:@"firstName"];
    [parse_student4 setValue:@"Shrader" forKey:@"lastName"];
    [parse_student4 setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [parse_student4 save];
    
    [[parse_student4 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:parse_student4];
    [PFObject saveAll:@[parse_student4,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            [self.parse_student refresh];
            XCTAssert([[self.parse_student valueForKey:kTKDBIsDeletedField] boolValue], @"Not deleted on server");
            
            Student *student4 = (Student*)[super searchLocalDBForObjectWithUniqueID:[parse_student4 valueForKey:kTKDBUniqueIDField] entity:@"Student"];
            XCTAssertNotNil(student4, @"Server insert not saved to local");
            
            XCTAssert([student4.classes count] == 1, @"New student not wired to class on local");
            
            XCTAssert([self.classroom.students count] == 1, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 1, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
}

/**
 *  On server, update object a, link to object c. On local, delete object
 *  b that was linked to object c.
 */
- (void) testDeleteUpdateSameRelatedObject {
    [[TKDB defaultDB].rootContext deleteObject:self.student];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_student2 relationForKey:@"classes"] addObject:self.parse_classroom];
    [[self.parse_classroom relationForKey:@"students"] addObject:self.parse_student2];
    [PFObject saveAll:@[self.parse_student2,self.parse_classroom]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            [self.parse_student refresh];
            XCTAssert([[self.parse_student valueForKey:kTKDBIsDeletedField] boolValue], @"Not deleted on server");
            
            XCTAssert([self.student2.classes count] == 1, @"existing student not wired to class on local");
            
            XCTAssert([self.classroom.students count] == 1, @"Relation merge failed locally.");
            XCTAssert([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count] == 1, @"Relation merge failed on cloud.");
            
            EndBlock();
        }
    }];
    
    WaitUntilBlockCompletes();
}

@end
