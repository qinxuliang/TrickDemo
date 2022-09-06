//
//  ViewController.m
//  ObjcF
//
//  Created by hanling on 2022/8/22.
//

#import "ViewController.h"
#import "ClassInitHook.h"
#import <mach-o/dyld.h>
#import "ViewController1.h"
#import "GetUserDefineClass.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)load{
    
    uint32_t numberOfImages = _dyld_image_count();
    for (int i = 0; i < numberOfImages; i++) {
        const char *imageName = _dyld_get_image_name(i);
//        if (strstr(imageName, binary_Name) != NULL) {
            
//        printf("%s", imageName);
//            _macho_start(imageName, binary_Name, sandbox_path, i, completion);
//        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController1 *vc1 = [[ViewController1 alloc] init];
    [self.view addSubview:vc1.view];
    
//    [GetUserDefineClass getUserDefineClass];
//    [ClassInitHook test];
    // Do any additional setup after loading the view.
}


@end
