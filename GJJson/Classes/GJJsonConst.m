//
//  GJJsonConst.m
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//
#ifndef __GJJsonConst__M__
#define __GJJsonConst__M__

#import <Foundation/Foundation.h>

/**
 *  成员变量类型（属性类型）
 */
NSString *const GJPropertyTypeInt = @"i";
NSString *const GJPropertyTypeShort = @"s";
NSString *const GJPropertyTypeFloat = @"f";
NSString *const GJPropertyTypeDouble = @"d";
NSString *const GJPropertyTypeLong = @"l";
NSString *const GJPropertyTypeLongLong = @"q";
NSString *const GJPropertyTypeChar = @"c";
NSString *const GJPropertyTypeBOOL1 = @"c";
NSString *const GJPropertyTypeBOOL2 = @"b";
NSString *const GJPropertyTypePointer = @"*";

NSString *const GJPropertyTypeIvar = @"^{objc_ivar=}";
NSString *const GJPropertyTypeMethod = @"^{objc_method=}";
NSString *const GJPropertyTypeBlock = @"@?";
NSString *const GJPropertyTypeClass = @"#";
NSString *const GJPropertyTypeSEL = @":";
NSString *const GJPropertyTypeId = @"@";

#endif
