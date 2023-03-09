//
//  NSObject+GJCoding.m
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import "NSObject+GJCoding.h"
#import "NSObject+GJClass.h"
#import "NSObject+GJProperty.h"
#import "GJProperty.h"

@implementation NSObject (GJCoding)

- (void)gj_encode:(NSCoder *)encoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz gj_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz gj_totalIgnoredCodingPropertyNames];
    
    [clazz gj_enumerateProperties:^(GJProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        [encoder encodeObject:value forKey:property.name];
    }];
}

- (void)gj_decode:(NSCoder *)decoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz gj_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz gj_totalIgnoredCodingPropertyNames];
    
    [clazz gj_enumerateProperties:^(GJProperty *property, BOOL *stop) {
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        // fixed `-[NSKeyedUnarchiver validateAllowedClass:forKey:] allowed unarchiving safe plist type ''NSNumber'(This will be disallowed in the future.)` warning.
        Class genericClass = [property objectClassInArrayForClass:property.srcClass];
        // If genericClass exists, property.type.typeClass would be a collection type(Array, Set, Dictionary). This scenario([obj, nil, obj, nil]) would not happened.
        NSSet *classes = [NSSet setWithObjects:NSNumber.class,
                          property.type.typeClass, genericClass, nil];
        id value = [decoder decodeObjectOfClasses:classes forKey:property.name];
        if (value == nil) { // 兼容以前的GJJson版本
            value = [decoder decodeObjectForKey:[@"_" stringByAppendingString:property.name]];
        }
        if (value == nil) return;
        [property setValue:value forObject:self];
    }];
}
@end
