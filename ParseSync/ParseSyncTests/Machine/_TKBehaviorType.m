// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKBehaviorType.m instead.

#import "_TKBehaviorType.h"

const struct TKBehaviorTypeAttributes TKBehaviorTypeAttributes = {
	.behaviortypeId = @"behaviortypeId",
	.createdDate = @"createdDate",
	.icon = @"icon",
	.iconPath = @"iconPath",
	.isPositive = @"isPositive",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.title = @"title",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKBehaviorTypeRelationships TKBehaviorTypeRelationships = {
	.behaviors = @"behaviors",
};

const struct TKBehaviorTypeFetchedProperties TKBehaviorTypeFetchedProperties = {
};

@implementation TKBehaviorTypeID
@end

@implementation _TKBehaviorType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Behaviortype" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Behaviortype";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Behaviortype" inManagedObjectContext:moc_];
}

- (TKBehaviorTypeID*)objectID {
	return (TKBehaviorTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isPositiveValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isPositive"];
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




@dynamic behaviortypeId;






@dynamic createdDate;






@dynamic icon;






@dynamic iconPath;






@dynamic isPositive;



- (BOOL)isPositiveValue {
	NSNumber *result = [self isPositive];
	return [result boolValue];
}

- (void)setIsPositiveValue:(BOOL)value_ {
	[self setIsPositive:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsPositiveValue {
	NSNumber *result = [self primitiveIsPositive];
	return [result boolValue];
}

- (void)setPrimitiveIsPositiveValue:(BOOL)value_ {
	[self setPrimitiveIsPositive:[NSNumber numberWithBool:value_]];
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






@dynamic title;






@dynamic tkID;






@dynamic updatedDate;






@dynamic behaviors;

	
- (NSMutableSet*)behaviorsSet {
	[self willAccessValueForKey:@"behaviors"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"behaviors"];
  
	[self didAccessValueForKey:@"behaviors"];
	return result;
}
	






@end
