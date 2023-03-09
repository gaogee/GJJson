//
//  GJPropertyKey.h
//  GJJson
//
//  Created by gaogee on 2023/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    GJPropertyKeyTypeDictionary = 0, // 字典的key
    GJPropertyKeyTypeArray // 数组的key
} GJPropertyKeyType;

/**
 *  属性的key
 */
@interface GJPropertyKey : NSObject
/** key的名字 */
@property (copy,   nonatomic) NSString *name;
/** key的种类，可能是@"10"，可能是@"age" */
@property (assign, nonatomic) GJPropertyKeyType type;

/**
 *  根据当前的key，也就是name，从object（字典或者数组）中取值
 */
- (id)valueInObject:(id)object;
@end

NS_ASSUME_NONNULL_END
