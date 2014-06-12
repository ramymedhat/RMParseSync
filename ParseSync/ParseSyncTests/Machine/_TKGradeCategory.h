// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGradeCategory.h instead.

#import <CoreData/CoreData.h>


extern const struct TKGradeCategoryAttributes {
	__unsafe_unretained NSString *calculationMode;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *gradecategoryId;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *percent;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKGradeCategoryAttributes;

extern const struct TKGradeCategoryRelationships {
	__unsafe_unretained NSString *classroom;
	__unsafe_unretained NSString *gradableItems;
} TKGradeCategoryRelationships;

extern const struct TKGradeCategoryFetchedProperties {
} TKGradeCategoryFetchedProperties;

@class TKClassroom;
@class TKGradableItem;












@interface TKGradeCategoryID : NSManagedObjectID {}
@end

@interface _TKGradeCategory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKGradeCategoryID*)objectID;





@property (nonatomic, strong) NSNumber* calculationMode;



@property int32_t calculationModeValue;
- (int32_t)calculationModeValue;
- (void)setCalculationModeValue:(int32_t)value_;

//- (BOOL)validateCalculationMode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* gradecategoryId;



//- (BOOL)validateGradecategoryId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* percent;



@property float percentValue;
- (float)percentValue;
- (void)setPercentValue:(float)value_;

//- (BOOL)validatePercent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKClassroom *classroom;

//- (BOOL)validateClassroom:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *gradableItems;

- (NSMutableSet*)gradableItemsSet;





@end

@interface _TKGradeCategory (CoreDataGeneratedAccessors)

- (void)addGradableItems:(NSSet*)value_;
- (void)removeGradableItems:(NSSet*)value_;
- (void)addGradableItemsObject:(TKGradableItem*)value_;
- (void)removeGradableItemsObject:(TKGradableItem*)value_;

@end

@interface _TKGradeCategory (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCalculationMode;
- (void)setPrimitiveCalculationMode:(NSNumber*)value;

- (int32_t)primitiveCalculationModeValue;
- (void)setPrimitiveCalculationModeValue:(int32_t)value_;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveGradecategoryId;
- (void)setPrimitiveGradecategoryId:(NSString*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSNumber*)primitivePercent;
- (void)setPrimitivePercent:(NSNumber*)value;

- (float)primitivePercentValue;
- (void)setPrimitivePercentValue:(float)value_;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (TKClassroom*)primitiveClassroom;
- (void)setPrimitiveClassroom:(TKClassroom*)value;



- (NSMutableSet*)primitiveGradableItems;
- (void)setPrimitiveGradableItems:(NSMutableSet*)value;


@end
