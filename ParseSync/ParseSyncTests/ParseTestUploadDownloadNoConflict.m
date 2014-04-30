//
//  ParseTestUploadDownloadNoConflict.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-29.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParseBaseTestCase.h"

@interface ParseTestUploadDownloadNoConflict : ParseBaseTestCase

@end

@implementation ParseTestUploadDownloadNoConflict

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super createTemplateObjects];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testInsertInsert {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Menna"; student3.lastName = @"Mostafa";
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

- (void) testInsertUpdate {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Menna"; student3.lastName = @"Mostafa";
    [[TKDB defaultDB].rootContext save:nil];
    
    [self.parse_student2 setValue:@"Amr" forKey:@"firstName"];
    [self.parse_student2 setValue:@"ElSehemy" forKey:@"lastName"];
    [self.parse_student2 save];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *parse_student3 = [super searchCloudDBForObjectWithUniqueID:student3.tk_uniqueObjectID entity:@"Student"];
        
        XCTAssertNotNil(parse_student3, @"Local insert not saved to cloud");
        
        XCTAssertEqualObjects(self.student2.firstName, @"Amr", @"Server update not downloaded correctly");
        
        EndBlock();
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testInsertDelete {
    Student *student3 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student3.firstName = @"Menna"; student3.lastName = @"Mostafa";
    [[TKDB defaultDB].rootContext save:nil];
    
    [self.parse_student2 setValue:@YES forKey:@"isDeleted"];
    [self.parse_student2 save];
    
    StartBlock();
    
    [[TKDB defaultDB] syncWithSuccessBlock:^(NSArray *objects) {
        PFObject *parse_student3 = [super searchCloudDBForObjectWithUniqueID:student3.tk_uniqueObjectID entity:@"Student"];
        
        XCTAssertNotNil(parse_student3, @"Local insert not saved to cloud");
        
        XCTAssertNil(self.student2.managedObjectContext, @"Server delete not applied locally");
        
        EndBlock();
    } andFailureBlock:^(NSArray *objects, NSError *error) {
        XCTFail(@"Sync Failed");
        EndBlock();
    }];
    
    WaitUntilBlockCompletes();
}

- (void) testUpdateInsert {
    
}

- (void) testUpdateUpdate {
    
}

- (void) testUpdateDelete {
    
}

- (void) testDeleteInsert {
    
}

- (void) testDeleteUpdate {
    
}

- (void) testDeleteDelete {
    
}

@end
