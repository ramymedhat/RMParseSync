//
//  Student.h
//  ParseSync
//
//  Created by Ramy Medhat on 2014-05-02.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attendance, Classroom;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * serverObjectID;
@property (nonatomic, retain) NSString * tkID;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSSet *attendances;
@property (nonatomic, retain) NSSet *classes;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addAttendancesObject:(Attendance *)value;
- (void)removeAttendancesObject:(Attendance *)value;
- (void)addAttendances:(NSSet *)values;
- (void)removeAttendances:(NSSet *)values;

- (void)addClassesObject:(Classroom *)value;
- (void)removeClassesObject:(Classroom *)value;
- (void)addClasses:(NSSet *)values;
- (void)removeClasses:(NSSet *)values;

@end
