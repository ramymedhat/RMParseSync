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
    
    [Parse setApplicationId:@"2cjtLvANwrqhS94xOc9k4AKENGH8kjOpLNfov7cQ"
                  clientKey:@"AbsBXCzUmb7983UBd5owHzyOy9qEcrWT2pNgjXH5"];
    
    //Create In memory store
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:@"ParseSyncTest" withExtension:@"momd"];
    NSManagedObjectModel *_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    
    NSManagedObjectContext *_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    [TKDB defaultDB].rootContext = _managedObjectContext;
    
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
    self.student.firstName = @"Ramy";
    self.student.lastName = @"Medhat";
    self.student.serverObjectID = nil;
    [self.student addClassesObject:self.classroom];
    [self.classroom addStudentsObject:self.student];
    
    self.student2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[TKDB defaultDB].rootContext];
    self.student2.firstName = @"Yara";
    self.student2.lastName = @"Medhat";
    self.student2.serverObjectID = nil;
    
    [[TKDB defaultDB].rootContext save:nil];
    
    PFObject *object = [PFObject objectWithClassName:@"AttendanceType"];
    [object setValue:self.attendanceType.title forKeyPath:@"title"];
    [object setValue:self.attendanceType.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [object setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object save];
    
    PFObject *object1 = [PFObject objectWithClassName:@"Classroom"];
    [object1 setValue:@"Mathematics" forKeyPath:@"title"];
    [object1 setValue:self.classroom.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [object1 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object1 save];
    
    PFObject *object2 = [PFObject objectWithClassName:@"Student"];
    [object2 setValue:@"Ramy" forKeyPath:@"firstName"];
    [object2 setValue:@"Medhat" forKeyPath:@"lastName"];
    [object2 setValue:self.student.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [object2 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object2 save];
    
    PFObject *object3 = [PFObject objectWithClassName:@"Student"];
    [object3 setValue:@"Yara" forKeyPath:@"firstName"];
    [object3 setValue:@"Medhat" forKeyPath:@"lastName"];
    [object3 setValue:self.student2.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [object3 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object3 save];
    
    PFObject *object4 = [PFObject objectWithClassName:@"Attendance"];
    [object4 setValue:self.attendance1.attendanceDate forKeyPath:@"attendanceDate"];
    [object4 setValue:self.attendance1.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [object4 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object4 save];
    
    PFObject *object5 = [PFObject objectWithClassName:@"Attendance"];
    [object5 setValue:self.attendance2.attendanceDate forKeyPath:@"attendanceDate"];
    [object5 setValue:self.attendance2.tk_uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [object5 setValue:@NO forKeyPath:kTKDBIsDeletedField];
    [object5 setValue:object forKeyPath:@"attendanceType"];
    [object5 save];
    
    PFRelation *relation1 = [object1 relationForKey:@"students"];
    [relation1 addObject:object2];
    
    PFRelation *relation2 = [object2 relationForKey:@"classes"];
    [relation2 addObject:object1];
    
    PFRelation *relation3 = [object relationForKey:@"attendances"];
    [relation3 addObject:object5];
    
    [PFObject saveAll:@[object1, object2, object3, object4, object5]];
    
    self.attendanceType.serverObjectID = object.objectId;
    self.classroom.serverObjectID = object1.objectId;
    self.student.serverObjectID = object2.objectId;
    self.student2.serverObjectID = object3.objectId;
    self.attendance1.serverObjectID = object4.objectId;
    self.attendance2.serverObjectID = object5.objectId;
    [[TKDB defaultDB].rootContext save:nil];
    
    // Clear cache to begin with a new slate
    [[TKDBCacheManager sharedManager] clearCache];
    //    [[TKDBCacheManager sharedManager] clearMappings];
    
    [[TKDB defaultDB] setLastSyncDate:[NSDate date]];
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

+ (NSString*) getAUniqueID {
    CFUUIDRef uuid = CFUUIDCreate(CFAllocatorGetDefault());
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(CFAllocatorGetDefault(), uuid);
    CFRelease(uuid);
    return uuidString;
}

@end
