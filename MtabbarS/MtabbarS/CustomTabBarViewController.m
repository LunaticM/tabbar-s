//
//  CustomTabBarViewController.m
//  MtabbarS
//
//  Created by lunaticM on 14-5-28.
//  Copyright (c) 2014年 lunaticM. All rights reserved.
//

#import "CustomTabBarViewController.h"

#import "CustomTabBar.h"
#import "NSString+HexColor.h"

@interface CustomTabBarViewController ()<CustomTabBarResourceDelegate, CustomTabBarDelegate>
{
    CustomTabBar* _tabBar;
    NSArray* _tabBarItems;
    UIViewController* _currentViewController;
}
@end

@implementation CustomTabBarViewController

@synthesize viewdelegate = _viewDelegate;

static NSMutableDictionary* _sSingletons;

+ (void)initialize {
    static dispatch_once_t once;
    dispatch_once(&once, ^ { _sSingletons = [[NSMutableDictionary alloc] init]; });
    [_sSingletons setObject:[[self alloc] init] forKey:(id<NSCopying>)[self class]];
}

+ (id)singleton {
    return [_sSingletons objectForKey:[self class]];
}

- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setupTabBar:(NSArray*)tabBarItems {
    _tabBarItems = tabBarItems;
    CGRect frame = [UIScreen mainScreen].bounds;
    //    UIImage *backImage = [UIImage imageNamed:@"menu_JTlogo"];
    int tabItemsCount = [_tabBarItems count];
    
    //自定义高低
    _tabBar = [[CustomTabBar alloc] initWithItemCount:tabItemsCount itemSize:CGSizeMake(74, 55) resourceDelegate:self];
    CGRect tabBarFrame = _tabBar.frame;
    tabBarFrame.origin.y = frame.size.height - tabBarFrame.size.height;
    _tabBar.frame = tabBarFrame;
    [_tabBar setTitleColor:[UIColor whiteColor] selectedColor:[@"#ffb400" colorValue]];
    [self.view addSubview:_tabBar];
    _tabBar.customTabBarDelegate = self;
    [self touchUpInsideItemAtIndex:0];
}

- (void) selectAtIndex:(NSInteger)index{
    [_tabBar selectItemAtIndex:index];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    for (NSDictionary* item in _tabBarItems) {
        UIViewController* viewController = [item objectForKey:@"view"];
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* wrapperViewController = (UINavigationController* )viewController;
            wrapperViewController.visibleViewController.title = title;
        }
        else {
            viewController.title = title;
        }
    }
}

- (void)setTabBarItemLabelAsTitle {
    for (NSDictionary* item in _tabBarItems) {
        UIViewController* viewController = [item objectForKey:@"view"];
        NSString* title = [item objectForKey:@"title"];
        if(title == nil) {
            continue;
        }
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* wrapperViewController = (UINavigationController* )viewController;
            wrapperViewController.visibleViewController.title = title;
        }
        else {
            viewController.title = title;
        }
    }
}
- (UIViewController*)currentViewController {
    return _currentViewController;
}
- (void)viewWillAppear:(BOOL)animated {
    [_currentViewController viewWillAppear:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [_currentViewController viewDidAppear:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (_currentViewController) {
        return [_currentViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    else {
        return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
}

#pragma mark - TabBar custom

- (NSString*) titleFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    return [[_tabBarItems objectAtIndex:itemIndex] objectForKey:@"title"];
}

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    return [UIImage imageNamed:[[_tabBarItems objectAtIndex:itemIndex] objectForKey:@"image"]];
}

- (UIImage*) selectedImageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    return [UIImage imageNamed:[[_tabBarItems objectAtIndex:itemIndex] objectForKey:@"selectedImage"]];
}

- (UIImage*) selectedItemBackgroundImageFor:(CustomTabBar*)tabBar {
    return nil;
}

- (UIImage*) backgroundImage {
    return nil;
}
#pragma mark - TabBar event
- (void)adjustViewController:(UIViewController*)viewController {
    CGRect frame = viewController.view.frame;
    frame.origin = CGPointZero;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.bounds.size.height - _tabBar.frame.size.height;
    viewController.view.frame = frame;
}

- (void) touchUpInsideItemAtIndex:(NSUInteger)itemIndex {
    if (_viewDelegate && [_viewDelegate respondsToSelector:@selector(onTouchUpInsideItemAtIndex:)])
        [_viewDelegate onTouchUpInsideItemAtIndex:itemIndex];
    
    //如果不是特殊界面 按照传统跳转方法  与MrootVC的特殊界面一致
    if (itemIndex != 7) {
        
        UIViewController* viewController = [[_tabBarItems objectAtIndex:itemIndex] objectForKey:@"view"];
        if (_currentViewController == viewController ) {
            return ;
        }
        
        if (_currentViewController) {
            [_currentViewController viewWillDisappear:YES];
            [_currentViewController.view removeFromSuperview];
            [_currentViewController viewDidDisappear:YES];
        }
        
        [self adjustViewController:viewController];
        
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [viewController viewWillAppear:YES];
        [self.view insertSubview:viewController.view belowSubview:_tabBar];
        [viewController viewDidAppear:YES];
        
        _currentViewController = viewController;
        
        [_tabBar selectItemAtIndex:itemIndex];
    }
    
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)contex {
    if ([animationID isEqualToString:@"hide"]) {
        _tabBar.hidden = YES;
    }
}

- (void)showTabBar:(Boolean)animated {
    if (!_tabBar.hidden) {
        return ;
    }
    
    UIView* currentView = _currentViewController.view;
    CGRect currentViewFrame = currentView.frame;
    currentViewFrame.size.height -= _tabBar.frame.size.height;
    
    _tabBar.hidden = NO;
    CGRect tabBarFrame = _tabBar.frame;
    tabBarFrame.origin.y -= tabBarFrame.size.height;
    
    if (animated) {
        [UIView beginAnimations:@"show" context:nil]; {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.15];
            [UIView setAnimationDelegate:self];
            
            currentView.frame = currentViewFrame;
            _tabBar.frame = tabBarFrame;
            
        }[UIView commitAnimations];
    }
    else {
        currentView.frame = currentViewFrame;
        _tabBar.frame = tabBarFrame;
        _tabBar.hidden = NO;
    }
}

- (void)hideTabBar:(Boolean)animated {
    if (_tabBar.hidden) {
        return ;
    }
    
    UIView* currentView = _currentViewController.view;
    CGRect currentViewFrame = currentView.frame;
    currentViewFrame.size.height += _tabBar.frame.size.height;
    
    CGRect tabBarFrame = _tabBar.frame;
    tabBarFrame.origin.y += tabBarFrame.size.height;
    
    if (animated) {
        [UIView beginAnimations:@"hide" context:nil]; {
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.15];
            [UIView setAnimationDelegate:self];
            
            currentView.frame = currentViewFrame;
            _tabBar.frame = tabBarFrame;
            
        }[UIView commitAnimations];
    }
    else {
        currentView.frame = currentViewFrame;
        _tabBar.frame = tabBarFrame;
        _tabBar.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
