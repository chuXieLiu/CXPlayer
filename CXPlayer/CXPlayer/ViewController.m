//
//  ViewController.m
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "ViewController.h"
#import "CXPlayerController.h"
#import "VideoViewController.h"



@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self presentViewController:[VideoViewController new] animated:YES completion:nil];
}


- (void)dealloc
{
    
}













@end
