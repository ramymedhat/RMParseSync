//
//  ParseBaseTestCase.m
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-28.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "ParseBaseTestCase.h"
#import "TKDBCacheManager.h"

@implementation ParseBaseTestCase

- (void) setUp {
    [super setUp];
    
//    [Parse setApplicationId:@"vvIFEVKHztE3l8CZrECjn09T3j8cjB3y0E3VxCN8"
//                  clientKey:@"skHvUZEUu1GqdD0LbqMyhzutGCwjIm5fUcWV6Ddj"];
    
    [Parse setApplicationId:@"dF5jw2NyW1xV7PwT2OLTQlXdfNDNfA6fj7bv8eE2"/*@"vvIFEVKHztE3l8CZrECjn09T3j8cjB3y0E3VxCN8"*/
                  clientKey:@"tmAegbSiFExlTQSPjVYAQBohQtjbLLUsHx45nhEt"/*@"skHvUZEUu1GqdD0LbqMyhzutGCwjIm5fUcWV6Ddj"*/];
    
    
//    [Parse setApplicationId:@"wOA4mkcFIhmqDHQtLASnIiQtpZp5uiywF8FBjevv"/*@"vvIFEVKHztE3l8CZrECjn09T3j8cjB3y0E3VxCN8"*/
//                  clientKey:@"SLLX0NJ3NCcUR40XB6DP2lIJWILdApYwAdnQ2QIx"/*@"skHvUZEUu1GqdD0LbqMyhzutGCwjIm5fUcWV6Ddj"*/];
    //Create In memory store
    
    [PFUser logInWithUsername:@"moraly" password:@"a"];
    [PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:@"ParseSyncTest" withExtension:@"momd"];
    NSManagedObjectModel *_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    
    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    [TKDB defaultDB].rootContext = _managedObjectContext;
    
    [TKDB defaultDB].entities = [[_managedObjectModel entitiesByName] allKeys];
    
    //Clear cloud database
    
    NSArray *entities = [[TKDB defaultDB] entities];
    
    for (NSString *entity in entities) {
        PFQuery *query = [PFQuery queryWithClassName:entity];
        NSArray *objects = [query findObjects];
        [PFObject deleteAll:objects];
    }
}

/**
 *     AttendanceType                                      Attendance
 *     ----------------------------                        ----------------
 *     self.attendanceType[Present]__________              self.attendance1
 *                                           \_____________self.attendance2
 *
 *
 *     Classroom                                           Student
 *     ---------------------------                         --------------------
 *     self.classroom[Mathematics]_________________________self.student1[Ramy Medhat]
 *                                                         self.student2[Yara Medhat]
 *
 */
