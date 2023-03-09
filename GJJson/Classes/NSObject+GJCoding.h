//
//  NSObject+GJCoding.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import "GJJsonConst.h"
NS_ASSUME_NONNULL_BEGIN


/**
 *  Codeing协议
 */
@protocol GJCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)gj_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)gj_ignoredCodingPropertyNames;
@end

@interface NSObject (GJCoding)
/**
 *  解码（从文件中解析对象）
 */
- (void)gj_decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)gj_encode:(NSCoder *)encoder;
@end
NS_ASSUME_NONNULL_END
/**
 归档的实现
 */
#define GJCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self gj_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self gj_encode:encoder]; \
}\

#define GJJsonCodingImplementation GJCodingImplementation

#define GJSecureCodingImplementation(CLASS, FLAG) \
@interface CLASS (GJSecureCoding) <NSSecureCoding> \
@end \
@implementation CLASS (GJSecureCoding) \
GJCodingImplementation \
+ (BOOL)supportsSecureCoding { \
return FLAG; \
} \
@end \


