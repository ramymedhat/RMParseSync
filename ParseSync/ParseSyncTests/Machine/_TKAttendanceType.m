// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAttendanceType.m instead.

#import "_TKAttendanceType.h"

const struct TKAttendanceTypeAttributes TKAttendanceTypeAttributes = {
	.attendancetypeId = @"attendancetypeId",
	.color = @"color",
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.sortKey = @"sortKey",
	.title = @"title",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKAttendanceTypeRelationships TKAttendanceTypeRelationships = {
	.attendances = @"attendances",
};

const struct TKAttendanceTypeFetchedProperties TKAttendanceTypeFetchedProperties = {
};

@implementation TKAttendanceTypeID
@end

@implementation _TKAttendanceType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Attendancetype" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Attendancetype";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Attendancetype" inManagedObjectContext:moc_];
}

- (TKAttendanceTypeID*)objectID {
	return (TKAttendanceTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sortKeyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sortKey"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic attendancetypeId;






@dynamic color;






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






@dynamic sortKey;



- (int16_t)sortKeyValue {
	NSNumber *result = [self sortKey];
	return [result shortValue];
}

- (void)setSortKeyValue:(int16_t)value_ {
	[self setSortKey:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSortKeyValue {
	NSNumber *result = [self primitiveSortKey];
	return [result shortValue];
}

- (void)setPrimitiveSortKeyValue:(int16_t)value_ {
	[self setPrimitiveSortKey:[NSNumber numberWithShort:value_]];
}





@dynamic title;






@dynamic tkID;






@dynamic updatedDate;






@dynamic attendances;

	
- (NSMutableSet*)attendancesSet {
	[self willAccessValueForKey:@"attendances"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"attendances"];
  
	[self didAccessValueForKey:@"attendances"];
	return result;
}
	






@end
