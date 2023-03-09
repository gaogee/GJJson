//
//  NSObject+GJClass.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  遍历所有类的block（父类）
 */
typedef void (^GJClassesEnumeration)(Class c, BOOL *stop);

/** 这个数组中的属性名才会进行字典和模型的转换 */
typedef NSArray * _Nullable (^GJAllowedPropertyNames)(void);
/** 这个数组中的属性名才会进行归档 */
typedef NSArray * _Nullable (^GJAllowedCodingPropertyNames)(void);

/** 这个数组中的属性名将会被忽略：不进行字典和模型的转换 */
typedef NSArray * _Nullable (^GJIgnoredPropertyNames)(void);
/** 这个数组中的属性名将会被忽略：不进行归档 */
typedef NSArray * _Nullable (^GJIgnoredCodingPropertyNames)(void);

/**
 * 类相关的扩展
 */
@interface NSObject (GJClass)
/**
 *  遍历所有的类
 */
+ (void)gj_enumerateClasses:(GJClassesEnumeration)enumeration;
+ (void)gj_enumerateAllClasses:(GJClassesEnumeration)enumeration;

#pragma mark - 属性白名单配置
/**
 *  这个数组中的属性名才会进行字典和模型的转换
 *
 *  @param allowedPropertyNames          这个数组中的属性名才会进行字典和模型的转换
 */
+ (void)gj_setupAllowedPropertyNames:(GJAllowedPropertyNames)allowedPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)gj_totalAllowedPropertyNames;

#pragma mark - 属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 *
 *  @param ignoredPropertyNames          这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (void)gj_setupIgnoredPropertyNames:(GJIgnoredPropertyNames)ignoredPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSMutableArray *)gj_totalIgnoredPropertyNames;

#pragma mark - 归档属性白名单配置
/**
 *  这个数组中的属性名才会进行归档
 *
 *  @param allowedCodingPropertyNames          这个数组中的属性名才会进行归档
 */
+ (void)gj_setupAllowedCodingPropertyNames:(GJAllowedCodingPropertyNames)allowedCodingPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)gj_totalAllowedCodingPropertyNames;

#pragma mark - 归档属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 *
 *  @param ignoredCodingPropertyNames          这个数组中的属性名将会被忽略：不进行归档
 */
+ (void)gj_setupIgnoredCodingPropertyNames:(GJIgnoredCodingPropertyNames)ignoredCodingPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSMutableArray *)gj_totalIgnoredCodingPropertyNames;

#pragma mark - 内部使用
+ (void)gj_setupBlockReturnValue:(id (^)(void))block key:(const char *)key;
@end

NS_ASSUME_NONNULL_END
