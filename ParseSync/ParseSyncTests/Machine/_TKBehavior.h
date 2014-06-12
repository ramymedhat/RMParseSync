// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKBehavior.h instead.

#import <CoreData/CoreData.h>


extern const struct TKBehaviorAttributes {
	__unsafe_unretained NSString *behaviorDate;
	__unsafe_unretained NSString *behaviorId;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKBehaviorAttributes;

extern const struct TKBehaviorRelationships {
	__unsafe_unretained NSString *behaviorType;
	__unsafe_unretained NSString *classroom;
	__unsafe_unretained NSString *student;
} TKBehaviorRelationships;

extern const struct TKBehaviorFetchedProperties {
} TKBehaviorFetchedProperties;

@class TKBehaviorType;
@class TKClassroom;
@class TKStudent;











@interface TKBehaviorID : NSManagedObjectID {}
@end

@interface _TKBehavior : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKBehaviorID*)objectID;





@property (nonatomic, strong) NSDate* behaviorDate;



//- (BOOL)validateBehaviorDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* behaviorId;



//- (BOOL)validateBehaviorId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKBehaviorType *behaviorType;

//- (BOOL)validateBehaviorType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKClassroom *classroom;

//- (BOOL)validateClassroom:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKStudent *student;

//- (BOOL)validateStudent:(id*)value_ error:(NSError**)error_;





@end

@interface _TKBehavior (CoreDataGeneratedAccessors)

@end

@interface _TKBehavior (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBehaviorDate;
- (void)setPrimitiveBehaviorDate:(NSDate*)value;




- (NSString*)primitiveBehaviorId;
- (void)setPrimitiveBehaviorId:(NSString*)value;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (TKBehaviorType*)primitiveBehaviorType;
- (void)setPrimitiveBehaviorType:(TKBehaviorType*)value;



- (TKClassroom*)primitiveClassroom;
- (void)setPrimitiveClassroom:(TKClassroom*)value;



- (TKStudent*)primitiveStudent;
- (void)setPrimitiveStudent:(TKStudent*)value;


@end
