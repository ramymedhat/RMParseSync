//
//  TKServerObject.m
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-18.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "TKServerObject.h"

@implementation TKServerObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.attributeValues = [NSDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithUniqueID:(NSString*)uniqueID;
{
    self = [self init];
    if (self) {
        self.uniqueObjectID = uniqueID;
    }
    return self;
}

- (BOOL) isEqual:(id)object {
    TKServerObject *otherObject = (TKServerObject*)object;
    if (self.uniqueObjectID == otherObject.uniqueObjectID) {
        return YES;
    }
    return NO;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@,%@,%@\n%@", self.entityName, self.uniqueObjectID, self.serverObjectID, self.attributeValues];
}

@end

@implementation TKServerObjectConflictPair

- (id) initWithServerObject:(TKServerObject*)serverObject localObject:(TKServerObject*)localObject shadowObject:(TKServerObject*)shadowObject {
    self = [super init];
    if (self) {
        self.serverObject = serverObject;
        self.localObject = localObject;
        self.shadowObject = shadowObject;
    }
    return self;
}

@end