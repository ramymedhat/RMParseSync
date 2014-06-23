// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKStudent.m instead.

#import "_TKStudent.h"

const struct TKStudentAttributes TKStudentAttributes = {
	.code = @"code",
	.createdDate = @"createdDate",
	.email = @"email",
	.firstName = @"firstName",
	.icon = @"icon",
	.image_BinaryPathKey = @"image_BinaryPathKey",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.lastName = @"lastName",
	.notes = @"notes",
	.parentEmail = @"parentEmail",
	.parentName = @"parentName",
	.parentPhone = @"parentPhone",
	.parentSkype = @"parentSkype",
	.phone = @"phone",
	.serverObjectID = @"serverObjectID",
	.skype = @"skype",
	.studentId = @"studentId",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKStudentRelationships TKStudentRelationships = {
	.accessCode = @"accessCode",
	.attendances = @"attendances",
	.behaviors = @"behaviors",
	.classrooms = @"classrooms",
	.grades = @"grades",
	.seats = @"seats",
};

const struct TKStudentFetchedProperties TKStudentFetchedProperties = {
};

@implementation TKStudentID
@end

@implementation _TKStudent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Student";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Student" inManagedObjectContext:moc_];
}

- (TKStudentID*)objectID {
	return (TKStudentID*)[super objectID];
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




@dynamic code;






@dynamic createdDate;






@dynamic email;






@dynamic firstName;






@dynamic icon;






@dynamic image_BinaryPathKey;






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






@dynamic lastName;






@dynamic notes;






@dynamic parentEmail;






@dynamic parentName;






@dynamic parentPhone;






@dynamic parentSkype;






@dynamic phone;






@dynamic serverObjectID;






@dynamic skype;






@dynamic studentId;






@dynamic tkID;






@dynamic updatedDate;






@dynamic accessCode;

	

@dynamic attendances;

	
- (NSMutableSet*)attendancesSet {
	[self willAccessValueForKey:@"attendances"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"attendances"];
  
	[self didAccessValueForKey:@"attendances"];
	return result;
}
	

@dynamic behaviors;

	
- (NSMutableSet*)behaviorsSet {
	[self willAccessValueForKey:@"behaviors"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"behaviors"];
  
	[self didAccessValueForKey:@"behaviors"];
	return result;
}
	

@dynamic classrooms;

	
- (NSMutableSet*)classroomsSet {
	[self willAccessValueForKey:@"classrooms"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"classrooms"];
  
	[self didAccessValueForKey:@"classrooms"];
	return result;
}
	

@dynamic grades;

	
- (NSMutableSet*)gradesSet {
	[self willAccessValueForKey:@"grades"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"grades"];
  
	[self didAccessValueForKey:@"grades"];
	return result;
}
	

@dynamic seats;

	
- (NSMutableSet*)seatsSet {
	[self willAccessValueForKey:@"seats"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"seats"];
  
	[self didAccessValueForKey:@"seats"];
	return result;
}
	






@end
