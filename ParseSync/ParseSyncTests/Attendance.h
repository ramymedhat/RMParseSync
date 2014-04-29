//
//  Attendance.h
//  ParseSync
//
//  Created by Ramy Medhat on 2014-04-28.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttendanceType, Student;

@interface Attendance : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * isShadow;
@property (nonatomic, retain) NSString * serverObjectID;
@property (nonatomic, retain) NSDate * attendanceDate;
@property (nonatomic, retain) NSString * tkID;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) AttendanceType *attendanceType;

@end
