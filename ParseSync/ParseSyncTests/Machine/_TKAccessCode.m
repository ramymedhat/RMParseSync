// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TKAccessCode.m instead.

#import "_TKAccessCode.h"

const struct TKAccessCodeAttributes TKAccessCodeAttributes = {
	.accesscodeId = @"accesscodeId",
	.createdDate = @"createdDate",
	.lastModifiedDate = @"lastModifiedDate",
	.parentCode = @"parentCode",
	.parentRoleName = @"parentRoleName",
	.serverObjectID = @"serverObjectID",
	.studentCode = @"studentCode",
	.studentRoleName = @"studentRoleName",
	.tkID = @"tkID",
	.updatedDate = @"updatedDate",
};

const struct TKAccessCodeRelationships TKAccessCodeRelationships = {
	.student = @"student",
};

const struct TKAccessCodeFetchedProperties TKAccessCodeFetchedProperties = {
};

@implementation TKAccessCodeID
@end

@implementation _TKAccessCode

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AccessCode" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AccessCode";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AccessCode" inManagedObjectContext:moc_];
}

- (TKAccessCodeID*)objectID {
	return (TKAccessCodeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic accesscodeId;






@dynamic createdDate;






@dynamic lastModifiedDate;






@dynamic parentCode;






@dynamic parentRoleName;






@dynamic serverObjectID;






@dynamic studentCode;






@dynamic studentRoleName;






@dynamic tkID;






@dynamic updatedDate;






@dynamic student;

	






@end
