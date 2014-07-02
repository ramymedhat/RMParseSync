//
//  TKParseManagerDelegate.m
//  ParseSync
//
//  Created by Ahmed AlMoraly on 6/30/14.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import "TKParseManagerDelegate.h"
#import "TKStudent.h"
#import "TKAttendance.h"
#import "TKAttendanceType.h"
#import "TKBehavior.h"
#import "TKBehaviorType.h"
#import "TKGradeType.h"
#import "TKGradableItem.h"
#import "TKAccessCode.h"
#import "TKClassroom.h"
#import "TKLesson.h"
#import "TKGrade.h"

@implementation TKParseManagerDelegate

- (void)parseSyncManager:(TKParseServerSyncManager *)manager willUploadParseObject:(PFObject *)parseObject withServerObject:(TKServerObject *)serverObject {

    if ([serverObject.entityName isEqualToString:[TKAccessCode entityName]]) {
        // create a new PFRole for student and parent
        if (parseObject[@"parentRole"] == nil) {
            NSString *parentRoleName = serverObject.attributeValues[TKAccessCodeAttributes.parentRoleName];
            PFRole *parentRole = [PFRole roleWithName:parentRoleName];
            [parseObject setValue:parentRole forKey:@"parentRole"];
        }
        if (parseObject[@"studentRole"] == nil) {
            NSString *studentRoleName = serverObject.attributeValues[TKAccessCodeAttributes.studentRoleName];
            PFRole *studentRole = [PFRole roleWithName:studentRoleName];
            [parseObject setValue:studentRole forKey:@"studentRole"];
        }
    }
    else if ([serverObject.entityName isEqualToString:[TKStudent entityName]]) {
        
        [self setACLForParseObject:parseObject withStudentServerObject:serverObject];
    }
    
    // check for attendancetype/ behaviorType/GradeType/GradableItem
    else if ([serverObject.entityName isEqualToString:[TKAttendanceType entityName]]) {
        // check if it has attendances
        NSArray *attendances = serverObject.relatedObjects[TKAttendanceTypeRelationships.attendances];
        for (TKServerObject *attend in attendances) {
            TKAttendance *attendance = (TKAttendance *)[[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:attend.localObjectIDURL]];
            NSManagedObject *student = attendance.student;
            [self setACLForParseObject:parseObject withStudent:student];
        }
    }
    else if ([serverObject.entityName isEqualToString:[TKBehaviorType entityName]]) {
        // check if it has attendances
        NSArray *behaviors = serverObject.relatedObjects[TKBehaviorTypeRelationships.behaviors];
        for (TKServerObject *behavior in behaviors) {
            TKBehavior *behaviorObj = (TKBehavior *)[[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:behavior.localObjectIDURL]];
            NSManagedObject *student = behaviorObj.student;
            [self setACLForParseObject:parseObject withStudent:student];
        }
    }
    else if ([serverObject.entityName isEqualToString:[TKGradableItem entityName]]) {
        // search across the grades, get student, add
        NSArray *grades = serverObject.relatedObjects[TKGradableItemRelationships.grades];
        for (TKServerObject *grade in grades) {
            TKGrade *gradeObject = (TKGrade *)[[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:grade.localObjectIDURL]];
            NSManagedObject *student = gradeObject.student;
            [self setACLForParseObject:parseObject withStudent:student];
        }
    }
    else if ([serverObject.entityName isEqualToString:[TKLesson entityName]]) {
        // search across the grades, get student, add
        NSArray *attendances = serverObject.relatedObjects[TKLessonRelationships.attendances];
        for (TKServerObject *attendance in attendances) {
            TKAttendance *attendanceModel = (TKAttendance *)[[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:attendance.localObjectIDURL]];
            NSManagedObject *student = attendanceModel.student;
            [self setACLForParseObject:parseObject withStudent:student];
        }
    }
    
    else {
        // check for student related data
        
        // to-one relationship: "student"
        id studentVal = [serverObject.relatedObjects valueForKey:TKAccessCodeRelationships.student];
        if (!studentVal) {
            // to-many relationship: "students"
            studentVal = [serverObject.relatedObjects valueForKey:TKClassroomRelationships.students];
        }
        if (studentVal) {
            // has a student relation
            // get that student from db
            // check the AccessCodes table
            if ([studentVal isKindOfClass:[TKServerObject class]]) {
                // to-one relation
                [self setACLForParseObject:parseObject withStudentServerObject:studentVal];
            }
            else if ([studentVal isKindOfClass:[NSArray class]]) {
                // to-many relation
                NSArray *students = (NSArray *)studentVal;
                for (TKServerObject *studentServerObject in students) {
                    [self setACLForParseObject:parseObject withStudentServerObject:studentServerObject];
                }
            }
        }
    }

}

- (void)setACLForParseObject:(PFObject *)parseObject withStudentServerObject:(TKServerObject *)serverObject {
    
    NSManagedObject *studentManagedObject = [[TKDB defaultDB].syncContext objectWithURI:[NSURL URLWithString:serverObject.localObjectIDURL]];
    [self setACLForParseObject:parseObject withStudent:studentManagedObject];
}

- (void)setACLForParseObject:(PFObject *)parseObject withStudent:(NSManagedObject *)studentManagedObject {
    
    NSManagedObject *accessCode = [studentManagedObject valueForKey:@"accessCode"];
    
    NSString *parentRoleName = [accessCode valueForKey:@"parentRoleName"];
    if (parentRoleName) {
        [parseObject.ACL setReadAccess:YES forRoleWithName:parentRoleName];
    }
    
    NSString *studentRoleName = [accessCode valueForKey:@"studentRoleName"];
    if (studentRoleName) {
        [parseObject.ACL setReadAccess:YES forRoleWithName:studentRoleName];
    }
}

@end
