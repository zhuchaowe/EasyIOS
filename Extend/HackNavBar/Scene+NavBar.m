//
//  Scene+NavBar.m
//  mcapp
//
//  Created by zhuchao on 15/2/12.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "Scene+NavBar.h"
#import <objc/runtime.h>


@interface EZNavBar()
@property(nonatomic,retain)UIView *leftContentView;
@property(nonatomic,retain)UIView *centerContentView;
@property(nonatomic,retain)UIView *rightContentView;
@property(nonatomic,retain)UIImageView *navView;
@property(nonatomic,retain)NSMutableArray *leftConstrains;
@property(nonatomic,retain)NSMutableArray *rightConstrains;
@property(nonatomic,retain)NSMutableArray *centerConstrains;
@end
@implementation EZNavBar

-(instancetype)init{
    self = [super init];
    if(self){
        
        _leftConstrains = [NSMutableArray array];
        _rightConstrains = [NSMutableArray array];
        _centerConstrains = [NSMutableArray array];
        
        _navView = [[UIImageView alloc]init];
        _navView.userInteractionEnabled = YES;
        [self addSubview:_navView];
        
        _leftContentView = [[UIView alloc]init];
        [_navView addSubview:_leftContentView];
        
        _centerContentView = [[UIView alloc]init];
        [_navView addSubview:_centerContentView];
        
        _rightContentView = [[UIView alloc]init];
        [_navView addSubview:_rightContentView];
        [self loadAutoLayout];
    }
    return self;
}

-(void)loadAutoLayout{
    [_navView alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:_navView.superview];
    [_navView constrainHeight:@"44"];
    
    [_leftContentView alignTop:@"2" leading:@"16" bottom:@"-2" trailing:nil toView:_leftContentView.superview];
    [_rightContentView alignTop:@"2" leading:nil bottom:@"-2" trailing:@"-16" toView:_rightContentView.superview];
    
    [_centerContentView constrainLeadingSpaceToView:_leftContentView predicate:@"0@1"];
    [_rightContentView constrainLeadingSpaceToView:_centerContentView predicate:@"0@1"];
    [_centerContentView alignTop:@"2" bottom:@"-2" toView:_centerContentView.superview];
    [_centerContentView alignCenterXWithView:_centerContentView.superview predicate:@"0"];
}

-(void)setLeftView:(UIView *)newView{
    
    for(UIView *oldView in _leftContentView.subviews){
        [oldView removeFromSuperview];
    }
    [_leftContentView removeConstraints:_leftConstrains];
    [_leftConstrains removeAllObjects];
    [_leftContentView addSubview:newView];
    
    [_leftConstrains addObjectsFromArray:newView.constraints];
    [_leftConstrains addObjectsFromArray:[newView alignLeading:@"0@3" trailing:@"0@3" toView:_leftContentView]];
    [_leftConstrains addObjectsFromArray:[newView alignCenterYWithView:_leftContentView predicate:@"0"]];
}

-(UIView *)leftView{
    return [_leftContentView.subviews safeObjectAtIndex:0];
}

-(void)setRightView:(UIView *)newView{
    for(UIView *oldView in _rightContentView.subviews){
        [oldView removeFromSuperview];
    }
    [_rightContentView removeConstraints:_rightConstrains];
    [_rightConstrains removeAllObjects];
    [_rightContentView addSubview:newView];
    [_rightConstrains addObjectsFromArray:newView.constraints];
    [_rightConstrains addObjectsFromArray:[newView alignLeading:@"0@3" trailing:@"0@3" toView:_rightContentView]];
    [_rightConstrains addObjectsFromArray:[newView alignCenterYWithView:_rightContentView predicate:@"0"]];
}

-(UIView *)rightView{
    return [_rightContentView.subviews safeObjectAtIndex:0];
}

-(void)setCenterView:(UIView *)newView{
    for(UIView *oldView in _centerContentView.subviews){
        [oldView removeFromSuperview];
    }
    [_centerContentView removeConstraints:_centerConstrains];
    [_centerConstrains removeAllObjects];
    [_centerContentView addSubview:newView];
    [_centerConstrains addObjectsFromArray:newView.constraints];
    [_centerConstrains addObjectsFromArray:[newView alignLeading:@"0@2" trailing:@"0@2" toView:_centerContentView]];
    [_centerConstrains addObjectsFromArray:[newView alignCenterYWithView:_centerContentView predicate:@"0"]];
}



-(UIView *)centerView{
    return [_centerContentView.subviews safeObjectAtIndex:0];
}

@end

static char SceneEZNavBar;

@implementation Scene (NavBar)

-(void)setNavBar:(EZNavBar *)navBar{
    [self willChangeValueForKey:@"navBar"];
    objc_setAssociatedObject(self, &SceneEZNavBar,
                             navBar,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"navBar"];
}

-(EZNavBar *)navBar {
    EZNavBar *bar = objc_getAssociatedObject(self, &SceneEZNavBar);
    if(bar.isNotEmpty){
        return bar;
    }else{
        EZNavBar *navBar = [[EZNavBar alloc]init];
        if(self.navigationController.navigationBar.barTintColor.isNotEmpty){
            navBar.backgroundColor = self.navigationController.navigationBar.barTintColor;
        }else if([UINavigationBar appearance].barTintColor.isNotEmpty){
            navBar.backgroundColor = [UINavigationBar appearance].barTintColor;
        }
        [self.view addSubview:navBar];
        self.automaticallyAdjustsScrollViewInsets=NO;//禁止自动调整
        [navBar alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:navBar.superview];
        [navBar constrainHeight:@"64"];
        self.navBar = navBar;
        return navBar;
    }
}

-(void)nav_setTitle:(NSString *)title{
    UIColor *foregroundColor = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:18.0f];
    
    if([self.navigationController.navigationBar.titleTextAttributes objectForKey:NSForegroundColorAttributeName]){
        foregroundColor = [self.navigationController.navigationBar.titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    }else if ([[UINavigationBar appearance].titleTextAttributes objectForKey:NSForegroundColorAttributeName]){
        foregroundColor = [[UINavigationBar appearance].titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    }
    if([self.navigationController.navigationBar.titleTextAttributes objectForKey:NSFontAttributeName]){
        font = [self.navigationController.navigationBar.titleTextAttributes objectForKey:NSFontAttributeName];
    }else if ([[UINavigationBar appearance].titleTextAttributes objectForKey:NSFontAttributeName]){
        font = [[UINavigationBar appearance].titleTextAttributes objectForKey:NSFontAttributeName];
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = foregroundColor;
    label.font = font;
    self.navBar.centerView = label;
}

-(void)addSubViewAlignTopNavBar:(UIView *)view{
    [self.view addSubview:view];
    [view constrainTopSpaceToView:self.navBar predicate:@"0"];
    [view alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:view.superview];
}

- (void)nav_showBarButton:(EzNavigationBar)position button:(UIButton *)button{
    if (NAV_LEFT == position) {
        [button addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navBar.leftView = button;
        if (IOS7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if (NAV_RIGHT == position){
        [button addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navBar.rightView = button;
    }
}

@end
