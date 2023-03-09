//
//  GJPropertyType.m
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import "GJPropertyType.h"
#import "GJJson.h"
#import "GJFoundation.h"
#import "GJJsonConst.h"

@implementation GJPropertyType

+ (instancetype)cachedTypeWithCode:(NSString *)code
{
    GJJsonAssertParamNotNil2(code, nil);
    
    static NSMutableDictionary *types;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        types = [NSMutableDictionary dictionary];
    });
    
    GJPropertyType *type = types[code];
    if (type == nil) {
        type = [[self alloc] init];
        type.code = code;
        types[code] = type;
    }
    return type;
}

#pragma mark - 公共方法
- (void)setCode:(NSString *)code
{
    _code = code;
    
    GJJsonAssertParamNotNil(code);
    
    if ([code isEqualToString:GJPropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [GJFoundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:GJPropertyTypeSEL] ||
               [code isEqualToString:GJPropertyTypeIvar] ||
               [code isEqualToString:GJPropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    
    // 是否为数字类型
    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[GJPropertyTypeInt, GJPropertyTypeShort, GJPropertyTypeBOOL1, GJPropertyTypeBOOL2, GJPropertyTypeFloat, GJPropertyTypeDouble, GJPropertyTypeLong, GJPropertyTypeLongLong, GJPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:GJPropertyTypeBOOL1]
            || [lowerCode isEqualToString:GJPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end
