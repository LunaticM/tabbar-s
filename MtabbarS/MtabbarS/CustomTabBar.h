//
//  CustomTabBar.h
//  MTabbarS
//
//  Created by lunaticM on 14-5-28.
//  Copyright (c) 2014年 lunaticM. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

@class CustomTabBar;
@protocol CustomTabBarResourceDelegate
- (NSString*)titleFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex;

- (UIImage*)imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage*)selectedImageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex;

- (UIImage*)backgroundImage;
- (UIImage*)selectedItemBackgroundImageFor:(CustomTabBar*)tabBar;

@optional
- (UIColor*)titleColorFor:(CustomTabBar*)tabBar;
- (UIImage*)seperatorImageFor:(CustomTabBar*)tabBar;
- (CGFloat)selectedItemHeight:(CustomTabBar*)tabBar;
@end

@protocol CustomTabBarDelegate
@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
- (void)touchLogoBtn;
@end


typedef enum{
    BadgePositionTopLeft, 
    BadgePositionTopRight, 
}BadgePosition;

@interface CustomTabBar : UIView<UIScrollViewDelegate>
{
    NSObject<CustomTabBarResourceDelegate> *_resourceDelegate;
    
    NSMutableArray* _buttons;
    NSMutableArray* _titleLabels;
    NSMutableDictionary* _badges;
    
    UIColor* _normalTitleColor;
    UIColor* _selectedTitleColor;
}
@property (nonatomic, strong) UIImageView *moreImageView;
@property (nonatomic, unsafe_unretained) NSObject<CustomTabBarDelegate> *customTabBarDelegate;
@property (nonatomic, strong) NSMutableArray* buttons;
@property (nonatomic, assign) BadgePosition position; 
@property (nonatomic, assign) NSInteger selectedTabBarItemIndex;

- (id) initWithItemCount:(NSUInteger)itemCount 
                itemSize:(CGSize)itemSize 
        resourceDelegate:(NSObject <CustomTabBarResourceDelegate>*)CustomTabBarResourceDelegate;

- (void) setTitleColor:(UIColor*)normalColor selectedColor:(UIColor*)selectedColor;
- (void) selectItemAtIndex:(NSInteger)index;

- (void) addBadge:(UIView*)badge atIndex:(NSInteger)index;
- (void) removeBadge:(NSInteger)index;

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void) toggleTabBar:(Boolean)isShow animated:(Boolean)animated;

@end
