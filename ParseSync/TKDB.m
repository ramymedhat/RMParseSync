//
//  TKDB.m
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-19.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "TKDB.h"
#import "TKParseServerSyncManager.h"
#import "TKServerObject.h"
#import "TKServerObjectHelper.h"
#import "TKDBCacheManager.h"

@implementation TKDB {
    /**
     *  Used to stop notifications form firing during sync.
     */
    BOOL disableNotifications;
}

+ (instancetype)defaultDB
{
    static dispatch_once_t pred = 0;
    __strong static TKDB* _defaultDB = nil;
    dispatch_once(&pred, ^{
        _defaultDB = [[self alloc] init];
    });
    
    return _defaultDB;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        disableNotifications = NO;
    }
    return self;
}


- (void) contextDidSave:(NSNotification*)notification {
    
    if (disableNotifications) {
        return;
    }
    
    NSDictionary *dictChanges = notification.userInfo;
    
    for (NSManagedObject *object in dictChanges[NSInsertedObjectsKey]) {
        if ([object tk_serverObjectID] != nil) {
            continue;
        }
        TKDBCacheEntry *entry = [[TKDBCacheEntry alloc] initWithType:TKDBCacheInsert];
        entry.localObjectIDURL = [[[object objectID] URIRepresentation] absoluteString];
        entry.uniqueObjectID = object.tk_uniqueObjectID;
        entry.entity = object.entity.name;
        [[TKDBCacheManager sharedManager] addCacheEntry:entry];
        [[TKDBCacheManager sharedManager] mapLocalObjectWithURL:entry.localObjectIDURL toUniqueObjectWithID:entry.uniqueObjectID];
    }
    
    for (NSManagedObject *object in dictChanges[NSUpdatedObjectsKey]) {
        
        TKDBCacheEntry *entry = [[TKDBCacheManager sharedManager] entryForObjectID:object.tk_uniqueObjectID withType:TKDBCacheUpdate];
        
        // Check if there is an update entry for this object in the cache.
        if (entry) {
            // Check if the entry is pending save (which normally should be the case).
            if (entry.entryState == TKDBCachePendingSave) {
                entry.entryState = TKDBCacheSaved;
                entry.changedFields = entry.tempChangedFields;
                entry.tempChangedFields = nil;
            }
            // If the entry is not pending save, it might be the case that it is updated
            // inadvertently when saving due to a relationship getting updated. In this
            // case, we do nothing.
            else {
                
            }
        }
        // If no entry exists, do nothing. This will happen if we were saving server info.
        else {
        }
    }
    
    NSError *error;
    [[TKDB defaultDB].referenceContext save:&error];
    
    if (error) {
#warning Handle this error.
        abort();
    }
}

- (void) contextWillSave:(NSNotification*)notification {
    
    if (disableNotifications) {
        return;
    }
    
    for (NSManagedObject *object in [TKDB defaultDB].rootContext.insertedObjects) {
        if ([object tk_serverObjectID] != nil) {
            continue;
        }
        [object setValue:[NSDate date] forKey:kTKDBCreatedDateField];
        [object setValue:[NSDate date] forKey:kTKDBUpdatedDateField];
        [object assignUniqueObjectID];
    }
    
    for (NSManagedObject *object in [TKDB defaultDB].rootContext.updatedObjects) {
        
        if ([[TKDB defaultDB].rootContext.insertedObjects containsObject:object]) {
            continue;
        }
        // Do not create cache entries if we are modifying server based data.
        if (object.changedValues[kTKDBServerIDField] != nil) {
            continue;
        }
        
        // Set the updated date on the object to be saved in local db.
        [object setValue:[NSDate date] forKey:kTKDBUpdatedDateField];
        
        // Check whether there is an insert entry for this object. If there is,
        // we should ignore this update event since uploading inserted objects
        // will read from the database ayway.
        TKDBCacheEntry *entry = [[TKDBCacheManager sharedManager] entryForObjectID:object.tk_uniqueObjectID withType:TKDBCacheInsert];
        
        if (entry) {
            continue;
        }
        
        // Check if there is an update entry for this object.
        entry = [[TKDBCacheManager sharedManager] entryForObjectID:object.tk_uniqueObjectID withType:TKDBCacheUpdate];
        
        // If there is no update entry, we create a new entry.
        if (!entry) {
            entry = [[TKDBCacheEntry alloc] initWithType:TKDBCacheUpdate];
            entry.localObjectIDURL = [[[object objectID] URIRepresentation] absoluteString];
            entry.serverObjectID = object.tk_serverObjectID;
            entry.uniqueObjectID = object.tk_uniqueObjectID;
            entry.entity = object.entity.name;
            [[TKDBCacheManager sharedManager] addCacheEntry:entry];
        }
        
        // Mark the entry as pending save.
        entry.entryState = TKDBCachePendingSave;
        
        // If there are no temp changed values dictionary, create it.
        if (!entry.tempChangedFields) {
            // If there are changed values, copy them to temp to later
            // add the new changed values.
            if (entry.changedFields) {
                entry.tempChangedFields = [NSMutableSet setWithSet:entry.changedFields];
            }
            else {
                entry.tempChangedFields = [NSMutableSet set];
            }
        }
        
        // Merge the new changed values with the ones in the entry.
        [entry.tempChangedFields addObjectsFromArray:[object.changedValues allKeys]];
        
        if (!entry.shadowObjectIDURL) {
            NSManagedObject *shadow = [object duplicateObjectInContext:[TKDB defaultDB].referenceContext];
            [shadow setValue:@YES forKey:kTKDBIsShadowField];
            NSError *error;
            [[TKDB defaultDB].referenceContext obtainPermanentIDsForObjects:@[shadow] error:&error];
            
            if (error) {
#warning Handle this error.
                abort();
            }
            else {
                entry.shadowObjectIDURL = [shadow tk_localURL];
            }
        }
    }
    
    for (NSManagedObject *object in [TKDB defaultDB].rootContext.deletedObjects) {
        // If there is an insert entry for this object, we remove it.
        TKDBCacheEntry *entry = [[TKDBCacheManager sharedManager] entryForObjectID:object.tk_uniqueObjectID withType:TKDBCacheInsert];
        
        if (entry) {
            [[TKDBCacheManager sharedManager] removeEntry:entry];
            // We continue here because we do not need to inform the
            // server with the deletion of an object that hasn't been
            // uploaded.
            continue;
        }
        
        // If there is an update entry we remove it so as to not do any
        // needless work.
        entry = [[TKDBCacheManager sharedManager] entryForObjectID:object.tk_uniqueObjectID withType:TKDBCacheUpdate];
        
        if (entry) {
            [[TKDBCacheManager sharedManager] removeEntry:entry];
        }
        
        // Create the deletion entry.
        entry = [[TKDBCacheEntry alloc] initWithType:TKDBCacheDelete];
        entry.localObjectIDURL = [[[object objectID] URIRepresentation] absoluteString];
        entry.serverObjectID = [object tk_serverObjectID];
        entry.uniqueObjectID = object.tk_uniqueObjectID;
        entry.entity = object.entity.name;
        [[TKDBCacheManager sharedManager] addCacheEntry:entry];
    }
    
}

