// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAccessCode.h instead.

#import <CoreData/CoreData.h>


extern const struct TKAccessCodeAttributes {
	__unsafe_unretained NSString *accesscodeId;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *parentCode;
	__unsafe_unretained NSString *parentRoleName;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *studentCode;
	__unsafe_unretained NSString *studentRoleName;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKAccessCodeAttributes;

extern const struct TKAccessCodeRelationships {
	__unsafe_unretained NSString *student;
} TKAccessCodeRelationships;

extern const struct TKAccessCodeFetchedProperties {
} TKAccessCodeFetchedProperties;

@class TKStudent;












@interface TKAccessCodeID : NSManagedObjectID {}
@end

@interface _TKAccessCode : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKAccessCodeID*)objectID;





@property (nonatomic, strong) NSString* accesscodeId;



//- (BOOL)validateAccesscodeId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parentCode;



//- (BOOL)validateParentCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* parentRoleName;



//- (BOOL)validateParentRoleName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* studentCode;



//- (BOOL)validateStudentCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* studentRoleName;



//- (BOOL)validateStudentRoleName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKStudent *student;

//- (BOOL)validateStudent:(id*)value_ error:(NSError**)error_;





@end

@interface _TKAccessCode (CoreDataGeneratedAccessors)

@end

@interface _TKAccessCode (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAccesscodeId;
- (void)setPrimitiveAccesscodeId:(NSString*)value;




- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSString*)primitiveParentCode;
- (void)setPrimitiveParentCode:(NSString*)value;




- (NSString*)primitiveParentRoleName;
- (void)setPrimitiveParentRoleName:(NSString*)value;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveStudentCode;
- (void)setPrimitiveStudentCode:(NSString*)value;




- (NSString*)primitiveStudentRoleName;
- (void)setPrimitiveStudentRoleName:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (TKStudent*)primitiveStudent;
- (void)setPrimitiveStudent:(TKStudent*)value;


@end
