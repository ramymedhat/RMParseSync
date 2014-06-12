// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKClassroom.h instead.

#import <CoreData/CoreData.h>


extern const struct TKClassroomAttributes {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *classroomDescription;
	__unsafe_unretained NSString *classroomId;
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *iconPath;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *lessonsEndDate;
	__unsafe_unretained NSString *lessonsStartDate;
	__unsafe_unretained NSString *lessonsType;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKClassroomAttributes;

extern const struct TKClassroomRelationships {
	__unsafe_unretained NSString *attendances;
	__unsafe_unretained NSString *behaviors;
	__unsafe_unretained NSString *categories;
	__unsafe_unretained NSString *lessons;
	__unsafe_unretained NSString *seats;
	__unsafe_unretained NSString *students;
} TKClassroomRelationships;

extern const struct TKClassroomFetchedProperties {
} TKClassroomFetchedProperties;

@class TKAttendance;
@class TKBehavior;
@class TKGradeCategory;
@class TKLesson;
@class TKSeat;
@class TKStudent;


















@interface TKClassroomID : NSManagedObjectID {}
@end

@interface _TKClassroom : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKClassroomID*)objectID;





@property (nonatomic, strong) NSString* category;



//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* classroomDescription;



//- (BOOL)validateClassroomDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* classroomId;



//- (BOOL)validateClassroomId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* icon;



//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* iconPath;



//- (BOOL)validateIconPath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lessonsEndDate;



//- (BOOL)validateLessonsEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lessonsStartDate;



//- (BOOL)validateLessonsStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lessonsType;



@property int16_t lessonsTypeValue;
- (int16_t)lessonsTypeValue;
- (void)setLessonsTypeValue:(int16_t)value_;

//- (BOOL)validateLessonsType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *attendances;

- (NSMutableSet*)attendancesSet;




@property (nonatomic, strong) NSSet *behaviors;

- (NSMutableSet*)behaviorsSet;




@property (nonatomic, strong) NSSet *categories;

- (NSMutableSet*)categoriesSet;




@property (nonatomic, strong) NSSet *lessons;

- (NSMutableSet*)lessonsSet;




@property (nonatomic, strong) NSSet *seats;

- (NSMutableSet*)seatsSet;




@property (nonatomic, strong) NSSet *students;

- (NSMutableSet*)studentsSet;





@end

@interface _TKClassroom (CoreDataGeneratedAccessors)

- (void)addAttendances:(NSSet*)value_;
- (void)removeAttendances:(NSSet*)value_;
- (void)addAttendancesObject:(TKAttendance*)value_;
- (void)removeAttendancesObject:(TKAttendance*)value_;

- (void)addBehaviors:(NSSet*)value_;
- (void)removeBehaviors:(NSSet*)value_;
- (void)addBehaviorsObject:(TKBehavior*)value_;
- (void)removeBehaviorsObject:(TKBehavior*)value_;

- (void)addCategories:(NSSet*)value_;
- (void)removeCategories:(NSSet*)value_;
- (void)addCategoriesObject:(TKGradeCategory*)value_;
- (void)removeCategoriesObject:(TKGradeCategory*)value_;

- (void)addLessons:(NSSet*)value_;
- (void)removeLessons:(NSSet*)value_;
- (void)addLessonsObject:(TKLesson*)value_;
- (void)removeLessonsObject:(TKLesson*)value_;

- (void)addSeats:(NSSet*)value_;
- (void)removeSeats:(NSSet*)value_;
- (void)addSeatsObject:(TKSeat*)value_;
- (void)removeSeatsObject:(TKSeat*)value_;

- (void)addStudents:(NSSet*)value_;
- (void)removeStudents:(NSSet*)value_;
- (void)addStudentsObject:(TKStudent*)value_;
- (void)removeStudentsObject:(TKStudent*)value_;

@end

@interface _TKClassroom (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCategory;
- (void)setPrimitiveCategory:(NSString*)value;




- (NSString*)primitiveClassroomDescription;
- (void)setPrimitiveClassroomDescription:(NSString*)value;




- (NSString*)primitiveClassroomId;
- (void)setPrimitiveClassroomId:(NSString*)value;




- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(NSString*)value;




- (NSString*)primitiveIconPath;
- (void)setPrimitiveIconPath:(NSString*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSDate*)primitiveLessonsEndDate;
- (void)setPrimitiveLessonsEndDate:(NSDate*)value;




- (NSDate*)primitiveLessonsStartDate;
- (void)setPrimitiveLessonsStartDate:(NSDate*)value;




- (NSNumber*)primitiveLessonsType;
- (void)setPrimitiveLessonsType:(NSNumber*)value;

- (int16_t)primitiveLessonsTypeValue;
- (void)setPrimitiveLessonsTypeValue:(int16_t)value_;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (NSMutableSet*)primitiveAttendances;
- (void)setPrimitiveAttendances:(NSMutableSet*)value;



- (NSMutableSet*)primitiveBehaviors;
- (void)setPrimitiveBehaviors:(NSMutableSet*)value;



- (NSMutableSet*)primitiveCategories;
- (void)setPrimitiveCategories:(NSMutableSet*)value;



- (NSMutableSet*)primitiveLessons;
- (void)setPrimitiveLessons:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSeats;
- (void)setPrimitiveSeats:(NSMutableSet*)value;



- (NSMutableSet*)primitiveStudents;
- (void)setPrimitiveStudents:(NSMutableSet*)value;


@end
