//
//  TKServerObjectHelper.m
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-18.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "TKServerObjectHelper.h"
#import "TKDBCacheManager.h"
#import "TKServerObject.h"
#import "NSManagedObject+Sync.h"

@implementation TKServerObjectHelper

+ (NSManagedObject*) managedObjectWithoutRelationshipsFromServerObject:(TKServerObject*)object {
    NSManagedObject *__block managedObject;
    NSManagedObjectContext __weak *weakSyncContext = [TKDB defaultDB].syncContext;
    
    [[TKDB defaultDB].syncContext performBlockAndWait:^{
        managedObject =[NSEntityDescription insertNewObjectForEntityForName:object.entityName inManagedObjectContext:weakSyncContext];
    }];
    
    [managedObject setValue:object.uniqueObjectID forKeyPath:kTKDBUniqueIDField];
    [managedObject setValue:object.serverObjectID forKey:kTKDBServerIDField];
    [managedObject setValue:object.creationDate forKey:kTKDBCreatedDateField];
    [managedObject setValue:object.lastModificationDate forKey:kTKDBUpdatedDateField];
    
    for (NSString *key in [object.attributeValues allKeys]) {
        [managedObject setValue:object.attributeValues[key] forKey:key];
    }
    
    return managedObject;
}

+ (void) wireRelationshipsForManagedObject:(NSManagedObject*)managedObject withServerObject:(TKServerObject*)serverObject {
    
    for (NSString *key in [serverObject.relatedObjects allKeys]) {
        if ([serverObject.relatedObjects[key] isKindOfClass:[TKServerObject class]]) {
            TKServerObject *relatedServerObject = serverObject.relatedObjects[key];
            if (relatedServerObject.isDeleted) {
                [managedObject setValue:nil forKey:key];
            }
            else {
                NSManagedObject *relatedManagedObject = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:[[TKDBCacheManager sharedManager] localObjectURLForUniqueObjectID:relatedServerObject.uniqueObjectID]]];
                [managedObject setValue:relatedManagedObject forKey:key];
            }
        }
        else if ([serverObject.relatedObjects[key] isKindOfClass:[NSArray class]]) {
            NSMutableSet *relatedObjects = [NSMutableSet set];
            for (TKServerObject *relatedServerObject in serverObject.relatedObjects[key]) {
                if (relatedServerObject.isDeleted) {
                    continue;
                }
                NSManagedObject *relatedManagedObject = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:[[TKDBCacheManager sharedManager] localObjectURLForUniqueObjectID:relatedServerObject.uniqueObjectID]]];
                [relatedObjects addObject:relatedManagedObject];
            }
            [managedObject setValue:relatedObjects forKey:key];
        }
        else if ([serverObject.relatedObjects[key] isEqual:[NSNull null]]) {
            [managedObject setValue:nil forKey:key];
        }
    }
}

+ (NSArray*)getInsertedObjectsFromCache {
    NSMutableArray *insertedObjects = [NSMutableArray array];
    TKDBCacheManager *manager = [TKDBCacheManager sharedManager];
    for (TKDBCacheEntry *entry in [[manager dictInserts] allValues]) {
        NSManagedObject *managedObject = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:entry.localObjectIDURL]];
        TKServerObject *serverObject = [managedObject toServerObject];
        [insertedObjects addObject:serverObject];
    }
    return insertedObjects;
}

+ (NSArray*)getUpdatedObjectsFromCache {
    NSMutableArray *updatedObjects = [NSMutableArray array];
    TKDBCacheManager *manager = [TKDBCacheManager sharedManager];
    for (TKDBCacheEntry *entry in [[manager dictUpdates] allValues]) {
        NSManagedObject *managedObject = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:entry.localObjectIDURL]];
        TKServerObject *serverObject = [managedObject toServerObject];
        [updatedObjects addObject:serverObject];
    }
    for (TKDBCacheEntry *entry in [[manager dictDeletes] allValues]) {
        TKServerObject *serverObject = [[TKServerObject alloc] init];
        serverObject.localObjectIDURL = entry.localObjectIDURL;
        serverObject.serverObjectID = entry.serverObjectID;
        serverObject.uniqueObjectID = entry.uniqueObjectID;
        serverObject.entityName = entry.entity;
        serverObject.isDeleted = YES;
        [updatedObjects addObject:serverObject];
    }
    return updatedObjects;
}

