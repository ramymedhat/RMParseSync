// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAttendance.h instead.

#import <CoreData/CoreData.h>


extern const struct TKAttendanceAttributes {
	__unsafe_unretained NSString *attendanceId;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKAttendanceAttributes;

extern const struct TKAttendanceRelationships {
	__unsafe_unretained NSString *classroom;
	__unsafe_unretained NSString *lesson;
	__unsafe_unretained NSString *student;
	__unsafe_unretained NSString *type;
} TKAttendanceRelationships;

extern const struct TKAttendanceFetchedProperties {
} TKAttendanceFetchedProperties;

@class TKClassroom;
@class TKLesson;
@class TKStudent;
@class TKAttendanceType;









@interface TKAttendanceID : NSManagedObjectID {}
@end

@interface _TKAttendance : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKAttendanceID*)objectID;





@property (nonatomic, strong) NSString* attendanceId;



//- (BOOL)validateAttendanceId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKClassroom *classroom;

//- (BOOL)validateClassroom:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKLesson *lesson;

//- (BOOL)validateLesson:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKStudent *student;

//- (BOOL)validateStudent:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKAttendanceType *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@end

@interface _TKAttendance (CoreDataGeneratedAccessors)

@end

@interface _TKAttendance (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAttendanceId;
- (void)setPrimitiveAttendanceId:(NSString*)value;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (TKClassroom*)primitiveClassroom;
- (void)setPrimitiveClassroom:(TKClassroom*)value;



- (TKLesson*)primitiveLesson;
- (void)setPrimitiveLesson:(TKLesson*)value;



- (TKStudent*)primitiveStudent;
- (void)setPrimitiveStudent:(TKStudent*)value;



- (TKAttendanceType*)primitiveType;
- (void)setPrimitiveType:(TKAttendanceType*)value;


@end
