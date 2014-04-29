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

@interface ParseBaseTestCase : XCTestCase

@property (nonatomic, strong) Attendance *attendance1;
@property (nonatomic, strong) Attendance *attendance2;
@property (nonatomic, strong) AttendanceType *attendanceType;
@property (nonatomic, strong) Classroom *classroom;
@property (nonatomic, strong) Student *student;
@property (nonatomic, strong) Student *student2;

+ (NSString*) getAUniqueID;

- (void) createTemplateObjects;

@end