- (void) setRootContext:(NSManagedObjectContext*)rootContext {
    _rootContext = rootContext;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_rootContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextWillSave:) name:NSManagedObjectContextWillSaveNotification object:_rootContext];
    
    NSManagedObjectContext *syncContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    syncContext.parentContext = _rootContext;
    _syncContext = syncContext;
    
    NSManagedObjectContext *referenceContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    referenceContext.persistentStoreCoordinator = _rootContext.persistentStoreCoordinator;
    _referenceContext = referenceContext;
    _referenceContext.mergePolicy = NSOverwriteMergePolicy;
}

- (NSDate*) lastSyncDate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"];
    if (!date) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"lastSyncDate"];
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"];
}

- (void) setLastSyncDate:(NSDate*)date {
     [[NSUserDefaults standardUserDefaults] setValue:date forKey:@"lastSyncDate"];
}

- (void) syncWithSuccessBlock:(TKSyncSuccessBlock)successBlock andFailureBlock:(TKSyncFailureBlock)failureBlock {
    
    dispatch_async(dispatch_queue_create("sync", nil), ^{
        NSArray *localInsertedObjects = [TKServerObjectHelper getInsertedObjectsFromCache];
        NSArray __block *localUpdatedObjects = [TKServerObjectHelper getUpdatedObjectsFromCache];
        NSArray __block *insertedObjectsWithServerIDs;
        NSMutableSet *localUpdatesNoConflict;
        NSMutableSet *serverUpdatesNoConflict;
        NSMutableSet *conflictPairs = [NSMutableSet set];
        TKParseServerSyncManager *manager = [[TKParseServerSyncManager alloc] init];
        NSMutableArray __block *arrServerObjects = [NSMutableArray array];
        NSMutableArray __block *arrShadowObjects = [NSMutableArray array];
        NSError __block *syncError;
        [[TKDBCacheManager sharedManager] startCheckpoint];
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        
#pragma mark Step 1: Download all objects updated on the server since last sync
        for (NSString *entity in kEntities) {
            [manager downloadUpdatedObjectsForEntity:entity withSuccessBlock:^(NSArray *objects) {
                [arrServerObjects addObjectsFromArray:objects];
                dispatch_semaphore_signal(sem);
            } andFailureBlock:^(NSArray *objects, NSError *error) {
                syncError = error;
                dispatch_semaphore_signal(sem);
            }];
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            if (syncError) {
                failureBlock(nil,syncError);
                [[TKDBCacheManager sharedManager] rollbackToCheckpoint];
                return;
            }
        }
        
#pragma mark Step 2: Insert newly created objects on local from server and vice versa.
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate > %@", [self lastSyncDate]];
        NSArray *newServerObjects = [arrServerObjects filteredArrayUsingPredicate:predicate];
        [TKServerObjectHelper insertServerObjectsInLocalDatabase:newServerObjects];
        [manager uploadInsertedObjects:localInsertedObjects withSuccessBlock:^(NSArray *objects) {
            insertedObjectsWithServerIDs = objects;
            dispatch_semaphore_signal(sem);
        } andFailureBlock:^(NSArray *objects, NSError *error) {
            syncError = error;
            dispatch_semaphore_signal(sem);
        }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        if (syncError) {
            failureBlock(nil,syncError);
            [[TKDBCacheManager sharedManager] rollbackToCheckpoint];
            return;
        }
        
#pragma mark Step 3: Update managed objects with server IDs
        [TKServerObjectHelper updateServerIDInLocalDatabase:insertedObjectsWithServerIDs];
        
#pragma mark Step 4: Upload inserted objects as updates to wire relationships on the cloud.
        [manager uploadUpdatedObjects:insertedObjectsWithServerIDs WithSuccessBlock:^(NSArray *objects) {
            dispatch_semaphore_signal(sem);
        } andFailureBlock:^(NSArray *objects, NSError *error) {
            syncError = error;
            dispatch_semaphore_signal(sem);
        }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        if (syncError) {
            failureBlock(nil,syncError);
            [[TKDBCacheManager sharedManager] rollbackToCheckpoint];
            return;
        }
        
#pragma mark Step 5: Separate updated objects into local no conflict, server no conflict, and conflict
        predicate = [NSPredicate predicateWithFormat:@"creationDate <= %@", [self lastSyncDate]];
        NSArray *updatedServerObjects = [arrServerObjects filteredArrayUsingPredicate:predicate];
        NSSet *updatedServerObjectsSet = [NSSet setWithArray:updatedServerObjects];
        NSSet *updatedLocalObjectsSet = [NSSet setWithArray:localUpdatedObjects];
        serverUpdatesNoConflict = [[updatedServerObjectsSet objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            return ![localUpdatedObjects containsObject:obj];
        }] mutableCopy];
        localUpdatesNoConflict = [[updatedLocalObjectsSet objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            return ![updatedServerObjectsSet containsObject:obj];
        }] mutableCopy];
        for (TKServerObject *serverObject in updatedServerObjectsSet) {
            for (TKServerObject *localObject in updatedLocalObjectsSet) {
                if ([serverObject isEqual:localObject]) {
                    TKDBCacheEntry *entry = [[TKDBCacheManager sharedManager] entryForObjectID:localObject.uniqueObjectID withType:TKDBCacheUpdate];
                    NSManagedObject *shadowObject = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:entry.shadowObjectIDURL]];
                    [arrShadowObjects addObject:shadowObject];
                    TKServerObject *shadowServerObject = [shadowObject toServerObject];
                    [conflictPairs addObject:[[TKServerObjectConflictPair alloc] initWithServerObject:serverObject localObject:localObject shadowObject:shadowServerObject]];
                }
            }
        }
        
#pragma mark Step 6: Resolve conflicts
        for (TKServerObjectConflictPair *conflictPair in conflictPairs) {
            [TKServerObjectHelper resolveConflict:conflictPair];
            if (conflictPair.resolutionType == TKDBMergeLocalWins) {
                [serverUpdatesNoConflict addObject:conflictPair.outputObject];
            }
            else if (conflictPair.resolutionType == TKDBMergeServerWins) {
                [localUpdatesNoConflict addObject:conflictPair.outputObject];
            }
        }
        
#pragma mark Step 7: Save objects updated on the server to local db (no conflict + conflict resolved)
        [TKServerObjectHelper updateServerObjectsInLocalDatabase:[serverUpdatesNoConflict allObjects]];
        
#pragma mark Step 8: Save objects updated locally to server (no conflict + conflict resolved)
        [manager uploadUpdatedObjects:[localUpdatesNoConflict allObjects] WithSuccessBlock:^(NSArray *objects) {
            dispatch_semaphore_signal(sem);
        } andFailureBlock:^(NSArray *objects, NSError *error) {
            syncError = error;
            dispatch_semaphore_signal(sem);
        }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        if (syncError) {
            failureBlock(nil,syncError);
            [[TKDBCacheManager sharedManager] rollbackToCheckpoint];
            return;
        }
        
        NSManagedObjectContext __weak *weakSyncContext = self.syncContext;
#pragma mark Step 9: Delete all shadow objects
        for (NSManagedObject *shadowObject in arrShadowObjects) {
            NSManagedObject __weak *weakShadowObject = shadowObject;
            [self.syncContext performBlockAndWait:^{
                [weakSyncContext deleteObject:weakShadowObject];
            }];
        }
        
#warning Replace with MagicalRecord save to persistent store.
        [self.syncContext performBlockAndWait:^{
            [weakSyncContext save:nil];
            disableNotifications = YES;
            [weakSyncContext.parentContext save:nil];
            disableNotifications = NO;
        }];
        
        if (syncError) {
            failureBlock(nil,syncError);
            [[TKDBCacheManager sharedManager] rollbackToCheckpoint];
            return;
        }
        else {
            [self setLastSyncDate:[NSDate date]];
            [[TKDBCacheManager sharedManager] clearCache];
            [[TKDBCacheManager sharedManager] endCheckpointSuccessfully];
            successBlock(nil);
        }
        
    });
}

@end
