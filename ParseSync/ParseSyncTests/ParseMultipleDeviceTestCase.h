//
//  ParseMultipleDeviceTestCase.h
//  ParseSync
//
//  Created by Ahmed AlMoraly on 6/11/14.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TKClassroom.h"
#import "TKStudent.h"
#import "TKBehavior.h"
#import "TKBehaviorType.h"
#import "TKDBCacheManager.h"
#import <Bolts/Bolts.h>

@interface ParseMultipleDeviceTestCase : XCTestCase

@property (nonatomic, strong) TKDB *d1_db;
@property (nonatomic, strong) TKDB *d2_db;
@property (nonatomic, strong) TKDBCacheManager *d1_cacheManager;
@property (nonatomic, strong) TKDBCacheManager *d2_cacheManager;

- (NSString*) getAUniqueID;
- (NSManagedObject*) searchLocalDBForObjectWithUniqueID:(NSString*)uniqueID entity:(NSString*)entity;
- (PFObject*) searchCloudDBForObjectWithUniqueID:(NSString*)uniqueID entity:(NSString*)entity;

@end
