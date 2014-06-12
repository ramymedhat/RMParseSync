// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAttendanceType.h instead.

#import <CoreData/CoreData.h>


extern const struct TKAttendanceTypeAttributes {
	__unsafe_unretained NSString *attendancetypeId;
	__unsafe_unretained NSString *color;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *sortKey;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKAttendanceTypeAttributes;

extern const struct TKAttendanceTypeRelationships {
	__unsafe_unretained NSString *attendances;
} TKAttendanceTypeRelationships;

extern const struct TKAttendanceTypeFetchedProperties {
} TKAttendanceTypeFetchedProperties;

@class TKAttendance;












@interface TKAttendanceTypeID : NSManagedObjectID {}
@end

@interface _TKAttendanceType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKAttendanceTypeID*)objectID;





@property (nonatomic, strong) NSString* attendancetypeId;



//- (BOOL)validateAttendancetypeId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* color;



//- (BOOL)validateColor:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSNumber* sortKey;



@property int16_t sortKeyValue;
- (int16_t)sortKeyValue;
- (void)setSortKeyValue:(int16_t)value_;

//- (BOOL)validateSortKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tkID;



//- (BOOL)validateTkID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedDate;



//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *attendances;

- (NSMutableSet*)attendancesSet;





@end

@interface _TKAttendanceType (CoreDataGeneratedAccessors)

- (void)addAttendances:(NSSet*)value_;
- (void)removeAttendances:(NSSet*)value_;
- (void)addAttendancesObject:(TKAttendance*)value_;
- (void)removeAttendancesObject:(TKAttendance*)value_;

@end

@interface _TKAttendanceType (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAttendancetypeId;
- (void)setPrimitiveAttendancetypeId:(NSString*)value;




- (NSString*)primitiveColor;
- (void)setPrimitiveColor:(NSString*)value;




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




- (NSNumber*)primitiveSortKey;
- (void)setPrimitiveSortKey:(NSNumber*)value;

- (int16_t)primitiveSortKeyValue;
- (void)setPrimitiveSortKeyValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveTkID;
- (void)setPrimitiveTkID:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;





- (NSMutableSet*)primitiveAttendances;
- (void)setPrimitiveAttendances:(NSMutableSet*)value;


@end
