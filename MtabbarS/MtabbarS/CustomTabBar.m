//
//  CustomTabBar.h
//  MTabbarS
//
//  Created by lunaticM on 14-5-28.
//  Copyright (c) 2014年 lunaticM. All rights reserved.
//


#import "CustomTabBar.h"

@interface CustomTabBar (PrivateMethods)

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex;
-(UIButton*) buttonAtIndex:(NSUInteger)itemIndex;


@end

@implementation CustomTabBar

@synthesize moreImageView = _moreImageView;
@synthesize customTabBarDelegate = _customTabBarDelegate;
@synthesize buttons = _buttons;
@synthesize position = _position;
@synthesize selectedTabBarItemIndex = _selectedTabBarItemIndex;

static UIImage *_gMoreImage = nil;

+ (void)initialize{
    [super initialize];
    _gMoreImage = [UIImage imageNamed:@"menu_more"];
}

- (id) initWithItemCount:(NSUInteger)itemCount 
                itemSize:(CGSize)itemSize 
                resourceDelegate:(NSObject <CustomTabBarResourceDelegate>*)customTabBarResourceDelegate
{
    if (self = [super init])
    {
        _resourceDelegate = customTabBarResourceDelegate;
        
        _badges = [[NSMutableDictionary alloc] init];
        _position = BadgePositionTopRight;
        
        _selectedTabBarItemIndex = -1;
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        UIImage *backImage = [UIImage imageNamed:@"menu_JTlogo_default"];
        UIImageView *logoView = [[UIImageView alloc] initWithImage:backImage];
        logoView.userInteractionEnabled = YES;
        float x = backImage.size.width;
        CGRect frame = [UIScreen mainScreen].bounds;
        UIImage* backgroundImage = [_resourceDelegate backgroundImage];
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = CGRectMake(x, itemSize.height - backgroundImage.size.height, itemSize.width*itemCount, backgroundImage.size.height);
        backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:backgroundImageView];
        [self addSubview:logoView];
        logoView.frame = CGRectMake(0, itemSize.height - backgroundImage.size.height, backImage.size.width, backImage.size.height);
        
        UIButton *logo = [UIButton buttonWithType:UIButtonTypeCustom];
        logo.frame = logoView.frame;
        [logo addTarget:self action:@selector(logoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:logo];
        
        
        
        _moreImageView = [[UIImageView alloc] initWithImage:_gMoreImage];
        _moreImageView.frame = CGRectMake(frame.size.height - _gMoreImage.size.width, (itemSize.height - _gMoreImage.size.height)/2, _gMoreImage.size.width, _gMoreImage.size.height);
        [self addSubview:_moreImageView];
        
        UIColor *titleColor = nil;
        if ([_resourceDelegate respondsToSelector:@selector(titleColorFor:)]) {
            titleColor = [_resourceDelegate titleColorFor:self];
        }
        else {
            titleColor = [UIColor blackColor];
        }
        
        self.frame = CGRectMake(0, 0, frame.size.height, itemSize.height);
        
        UIImage* itemBackground = [_resourceDelegate selectedItemBackgroundImageFor:self];
        _buttons = [[NSMutableArray alloc] initWithCapacity:itemCount];
        _titleLabels = [[NSMutableArray alloc] initWithCapacity:itemCount];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 0, frame.size.height - _gMoreImage.size.width-x-10, itemSize.height)];
        scrollView.delegate = self;
        
        CGFloat horizontalOffset = 0;
        for (NSUInteger i = 0 ; i < itemCount ; i++)
        {
            NSString* title = [_resourceDelegate titleFor:self atIndex:i];
            UILabel* newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            CGRect labelFrame = newLabel.frame;
            if (title) {
                newLabel.text = title;
                newLabel.font = [UIFont systemFontOfSize:12];
                newLabel.backgroundColor = [UIColor clearColor];
                newLabel.textAlignment = NSTextAlignmentCenter;
                newLabel.textColor = titleColor;
                [newLabel sizeToFit];
                labelFrame = newLabel.frame;
            }
            
            UIButton* newButton = [self buttonAtIndex:i];
            
            [newButton setBackgroundImage:itemBackground forState:UIControlStateSelected];
            newButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            newButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            [newButton addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [newButton addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
//            [newButton addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
//            [newButton addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
//            [newButton addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            //newButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
            newButton.frame = CGRectMake(horizontalOffset, 0, 
                                         itemSize.width, itemSize.height);
            newButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, labelFrame.size.height + 2, 0);
            [_buttons addObject:newButton];
            [scrollView addSubview:newButton];

            if (i < itemCount) {
                if ([_resourceDelegate respondsToSelector:@selector(seperatorImageFor:)]) {
                    UIImage* seperatorImage = [_resourceDelegate seperatorImageFor:self];
                    if (seperatorImage) {
                        UIImageView *seperatorImageView=[[UIImageView alloc]initWithImage:seperatorImage];
                        CGRect seperatorFrame = seperatorImageView.frame;
                        seperatorFrame.origin.x = newButton.frame.origin.x + newButton.frame.size.width;
                        seperatorFrame.origin.y = 0;
                        seperatorFrame.size.height = itemSize.height;
                        
                        seperatorImageView.frame = seperatorFrame;
                        [scrollView addSubview:seperatorImageView];
                    }
                }
            }
            
            newLabel.center = CGPointMake(newButton.frame.origin.x + newButton.imageView.frame.origin.x + 
                                              newButton.imageView.frame.size.width/2.0f, 
                                              newButton.frame.origin.y + newButton.imageView.frame.origin.y + 
                                              newButton.imageView.frame.size.height + newLabel.frame.size.height/2.0f );
           // NSLog(@"newLabel=%@",[NSValue valueWithCGRect:newLabel.frame]);
            [_titleLabels addObject:newLabel];
            [scrollView addSubview:newLabel];
            
            horizontalOffset = horizontalOffset + itemSize.width;

        }
        self.userInteractionEnabled = YES;
   
        [self addSubview:scrollView];
        [scrollView setContentSize:CGSizeMake(itemSize.width*itemCount, itemSize.height)];
        
        
        
    }
    
    return self;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _moreImageView.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _moreImageView.hidden = NO;
}

