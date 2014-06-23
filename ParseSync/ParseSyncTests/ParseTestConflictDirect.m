//
//  ParseTestUploadDownloadConflict.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-29.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"

@interface ParseTestUploadDownloadConflict : ParseBaseTestCase

@end

@implementation ParseTestUploadDownloadConflict

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super createTemplateObjects2];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testUpdateDifferentAttributes {
    [self.students[0] setValue:@"Saul" forKey:@"firstName"];
    [[TKDB defaultDB].rootContext save:nil];
    
    [self.parse_students[0] setValue:@"Goodman" forKeyPath:@"lastName"];
    [self.parse_students[0] save];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqualObjects([self.students[0] valueForKey:@"firstName"], @"Saul", @"Firstname local rolledback");
            XCTAssertEqualObjects([self.students[0] valueForKey:@"lastName"], @"Goodman", @"Lastname local not updated");
            
            [self.parse_students[0] refresh];
            XCTAssertEqualObjects([self.parse_students[0] valueForKey:@"firstName"], @"Saul", @"Firstname server not updated");
            XCTAssertEqualObjects([self.parse_students[0] valueForKey:@"lastName"], @"Goodman", @"Lastname server rolledback");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateSameAttributeServerWins {
    [self.students[0] setValue:@"Saul" forKey:@"firstName"];
    [[TKDB defaultDB].rootContext save:nil];
    
    sleep(2);
    
    [self.parse_students[0] setValue:@"Mike" forKeyPath:@"firstName"];
    [self.parse_students[0] setValue:[NSDate date] forKeyPath:kTKDBUpdatedDateField];
    [self.parse_students[0] save];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqualObjects([self.students[0] valueForKey:@"firstName"], @"Mike", @"Firstname local not updated");
            
            [self.parse_students[0] refresh];
            XCTAssertEqualObjects([self.parse_students[0] valueForKey:@"firstName"], @"Mike", @"Firstname server rolledback");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateSameAttributeLocalWins {
    [self.parse_students[0] setValue:@"Mike" forKeyPath:@"firstName"];
    [self.parse_students[0] setValue:[NSDate date] forKeyPath:kTKDBUpdatedDateField];
    [self.parse_students[0] save];
    
    sleep(2);
    
    [self.students[0] setValue:@"Saul" forKey:@"firstName"];
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
            XCTAssertEqualObjects([self.students[0] valueForKey:@"firstName"], @"Saul", @"Firstname local rolledback");
            
            [self.parse_students[0] refresh];
            XCTAssertEqualObjects([self.parse_students[0] valueForKey:@"firstName"], @"Saul", @"Firstname server not updated");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateToOneRelationshipServerWins {
    
}

- (void) testUpdateToOneRelationshipLocalWins {
    
}

- (void) testUpdateToManyAddLocalAddServer {
    [self.classroom addStudentsObject:self.students[2]];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_classroom relationForKey:@"students"] addObject:self.parse_students[3]];
    [[self.parse_students[3] relationForKey:@"classes"] addObject:self.parse_classroom];
    [PFObject saveAll:@[self.parse_classroom, self.parse_students[3]]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqual([[self.classroom students] count], 4, @"Not all students are added to local class");
            
            [self.parse_classroom refresh];
            [self.parse_students[2] refresh];
            XCTAssertEqual([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count], 4, @"Not all students are added to server class");
            XCTAssertEqual([[[[self.parse_students[2] relationForKey:@"classes"] query] findObjects] count], 1, @"Class not added to server student");
            
            EndBlock();
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateToManyAddLocalRemoveServer {
    [self.classroom addStudentsObject:self.students[2]];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_students[1]];
    [[self.parse_students[1] relationForKey:@"classes"] removeObject:self.parse_classroom];
    [PFObject saveAll:@[self.parse_classroom, self.parse_students[1]]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqual([[self.classroom students] count], 2, @"Error in local students count");
            
            [self.parse_classroom refresh];
            [self.parse_students[2] refresh];
            XCTAssertEqual([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count], 2, @"Error in server students count");
            XCTAssertEqual([[[[self.parse_students[2] relationForKey:@"classes"] query] findObjects] count], 1, @"Class not added to server student");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateToManyAddServerRemoveLocal {
    [self.classroom removeStudentsObject:self.students[1]];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_classroom relationForKey:@"students"] addObject:self.parse_students[3]];
    [[self.parse_students[3] relationForKey:@"classes"] addObject:self.parse_classroom];
    [PFObject saveAll:@[self.parse_classroom, self.parse_students[3]]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqual([[self.classroom students] count], 2, @"Not all students are added to local class");
            
            [self.parse_classroom refresh];
            [self.parse_students[1] refresh];
            XCTAssertEqual([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count], 2, @"Not all students are added to server class");
            XCTAssertEqual([[[[self.parse_students[1] relationForKey:@"classes"] query] findObjects] count], 0, @"Class not added to server student");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateToManyAddRemoveOnLocalAndServer {
    [self.classroom addStudentsObject:self.students[2]];
    [self.classroom removeStudentsObject:self.students[0]];
    [[TKDB defaultDB].rootContext save:nil];
    
    [[self.parse_classroom relationForKey:@"students"] addObject:self.parse_students[3]];
    [[self.parse_students[3] relationForKey:@"classes"] addObject:self.parse_classroom];
    [PFObject saveAll:@[self.parse_classroom, self.parse_students[3]]];
    [[self.parse_classroom relationForKey:@"students"] removeObject:self.parse_students[1]];
    [[self.parse_students[1] relationForKey:@"classes"] removeObject:self.parse_classroom];
    [PFObject saveAll:@[self.parse_classroom, self.parse_students[1]]];
    
    StartBlock();
    
    [[[TKDB defaultDB] sync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            
        }
        else if (task.error) {
            XCTFail(@"Sync Failed");
            EndBlock();
        }
        else {
            XCTAssertEqual([[self.classroom students] count], 2, @"Not all students are added to local class");
            XCTAssertEqual([[self.students[0] classes] count], 0, @"Student not updated on local");
            XCTAssertEqual([[self.students[1] classes] count], 0, @"Student not updated on local");
            XCTAssertEqual([[self.students[2] classes] count], 1, @"Student not updated on local");
            XCTAssertEqual([[self.students[3] classes] count], 1, @"Student not updated on local");
            
            [self.parse_classroom refresh];
            [self.parse_students[3] refresh];
            [self.parse_students[2] refresh];
            [self.parse_students[1] refresh];
            [self.parse_students[0] refresh];
            XCTAssertEqual([[[[self.parse_classroom relationForKey:@"students"] query] findObjects] count], 2, @"Not all students are added to server class");
            XCTAssertEqual([[[[self.parse_students[0] relationForKey:@"classes"] query] findObjects] count], 0, @"Class not removed from server student");
            XCTAssertEqual([[[[self.parse_students[1] relationForKey:@"classes"] query] findObjects] count], 0, @"Class not removed from server student");
            XCTAssertEqual([[[[self.parse_students[2] relationForKey:@"classes"] query] findObjects] count], 1, @"Class not removed from server student");
            XCTAssertEqual([[[[self.parse_students[3] relationForKey:@"classes"] query] findObjects] count], 1, @"Class not removed from server student");
            
            EndBlock();
            
        }
        return nil;
    }];
    
    WaitUntilBlockCompletes();
}

@end
