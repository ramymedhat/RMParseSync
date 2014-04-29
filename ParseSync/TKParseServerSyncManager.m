//
//  TKParseServerSyncManager.m
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-18.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "TKParseServerSyncManager.h"
#import "TKServerObject.h"
#import "TKDBCacheManager.h"

@implementation TKParseServerSyncManager

- (TKServerObject*) serverObjectBasicInfoForParseObject:(PFObject*)parseObject {
    TKServerObject *serverObject = [[TKServerObject alloc] init];
    serverObject.entityName = parseObject.parseClassName;
    serverObject.uniqueObjectID = [parseObject valueForKey:kTKDBUniqueIDField];
    serverObject.serverObjectID = parseObject.objectId;
    serverObject.creationDate = parseObject.createdAt;
    serverObject.lastModificationDate = [parseObject valueForKey:kTKDBUpdatedDateField];
    serverObject.isDeleted = [[parseObject valueForKey:kTKDBIsDeletedField] boolValue];
    return serverObject;
}


- (PFObject*) newParseObjectBasicInfoForServerObject:(TKServerObject*)serverObject {
    PFObject *object = [PFObject objectWithClassName:serverObject.entityName];
    
    NSMutableDictionary *dictAttributes = [serverObject.attributeValues mutableCopy];
    [dictAttributes removeObjectsForKeys:@[kTKDBCreatedDateField, kTKDBServerIDField, kTKDBIsShadowField]];
    [dictAttributes setObject:@(serverObject.isDeleted) forKey:kTKDBIsDeletedField];
    [object setValuesForKeysWithDictionary:dictAttributes];
    return object;
}

- (PFObject*) existingParseObjectBasicInfoForServerObject:(TKServerObject*)serverObject {
    PFObject *object = [PFObject objectWithoutDataWithClassName:serverObject.entityName objectId:serverObject.serverObjectID];
    
    NSMutableDictionary *dictAttributes = [serverObject.attributeValues mutableCopy];
    [dictAttributes removeObjectsForKeys:@[kTKDBCreatedDateField, kTKDBServerIDField, kTKDBIsShadowField]];
    [dictAttributes setObject:@(serverObject.isDeleted) forKey:kTKDBIsDeletedField];
    [object setValuesForKeysWithDictionary:dictAttributes];
    return object;
}

- (TKServerObject*) serverObjectForParseObject:(PFObject*)parseObject {
    TKServerObject *serverObject = [self serverObjectBasicInfoForParseObject:parseObject];
    
    NSMutableDictionary *dictAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *relatedObjects = [NSMutableDictionary dictionary];
    
    for (NSString* key in [parseObject allKeys]) {
        
        if ([key isEqualToString:kTKDBIsDeletedField] || [key isEqualToString:kTKDBUniqueIDField]) {
            continue;
        }
        
        if ([[parseObject valueForKey:key] isKindOfClass:[PFObject class]]) {
            PFObject *relatedObject = [parseObject valueForKey:key];
            [relatedObject refresh];
            TKServerObject *toOneServerObject = [self serverObjectBasicInfoForParseObject:relatedObject];
            [relatedObjects setObject:toOneServerObject forKey:key];
        }
        else if ([[parseObject valueForKey:key] isKindOfClass:[PFRelation class]]) {
            PFRelation *relation = [parseObject relationForKey:key];
            // get related objects using [relation query]
            PFQuery *query = [relation query];
            NSArray *parseObjects = [query findObjects];
            NSMutableArray *arrServerObjects = [NSMutableArray array];
            
            for (PFObject *relatedObject in parseObjects) {
                [arrServerObjects addObject:[self serverObjectBasicInfoForParseObject:relatedObject]];
            }
            
            [relatedObjects setObject:arrServerObjects forKey:key];
        }
        else {
            [dictAttributes setValue:[parseObject valueForKey:key] forKey:key];
        }
    }
    
    serverObject.attributeValues = dictAttributes;
    serverObject.relatedObjects = relatedObjects;
    return serverObject;
}

