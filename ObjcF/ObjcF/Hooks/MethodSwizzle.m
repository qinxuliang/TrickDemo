//
//  MethodSwizzle.m
//  ObjcF
//
//  Created by hanling on 2022/8/22.
//

#import "MethodSwizzle.h"
#import <objc/message.h>

@implementation MethodSwizzle

+ (BOOL)swizzleClass:(Class)orgClass
         orgSelector:(SEL)orgSEL
           withClass:(Class)swizzlingClass
         andSelector:(SEL)swizzlingSEL{
    
    Method orgMethod = class_getClassMethod(orgClass, orgSEL);
    Method swizzlingMethod = class_getClassMethod(swizzlingClass, swizzlingSEL);
    if (!orgMethod || !swizzlingMethod) {
        return NO;
    }
    BOOL added = class_addMethod(orgClass, swizzlingSEL, method_getImplementation(orgMethod), method_getTypeEncoding(orgMethod));
    // 这里肯定是要成功的，否则就是存在同名的方法了，需要改名处理一下
    if (!added) {
        return NO;
    }
    added = class_addMethod(orgClass, orgSEL, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
    if (!added) {
        // 不成功，说明当前类已经有实现了原方法的，直接对调此方法和交换方法即可。
        method_exchangeImplementations(orgMethod, swizzlingMethod);
    }
    // 如果是成功的话，就是完成了向当前类添加原方法，实现指向交换方法的实现。
    // 配合前面addMethod的结果，当前类添加了交换方法，实现指向原方法的实现。
    return YES;
}

@end