- (void)setTitleColor:(UIColor*)normalColor selectedColor:(UIColor*)selectedColor {
    _normalTitleColor = normalColor;
    _selectedTitleColor = selectedColor;
    
    for (int i = 0; i < [_titleLabels count]; ++i) {
        UILabel* titleLabel = [_titleLabels objectAtIndex:i];
        if (_selectedTabBarItemIndex == i) {
            titleLabel.textColor = _selectedTitleColor;
        }
        else {
            titleLabel.textColor = _normalTitleColor;
        }
    }
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* hitSubview = [super hitTest: point withEvent: event];
    NSArray* indexs = [_badges allKeys];
    for (int i = 0; i < [_badges count]; ++i) {
        NSNumber* index = [indexs objectAtIndex:i];
        if ([_badges objectForKey:index] == hitSubview) {
            return [_buttons objectAtIndex:index.intValue];
        }
    }
    
    return hitSubview;         
}

- (void) addBadge:(UIView*)badge atIndex:(NSInteger)index {
    NSNumber* indexNumber = [NSNumber numberWithInteger:index];
    UIView* oldBadge = [_badges objectForKey:indexNumber];
    [oldBadge removeFromSuperview];
    [_badges setObject:badge forKey:indexNumber];
    UIButton* button = [_buttons objectAtIndex:index];
    badge.tag = -1;
    [button addSubview:badge];
}

