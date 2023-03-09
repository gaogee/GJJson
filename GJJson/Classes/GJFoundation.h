//
//  GJFoundation.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJFoundation : NSObject
+ (BOOL)isClassFromFoundation:(Class)c;
+ (BOOL)isFromNSObjectProtocolProperty:(NSString *)propertyName;
@end

NS_ASSUME_NONNULL_END
