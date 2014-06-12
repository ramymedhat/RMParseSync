// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKSeat.h instead.

#import <CoreData/CoreData.h>


extern const struct TKSeatAttributes {
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *seatId;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
	__unsafe_unretained NSString *xposition;
	__unsafe_unretained NSString *yposition;
} TKSeatAttributes;

extern const struct TKSeatRelationships {
	__unsafe_unretained NSString *classroom;
	__unsafe_unretained NSString *student;
} TKSeatRelationships;

extern const struct TKSeatFetchedProperties {
} TKSeatFetchedProperties;

@class TKClassroom;
@class TKStudent;











@interface TKSeatID : NSManagedObjectID {}
@end

@interface _TKSeat : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKSeatID*)objectID;





@property (nonatomic, strong) NSDate* createdDate;



//- (BOOL)validateCreatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isShadow;



@property BOOL isShadowValue;
- (BOOL)isShadowValue;
- (void)setIsShadowValue:(BOOL)value_;

//- (BOOL)validateIsShadow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastModifiedDate;



//- (BOOL)validateLastModifiedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* seatId;



//- (BOOL)validateSeatId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* serverObjectID;



//- (BOOL)validateServerObjectID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* xposition;



@property float xpositionValue;
- (float)xpositionValue;
- (void)setXpositionValue:(float)value_;

//- (BOOL)validateXposition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* yposition;



@property float ypositionValue;
- (float)ypositionValue;
- (void)setYpositionValue:(float)value_;

//- (BOOL)validateYposition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TKClassroom *classroom;

//- (BOOL)validateClassroom:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TKStudent *student;

//- (BOOL)validateStudent:(id*)value_ error:(NSError**)error_;





@end

@interface _TKSeat (CoreDataGeneratedAccessors)

@end

@interface _TKSeat (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedDate;
- (void)setPrimitiveCreatedDate:(NSDate*)value;




- (NSNumber*)primitiveIsShadow;
- (void)setPrimitiveIsShadow:(NSNumber*)value;

- (BOOL)primitiveIsShadowValue;
- (void)setPrimitiveIsShadowValue:(BOOL)value_;




- (NSDate*)primitiveLastModifiedDate;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value;




- (NSString*)primitiveSeatId;
- (void)setPrimitiveSeatId:(NSString*)value;




- (NSString*)primitiveServerObjectID;
- (void)setPrimitiveServerObjectID:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;




- (NSNumber*)primitiveXposition;
- (void)setPrimitiveXposition:(NSNumber*)value;

- (float)primitiveXpositionValue;
- (void)setPrimitiveXpositionValue:(float)value_;




- (NSNumber*)primitiveYposition;
- (void)setPrimitiveYposition:(NSNumber*)value;

- (float)primitiveYpositionValue;
- (void)setPrimitiveYpositionValue:(float)value_;





- (TKClassroom*)primitiveClassroom;
- (void)setPrimitiveClassroom:(TKClassroom*)value;



- (TKStudent*)primitiveStudent;
- (void)setPrimitiveStudent:(TKStudent*)value;


@end
