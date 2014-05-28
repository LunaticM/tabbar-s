//
//  CustomTabBarViewController.h
//  MtabbarS
//
//  Created by lunaticM on 14-5-28.
//  Copyright (c) 2014年 lunaticM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTabBar;
@protocol CustomTabBarViewDelegate <NSObject>

@optional

- (void) onTouchUpInsideItemAtIndex:(NSUInteger)itemIndex;

@end

@interface CustomTabBarViewController : UIViewController

@property (nonatomic, unsafe_unretained) NSObject<CustomTabBarViewDelegate> *viewdelegate;

+ (id)singleton;

- (UIViewController*)currentViewController;

- (void)setupTabBar:(NSArray*)tabBarItems;

- (void)setTabBarItemLabelAsTitle;

- (void)showTabBar:(Boolean)animated;
- (void)hideTabBar:(Boolean)animated;

- (void) selectAtIndex:(NSInteger)index;

@end
