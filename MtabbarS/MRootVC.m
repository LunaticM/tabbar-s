//
//  MRootVC.m
//  MTabbarS
//
//  Created by lunaticM on 14-5-28.
//  Copyright (c) 2014年 lunaticM. All rights reserved.
//

#import "MRootVC.h"

#import "CustomTabBar.h"

#import "FirstVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"
#import "FourthVC.h"
@interface MRootVC ()<CustomTabBarViewDelegate,UIAlertViewDelegate>

@end

@implementation MRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     FirstVC *first = [[FirstVC alloc] init];
     SecondVC *second = [[SecondVC alloc] init];
     ThirdVC *third = [[ThirdVC alloc] init];
     FourthVC *fourth = [[FourthVC alloc] init];
    
    UIViewController *firstNav = [[UINavigationController alloc]initWithRootViewController:first];
    UIViewController *secondNav = [[UINavigationController alloc]initWithRootViewController:second];
    UIViewController *thirdNav = [[UINavigationController alloc]initWithRootViewController:third];
//    UIViewController *fourthtNav = [[UINavigationController alloc]initWithRootViewController:fourth];
    
    NSArray* tabBarItems = [NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"第一个",@"title",
                             @"nevbar_01", @"image",
                             @"nevbar_01_a",@"selectedImage",
                             firstNav, @"view",
                             nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"第二个",@"title",
                             @"nevbar_02", @"image",
                             @"nevbar_02_a",@"selectedImage",
                             secondNav, @"view",
                             nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"第三个",@"title",
                             @"nevbar_03", @"image",
                             @"nevbar_03_a",@"selectedImage",
                             thirdNav, @"view",
                             nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"第四个",@"title",
                             @"nevbar_04", @"image",
                             @"nevbar_04_a",@"selectedImage",
                             fourth, @"view",
                             nil],

                            nil];
    
    [self setupTabBar:tabBarItems];
    self.viewdelegate = self;

}
- (void) onTouchUpInsideItemAtIndex:(NSUInteger)itemIndex{
    if (itemIndex == 7) {
   //处理特殊界面
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
