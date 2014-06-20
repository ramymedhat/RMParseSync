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
    
    [Parse setApplicationId:@"wOA4mkcFIhmqDHQtLASnIiQtpZp5uiywF8FBjevv"/*@"vvIFEVKHztE3l8CZrECjn09T3j8cjB3y0E3VxCN8"*/
                  clientKey:@"SLLX0NJ3NCcUR40XB6DP2lIJWILdApYwAdnQ2QIx"/*@"skHvUZEUu1GqdD0LbqMyhzutGCwjIm5fUcWV6Ddj"*/];
    
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
    NSArray *entities = [self.d1_db entities];
    
    for (NSString *entity in entities) {
        PFQuery *query = [PFQuery queryWithClassName:entity];
        NSArray *objects = [query findObjects];
        [PFObject deleteAll:objects];
    }
}

- (void) tearDown {
    //Clear cloud database
    //[self clearParse];
    
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

- (TKClassroom *)createClassroomInContext:(NSManagedObjectContext *)context {
    TKClassroom *classroom = [TKClassroom insertInManagedObjectContext:context];
    classroom.classroomId = [self getAUniqueID];
    
    classroom.title = @"Math 1";
    classroom.code = @"BS-1";
    classroom.category = @"Basic Science";
    classroom.lessonsStartDate = [NSDate date];
    classroom.lessonsEndDate = [NSDate dateWithTimeInterval:3*30*24*60*60 sinceDate:classroom.lessonsStartDate];
    
    return classroom;
}

- (TKStudent *)createStudentInContext:(NSManagedObjectContext *)context {
    TKStudent *student = [TKStudent insertInManagedObjectContext:context];
    student.studentId = [self getAUniqueID];
    
    student.firstName = @"Ahmad";
    student.lastName = @"AlMoraly";
    
    TKAccessCode *accessCode = [TKAccessCode insertInManagedObjectContext:context];
    accessCode.accesscodeId = [self getAUniqueID];
    accessCode.studentCode = [[NSUUID UUID] UUIDString];
    accessCode.parentCode = [[NSUUID UUID] UUIDString];
    NSString *parentRoleName = [@"parent-" stringByAppendingString:[[NSUUID UUID] UUIDString]];
    NSString *studentRoleName = [@"student-" stringByAppendingString:[[NSUUID UUID] UUIDString]];
    accessCode.parentRoleName = parentRoleName;
    accessCode.studentRoleName = studentRoleName;
    
    accessCode.student = student;
    
    student.accessCode = accessCode;
    
    return student;
}


-(void)getImageForEntity:(NSManagedObject *)entity forKey:(NSString*)key withCompletion:(id)pictureDownloadComplete {
    
    NSString *dzFileKey =[@"dz_"stringByAppendingString:key];
    NSString *pfFileName = [entity valueForKey:dzFileKey];
    
    if (pfFileName && pfFileName.length >0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *fullPath;// = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:dzPath_pfFileCatch,pfFileName]];
        
        //Check if file exists in the catch directory. If it exists load the catch.
        //When no file present reload the pfFile to fill the catch and use the image.
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
            
            UIImage *returnImage =[UIImage imageWithContentsOfFile:fullPath];
            
            if (pictureDownloadComplete) {
                //            pictureDownloadComplete(YES,returnImage,YES,nil);
            }
            
            [self refreshPictureDataIfPossibleOnEntity:entity forKey:key
                                           onDzFileKey:dzFileKey
                                        withCompletion:pictureDownloadComplete];
        }
        else
        {
            //If the file does not exist get the PFFile and the data.
            
            [self refreshPictureDataIfPossibleOnEntity:entity forKey:key
                                           onDzFileKey:dzFileKey withCompletion:pictureDownloadComplete];
        }
    }
    else
    {
        [self refreshPictureDataIfPossibleOnEntity:entity
                                            forKey:key
                                       onDzFileKey:dzFileKey
                                    withCompletion:pictureDownloadComplete];
    }
    
}

-(void)refreshPictureDataIfPossibleOnEntity:(NSManagedObject *)entity forKey:(NSString*)key onDzFileKey:(NSString*)dzFileKey withCompletion:(id)pictureDownloadComplete {
    
    if (true /*self.isConnectionPossible*/) {
        PFObject *emptyPFObject;
        [emptyPFObject refreshInBackgroundWithBlock:^(PFObject
                                                             *object, NSError *error) {
            if (!error) {
                PFFile *pfImageFile = [object valueForKey:key];
//                [self getDataFromPFFile:pfImageFile forEntity:entity onDzFileKey:dzFileKey cached:NO withCompletion:pictureDownloadComplete];
            }
            else{
//                TFLog(@"ERROR: refresh picture failed with error %@", error);
                if (pictureDownloadComplete) {
//                    pictureDownloadComplete(NO, nil, NO, nil);
                }
            }
        }];
        
    }else{
        if (pictureDownloadComplete) {
//            pictureDownloadComplete(NO, nil, NO, nil);
        }
    }
}
@end
