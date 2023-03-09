//
//  NSObject+GJClass.m
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import "NSObject+GJClass.h"
#import "NSObject+GJCoding.h"
#import "NSObject+GJKeyValue.h"
#import "GJFoundation.h"
#import <objc/runtime.h>

static const char GJAllowedPropertyNamesKey = '\0';
static const char GJIgnoredPropertyNamesKey = '\0';
static const char GJAllowedCodingPropertyNamesKey = '\0';
static const char GJIgnoredCodingPropertyNamesKey = '\0';

@implementation NSObject (GJClass)

+ (NSMutableDictionary *)gj_classDictForKey:(const void *)key
{
    static NSMutableDictionary *allowedPropertyNamesDict;
    static NSMutableDictionary *ignoredPropertyNamesDict;
    static NSMutableDictionary *allowedCodingPropertyNamesDict;
    static NSMutableDictionary *ignoredCodingPropertyNamesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allowedPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredPropertyNamesDict = [NSMutableDictionary dictionary];
        allowedCodingPropertyNamesDict = [NSMutableDictionary dictionary];
        ignoredCodingPropertyNamesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &GJAllowedPropertyNamesKey) return allowedPropertyNamesDict;
    if (key == &GJIgnoredPropertyNamesKey) return ignoredPropertyNamesDict;
    if (key == &GJAllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict;
    if (key == &GJIgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict;
    return nil;
}

+ (void)gj_enumerateClasses:(GJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if ([GJFoundation isClassFromFoundation:c]) break;
    }
}

+ (void)gj_enumerateAllClasses:(GJClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

#pragma mark - 属性黑名单配置
+ (void)gj_setupIgnoredPropertyNames:(GJIgnoredPropertyNames)ignoredPropertyNames
{
    [self gj_setupBlockReturnValue:ignoredPropertyNames key:&GJIgnoredPropertyNamesKey];
}

+ (NSMutableArray *)gj_totalIgnoredPropertyNames
{
    return [self gj_totalObjectsWithSelector:@selector(gj_ignoredPropertyNames) key:&GJIgnoredPropertyNamesKey];
}

#pragma mark - 归档属性黑名单配置
+ (void)gj_setupIgnoredCodingPropertyNames:(GJIgnoredCodingPropertyNames)ignoredCodingPropertyNames
{
    [self gj_setupBlockReturnValue:ignoredCodingPropertyNames key:&GJIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)gj_totalIgnoredCodingPropertyNames
{
    return [self gj_totalObjectsWithSelector:@selector(gj_ignoredCodingPropertyNames) key:&GJIgnoredCodingPropertyNamesKey];
}

#pragma mark - 属性白名单配置
+ (void)gj_setupAllowedPropertyNames:(GJAllowedPropertyNames)allowedPropertyNames;
{
    [self gj_setupBlockReturnValue:allowedPropertyNames key:&GJAllowedPropertyNamesKey];
}

+ (NSMutableArray *)gj_totalAllowedPropertyNames
{
    return [self gj_totalObjectsWithSelector:@selector(gj_allowedPropertyNames) key:&GJAllowedPropertyNamesKey];
}

#pragma mark - 归档属性白名单配置
+ (void)gj_setupAllowedCodingPropertyNames:(GJAllowedCodingPropertyNames)allowedCodingPropertyNames
{
    [self gj_setupBlockReturnValue:allowedCodingPropertyNames key:&GJAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)gj_totalAllowedCodingPropertyNames
{
    return [self gj_totalObjectsWithSelector:@selector(gj_allowedCodingPropertyNames) key:&GJAllowedCodingPropertyNamesKey];
}

#pragma mark - block和方法处理:存储block的返回值
+ (void)gj_setupBlockReturnValue:(id (^)(void))block key:(const char *)key {
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    if (block) {
        objc_setAssociatedObject(self, key, block(), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 清空数据
    [[self gj_classDictForKey:key] removeAllObjects];
    GJ_UNLOCK(gju_signalSemaphore);
}

+ (NSMutableArray *)gj_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    NSMutableArray *array = [self gj_classDictForKey:key][NSStringFromClass(self)];
    if (array == nil) {
        // 创建、存储
        [self gj_classDictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
            if (subArray) {
                [array addObjectsFromArray:subArray];
            }
        }
        
        [self gj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSArray *subArray = objc_getAssociatedObject(c, key);
            [array addObjectsFromArray:subArray];
        }];
    }
    GJ_UNLOCK(gju_signalSemaphore);
    return array;
}
@end
