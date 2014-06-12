//
//  ParseMultipleDeviceTestCase.m
//  ParseSync
//
//  Created by Ahmed AlMoraly on 6/11/14.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "ParseMultipleDeviceTestCase.h"


@implementation ParseMultipleDeviceTestCase

- (NSManagedObjectContext *)setUpCoreDataStackWithName:(NSString *)storeFileName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:@"TeacherKit" withExtension:@"momd"];
    NSManagedObjectModel *_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];

    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"RMParse"];
    NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:storeFileName]];
    
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [url URLByDeletingLastPathComponent];
    
    if ([fileManager fileExistsAtPath:pathToStore.path]) {
        [fileManager removeItemAtURL:pathToStore error:nil];
    }
    
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!pathWasCreated)
    {
        XCTFail(@"error creating store");
    }

    [persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:nil
                                                          error:&error];

    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return managedObjectContext;
    
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [Parse setApplicationId:@"vvIFEVKHztE3l8CZrECjn09T3j8cjB3y0E3VxCN8"
                  clientKey:@"skHvUZEUu1GqdD0LbqMyhzutGCwjIm5fUcWV6Ddj"];
    
    [PFUser logInWithUsername:@"moraly" password:@"a"];
    [PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
    
    
    
    self.d1_db = [[TKDB alloc] init];
    self.d1_db.rootContext = [self setUpCoreDataStackWithName:@"Device1.sqlite"];
    self.d1_cacheManager = [[TKDBCacheManager alloc] init];
    
    
    self.d2_db = [[TKDB alloc] init];
    self.d2_db.rootContext = [self setUpCoreDataStackWithName:@"Device2.sqlite"];
    self.d2_cacheManager = [[TKDBCacheManager alloc] init];
    
    [self clearParse];
}

- (void)clearParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Classroom"];
    NSArray *objects = [query findObjects];
    [PFObject deleteAll:objects];
    
    query = [PFQuery queryWithClassName:@"Student"];
    objects = [query findObjects];
    [PFObject deleteAll:objects];
    
    query = [PFQuery queryWithClassName:@"Behaviortype"];
    objects = [query findObjects];
    [PFObject deleteAll:objects];
    
    query = [PFQuery queryWithClassName:@"Behavior"];
    objects = [query findObjects];
    [PFObject deleteAll:objects];
}

- (void) tearDown {
    //Clear cloud database
    [self clearParse];
    
    [super tearDown];
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
    return [[NSUUID UUID] UUIDString];
}

@end
