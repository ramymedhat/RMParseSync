// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGrade.h instead.

#import <CoreData/CoreData.h>


extern const struct TKGradeAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *gradeId;
	__unsafe_unretained NSString *gradeValue;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKGradeAttributes;

extern const struct TKGradeRelationships {
	__unsafe_unretained NSString *gradableItem;
	__unsafe_unretained NSString *student;
} TKGradeRelationships;

extern const struct TKGradeFetchedProperties {
} TKGradeFetchedProperties;

@class TKGradableItem;
@class TKStudent;










@interface TKGradeID : NSManagedObjectID {}
@end

@interface _TKGrade : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKGradeID*)objectID;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* gradeId;



//- (BOOL)validateGradeId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* gradeValue;



@property float gradeValueValue;
- (float)gradeValueValue;
- (void)setGradeValueValue:(float)value_;

//- (BOOL)validateGradeValue:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) TKGradableItem *gradableItem;

//- (BOOL)validateGradableItem:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKStudent *student;

//- (BOOL)validateStudent:(id*)value_ error:(NSError**)error_;





@end

@interface _TKGrade (CoreDataGeneratedAccessors)

@end

@interface _TKGrade (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSString*)primitiveGradeId;
- (void)setPrimitiveGradeId:(NSString*)value;




- (NSNumber*)primitiveGradeValue;
- (void)setPrimitiveGradeValue:(NSNumber*)value;

- (float)primitiveGradeValueValue;
- (void)setPrimitiveGradeValueValue:(float)value_;




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





- (TKGradableItem*)primitiveGradableItem;
- (void)setPrimitiveGradableItem:(TKGradableItem*)value;



- (TKStudent*)primitiveStudent;
- (void)setPrimitiveStudent:(TKStudent*)value;


@end