- (void)removeBadge:(NSInteger)index {
    NSNumber* indexNumber = [NSNumber numberWithInteger:index];
    UIView* oldBadge = [_badges objectForKey:indexNumber];
    [oldBadge removeFromSuperview];
    [_badges removeObjectForKey:indexNumber];
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
    
    
    
    for ( int i = 0; i < [_buttons count]; ++i ) {
        UIButton* button = [_buttons objectAtIndex:i];
        if (button == selectedButton)
        {
            button.selected = YES;
            button.highlighted = button.selected ? NO : YES;
            
            if([_resourceDelegate respondsToSelector:@selector(selectedItemHeight:)]) {
                CGRect frame = button.frame;
                frame.size.height = [_resourceDelegate selectedItemHeight:self];
                frame.origin.y = self.frame.size.height - frame.size.height;
                frame.origin.x = i * button.frame.size.width;   
                button.frame=frame;
            }
            
            if (_selectedTabBarItemIndex >= 0 && _selectedTabBarItemIndex < [_buttons count]) {
                UILabel* lastSelectedLabel = [_titleLabels objectAtIndex:_selectedTabBarItemIndex];
                if (_normalTitleColor) {
                    lastSelectedLabel.textColor = _normalTitleColor;
                }
            }
            
            _selectedTabBarItemIndex = i;
            
            UILabel* selectedLabel = [_titleLabels objectAtIndex:i];
            if (_selectedTitleColor) {
                selectedLabel.textColor = _selectedTitleColor;
            }
            
        }
        else
        {
            button.selected = NO;
            button.highlighted = NO;
            CGRect frame = button.frame;
            frame.origin.y = 0;
            frame.size.height = self.frame.size.height;
            button.frame = frame;
        }
    }
}

- (void)touchDownAction:(UIButton*)button
{
    if ([_customTabBarDelegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
        [_customTabBarDelegate touchDownAtItemAtIndex:[_buttons indexOfObject:button]];
    [self dimAllButtonsExcept:button];
}
-(void)logoBtnClick
{
    if ([_customTabBarDelegate respondsToSelector:@selector(touchLogoBtn)]) {
        [_customTabBarDelegate touchLogoBtn];
    }
}
- (void)touchUpInsideAction:(UIButton*)button
{
    if ([_customTabBarDelegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        [_customTabBarDelegate touchUpInsideItemAtIndex:[_buttons indexOfObject:button]];
   
    
    [self dimAllButtonsExcept:button];
}

- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
}

- (void) selectItemAtIndex:(NSInteger)index
{
    UIButton* button = [_buttons objectAtIndex:index];
    [self touchUpInsideAction:button];
}


- (UIButton*) buttonAtIndex:(NSUInteger)itemIndex
{

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.tag = itemIndex;
    UIImage* image = [_resourceDelegate imageFor:self atIndex:itemIndex];
    if(image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    UIImage* selectedImage = [_resourceDelegate selectedImageFor:self atIndex:itemIndex];
    if(selectedImage) {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
//    CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? appFrame.size.height : appFrame.size.width)/_buttons.count;
//    CGFloat horizontalOffset = 0;
//    CGFloat spacing = 2;
//    for ( int i = 0; i <[_buttons count]; ++i) {
//        UIButton* button = [_buttons objectAtIndex:i];
//        UILabel* label = [_titleLabels objectAtIndex:i];
//        
//        button.frame = CGRectMake(horizontalOffset + spacing, 
//                                  spacing, 
//                                  itemWidth - spacing * 2, 
//                                  button.frame.size.height);
//        label.center = CGPointMake(button.frame.origin.x + button.imageView.frame.origin.x + 
//                                      button.imageView.frame.size.width/2.0, 
//                                      self.frame.size.height - label.frame.size.height/2.0 - 3);
//        
//        horizontalOffset = horizontalOffset + itemWidth;
//    }
//
//    if (_selectedTabBarItemIndex < 0 || _selectedTabBarItemIndex >= [_buttons count]) {
//        return ;
//    }
//    
//    UIButton* selectedButton = [_buttons objectAtIndex:_selectedTabBarItemIndex];
//    [self dimAllButtonsExcept:selectedButton];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    self.hidden = ![((__bridge_transfer NSNumber*)context) boolValue]; 
}

- (void)toggleTabBar:(Boolean)isShow animated:(Boolean)animated {
    if (isShow != self.hidden) {
        return ;
    }
    
    CGRect frame = self.frame;
    if (isShow) {
        frame.origin.y -= frame.size.height;
    }
    else {
        frame.origin.y += frame.size.height;
    }
    
    if (animated ) {
        self.hidden = NO;

		[UIView beginAnimations:nil context:(__bridge_retained void *)[NSNumber numberWithBool:isShow]]; {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.15];
            [UIView setAnimationDelegate:self];
            
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            
            self.frame = frame;
            
        }[UIView commitAnimations];
    }
    else {
        self.hidden = !isShow;
        self.frame = frame;
        
    }
    
}



@end
