// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKConfiguration.m instead.

#import "_TKConfiguration.h"

const struct TKConfigurationAttributes TKConfigurationAttributes = {
	.configurationId = @"configurationId",
	.configurationKey = @"configurationKey",
	.configurationValue = @"configurationValue",
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKConfigurationRelationships TKConfigurationRelationships = {
};

const struct TKConfigurationFetchedProperties TKConfigurationFetchedProperties = {
};

@implementation TKConfigurationID
@end

@implementation _TKConfiguration

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Configuration" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Configuration";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Configuration" inManagedObjectContext:moc_];
}

- (TKConfigurationID*)objectID {
	return (TKConfigurationID*)[super objectID];
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




@dynamic configurationId;






@dynamic configurationKey;






@dynamic configurationValue;






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











@end
