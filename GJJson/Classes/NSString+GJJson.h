//
//  NSString+GJJson.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import "GJJsonConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSString (GJJson)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)gj_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)gj_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)gj_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)gj_firstCharLower;

- (BOOL)gj_isPureInt;

- (NSURL *)gj_url;
@end

NS_ASSUME_NONNULL_END
