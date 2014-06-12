// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKSeat.m instead.

#import "_TKSeat.h"

const struct TKSeatAttributes TKSeatAttributes = {
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.seatId = @"seatId",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
	.xposition = @"xposition",
	.yposition = @"yposition",
};

const struct TKSeatRelationships TKSeatRelationships = {
	.classroom = @"classroom",
	.student = @"student",
};

const struct TKSeatFetchedProperties TKSeatFetchedProperties = {
};

@implementation TKSeatID
@end

@implementation _TKSeat

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Seat";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Seat" inManagedObjectContext:moc_];
}

- (TKSeatID*)objectID {
	return (TKSeatID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"xpositionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"xposition"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ypositionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"yposition"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




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






@dynamic seatId;






@dynamic serverObjectID;






@dynamic tkID;






@dynamic updatedDate;






@dynamic xposition;



- (float)xpositionValue {
	NSNumber *result = [self xposition];
	return [result floatValue];
}

- (void)setXpositionValue:(float)value_ {
	[self setXposition:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveXpositionValue {
	NSNumber *result = [self primitiveXposition];
	return [result floatValue];
}

- (void)setPrimitiveXpositionValue:(float)value_ {
	[self setPrimitiveXposition:[NSNumber numberWithFloat:value_]];
}





@dynamic yposition;



- (float)ypositionValue {
	NSNumber *result = [self yposition];
	return [result floatValue];
}

- (void)setYpositionValue:(float)value_ {
	[self setYposition:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveYpositionValue {
	NSNumber *result = [self primitiveYposition];
	return [result floatValue];
}

- (void)setPrimitiveYpositionValue:(float)value_ {
	[self setPrimitiveYposition:[NSNumber numberWithFloat:value_]];
}





@dynamic classroom;

	

@dynamic student;

	






@end
