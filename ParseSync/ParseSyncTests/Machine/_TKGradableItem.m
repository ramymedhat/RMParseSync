// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGradableItem.m instead.

#import "_TKGradableItem.h"

const struct TKGradableItemAttributes TKGradableItemAttributes = {
	.createdDate = @"createdDate",
	.date = @"date",
	.gradableitemId = @"gradableitemId",
	.isShadow = @"isShadow",
	.itemDescription = @"itemDescription",
	.lastModifiedDate = @"lastModifiedDate",
	.maximumGrade = @"maximumGrade",
	.serverObjectID = @"serverObjectID",
	.title = @"title",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
	.weight = @"weight",
};

const struct TKGradableItemRelationships TKGradableItemRelationships = {
	.gradeCategory = @"gradeCategory",
	.gradeType = @"gradeType",
	.grades = @"grades",
};

const struct TKGradableItemFetchedProperties TKGradableItemFetchedProperties = {
};

@implementation TKGradableItemID
@end

@implementation _TKGradableItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Gradableitem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Gradableitem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Gradableitem" inManagedObjectContext:moc_];
}

- (TKGradableItemID*)objectID {
	return (TKGradableItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maximumGradeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maximumGrade"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weightValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weight"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdDate;






@dynamic date;






@dynamic gradableitemId;






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





@dynamic itemDescription;






@dynamic lastModifiedDate;






@dynamic maximumGrade;



- (int32_t)maximumGradeValue {
	NSNumber *result = [self maximumGrade];
	return [result intValue];
}

- (void)setMaximumGradeValue:(int32_t)value_ {
	[self setMaximumGrade:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMaximumGradeValue {
	NSNumber *result = [self primitiveMaximumGrade];
	return [result intValue];
}

- (void)setPrimitiveMaximumGradeValue:(int32_t)value_ {
	[self setPrimitiveMaximumGrade:[NSNumber numberWithInt:value_]];
}





@dynamic serverObjectID;






@dynamic title;






@dynamic tkID;






@dynamic updatedDate;






@dynamic weight;



- (float)weightValue {
	NSNumber *result = [self weight];
	return [result floatValue];
}

- (void)setWeightValue:(float)value_ {
	[self setWeight:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveWeightValue {
	NSNumber *result = [self primitiveWeight];
	return [result floatValue];
}

- (void)setPrimitiveWeightValue:(float)value_ {
	[self setPrimitiveWeight:[NSNumber numberWithFloat:value_]];
}





@dynamic gradeCategory;

	

@dynamic gradeType;

	

@dynamic grades;

	
- (NSMutableSet*)gradesSet {
	[self willAccessValueForKey:@"grades"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"grades"];
  
	[self didAccessValueForKey:@"grades"];
	return result;
}
	






@end
