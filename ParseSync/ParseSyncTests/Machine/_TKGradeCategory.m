// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGradeCategory.m instead.

#import "_TKGradeCategory.h"

const struct TKGradeCategoryAttributes TKGradeCategoryAttributes = {
	.calculationMode = @"calculationMode",
	.createdDate = @"createdDate",
	.gradecategoryId = @"gradecategoryId",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.percent = @"percent",
	.serverObjectID = @"serverObjectID",
	.title = @"title",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKGradeCategoryRelationships TKGradeCategoryRelationships = {
	.classroom = @"classroom",
	.gradableItems = @"gradableItems",
};

const struct TKGradeCategoryFetchedProperties TKGradeCategoryFetchedProperties = {
};

@implementation TKGradeCategoryID
@end

@implementation _TKGradeCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Gradecategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Gradecategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Gradecategory" inManagedObjectContext:moc_];
}

- (TKGradeCategoryID*)objectID {
	return (TKGradeCategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"calculationModeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"calculationMode"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"percentValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"percent"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic calculationMode;



- (int32_t)calculationModeValue {
	NSNumber *result = [self calculationMode];
	return [result intValue];
}

- (void)setCalculationModeValue:(int32_t)value_ {
	[self setCalculationMode:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCalculationModeValue {
	NSNumber *result = [self primitiveCalculationMode];
	return [result intValue];
}

- (void)setPrimitiveCalculationModeValue:(int32_t)value_ {
	[self setPrimitiveCalculationMode:[NSNumber numberWithInt:value_]];
}





@dynamic createdDate;






@dynamic gradecategoryId;






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






@dynamic percent;



- (float)percentValue {
	NSNumber *result = [self percent];
	return [result floatValue];
}

- (void)setPercentValue:(float)value_ {
	[self setPercent:[NSNumber numberWithFloat:value_]];
}

- (float)primitivePercentValue {
	NSNumber *result = [self primitivePercent];
	return [result floatValue];
}

- (void)setPrimitivePercentValue:(float)value_ {
	[self setPrimitivePercent:[NSNumber numberWithFloat:value_]];
}





@dynamic serverObjectID;






@dynamic title;






@dynamic tkID;






@dynamic updatedDate;






@dynamic classroom;

	

@dynamic gradableItems;

	
- (NSMutableSet*)gradableItemsSet {
	[self willAccessValueForKey:@"gradableItems"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"gradableItems"];
  
	[self didAccessValueForKey:@"gradableItems"];
	return result;
}
	






@end
