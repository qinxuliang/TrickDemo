//
//  ViewController.m
//  ObjcF
//
//  Created by hanling on 2022/8/22.
//

#import "ViewController.h"
#import "ClassInitHook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ClassInitHook test];
    // Do any additional setup after loading the view.
}


@end
