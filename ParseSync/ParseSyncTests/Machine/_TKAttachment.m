// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAttachment.m instead.

#import "_TKAttachment.h"

const struct TKAttachmentAttributes TKAttachmentAttributes = {
	.attachmentId = @"attachmentId",
	.attachmentUrl = @"attachmentUrl",
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKAttachmentRelationships TKAttachmentRelationships = {
	.lesson = @"lesson",
};

const struct TKAttachmentFetchedProperties TKAttachmentFetchedProperties = {
};

@implementation TKAttachmentID
@end

@implementation _TKAttachment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Attachment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Attachment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Attachment" inManagedObjectContext:moc_];
}

- (TKAttachmentID*)objectID {
	return (TKAttachmentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic attachmentId;






@dynamic attachmentUrl;






@dynamic createdDate;






@dynamic isShadow;



- (BOOL)isShadowValue {
	NSNumber *result = [self isShadow];
	return [result boolValue];
}

- (void)setIsShadowValue:(BOOL)value_ {
	[self setIsShadow:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsShadowValue {
	NSNumber *result = [self primitiveIsShadow];
	return [result boolValue];
}

- (void)setPrimitiveIsShadowValue:(BOOL)value_ {
	[self setPrimitiveIsShadow:[NSNumber numberWithBool:value_]];
}





@dynamic lastModifiedDate;






@dynamic serverObjectID;






@dynamic tkID;






@dynamic updatedDate;






@dynamic lesson;

	






@end
