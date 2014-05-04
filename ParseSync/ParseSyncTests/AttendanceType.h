//
//  AttendanceType.h
//  ParseSync
//
//  Created by Ramy Medhat on 2014-05-02.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendance;

@interface AttendanceType : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * serverObjectID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * tkID;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSSet *attendances;
@end

@interface AttendanceType (CoreDataGeneratedAccessors)

- (void)addAttendancesObject:(Attendance *)value;
- (void)removeAttendancesObject:(Attendance *)value;
- (void)addAttendances:(NSSet *)values;
- (void)removeAttendances:(NSSet *)values;

@end
