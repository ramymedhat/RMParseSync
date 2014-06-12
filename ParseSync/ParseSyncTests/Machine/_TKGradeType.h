// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGradeType.h instead.

#import <CoreData/CoreData.h>


extern const struct TKGradeTypeAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *gradetypeId;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
	__unsafe_unretained NSString *values;
} TKGradeTypeAttributes;

extern const struct TKGradeTypeRelationships {
	__unsafe_unretained NSString *gradableItems;
} TKGradeTypeRelationships;

extern const struct TKGradeTypeFetchedProperties {
} TKGradeTypeFetchedProperties;

@class TKGradableItem;











@interface TKGradeTypeID : NSManagedObjectID {}
@end

@interface _TKGradeType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKGradeTypeID*)objectID;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* gradetypeId;



//- (BOOL)validateGradetypeId:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSString* values;



//- (BOOL)validateValues:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *gradableItems;

- (NSMutableSet*)gradableItemsSet;





@end

@interface _TKGradeType (CoreDataGeneratedAccessors)

- (void)addGradableItems:(NSSet*)value_;
- (void)removeGradableItems:(NSSet*)value_;
- (void)addGradableItemsObject:(TKGradableItem*)value_;
- (void)removeGradableItemsObject:(TKGradableItem*)value_;

@end

@interface _TKGradeType (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveGradetypeId;
- (void)setPrimitiveGradetypeId:(NSString*)value;




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




- (NSString*)primitiveValues;
- (void)setPrimitiveValues:(NSString*)value;





- (NSMutableSet*)primitiveGradableItems;
- (void)setPrimitiveGradableItems:(NSMutableSet*)value;


@end
