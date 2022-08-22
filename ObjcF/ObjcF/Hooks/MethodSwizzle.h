//
//  MethodSwizzle.h
//  ObjcF
//
//  Created by hanling on 2022/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodSwizzle : NSObject

+ (BOOL)swizzleClass:(Class)orgClass
         orgSelector:(SEL)orgSEL
           withClass:(Class)swizzlingClass
         andSelector:(SEL)swizzlingSEL;

@end

NS_ASSUME_NONNULL_END
