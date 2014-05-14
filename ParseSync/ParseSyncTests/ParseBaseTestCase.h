//
//  ParseBaseTestCase.h
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-28.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Classroom.h"
#import "Student.h"
#import "Attendance.h"
#import "AttendanceType.h"
#import "TKDBCacheManager.h"
#import <Bolts/Bolts.h>

@interface ParseBaseTestCase : XCTestCase

@property (nonatomic, strong) Attendance *attendance1;
@property (nonatomic, strong) Attendance *attendance2;
@property (nonatomic, strong) AttendanceType *attendanceType;
@property (nonatomic, strong) Classroom *classroom;
@property (nonatomic, strong) Student *student;
@property (nonatomic, strong) Student *student2;

@property (nonatomic, strong) PFObject *parse_attendance1;
@property (nonatomic, strong) PFObject *parse_attendance2;
@property (nonatomic, strong) PFObject *parse_attendanceType;
@property (nonatomic, strong) PFObject *parse_classroom;
@property (nonatomic, strong) PFObject *parse_student;
@property (nonatomic, strong) PFObject *parse_student2;

@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, strong) NSMutableArray *parse_students;

- (NSString*) getAUniqueID;
- (void) createTemplateObjects;
- (void) createTemplateObjects2;
- (NSManagedObject*) searchLocalDBForObjectWithUniqueID:(NSString*)uniqueID entity:(NSString*)entity;
- (PFObject*) searchCloudDBForObjectWithUniqueID:(NSString*)uniqueID entity:(NSString*)entity;

@end
