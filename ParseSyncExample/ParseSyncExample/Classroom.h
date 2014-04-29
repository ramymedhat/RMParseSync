//
//  Classroom.h
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-22.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Classroom : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * serverObjectID;
@property (nonatomic, retain) NSDate * serverUpdatedDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * tkID;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSSet *students;
@end

@interface Classroom (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(NSManagedObject *)value;
- (void)removeStudentsObject:(NSManagedObject *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
