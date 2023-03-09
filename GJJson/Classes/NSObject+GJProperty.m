//
//  NSObject+GJProperty.m
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import "NSObject+GJProperty.h"
#import "NSObject+GJKeyValue.h"
#import "NSObject+GJCoding.h"
#import "NSObject+GJClass.h"
#import "GJProperty.h"
#import "GJFoundation.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

static const char GJReplacedKeyFromPropertyNameKey = '\0';
static const char GJReplacedKeyFromPropertyName121Key = '\0';
static const char GJNewValueFromOldValueKey = '\0';
static const char GJObjectClassInArrayKey = '\0';

static const char GJCachedPropertiesKey = '\0';

dispatch_semaphore_t gju_signalSemaphore;
dispatch_once_t gju_onceTokenSemaphore;

@implementation NSObject (Property)

+ (NSMutableDictionary *)gj_propertyDictForKey:(const void *)key
{
    static NSMutableDictionary *replacedKeyFromPropertyNameDict;
    static NSMutableDictionary *replacedKeyFromPropertyName121Dict;
    static NSMutableDictionary *newValueFromOldValueDict;
    static NSMutableDictionary *objectClassInArrayDict;
    static NSMutableDictionary *cachedPropertiesDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacedKeyFromPropertyNameDict = [NSMutableDictionary dictionary];
        replacedKeyFromPropertyName121Dict = [NSMutableDictionary dictionary];
        newValueFromOldValueDict = [NSMutableDictionary dictionary];
        objectClassInArrayDict = [NSMutableDictionary dictionary];
        cachedPropertiesDict = [NSMutableDictionary dictionary];
    });
    
    if (key == &GJReplacedKeyFromPropertyNameKey) return replacedKeyFromPropertyNameDict;
    if (key == &GJReplacedKeyFromPropertyName121Key) return replacedKeyFromPropertyName121Dict;
    if (key == &GJNewValueFromOldValueKey) return newValueFromOldValueDict;
    if (key == &GJObjectClassInArrayKey) return objectClassInArrayDict;
    if (key == &GJCachedPropertiesKey) return cachedPropertiesDict;
    return nil;
}

#pragma mark - --私有方法--
+ (id)gj_propertyKey:(NSString *)propertyName
{
    GJJsonAssertParamNotNil2(propertyName, nil);
    
    __block id key = nil;
    // 查看有没有需要替换的key
    if ([self respondsToSelector:@selector(gj_replacedKeyFromPropertyName121:)]) {
        key = [self gj_replacedKeyFromPropertyName121:propertyName];
    }
    
    // 调用block
    if (!key) {
        [self gj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            GJReplacedKeyFromPropertyName121 block = objc_getAssociatedObject(c, &GJReplacedKeyFromPropertyName121Key);
            if (block) {
                key = block(propertyName);
            }
            if (key) *stop = YES;
        }];
    }
    
    // 查看有没有需要替换的key
    if ((!key || [key isEqual:propertyName]) && [self respondsToSelector:@selector(gj_replacedKeyFromPropertyName)]) {
        key = [self gj_replacedKeyFromPropertyName][propertyName];
    }
    
    if (!key || [key isEqual:propertyName]) {
        [self gj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &GJReplacedKeyFromPropertyNameKey);
            if (dict) {
                key = dict[propertyName];
            }
            if (key && ![key isEqual:propertyName]) *stop = YES;
        }];
    }
    
    // 2.用属性名作为key
    if (!key) key = propertyName;
    
    return key;
}

+ (Class)gj_propertyObjectClassInArray:(NSString *)propertyName
{
    __block id clazz = nil;
    if ([self respondsToSelector:@selector(gj_objectClassInArray)]) {
        clazz = [self gj_objectClassInArray][propertyName];
    }
    
    if (!clazz) {
        [self gj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &GJObjectClassInArrayKey);
            if (dict) {
                clazz = dict[propertyName];
            }
            if (clazz) *stop = YES;
        }];
    }
    
    // 如果是NSString类型
    if ([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    return clazz;
}

#pragma mark - --公共方法--
+ (void)gj_enumerateProperties:(GJPropertiesEnumeration)enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self gj_properties];
    // 遍历成员变量
    BOOL stop = NO;
    for (GJProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}

