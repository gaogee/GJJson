//
//  NSObject+GJProperty.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import "GJJsonConst.h"
NS_ASSUME_NONNULL_BEGIN


@class GJProperty;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^GJPropertiesEnumeration)(GJProperty *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * _Nullable (^GJReplacedKeyFromPropertyName)(void);
typedef id _Nullable (^GJReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * _Nullable (^GJObjectClassInArray)(void);
/** 用于过滤字典中的值 */
typedef id _Nullable (^GJNewValueFromOldValue)(id object, id oldValue, GJProperty *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (GJProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)gj_enumerateProperties:(GJPropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)gj_setupNewValueFromOldValue:(GJNewValueFromOldValue)newValueFormOldValue;
+ (id)gj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained GJProperty *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)gj_setupReplacedKeyFromPropertyName:(GJReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)gj_setupReplacedKeyFromPropertyName121:(GJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)gj_setupObjectClassInArray:(GJObjectClassInArray)objectClassInArray;
@end

NS_ASSUME_NONNULL_END
