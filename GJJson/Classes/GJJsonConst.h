//
//  GJJsonConst.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#ifndef __GJJsonConst__H__
#define __GJJsonConst__H__

#import <Foundation/Foundation.h>

#ifndef GJ_LOCK
#define GJ_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef GJ_UNLOCK
#define GJ_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

// 信号量
#define GJJsonSemaphoreCreate \
extern dispatch_semaphore_t gju_signalSemaphore; \
extern dispatch_once_t gju_onceTokenSemaphore; \
dispatch_once(&gju_onceTokenSemaphore, ^{ \
    gju_signalSemaphore = dispatch_semaphore_create(1); \
});

// 过期
#define GJJsonDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define GJJsonBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setGj_error:error];

// 日志输出
#ifdef DEBUG
#define GJJsonLog(...) NSLog(__VA_ARGS__)
#else
#define GJJsonLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define GJJsonAssertError(condition, returnValue, clazz, msg) \
[clazz setGj_error:nil]; \
if ((condition) == NO) { \
    GJJsonBuildError(clazz, msg); \
    return returnValue;\
}

#define GJJsonAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define GJJsonAssert(condition) GJJsonAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define GJJsonAssertParamNotNil2(param, returnValue) \
GJJsonAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define GJJsonAssertParamNotNil(param) GJJsonAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define GJLogAllIvars \
- (NSString *)description \
{ \
    return [self gj_keyValues].description; \
}
#define GJJsonLogAllProperties GJLogAllIvars

/** 仅在 Debugger 展示所有的属性 */
#define GJImplementDebugDescription \
- (NSString *)debugDescription \
{ \
return [self gj_keyValues].debugDescription; \
}

/**
 *  类型（属性类型）
 */
FOUNDATION_EXPORT NSString *const GJPropertyTypeInt;
FOUNDATION_EXPORT NSString *const GJPropertyTypeShort;
FOUNDATION_EXPORT NSString *const GJPropertyTypeFloat;
FOUNDATION_EXPORT NSString *const GJPropertyTypeDouble;
FOUNDATION_EXPORT NSString *const GJPropertyTypeLong;
FOUNDATION_EXPORT NSString *const GJPropertyTypeLongLong;
FOUNDATION_EXPORT NSString *const GJPropertyTypeChar;
FOUNDATION_EXPORT NSString *const GJPropertyTypeBOOL1;
FOUNDATION_EXPORT NSString *const GJPropertyTypeBOOL2;
FOUNDATION_EXPORT NSString *const GJPropertyTypePointer;

FOUNDATION_EXPORT NSString *const GJPropertyTypeIvar;
FOUNDATION_EXPORT NSString *const GJPropertyTypeMethod;
FOUNDATION_EXPORT NSString *const GJPropertyTypeBlock;
FOUNDATION_EXPORT NSString *const GJPropertyTypeClass;
FOUNDATION_EXPORT NSString *const GJPropertyTypeSEL;
FOUNDATION_EXPORT NSString *const GJPropertyTypeId;

#endif
