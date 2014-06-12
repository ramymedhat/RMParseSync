// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKGrade.m instead.

#import "_TKGrade.h"

const struct TKGradeAttributes TKGradeAttributes = {
	.createdDate = @"createdDate",
	.gradeId = @"gradeId",
	.gradeValue = @"gradeValue",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKGradeRelationships TKGradeRelationships = {
	.gradableItem = @"gradableItem",
	.student = @"student",
};

const struct TKGradeFetchedProperties TKGradeFetchedProperties = {
};

@implementation TKGradeID
@end

@implementation _TKGrade

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Grade" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Grade";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Grade" inManagedObjectContext:moc_];
}

- (TKGradeID*)objectID {
	return (TKGradeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"gradeValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gradeValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdDate;






@dynamic gradeId;






@dynamic gradeValue;



- (float)gradeValueValue {
	NSNumber *result = [self gradeValue];
	return [result floatValue];
}

- (void)setGradeValueValue:(float)value_ {
	[self setGradeValue:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveGradeValueValue {
	NSNumber *result = [self primitiveGradeValue];
	return [result floatValue];
}

- (void)setPrimitiveGradeValueValue:(float)value_ {
	[self setPrimitiveGradeValue:[NSNumber numberWithFloat:value_]];
}





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






@dynamic gradableItem;

	

@dynamic student;

	






@end
