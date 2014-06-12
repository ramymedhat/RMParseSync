// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKBehavior.m instead.

#import "_TKBehavior.h"

const struct TKBehaviorAttributes TKBehaviorAttributes = {
	.behaviorDate = @"behaviorDate",
	.behaviorId = @"behaviorId",
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.notes = @"notes",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKBehaviorRelationships TKBehaviorRelationships = {
	.behaviorType = @"behaviorType",
	.classroom = @"classroom",
	.student = @"student",
};

const struct TKBehaviorFetchedProperties TKBehaviorFetchedProperties = {
};

@implementation TKBehaviorID
@end

@implementation _TKBehavior

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Behavior" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Behavior";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Behavior" inManagedObjectContext:moc_];
}

- (TKBehaviorID*)objectID {
	return (TKBehaviorID*)[super objectID];
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




@dynamic behaviorDate;






@dynamic behaviorId;






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






@dynamic notes;






@dynamic serverObjectID;






@dynamic tkID;






@dynamic updatedDate;






@dynamic behaviorType;

	

@dynamic classroom;

	

@dynamic student;

	






@end
