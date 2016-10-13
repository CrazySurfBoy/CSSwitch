//
//  ViewController.m
//  CSSwitch
//
//  Created by SurfBoy on 13/10/2016.
//  Copyright © 2016 CrazySurfboy. All rights reserved.
//

#import "ViewController.h"
#import "CSSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Init
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo";
    
    // 创建
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CSSwitch *csSwitch = [[CSSwitch alloc] init];
    csSwitch.center = CGPointMake(screenFrame.size.width - 140, 37);
    [self.view addSubview:csSwitch];
    
    csSwitch.switchStateChangedBlock = ^(CSSwitchState switchState) {
        
        NSLog(@"CSSwitchState:%ld", switchState);
    };
}





@end
