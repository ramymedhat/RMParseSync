//
//  Attendance.h
//  ParseSync
//
//  Created by Ramy Medhat on 2014-05-02.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttendanceType, Student;

@interface Attendance : NSManagedObject

@property (nonatomic, retain) NSDate * attendanceDate;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * serverObjectID;
@property (nonatomic, retain) NSString * tkID;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) AttendanceType *attendanceType;
@property (nonatomic, retain) Student *student;

@end