- (void) createTemplateObjects {
    // Insert objects in local and server separately without using sync
    self.attendanceType = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceType" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.attendanceType.title = @"Present";
    
    self.attendance1 = [NSEntityDescription insertNewObjectForEntityForName:@"Attendance" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.attendance1.attendanceDate = [NSDate date];
    
    self.attendance2 = [NSEntityDescription insertNewObjectForEntityForName:@"Attendance" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.attendance2.attendanceDate = [NSDate date];
    self.attendance2.attendanceType = self.attendanceType;
    
    self.classroom = [NSEntityDescription insertNewObjectForEntityForName:@"Classroom" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.classroom.title = @"Mathematics";
    self.classroom.serverObjectID = nil;
    
    self.student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.student.firstName = @"Walter";
    self.student.lastName = @"White";
    self.student.serverObjectID = nil;
    [self.student addClassesObject:self.classroom];
    [self.classroom addStudentsObject:self.student];
    
    self.student2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.student2.firstName = @"Skylar";
    self.student2.lastName = @"White";
    self.student2.serverObjectID = nil;
    
    [[TKDB defaultDB].rootContext save:nil];
    
    self.parse_attendanceType = [PFObject objectWithClassName:@"AttendanceType"];
    [self.parse_attendanceType setValue:self.attendanceType.title forKeyPath:@"title"];
    [self.parse_attendanceType setValue:self.attendanceType.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_attendanceType setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_attendanceType save];
    
    self.parse_classroom = [PFObject objectWithClassName:@"Classroom"];
    [self.parse_classroom setValue:@"Mathematics" forKeyPath:@"title"];
    [self.parse_classroom setValue:self.classroom.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_classroom setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_classroom save];
    
    self.parse_student = [PFObject objectWithClassName:@"Student"];
    [self.parse_student setValue:@"Walter" forKeyPath:@"firstName"];
    [self.parse_student setValue:@"White" forKeyPath:@"lastName"];
    [self.parse_student setValue:self.student.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_student setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_student save];
    
    self.parse_student2 = [PFObject objectWithClassName:@"Student"];
    [self.parse_student2 setValue:@"Skylar" forKeyPath:@"firstName"];
    [self.parse_student2 setValue:@"White" forKeyPath:@"lastName"];
    [self.parse_student2 setValue:self.student2.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_student2 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_student2 save];
    
    self.parse_attendance1 = [PFObject objectWithClassName:@"Attendance"];
    [self.parse_attendance1 setValue:self.attendance1.attendanceDate forKeyPath:@"attendanceDate"];
    [self.parse_attendance1 setValue:self.attendance1.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_attendance1 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_attendance1 save];
    
    self.parse_attendance2 = [PFObject objectWithClassName:@"Attendance"];
    [self.parse_attendance2 setValue:self.attendance2.attendanceDate forKeyPath:@"attendanceDate"];
    [self.parse_attendance2 setValue:self.attendance2.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_attendance2 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_attendance2 setValue:self.parse_attendanceType forKeyPath:@"attendanceType"];
    [self.parse_attendance2 save];
    
    PFRelation *relation1 = [self.parse_classroom relationForKey:@"students"];
    [relation1 addObject:self.parse_student];
    
    PFRelation *relation2 = [self.parse_student relationForKey:@"classes"];
    [relation2 addObject:self.parse_classroom];
    
    PFRelation *relation3 = [self.parse_attendanceType relationForKey:@"attendances"];
    [relation3 addObject:self.parse_attendance2];
    
    [PFObject saveAll:@[self.parse_classroom, self.parse_student, self.parse_student2, self.parse_attendanceType,
                        self.parse_attendance1, self.parse_attendance2]];
    
    self.attendanceType.serverObjectID = self.parse_attendanceType.objectId;
    self.classroom.serverObjectID = self.parse_classroom.objectId;
    self.student.serverObjectID = self.parse_student.objectId;
    self.student2.serverObjectID = self.parse_student2.objectId;
    self.attendance1.serverObjectID = self.parse_attendance1.objectId;
    self.attendance2.serverObjectID = self.parse_attendance2.objectId;
    [[TKDB defaultDB].rootContext save:nil];
    
    // Clear cache to begin with a new slate
    [[TKDBCacheManager sharedManager] clearCache];
    //    [[TKDBCacheManager sharedManager] clearMappings];
    
    [[TKDB defaultDB] setLastSyncDate:[NSDate date]];
    sleep(1);
}


/**
 *     Classroom                                           Student
 *     ---------------------------                         ----------------------------------
 *     self.classroom[Mathematics]_________________________self.students[0] = [Walter White]
 *                                          \______________self.students[1] = [Skylar White]
 *                                                         self.students[2] = [Jesse Pinkman]
 *                                                         self.students[3] = [Hank Shrader]
 *                                                         self.students[4] = [Marie Shrader]
 */
- (void) createTemplateObjects2 {
    // Insert objects in local and server separately without using sync
    
    self.classroom = [NSEntityDescription insertNewObjectForEntityForName:@"Classroom" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.classroom.title = @"Mathematics";
    self.classroom.serverObjectID = nil;
    self.students = [NSMutableArray array];
    self.parse_students = [NSMutableArray array];
    
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student.firstName = @"Walter";
    student.lastName = @"White";
    student.serverObjectID = nil;
    [student addClassesObject:self.classroom];
    [self.classroom addStudentsObject:student];
    [self.students addObject:student];
    
    student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student.firstName = @"Skylar";
    student.lastName = @"White";
    student.serverObjectID = nil;
    [student addClassesObject:self.classroom];
    [self.classroom addStudentsObject:student];
    [self.students addObject:student];
    
    student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student.firstName = @"Jesse";
    student.lastName = @"Pinkman";
    student.serverObjectID = nil;
    [self.students addObject:student];
    
    student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student.firstName = @"Hank";
    student.lastName = @"Shrader";
    student.serverObjectID = nil;
    [self.students addObject:student];
    
    student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    student.firstName = @"Marie";
    student.lastName = @"Shrader";
    student.serverObjectID = nil;
    [self.students addObject:student];
    
    [[TKDB defaultDB].rootContext save:nil];
    
    self.parse_classroom = [PFObject objectWithClassName:@"Classroom"];
    [self.parse_classroom setValue:@"Mathematics" forKeyPath:@"title"];
    [self.parse_classroom setValue:self.classroom.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [self.parse_classroom setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [self.parse_classroom save];
    
    PFObject *parse_student = [PFObject objectWithClassName:@"Student"];
    [parse_student setValue:@"Walter" forKeyPath:@"firstName"];
    [parse_student setValue:@"White" forKeyPath:@"lastName"];
    [parse_student setValue:[self.students[0] tk_uniqueObjectID] forKeyPath:kTKDBUniqueIDField];
    [parse_student setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [parse_student save];
    [self.parse_students addObject:parse_student];
    
    parse_student = [PFObject objectWithClassName:@"Student"];
    [parse_student setValue:@"Skylar" forKeyPath:@"firstName"];
    [parse_student setValue:@"White" forKeyPath:@"lastName"];
    [parse_student setValue:[self.students[1] tk_uniqueObjectID] forKeyPath:kTKDBUniqueIDField];
    [parse_student setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [parse_student save];
    [self.parse_students addObject:parse_student];
    
    parse_student = [PFObject objectWithClassName:@"Student"];
    [parse_student setValue:@"Jesse" forKeyPath:@"firstName"];
    [parse_student setValue:@"Pinkman" forKeyPath:@"lastName"];
    [parse_student setValue:[self.students[2] tk_uniqueObjectID] forKeyPath:kTKDBUniqueIDField];
    [parse_student setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [parse_student save];
    [self.parse_students addObject:parse_student];
    
    parse_student = [PFObject objectWithClassName:@"Student"];
    [parse_student setValue:@"Hank" forKeyPath:@"firstName"];
    [parse_student setValue:@"Shrader" forKeyPath:@"lastName"];
    [parse_student setValue:[self.students[3] tk_uniqueObjectID] forKeyPath:kTKDBUniqueIDField];
    [parse_student setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [parse_student save];
    [self.parse_students addObject:parse_student];
    
    parse_student = [PFObject objectWithClassName:@"Student"];
    [parse_student setValue:@"Marie" forKeyPath:@"firstName"];
    [parse_student setValue:@"Shrader" forKeyPath:@"lastName"];
    [parse_student setValue:[self.students[4] tk_uniqueObjectID] forKeyPath:kTKDBUniqueIDField];
    [parse_student setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [parse_student save];
    [self.parse_students addObject:parse_student];
    
    PFRelation *relation1 = [self.parse_classroom relationForKey:@"students"];
    [relation1 addObject:self.parse_students[0]];
    [relation1 addObject:self.parse_students[1]];
    
    PFRelation *relation2 = [self.parse_students[0] relationForKey:@"classes"];
    [relation2 addObject:self.parse_classroom];
    
    PFRelation *relation3 = [self.parse_students[1] relationForKey:@"classes"];
    [relation3 addObject:self.parse_classroom];
    
    [PFObject saveAll:@[self.parse_classroom, self.parse_students[0], self.parse_students[1]]];
    
    [self.classroom setServerObjectID:[self.parse_classroom objectId]];
    [self.students[0] setServerObjectID:[self.parse_students[0] objectId]];
    [self.students[1] setServerObjectID:[self.parse_students[1] objectId]];
    [self.students[2] setServerObjectID:[self.parse_students[2] objectId]];
    [self.students[3] setServerObjectID:[self.parse_students[3] objectId]];
    [self.students[4] setServerObjectID:[self.parse_students[4] objectId]];
    [[TKDB defaultDB].rootContext save:nil];
    
    // Clear cache to begin with a new slate
    [[TKDBCacheManager sharedManager] clearCache];
    //    [[TKDBCacheManager sharedManager] clearMappings];
    
    [[TKDB defaultDB] setLastSyncDate:[NSDate date]];
    sleep(1);
}

- (void) tearDown {
    //Clear cloud database
    PFQuery *query = [PFQuery queryWithClassName:@"Classroom"];
    NSArray *objects = [query findObjects];
    
    for (PFObject *object in objects) {
        [object delete];
    }
    
    query = [PFQuery queryWithClassName:@"Student"];
    objects = [query findObjects];
    
    for (PFObject *object in objects) {
        [object delete];
    }
    
    query = [PFQuery queryWithClassName:@"AttendanceType"];
    objects = [query findObjects];
    
    for (PFObject *object in objects) {
        [object delete];
    }
    
    query = [PFQuery queryWithClassName:@"Attendance"];
    objects = [query findObjects];
    
    for (PFObject *object in objects) {
        [object delete];
    }
}

- (NSManagedObject*) searchLocalDBForObjectWithUniqueID:(NSString*)uniqueID entity:(NSString*)entity {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", kTKDBUniqueIDField, uniqueID];
    NSArray *results = [[TKDB defaultDB].rootContext executeFetchRequest:fetchRequest error:nil];
    
    if ([results count] == 1) {
        return results[0];
    }
    else {
        return nil;
    }
}


- (PFObject*) searchCloudDBForObjectWithUniqueID:(NSString*)uniqueID entity:(NSString*)entity {
    PFQuery *query = [PFQuery queryWithClassName:entity];
    [query whereKey:kTKDBUniqueIDField equalTo:uniqueID];
    NSArray *results = [query findObjects];
    
    if ([results count] == 1) {
        return results[0];
    }
    else {
        return nil;
    }
}

- (NSString*) getAUniqueID {
    CFUUIDRef uuid = CFUUIDCreate(CFAllocatorGetDefault());
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(CFAllocatorGetDefault(), uuid);
    CFRelease(uuid);
    return uuidString;
}

@end
