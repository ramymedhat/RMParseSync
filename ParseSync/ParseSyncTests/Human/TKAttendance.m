#import "TKAttendance.h"


@interface TKAttendance ()

// Private interface goes here.

@end


@implementation TKAttendance

// Custom logic goes here.

+ (NSOrderedSet *)primaryKeyFields {
    return [NSOrderedSet orderedSetWithObjects:TKAttendanceRelationships.lesson, TKAttendanceRelationships.student, nil];
}

- (NSOrderedSet *)primaryKeys {
    return [NSOrderedSet orderedSetWithObjects:self.lesson, self.student, nil];
}

@end
