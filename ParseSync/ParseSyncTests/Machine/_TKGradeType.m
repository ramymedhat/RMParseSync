// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGradeType.m instead.

#import "_TKGradeType.h"

const struct TKGradeTypeAttributes TKGradeTypeAttributes = {
	.createdDate = @"createdDate",
	.gradetypeId = @"gradetypeId",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.title = @"title",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
	.values = @"values",
};

const struct TKGradeTypeRelationships TKGradeTypeRelationships = {
	.gradableItems = @"gradableItems",
};

const struct TKGradeTypeFetchedProperties TKGradeTypeFetchedProperties = {
};

@implementation TKGradeTypeID
@end

@implementation _TKGradeType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Gradetype" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Gradetype";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Gradetype" inManagedObjectContext:moc_];
}

- (TKGradeTypeID*)objectID {
	return (TKGradeTypeID*)[super objectID];
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




@dynamic createdDate;






@dynamic gradetypeId;






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






@dynamic title;






@dynamic tkID;






@dynamic updatedDate;






@dynamic values;






@dynamic gradableItems;

	
- (NSMutableSet*)gradableItemsSet {
	[self willAccessValueForKey:@"gradableItems"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"gradableItems"];
  
	[self didAccessValueForKey:@"gradableItems"];
	return result;
}
	






@end
