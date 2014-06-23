// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKClassroom.m instead.

#import "_TKClassroom.h"

const struct TKClassroomAttributes TKClassroomAttributes = {
	.category = @"category",
	.classroomDescription = @"classroomDescription",
	.classroomId = @"classroomId",
	.code = @"code",
	.createdDate = @"createdDate",
	.icon = @"icon",
	.image_BinaryPathKey = @"image_BinaryPathKey",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.lessonsEndDate = @"lessonsEndDate",
	.lessonsStartDate = @"lessonsStartDate",
	.lessonsType = @"lessonsType",
	.serverObjectID = @"serverObjectID",
	.title = @"title",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKClassroomRelationships TKClassroomRelationships = {
	.attendances = @"attendances",
	.behaviors = @"behaviors",
	.categories = @"categories",
	.lessons = @"lessons",
	.seats = @"seats",
	.students = @"students",
};

const struct TKClassroomFetchedProperties TKClassroomFetchedProperties = {
};

@implementation TKClassroomID
@end

@implementation _TKClassroom

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Classroom" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Classroom";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Classroom" inManagedObjectContext:moc_];
}

- (TKClassroomID*)objectID {
	return (TKClassroomID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lessonsTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lessonsType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic category;






@dynamic classroomDescription;






@dynamic classroomId;






@dynamic code;






@dynamic createdDate;






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






@dynamic lessonsEndDate;






@dynamic lessonsStartDate;






@dynamic lessonsType;



- (int16_t)lessonsTypeValue {
	NSNumber *result = [self lessonsType];
	return [result shortValue];
}

- (void)setLessonsTypeValue:(int16_t)value_ {
	[self setLessonsType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLessonsTypeValue {
	NSNumber *result = [self primitiveLessonsType];
	return [result shortValue];
}

- (void)setPrimitiveLessonsTypeValue:(int16_t)value_ {
	[self setPrimitiveLessonsType:[NSNumber numberWithShort:value_]];
}





@dynamic serverObjectID;






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
	

@dynamic behaviors;

	
- (NSMutableSet*)behaviorsSet {
	[self willAccessValueForKey:@"behaviors"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"behaviors"];
  
	[self didAccessValueForKey:@"behaviors"];
	return result;
}
	

@dynamic categories;

	
- (NSMutableSet*)categoriesSet {
	[self willAccessValueForKey:@"categories"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"categories"];
  
	[self didAccessValueForKey:@"categories"];
	return result;
}
	

@dynamic lessons;

	
- (NSMutableSet*)lessonsSet {
	[self willAccessValueForKey:@"lessons"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"lessons"];
  
	[self didAccessValueForKey:@"lessons"];
	return result;
}
	

@dynamic seats;

	
- (NSMutableSet*)seatsSet {
	[self willAccessValueForKey:@"seats"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"seats"];
  
	[self didAccessValueForKey:@"seats"];
	return result;
}
	

@dynamic students;

	
- (NSMutableSet*)studentsSet {
	[self willAccessValueForKey:@"students"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"students"];
  
	[self didAccessValueForKey:@"students"];
	return result;
}
	






@end
