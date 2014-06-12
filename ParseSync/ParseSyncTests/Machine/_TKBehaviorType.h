// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKBehaviorType.h instead.

#import <CoreData/CoreData.h>


extern const struct TKBehaviorTypeAttributes {
	__unsafe_unretained NSString *behaviortypeId;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *icon;
	__unsafe_unretained NSString *iconPath;
	__unsafe_unretained NSString *isPositive;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKBehaviorTypeAttributes;

extern const struct TKBehaviorTypeRelationships {
	__unsafe_unretained NSString *behaviors;
} TKBehaviorTypeRelationships;

extern const struct TKBehaviorTypeFetchedProperties {
} TKBehaviorTypeFetchedProperties;

@class TKBehavior;













@interface TKBehaviorTypeID : NSManagedObjectID {}
@end

@interface _TKBehaviorType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKBehaviorTypeID*)objectID;





@property (nonatomic, strong) NSString* behaviortypeId;



//- (BOOL)validateBehaviortypeId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* icon;



//- (BOOL)validateIcon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* iconPath;



//- (BOOL)validateIconPath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isPositive;



@property BOOL isPositiveValue;
- (BOOL)isPositiveValue;
- (void)setIsPositiveValue:(BOOL)value_;

//- (BOOL)validateIsPositive:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *behaviors;

- (NSMutableSet*)behaviorsSet;





@end

@interface _TKBehaviorType (CoreDataGeneratedAccessors)

- (void)addBehaviors:(NSSet*)value_;
- (void)removeBehaviors:(NSSet*)value_;
- (void)addBehaviorsObject:(TKBehavior*)value_;
- (void)removeBehaviorsObject:(TKBehavior*)value_;

@end

@interface _TKBehaviorType (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBehaviortypeId;
- (void)setPrimitiveBehaviortypeId:(NSString*)value;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveIcon;
- (void)setPrimitiveIcon:(NSString*)value;




- (NSString*)primitiveIconPath;
- (void)setPrimitiveIconPath:(NSString*)value;




- (NSNumber*)primitiveIsPositive;
- (void)setPrimitiveIsPositive:(NSNumber*)value;

- (BOOL)primitiveIsPositiveValue;
- (void)setPrimitiveIsPositiveValue:(BOOL)value_;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (NSMutableSet*)primitiveBehaviors;
- (void)setPrimitiveBehaviors:(NSMutableSet*)value;


@end
