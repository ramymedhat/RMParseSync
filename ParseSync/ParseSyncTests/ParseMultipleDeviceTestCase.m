//
//  ParseMultipleDeviceTestCase.m
//  ParseSync
//
//  Created by Ahmed AlMoraly on 6/11/14.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "ParseMultipleDeviceTestCase.h"
#import "TKParseManagerDelegate.h"

@interface UIColor (Random)

+ (UIColor *)randomColor;

@end

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
    
    self.delegate = [[TKParseManagerDelegate alloc] init];
    
    
    self.d1_db = [[TKDB alloc] init];
    self.d1_db.syncManagerDelegate = self.delegate;
    self.d1_db.rootContext = [self setUpCoreDataStackWithName:@"Device1.sqlite"];
    self.d1_cacheManager = [[TKDBCacheManager alloc] init];
    self.d2_cacheManager.dictCacheFilename = [NSString stringWithFormat:@"%lu-%@", self.d1_cacheManager.hash, self.d1_cacheManager.dictCacheFilename];
    self.d2_cacheManager.dictLocalMappingFilename = [NSString stringWithFormat:@"%lu-%@", self.d1_cacheManager.hash, self.d1_cacheManager.dictLocalMappingFilename];
    self.d2_cacheManager.dictServerMappingFilename = [NSString stringWithFormat:@"%lu-%@", self.d1_cacheManager.hash, self.d1_cacheManager.dictServerMappingFilename];
    
    
    self.d2_db = [[TKDB alloc] init];
    self.d2_db.syncManagerDelegate = self.delegate;
    self.d2_db.rootContext = [self setUpCoreDataStackWithName:@"Device2.sqlite"];
    self.d2_cacheManager = [[TKDBCacheManager alloc] init];
    self.d2_cacheManager.dictCacheFilename = [NSString stringWithFormat:@"%lu-%@", self.d2_cacheManager.hash, self.d2_cacheManager.dictCacheFilename];
    self.d2_cacheManager.dictLocalMappingFilename = [NSString stringWithFormat:@"%lu-%@", self.d2_cacheManager.hash, self.d2_cacheManager.dictLocalMappingFilename];
    self.d2_cacheManager.dictServerMappingFilename = [NSString stringWithFormat:@"%lu-%@", self.d2_cacheManager.hash, self.d2_cacheManager.dictServerMappingFilename];
    
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

- (TKClassroom *)createClassroomWithImageInContext:(NSManagedObjectContext *)context {
    TKClassroom *classroom = [TKClassroom insertInManagedObjectContext:context];
    classroom.classroomId = [self getAUniqueID];
    
    classroom.title = @"Math 1";
    classroom.code = @"BS-1";
    classroom.category = @"Basic Science";
    classroom.lessonsStartDate = [NSDate date];
    classroom.lessonsEndDate = [NSDate dateWithTimeInterval:3*30*24*60*60 sinceDate:classroom.lessonsStartDate];
    
    classroom.image_BinaryPathKey = [self newImagePath];
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

- (NSString *)newImagePath {
    UIImage *image = [self randomColoredImage];
    NSString *imageName = [[NSUUID UUID] UUIDString];
    NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:imageName] stringByAppendingPathExtension:@"jpg"];
    [UIImageJPEGRepresentation(image, 0.5) writeToFile:path atomically:YES];
    
    NSString *relativePath = [path stringByReplacingCharactersInRange:[path rangeOfString:NSHomeDirectory()] withString:@""];
    return relativePath;
}

- (UIImage *)randomColoredImage {
    UIImage *img = [UIImage imageWithContentsOfFile:@"/Users/ahmedalmoraly/Developer/RMParseSync/ParseSync/ParseSyncTests/user_placeholder.png"];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [[UIColor randomColor] setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end


@implementation UIColor (Random)

+ (UIColor *)randomColor {
    /*
     
     Distributed under The MIT License:
     http://opensource.org/licenses/mit-license.php
     
     Permission is hereby granted, free of charge, to any person obtaining
     a copy of this software and associated documentation files (the
     "Software"), to deal in the Software without restriction, including
     without limitation the rights to use, copy, modify, merge, publish,
     distribute, sublicense, and/or sell copies of the Software, and to
     permit persons to whom the Software is furnished to do so, subject to
     the following conditions:
     
     The above copyright notice and this permission notice shall be
     included in all copies or substantial portions of the Software.
     
     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
     LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
     OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
     WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
     */
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end