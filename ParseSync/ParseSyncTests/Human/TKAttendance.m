#import "TKAttendance.h"
#import "TKLesson.h"
#import "TKStudent.h"

@interface TKAttendance ()

// Private interface goes here.

@end


@implementation TKAttendance


- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"tkID"] && self.lesson && self.student) {
        if (!self.lesson.tkID) {
            self.lesson.tkID = [[NSUUID UUID] UUIDString];
        }
        if (!self.student.tkID) {
            self.student.tkID = [[NSUUID UUID] UUIDString];
        }
        NSString *lessonUniqueID = [self.lesson.tkID stringByAppendingString:self.student.tkID];
        value = lessonUniqueID;
    }
    [super setValue:value forKey:key];
}

@end
