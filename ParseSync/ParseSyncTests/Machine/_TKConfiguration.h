// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKConfiguration.h instead.

#import <CoreData/CoreData.h>


extern const struct TKConfigurationAttributes {
	__unsafe_unretained NSString *configurationId;
	__unsafe_unretained NSString *configurationKey;
	__unsafe_unretained NSString *configurationValue;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKConfigurationAttributes;

extern const struct TKConfigurationRelationships {
} TKConfigurationRelationships;

extern const struct TKConfigurationFetchedProperties {
} TKConfigurationFetchedProperties;












@interface TKConfigurationID : NSManagedObjectID {}
@end

@interface _TKConfiguration : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKConfigurationID*)objectID;





@property (nonatomic, strong) NSString* configurationId;



//- (BOOL)validateConfigurationId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* configurationKey;



//- (BOOL)validateConfigurationKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* configurationValue;



//- (BOOL)validateConfigurationValue:(id*)value_ error:(NSError**)error_;





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






@end

@interface _TKConfiguration (CoreDataGeneratedAccessors)

@end

@interface _TKConfiguration (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveConfigurationId;
- (void)setPrimitiveConfigurationId:(NSString*)value;




- (NSString*)primitiveConfigurationKey;
- (void)setPrimitiveConfigurationKey:(NSString*)value;




- (NSString*)primitiveConfigurationValue;
- (void)setPrimitiveConfigurationValue:(NSString*)value;




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




@end
