// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKLesson.h instead.

#import <CoreData/CoreData.h>


extern const struct TKLessonAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *lessonDescription;
	__unsafe_unretained NSString *lessonEndTime;
	__unsafe_unretained NSString *lessonId;
	__unsafe_unretained NSString *lessonLocation;
	__unsafe_unretained NSString *lessonPeriod;
	__unsafe_unretained NSString *lessonStartDate;
	__unsafe_unretained NSString *lessonStartTime;
	__unsafe_unretained NSString *lessonTitle;
	__unsafe_unretained NSString *recurrenceDays;
	__unsafe_unretained NSString *recurrenceId;
	__unsafe_unretained NSString *recurrenceParam;
	__unsafe_unretained NSString *recurrenceType;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKLessonAttributes;

extern const struct TKLessonRelationships {
	__unsafe_unretained NSString *attachments;
	__unsafe_unretained NSString *attendances;
	__unsafe_unretained NSString *classroom;
} TKLessonRelationships;

extern const struct TKLessonFetchedProperties {
} TKLessonFetchedProperties;

@class TKAttachment;
@class TKAttendance;
@class TKClassroom;




















@interface TKLessonID : NSManagedObjectID {}
@end

@interface _TKLesson : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKLessonID*)objectID;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lessonDescription;



//- (BOOL)validateLessonDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lessonEndTime;



//- (BOOL)validateLessonEndTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lessonId;



//- (BOOL)validateLessonId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lessonLocation;



//- (BOOL)validateLessonLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lessonPeriod;



@property int16_t lessonPeriodValue;
- (int16_t)lessonPeriodValue;
- (void)setLessonPeriodValue:(int16_t)value_;

//- (BOOL)validateLessonPeriod:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lessonStartDate;



//- (BOOL)validateLessonStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lessonStartTime;



//- (BOOL)validateLessonStartTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lessonTitle;



//- (BOOL)validateLessonTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recurrenceDays;



@property int16_t recurrenceDaysValue;
- (int16_t)recurrenceDaysValue;
- (void)setRecurrenceDaysValue:(int16_t)value_;

//- (BOOL)validateRecurrenceDays:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recurrenceId;



//- (BOOL)validateRecurrenceId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recurrenceParam;



//- (BOOL)validateRecurrenceParam:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recurrenceType;



@property int16_t recurrenceTypeValue;
- (int16_t)recurrenceTypeValue;
- (void)setRecurrenceTypeValue:(int16_t)value_;

//- (BOOL)validateRecurrenceType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *attachments;

- (NSMutableSet*)attachmentsSet;




@property (nonatomic, strong) NSSet *attendances;

- (NSMutableSet*)attendancesSet;




@property (nonatomic, strong) TKClassroom *classroom;

//- (BOOL)validateClassroom:(id*)value_ error:(NSError**)error_;





@end

@interface _TKLesson (CoreDataGeneratedAccessors)

- (void)addAttachments:(NSSet*)value_;
- (void)removeAttachments:(NSSet*)value_;
- (void)addAttachmentsObject:(TKAttachment*)value_;
- (void)removeAttachmentsObject:(TKAttachment*)value_;

- (void)addAttendances:(NSSet*)value_;
- (void)removeAttendances:(NSSet*)value_;
- (void)addAttendancesObject:(TKAttendance*)value_;
- (void)removeAttendancesObject:(TKAttendance*)value_;

@end

@interface _TKLesson (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSString*)primitiveLessonDescription;
- (void)setPrimitiveLessonDescription:(NSString*)value;




- (NSDate*)primitiveLessonEndTime;
- (void)setPrimitiveLessonEndTime:(NSDate*)value;




- (NSString*)primitiveLessonId;
- (void)setPrimitiveLessonId:(NSString*)value;




- (NSString*)primitiveLessonLocation;
- (void)setPrimitiveLessonLocation:(NSString*)value;




- (NSNumber*)primitiveLessonPeriod;
- (void)setPrimitiveLessonPeriod:(NSNumber*)value;

- (int16_t)primitiveLessonPeriodValue;
- (void)setPrimitiveLessonPeriodValue:(int16_t)value_;




- (NSDate*)primitiveLessonStartDate;
- (void)setPrimitiveLessonStartDate:(NSDate*)value;




- (NSDate*)primitiveLessonStartTime;
- (void)setPrimitiveLessonStartTime:(NSDate*)value;




- (NSString*)primitiveLessonTitle;
- (void)setPrimitiveLessonTitle:(NSString*)value;




- (NSNumber*)primitiveRecurrenceDays;
- (void)setPrimitiveRecurrenceDays:(NSNumber*)value;

- (int16_t)primitiveRecurrenceDaysValue;
- (void)setPrimitiveRecurrenceDaysValue:(int16_t)value_;




- (NSString*)primitiveRecurrenceId;
- (void)setPrimitiveRecurrenceId:(NSString*)value;




- (NSString*)primitiveRecurrenceParam;
- (void)setPrimitiveRecurrenceParam:(NSString*)value;




- (NSNumber*)primitiveRecurrenceType;
- (void)setPrimitiveRecurrenceType:(NSNumber*)value;

- (int16_t)primitiveRecurrenceTypeValue;
- (void)setPrimitiveRecurrenceTypeValue:(int16_t)value_;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (NSMutableSet*)primitiveAttachments;
- (void)setPrimitiveAttachments:(NSMutableSet*)value;



- (NSMutableSet*)primitiveAttendances;
- (void)setPrimitiveAttendances:(NSMutableSet*)value;



- (TKClassroom*)primitiveClassroom;
- (void)setPrimitiveClassroom:(TKClassroom*)value;


@end
