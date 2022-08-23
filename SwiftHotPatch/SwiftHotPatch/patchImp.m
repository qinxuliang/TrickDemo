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
    
    jsContext[@"call"] = ^(NSString *methodName){
        void (*raw_method_address)(void) = dlsym(RTLD_DEFAULT, methodName.UTF8String);
        if (raw_method_address) {
            raw_method_address();
        }
    };
    
    [jsContext evaluateScript:@"\
         function callback(){\
            log('patched hehe1');\
            log('calling raw method:');\
            call('s13SwiftHotPatch9TestClassC5hehe1yyF');\
         }\
         patch('SwiftHotPatch.TestClass', 's13SwiftHotPatch9TestClassC5hehe1yyF', callback);\
     "];
}
