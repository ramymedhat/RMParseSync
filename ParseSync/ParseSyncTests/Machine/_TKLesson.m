// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKLesson.m instead.

#import "_TKLesson.h"

const struct TKLessonAttributes TKLessonAttributes = {
	.createdDate = @"createdDate",
	.isShadow = @"isShadow",
	.lastModifiedDate = @"lastModifiedDate",
	.lessonDescription = @"lessonDescription",
	.lessonEndTime = @"lessonEndTime",
	.lessonId = @"lessonId",
	.lessonLocation = @"lessonLocation",
	.lessonPeriod = @"lessonPeriod",
	.lessonStartDate = @"lessonStartDate",
	.lessonStartTime = @"lessonStartTime",
	.lessonTitle = @"lessonTitle",
	.recurrenceDays = @"recurrenceDays",
	.recurrenceId = @"recurrenceId",
	.recurrenceParam = @"recurrenceParam",
	.recurrenceType = @"recurrenceType",
	.serverObjectID = @"serverObjectID",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKLessonRelationships TKLessonRelationships = {
	.attachments = @"attachments",
	.attendances = @"attendances",
	.classroom = @"classroom",
};

const struct TKLessonFetchedProperties TKLessonFetchedProperties = {
};

@implementation TKLessonID
@end

@implementation _TKLesson

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Lesson" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Lesson";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Lesson" inManagedObjectContext:moc_];
}

- (TKLessonID*)objectID {
	return (TKLessonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isShadowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isShadow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lessonPeriodValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lessonPeriod"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"recurrenceDaysValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recurrenceDays"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"recurrenceTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recurrenceType"];
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






@dynamic lessonDescription;






@dynamic lessonEndTime;






@dynamic lessonId;






@dynamic lessonLocation;






@dynamic lessonPeriod;



- (int16_t)lessonPeriodValue {
	NSNumber *result = [self lessonPeriod];
	return [result shortValue];
}

- (void)setLessonPeriodValue:(int16_t)value_ {
	[self setLessonPeriod:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLessonPeriodValue {
	NSNumber *result = [self primitiveLessonPeriod];
	return [result shortValue];
}

- (void)setPrimitiveLessonPeriodValue:(int16_t)value_ {
	[self setPrimitiveLessonPeriod:[NSNumber numberWithShort:value_]];
}





@dynamic lessonStartDate;






@dynamic lessonStartTime;






@dynamic lessonTitle;






@dynamic recurrenceDays;



- (int16_t)recurrenceDaysValue {
	NSNumber *result = [self recurrenceDays];
	return [result shortValue];
}

- (void)setRecurrenceDaysValue:(int16_t)value_ {
	[self setRecurrenceDays:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRecurrenceDaysValue {
	NSNumber *result = [self primitiveRecurrenceDays];
	return [result shortValue];
}

- (void)setPrimitiveRecurrenceDaysValue:(int16_t)value_ {
	[self setPrimitiveRecurrenceDays:[NSNumber numberWithShort:value_]];
}





@dynamic recurrenceId;






@dynamic recurrenceParam;






@dynamic recurrenceType;



- (int16_t)recurrenceTypeValue {
	NSNumber *result = [self recurrenceType];
	return [result shortValue];
}

- (void)setRecurrenceTypeValue:(int16_t)value_ {
	[self setRecurrenceType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRecurrenceTypeValue {
	NSNumber *result = [self primitiveRecurrenceType];
	return [result shortValue];
}

- (void)setPrimitiveRecurrenceTypeValue:(int16_t)value_ {
	[self setPrimitiveRecurrenceType:[NSNumber numberWithShort:value_]];
}





@dynamic serverObjectID;






@dynamic tkID;






@dynamic updatedDate;






@dynamic attachments;

	
- (NSMutableSet*)attachmentsSet {
	[self willAccessValueForKey:@"attachments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"attachments"];
  
	[self didAccessValueForKey:@"attachments"];
	return result;
}
	

@dynamic attendances;

	
- (NSMutableSet*)attendancesSet {
	[self willAccessValueForKey:@"attendances"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"attendances"];
  
	[self didAccessValueForKey:@"attendances"];
	return result;
}
	

@dynamic classroom;

	






@end