#pragma mark - 公共方法
+ (NSArray *)gj_properties
{
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    NSMutableDictionary *cachedInfo = [self gj_propertyDictForKey:&GJCachedPropertiesKey];
    NSMutableArray *cachedProperties = cachedInfo[NSStringFromClass(self)];
    if (cachedProperties == nil) {
        cachedProperties = [NSMutableArray array];
        
        [self gj_enumerateClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            // 1.获得所有的成员变量
            unsigned int outCount = 0;
            objc_property_t *properties = class_copyPropertyList(c, &outCount);
            
            // 2.遍历每一个成员变量
            for (unsigned int i = 0; i<outCount; i++) {
                GJProperty *property = [GJProperty cachedPropertyWithProperty:properties[i]];
                // 过滤掉Foundation框架类里面的属性
                if ([GJFoundation isClassFromFoundation:property.srcClass]) continue;
                // 过滤掉`hash`, `superclass`, `description`, `debugDescription`
                if ([GJFoundation isFromNSObjectProtocolProperty:property.name]) continue;
                
                property.srcClass = c;
                [property setOriginKey:[self gj_propertyKey:property.name] forClass:self];
                [property setObjectClassInArray:[self gj_propertyObjectClassInArray:property.name] forClass:self];
                [cachedProperties addObject:property];
            }
            
            // 3.释放内存
            free(properties);
        }];
        
        cachedInfo[NSStringFromClass(self)] = cachedProperties;
    }
    NSArray *properties = [cachedProperties copy];
    GJ_UNLOCK(gju_signalSemaphore);
    
    return properties;
}

#pragma mark - 新值配置
+ (void)gj_setupNewValueFromOldValue:(GJNewValueFromOldValue)newValueFormOldValue {
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    objc_setAssociatedObject(self, &GJNewValueFromOldValueKey, newValueFormOldValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    GJ_UNLOCK(gju_signalSemaphore);
}

+ (id)gj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(GJProperty *__unsafe_unretained)property{
    // 如果有实现方法
    if ([object respondsToSelector:@selector(gj_newValueFromOldValue:property:)]) {
        return [object gj_newValueFromOldValue:oldValue property:property];
    }
    
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    // 查看静态设置
    __block id newValue = oldValue;
    [self gj_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        GJNewValueFromOldValue block = objc_getAssociatedObject(c, &GJNewValueFromOldValueKey);
        if (block) {
            newValue = block(object, oldValue, property);
            *stop = YES;
        }
    }];
    GJ_UNLOCK(gju_signalSemaphore);
    return newValue;
}

+ (void)gj_removeCachedProperties {
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    [[self gj_propertyDictForKey:&GJCachedPropertiesKey] removeAllObjects];
    GJ_UNLOCK(gju_signalSemaphore);
}

#pragma mark - array model class配置
+ (void)gj_setupObjectClassInArray:(GJObjectClassInArray)objectClassInArray
{
    [self gj_setupBlockReturnValue:objectClassInArray key:&GJObjectClassInArrayKey];
    
    [self gj_removeCachedProperties];
}

#pragma mark - key配置

+ (void)gj_setupReplacedKeyFromPropertyName:(GJReplacedKeyFromPropertyName)replacedKeyFromPropertyName {
    [self gj_setupBlockReturnValue:replacedKeyFromPropertyName key:&GJReplacedKeyFromPropertyNameKey];
    
    [self gj_removeCachedProperties];
}

+ (void)gj_setupReplacedKeyFromPropertyName121:(GJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121 {
    GJJsonSemaphoreCreate
    GJ_LOCK(gju_signalSemaphore);
    objc_setAssociatedObject(self, &GJReplacedKeyFromPropertyName121Key, replacedKeyFromPropertyName121, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[self gj_propertyDictForKey:&GJCachedPropertiesKey] removeAllObjects];
    GJ_UNLOCK(gju_signalSemaphore);
}
@end
#pragma clang diagnostic pop
