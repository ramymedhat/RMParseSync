// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAttendance.m instead.

#import "_TKAttendance.h"

const struct TKAttendanceAttributes TKAttendanceAttributes = {
	.attendanceId = @"attendanceId",
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKAttendanceRelationships TKAttendanceRelationships = {
	.classroom = @"classroom",
	.lesson = @"lesson",
	.student = @"student",
	.type = @"type",
};

const struct TKAttendanceFetchedProperties TKAttendanceFetchedProperties = {
};

@implementation TKAttendanceID
@end

@implementation _TKAttendance

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Attendance" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Attendance";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Attendance" inManagedObjectContext:moc_];
}

- (TKAttendanceID*)objectID {
	return (TKAttendanceID*)[super objectID];
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




@dynamic attendanceId;






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






@dynamic classroom;

	

@dynamic lesson;

	

@dynamic student;

	

@dynamic type;

	






@end
