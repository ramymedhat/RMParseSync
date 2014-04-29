//
//  TKDB.h
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-19.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTKDBUniqueIDField          @"tkID"
#define kTKDBServerIDField          @"serverObjectID"
#define kTKDBIsShadowField          @"isShadow"
#define kTKDBIsDeletedField         @"isDeleted"
#define kTKDBCreatedDateField       @"createdDate"
#define kTKDBUpdatedDateField       @"updatedDate"

#define kLastSyncDate @"LastSync"
#define kEntities @[@"Classroom", @"Student", @"Attendance", @"AttendanceType"]

typedef void (^TKSyncSuccessBlock)(NSArray *objects);
typedef void (^TKSyncFailureBlock)(NSArray *objects, NSError *error);

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
} \
} while(0)

@interface TKDB : NSObject

/**
 *  Root saving context.
 */
@property (nonatomic, strong) NSManagedObjectContext *rootContext;

/**
 *  Reference context for getting the old values of changed objects.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *referenceContext;

/**
 *  Context used for syncing. Is a child of the root context.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *syncContext;

+ (TKDB*) defaultDB;

- (void) setRootContext:(NSManagedObjectContext*)rootContext;

- (NSDate*) lastSyncDate;
- (void) setLastSyncDate:(NSDate*)date;

- (void) syncWithSuccessBlock:(TKSyncSuccessBlock)successBlock andFailureBlock:(TKSyncFailureBlock)failureBlock;

@end
