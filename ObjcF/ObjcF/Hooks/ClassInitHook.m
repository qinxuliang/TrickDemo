//
//  ClassInitHook.m
//  ObjcF
//
//  Created by hanling on 2022/8/22.
//

#import "ClassInitHook.h"
#import "MethodSwizzle.h"
#import <objc/message.h>

/// 需求描述 : 把某个类 B的实现全部替换为其子类C (C可以是B的子类或者A的子类) ，父类A的实现不改变

@interface A : NSObject

- (void)hello;

@property (nonatomic,weak) A *owner;

@end

@implementation A

- (instancetype)init{
    if (self = [super init]) {
        self.owner = self;
    }
    return self;
}

- (void)hello{
    
    NSLog(@"my class is %@, my owner is%@", self.class,self.owner);
    
}
@end

@interface B : A

@end

@implementation B

@end

@interface C : A

@end

@implementation C

@end


@interface B (x)

@end

@implementation B (x)

+(instancetype)alloc{
    //方法1 通过对A实现一个category 在alloc里面通过方法转发直接替换为子类B
    Method m = class_getClassMethod([NSObject class], @selector(alloc));
    IMP i = method_getImplementation(m);
    return ((id(*)(id, SEL))i)([C class], @selector(alloc));
}

@end

@implementation ClassInitHook


+(void)test{
    A *a = [[A alloc] init];
    [a hello];
    
    B *b = [[B alloc] init];
    [b hello];
}

@end


