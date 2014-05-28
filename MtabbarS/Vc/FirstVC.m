//
//  FirstVC.m
//  MTabbarS
//
//  Created by lunaticM on 14-5-28.
//  Copyright (c) 2014年 lunaticM. All rights reserved.
//

#import "FirstVC.h"

@interface FirstVC ()

@end

@implementation FirstVC

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
    [[MRootVC singleton] showTabBar:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
