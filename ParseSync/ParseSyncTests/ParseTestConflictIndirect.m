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
    student3.firstName = @"Menna"; student3.lastName = @"Mostafa";
    [student3 addClassesObject:self.classroom];
    [[TKDB defaultDB].rootContext save:nil];
    
    PFObject *parse_student4 = [PFObject objectWithClassName:@"Student"];
    [parse_student4 setValue:@"Amr" forKey:@"firstName"];
    [parse_student4 setValue:@"ElSehemy" forKey:@"lastName"];
    [parse_student4 setValue:[super getAUniqueID] forKeyPath:kTKDBUniqueIDField];
    [parse_student4 save];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *parse_student3 = [super searchCloudDBForObjectWithUniqueID:student3.tk_uniqueObjectID entity:@"Student"];
        
        XCTAssertNotNil(parse_student3, @"Local insert not saved to cloud");
        
        Student *student4 = (Student*)[super searchLocalDBForObjectWithUniqueID:[parse_student4 valueForKey:kTKDBUniqueIDField] entity:@"Student"];
        
        XCTAssertNotNil(student4, @"Server insert not saved to local");
        
        EndBlock();
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
    
}
/**
 *  Insert an object and establish a relation to an existing object
 *  Update another object on the cloud to point to the same existing
 *  object.
 */
- (void) testInsertUpdateSameRelatedObject {
    
}

/**
 *  Locally, insert object a, link to object c. On server, delete object
 *  b that was linked to object c.
 */
- (void) testInsertDeleteSameRelatedObject {
    
}

/**
 *  On server, insert an object and establish a relation to an existing object
 *  Update another object locally to point to the same existing
 *  object.
 */
- (void) testUpdateInserSameRelatedObject {
    
}

/**
 *  Update two objects on local and server to point to the
 *  same object.
 */
- (void) testUpdateUpdateSameRelatedObject {
    
}

/**
 *  Locally, update object a, link to object c. On server, delete object
 *  b that was linked to object c.
 */
- (void) testUpdateDeleteSameRelatedObject {
    
}

/**
 *  Locally, delete object a which was linked to object c. On server, insert
 *  object b and link to object c.
 */
- (void) testDeleteInsertSameRelatedObject {
    
}

/**
 *  On server, update object a, link to object c. On local, delete object
 *  b that was linked to object c.
 */
- (void) testDeleteUpdateSameRelatedObject {
    
}

/**
 *  Delete two objects on server and local that were linked to same object.
 */
- (void) testDeleteDeleteSameRelatedObject {
    
}
@end