+ (void) insertServerObjectsInLocalDatabase:(NSArray*)serverObjects {
    NSMutableDictionary *dictManagedObjects = [NSMutableDictionary dictionary];
    
    if ([serverObjects count] == 0) {
        return;
    }
    
    // First, insert objects without wiring for relationships.
    for (TKServerObject *serverObject in serverObjects) {
        [dictManagedObjects setObject:[TKServerObjectHelper managedObjectWithoutRelationshipsFromServerObject:serverObject] forKey:serverObject.serverObjectID];
    }
    
    // Second, obtain permanent IDs and map them in the cache
    NSManagedObjectContext __weak *weakSyncContext = [TKDB defaultDB].syncContext;
    [[TKDB defaultDB].syncContext performBlockAndWait:^{
        [weakSyncContext obtainPermanentIDsForObjects:[dictManagedObjects allValues] error:nil];
    }];
    
    for (TKServerObject *serverObject in serverObjects) {
        NSManagedObject *object = dictManagedObjects[serverObject.serverObjectID];
        serverObject.localObjectIDURL = [[[object objectID] URIRepresentation] absoluteString];
        [[TKDBCacheManager sharedManager] mapLocalObjectWithURL:serverObject.localObjectIDURL toUniqueObjectWithID:serverObject.uniqueObjectID];
    }
    
    // Second, wire relationships.
    for (TKServerObject *serverObject in serverObjects) {
        NSManagedObject *object = dictManagedObjects[serverObject.serverObjectID];
        [TKServerObjectHelper wireRelationshipsForManagedObject:object withServerObject:serverObject];
    }
}

+ (void) updateServerIDInLocalDatabase:(NSArray*)serverObjects {
    for (TKServerObject *serverObject in serverObjects) {
        NSManagedObject *object = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:serverObject.localObjectIDURL]];
        [object setValue:serverObject.serverObjectID forKey:kTKDBServerIDField];
    }
}

+ (void) updateServerObjectsInLocalDatabase:(NSArray*)serverObjects {
    
    if ([serverObjects count] == 0) {
        return;
    }
   
    // Second, wire relationships.
    for (TKServerObject *serverObject in serverObjects) {
        NSManagedObject *object = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:[[TKDBCacheManager sharedManager] localObjectURLForUniqueObjectID:serverObject.uniqueObjectID]]];
        
        if (serverObject.isDeleted) {
            [[TKDB defaultDB].syncContext deleteObject:object];
        }
        else {
            for (NSString *key in serverObject.attributeValues) {
                [object setValue:serverObject.attributeValues[key] forKey:key];
            }
            
            [TKServerObjectHelper wireRelationshipsForManagedObject:object withServerObject:serverObject];
        }
    }
}

+ (void) resolveConflict:(TKServerObjectConflictPair*)conflictPair {
    TKServerObject *newerObject;
    
    if ([conflictPair.localObject.lastModificationDate compare:conflictPair.serverObject.lastModificationDate] == NSOrderedAscending) {
        newerObject = conflictPair.serverObject;
    }
    else {
        newerObject = conflictPair.localObject;
    }
    
    TKServerObject *outputObject = [[TKServerObject alloc] initWithUniqueID:conflictPair.localObject.uniqueObjectID];
    outputObject.entityName = conflictPair.localObject.entityName;
    outputObject.creationDate = conflictPair.localObject.creationDate;
    outputObject.serverObjectID = conflictPair.serverObject.serverObjectID;
    outputObject.localObjectIDURL = conflictPair.localObject.localObjectIDURL;
    
    NSMutableDictionary *dictAttributes = [NSMutableDictionary dictionary];
    
    for (NSString *key in [conflictPair.localObject.attributeValues allKeys]) {
        id localValue = [conflictPair.localObject valueForKey:key];
        id serverValue = [conflictPair.serverObject valueForKey:key];
        id shadowValue = [conflictPair.shadowObject valueForKey:key];
        
        BOOL localChanged = [localValue isEqual:shadowValue];
        BOOL serverChanged = [serverValue isEqual:shadowValue];
        
        if (localChanged && serverChanged) {
            dictAttributes[key] = newerObject.attributeValues[key];
        }
        else if (localChanged) {
            dictAttributes[key] = conflictPair.localObject.attributeValues[key];
        }
        else {
            dictAttributes[key] = conflictPair.serverObject.attributeValues[key];
        }
    }
    
    outputObject.attributeValues = dictAttributes;
    
    NSMutableDictionary *dictRelationships = [NSMutableDictionary dictionary];
    
    for (NSString *key in [conflictPair.localObject.relatedObjects allKeys]) {
        id localValue = [conflictPair.localObject valueForKey:key];
        id serverValue = [conflictPair.serverObject valueForKey:key];
        id shadowValue = [conflictPair.shadowObject valueForKey:key];
        
        BOOL localChanged = [localValue isEqual:shadowValue];
        BOOL serverChanged = [serverValue isEqual:shadowValue];
        
        if (localChanged && serverChanged) {
#warning should merge related objects
            dictRelationships[key] = newerObject.relatedObjects[key];
        }
        else if (localChanged) {
            dictRelationships[key] = conflictPair.localObject.relatedObjects[key];
        }
        else {
            dictRelationships[key] = conflictPair.serverObject.relatedObjects[key];
        }
    }
    
    outputObject.relatedObjects = dictRelationships;
    
    conflictPair.outputObject = outputObject;
    conflictPair.resolutionType = TKDBMergeBothUpdated;
}

@end
