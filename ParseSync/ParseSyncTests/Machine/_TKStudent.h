// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKStudent.h instead.

#import <CoreData/CoreData.h>


extern const struct TKStudentAttributes {
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *iconPath;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *parentEmail;
	__unsafe_unretained NSString *parentName;
	__unsafe_unretained NSString *parentPhone;
	__unsafe_unretained NSString *parentSkype;
	__unsafe_unretained NSString *phone;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *skype;
	__unsafe_unretained NSString *studentId;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKStudentAttributes;

extern const struct TKStudentRelationships {
	__unsafe_unretained NSString *accessCode;
	__unsafe_unretained NSString *attendances;
	__unsafe_unretained NSString *behaviors;
	__unsafe_unretained NSString *classrooms;
	__unsafe_unretained NSString *grades;
	__unsafe_unretained NSString *seats;
} TKStudentRelationships;

extern const struct TKStudentFetchedProperties {
} TKStudentFetchedProperties;

@class TKAccessCode;
@class TKAttendance;
@class TKBehavior;
@class TKClassroom;
@class TKGrade;
@class TKSeat;






















@interface TKStudentID : NSManagedObjectID {}
@end

@interface _TKStudent : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKStudentID*)objectID;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parentEmail;



//- (BOOL)validateParentEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parentName;



//- (BOOL)validateParentName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parentPhone;



//- (BOOL)validateParentPhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parentSkype;



//- (BOOL)validateParentSkype:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* phone;



//- (BOOL)validatePhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* skype;



//- (BOOL)validateSkype:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* studentId;



//- (BOOL)validateStudentId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKAccessCode *accessCode;

//- (BOOL)validateAccessCode:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *attendances;

- (NSMutableSet*)attendancesSet;




@property (nonatomic, strong) NSSet *behaviors;

- (NSMutableSet*)behaviorsSet;




@property (nonatomic, strong) NSSet *classrooms;

- (NSMutableSet*)classroomsSet;




@property (nonatomic, strong) NSSet *grades;

- (NSMutableSet*)gradesSet;




@property (nonatomic, strong) NSSet *seats;

- (NSMutableSet*)seatsSet;





@end

@interface _TKStudent (CoreDataGeneratedAccessors)

- (void)addAttendances:(NSSet*)value_;
- (void)removeAttendances:(NSSet*)value_;
- (void)addAttendancesObject:(TKAttendance*)value_;
- (void)removeAttendancesObject:(TKAttendance*)value_;

- (void)addBehaviors:(NSSet*)value_;
- (void)removeBehaviors:(NSSet*)value_;
- (void)addBehaviorsObject:(TKBehavior*)value_;
- (void)removeBehaviorsObject:(TKBehavior*)value_;

- (void)addClassrooms:(NSSet*)value_;
- (void)removeClassrooms:(NSSet*)value_;
- (void)addClassroomsObject:(TKClassroom*)value_;
- (void)removeClassroomsObject:(TKClassroom*)value_;

- (void)addGrades:(NSSet*)value_;
- (void)removeGrades:(NSSet*)value_;
- (void)addGradesObject:(TKGrade*)value_;
- (void)removeGradesObject:(TKGrade*)value_;

- (void)addSeats:(NSSet*)value_;
- (void)removeSeats:(NSSet*)value_;
- (void)addSeatsObject:(TKSeat*)value_;
- (void)removeSeatsObject:(TKSeat*)value_;

@end

@interface _TKStudent (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




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




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSString*)primitiveParentEmail;
- (void)setPrimitiveParentEmail:(NSString*)value;




- (NSString*)primitiveParentName;
- (void)setPrimitiveParentName:(NSString*)value;




- (NSString*)primitiveParentPhone;
- (void)setPrimitiveParentPhone:(NSString*)value;




- (NSString*)primitiveParentSkype;
- (void)setPrimitiveParentSkype:(NSString*)value;




- (NSString*)primitivePhone;
- (void)setPrimitivePhone:(NSString*)value;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveSkype;
- (void)setPrimitiveSkype:(NSString*)value;




- (NSString*)primitiveStudentId;
- (void)setPrimitiveStudentId:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (TKAccessCode*)primitiveAccessCode;
- (void)setPrimitiveAccessCode:(TKAccessCode*)value;



- (NSMutableSet*)primitiveAttendances;
- (void)setPrimitiveAttendances:(NSMutableSet*)value;



- (NSMutableSet*)primitiveBehaviors;
- (void)setPrimitiveBehaviors:(NSMutableSet*)value;



- (NSMutableSet*)primitiveClassrooms;
- (void)setPrimitiveClassrooms:(NSMutableSet*)value;



- (NSMutableSet*)primitiveGrades;
- (void)setPrimitiveGrades:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSeats;
- (void)setPrimitiveSeats:(NSMutableSet*)value;


@end