- (void) uploadInsertedObjects:(NSArray*)serverObjects withSuccessBlock:(TKSyncSuccessBlock)successBlock andFailureBlock:(TKSyncFailureBlock)failureBlock {
    NSMutableDictionary __block *dictServerObjects = [NSMutableDictionary dictionary];
    NSMutableArray __block *arrayParseObjects = [NSMutableArray array];
    
    if ([serverObjects count] == 0) {
        successBlock([NSArray array]);
        return;
    }
    
    for (TKServerObject *serverObject in serverObjects) {
        // Put the object in the dictionary to be later retrieved for setting relationships.
        [dictServerObjects setObject:serverObject forKey:serverObject.uniqueObjectID];
        
        // Create Parse object.
        PFObject *object = [self newParseObjectBasicInfoForServerObject:serverObject];
        [arrayParseObjects addObject:object];
    }
    
    [PFObject saveAllInBackground:arrayParseObjects block:^(BOOL succeeded, NSError *error) {
        if (error) {
            failureBlock(nil, error);
        }
        else {
            // Save all server IDs of objects to their respective server objects.
            for (PFObject *parseObject in arrayParseObjects) {
                NSString *uniqueID = [parseObject valueForKey:kTKDBUniqueIDField];
                TKServerObject *serverObject = (TKServerObject*)dictServerObjects[uniqueID];
                serverObject.serverObjectID = [parseObject objectId];
                [[TKDBCacheManager sharedManager] mapServerObjectWithID:serverObject.serverObjectID toUniqueObjectWithID:serverObject.uniqueObjectID];
            }
            
            successBlock([dictServerObjects allValues]);
        }
    }];
}

- (void) downloadUpdatedObjectsForEntity:(NSString*)entityName withSuccessBlock:(TKSyncSuccessBlock)successBlock andFailureBlock:(TKSyncFailureBlock)failureBlock {
    PFQuery *query = [PFQuery queryWithClassName:entityName];
    [query whereKey:@"updatedAt" greaterThan:[TKDB defaultDB].lastSyncDate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            failureBlock(nil, error);
        }
        else {
            NSMutableArray *arrayServerObjects = [NSMutableArray array];
            
            // Convert objects to server objects.
            for (PFObject *parseObject in objects) {
                TKServerObject *serverObject = [self serverObjectForParseObject:parseObject];
                [arrayServerObjects addObject:serverObject];
                [[TKDBCacheManager sharedManager] mapServerObjectWithID:serverObject.serverObjectID toUniqueObjectWithID:serverObject.uniqueObjectID];
            }
            
            successBlock(arrayServerObjects);
        }
    }];
}

- (void) uploadUpdatedObjects:(NSArray*)serverObjects WithSuccessBlock:(TKSyncSuccessBlock)successBlock andFailureBlock:(TKSyncFailureBlock)failureBlock {
    NSMutableArray *parseObjects = [NSMutableArray array];
    
    if ([serverObjects count] == 0) {
        successBlock([NSArray array]);
        return;
    }
    
    for (TKServerObject *serverObject in serverObjects) {
        PFObject *parseObject = [self existingParseObjectBasicInfoForServerObject:serverObject];
        [parseObject fetchIfNeeded];
        
        for (NSString *key in serverObject.relatedObjects) {
            if ([serverObject.relatedObjects[key] isKindOfClass:[TKServerObject class]]) {
                TKServerObject *relatedServerObject = serverObject.relatedObjects[key];
                NSString *serverObjectID = (relatedServerObject.serverObjectID == nil) ? [[TKDBCacheManager sharedManager] serverObjectIDForUniqueObjectID:relatedServerObject.uniqueObjectID] : relatedServerObject.serverObjectID;
                PFObject *relatedParseObject = [PFObject objectWithoutDataWithClassName:relatedServerObject.entityName objectId:serverObjectID];
                [parseObject setValue:relatedParseObject forKey:key];
            }
            else if ([serverObject.relatedObjects[key] isKindOfClass:[NSArray class]]) {
                PFRelation *relation = [parseObject relationForKey:key];
                NSArray *arrChildObjects = [[relation query] findObjects];
                for (PFObject *childObject in arrChildObjects) {
                    [relation removeObject:childObject];
                }
                
                for (TKServerObject *childObject in serverObject.relatedObjects[key]) {
                    NSString *serverObjectID = (childObject.serverObjectID == nil) ? [[TKDBCacheManager sharedManager] serverObjectIDForUniqueObjectID:childObject.uniqueObjectID] : childObject.serverObjectID;
                    [relation addObject:[PFObject objectWithoutDataWithClassName:childObject.entityName objectId:serverObjectID]];
                }
            }
            else if (serverObject.relatedObjects[key] == [NSNull null]) {
                [parseObject removeObjectForKey:key];
            }
        }
        
        [parseObjects addObject:parseObject];
    }
    
    [PFObject saveAllInBackground:parseObjects block:^(BOOL succeeded, NSError *error) {
        if (error) {
            failureBlock(nil, error);
        }
        else {
            successBlock(parseObjects);
        }
    }];
}

@end
