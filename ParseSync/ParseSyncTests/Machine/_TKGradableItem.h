// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGradableItem.h instead.

#import <CoreData/CoreData.h>


extern const struct TKGradableItemAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *gradableitemId;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *itemDescription;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *maximumGrade;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
	__unsafe_unretained NSString *weight;
} TKGradableItemAttributes;

extern const struct TKGradableItemRelationships {
	__unsafe_unretained NSString *gradeCategory;
	__unsafe_unretained NSString *gradeType;
	__unsafe_unretained NSString *grades;
} TKGradableItemRelationships;

extern const struct TKGradableItemFetchedProperties {
} TKGradableItemFetchedProperties;

@class TKGradeCategory;
@class TKGradeType;
@class TKGrade;














@interface TKGradableItemID : NSManagedObjectID {}
@end

@interface _TKGradableItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKGradableItemID*)objectID;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* gradableitemId;



//- (BOOL)validateGradableitemId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* itemDescription;



//- (BOOL)validateItemDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* maximumGrade;



@property int32_t maximumGradeValue;
- (int32_t)maximumGradeValue;
- (void)setMaximumGradeValue:(int32_t)value_;

//- (BOOL)validateMaximumGrade:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weight;



@property float weightValue;
- (float)weightValue;
- (void)setWeightValue:(float)value_;

//- (BOOL)validateWeight:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKGradeCategory *gradeCategory;

//- (BOOL)validateGradeCategory:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKGradeType *gradeType;

//- (BOOL)validateGradeType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *grades;

- (NSMutableSet*)gradesSet;





@end

@interface _TKGradableItem (CoreDataGeneratedAccessors)

- (void)addGrades:(NSSet*)value_;
- (void)removeGrades:(NSSet*)value_;
- (void)addGradesObject:(TKGrade*)value_;
- (void)removeGradesObject:(TKGrade*)value_;

@end

@interface _TKGradableItem (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSString*)primitiveGradableitemId;
- (void)setPrimitiveGradableitemId:(NSString*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSString*)primitiveItemDescription;
- (void)setPrimitiveItemDescription:(NSString*)value;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSNumber*)primitiveMaximumGrade;
- (void)setPrimitiveMaximumGrade:(NSNumber*)value;

- (int32_t)primitiveMaximumGradeValue;
- (void)setPrimitiveMaximumGradeValue:(int32_t)value_;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;




- (NSNumber*)primitiveWeight;
- (void)setPrimitiveWeight:(NSNumber*)value;

- (float)primitiveWeightValue;
- (void)setPrimitiveWeightValue:(float)value_;





- (TKGradeCategory*)primitiveGradeCategory;
- (void)setPrimitiveGradeCategory:(TKGradeCategory*)value;



- (TKGradeType*)primitiveGradeType;
- (void)setPrimitiveGradeType:(TKGradeType*)value;



- (NSMutableSet*)primitiveGrades;
- (void)setPrimitiveGrades:(NSMutableSet*)value;


@end
