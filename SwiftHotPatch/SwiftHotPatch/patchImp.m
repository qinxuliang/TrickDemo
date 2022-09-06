//
//  patchImp.m
//  SwiftHotPatch
//
//  Created by hanling on 2022/8/22.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <dlfcn.h>

static JSContext *jsContext = nil;
static JSValue *jsFunction = nil;


void patched(void) {
    [jsFunction callWithArguments:nil];
}

void patch_init(void) {
    jsContext = [[JSContext alloc] init];
    jsContext[@"log"] = ^(NSString *message) {
        NSLog(@"%@", message);
    };
    
    jsContext[@"patch"] = ^(NSString *className, NSString *methodName, JSValue *func) {
        void *class = (__bridge void *)objc_getClass(className.UTF8String);
       
        Class cls = objc_getClass(className.UTF8String);
        
        unsigned int outCount = 0;
        objc_property_t *properties  =class_copyPropertyList(cls, &outCount);
        NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:outCount];
        for (int i = 0; i<outCount; i++){
            // objc_property_t 属性类型
            objc_property_t property = properties[i];
            // 获取属性的名称 C语言字符串
            const char *cName = property_getName(property);
            // 转换为Objective C 字符串
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            [propertiesArray addObject:name];
            NSLog(@"属性: %@",name);
        }
        
        unsigned int count = 0;
       
        Method *methodList = class_copyMethodList(cls, &count);
        for (int i = 0; i<count; i++) {
            Method method = methodList[i];
            SEL sel = method_getName(method);
            IMP imp = class_getMethodImplementation(cls, sel);
            NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
        }
        
        void *raw_method_address = dlsym(RTLD_DEFAULT, methodName.UTF8String);
        if (!class || !raw_method_address) {
            NSLog(@"class or method note found!");
            return;
        }
        long offset = 0;
        for (long i=0; i<1024; i++) {
            if (*(long *)(class+i) == (long)raw_method_address) {
                offset = i;
                break;
            }
        }
        if (!offset) return;
        jsFunction = func;
        *(void **)(class+offset) = &patched;
    };
    
    jsContext[@"call"] = ^(NSString *className,NSString *methodName){
        void *class = (__bridge void *)objc_getClass(className.UTF8String);
//        void (*raw_method_address)(void) = dlsym(RTLD_DEFAULT, methodName.UTF8String);
//        if (raw_method_address) {
//            raw_method_address();
//        }
    };
    
    [jsContext evaluateScript:@"\
         function callback(){\
            log('patched hehe1');\
            log('calling raw method:');\
            call('SwiftHotPatch.TestClass','hehe1');\
         }\
         patch('SwiftHotPatch.TestClass', 'hehe1', callback);\
     "];
}

#pragma mark - 遍历某个对象的成员变量
//- (void)printClassAllProperties:(Class)cls{
//    NSLog(@"*********************");
//    unsigned int outCount = 0;
//    objc_property_t *properties  =class_copyPropertyList(cls, &outCount);
//    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:outCount];
//    for (int i = 0; i<outCount; i++){
//        // objc_property_t 属性类型
//        objc_property_t property = properties[i];
//        // 获取属性的名称 C语言字符串
//        const char *cName = property_getName(property);
//        // 转换为Objective C 字符串
//        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
//        [propertiesArray addObject:name];
//        NSLog(@"属性: %@",name);
//    }
//
//    free(properties);
//}

#pragma mark - 遍历某个类的方法
//void printClassAllMethod(cls:Class){
//    NSLog(@"*********************");
//    unsigned int count = 0;
//    Method *methodList = class_copyMethodList(cls, &count);
//    for (int i = 0; i<count; i++) {
//        Method method = methodList[i];
//        SEL sel = method_getName(method);
//        IMP imp = class_getMethodImplementation(cls, sel);
//        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
//    }
//    free(methodList);
//}
