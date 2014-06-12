// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAttachment.h instead.

#import <CoreData/CoreData.h>


extern const struct TKAttachmentAttributes {
	__unsafe_unretained NSString *attachmentId;
	__unsafe_unretained NSString *attachmentUrl;
	__unsafe_unretained NSString *createdDate;
	__unsafe_unretained NSString *isShadow;
	__unsafe_unretained NSString *lastModifiedDate;
	__unsafe_unretained NSString *serverObjectID;
	__unsafe_unretained NSString *tkID;
	__unsafe_unretained NSString *updatedDate;
} TKAttachmentAttributes;

extern const struct TKAttachmentRelationships {
	__unsafe_unretained NSString *lesson;
} TKAttachmentRelationships;

extern const struct TKAttachmentFetchedProperties {
} TKAttachmentFetchedProperties;

@class TKLesson;










@interface TKAttachmentID : NSManagedObjectID {}
@end

@interface _TKAttachment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TKAttachmentID*)objectID;





@property (nonatomic, strong) NSString* attachmentId;



//- (BOOL)validateAttachmentId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* attachmentUrl;



//- (BOOL)validateAttachmentUrl:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) TKLesson *lesson;

//- (BOOL)validateLesson:(id*)value_ error:(NSError**)error_;





@end

@interface _TKAttachment (CoreDataGeneratedAccessors)

@end

@interface _TKAttachment (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAttachmentId;
- (void)setPrimitiveAttachmentId:(NSString*)value;




- (NSString*)primitiveAttachmentUrl;
- (void)setPrimitiveAttachmentUrl:(NSString*)value;




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





- (TKLesson*)primitiveLesson;
- (void)setPrimitiveLesson:(TKLesson*)value;


@end
