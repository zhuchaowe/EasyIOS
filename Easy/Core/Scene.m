//
//  Scene.m
//  fastSign
//
//  Created by EasyIOS on 14-4-11.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "Scene.h"


@interface Scene ()

@end

@implementation Scene

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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)showBarButton:(EzNavigationBar)position title:(NSString *)name fontColor:(UIColor *)color{
    UIButton *button = [[UIButton alloc] initNavigationButtonWithTitle:name color:color];
    [self showBarButton:position button:button];
}

- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName{
    UIButton *button = [[UIButton alloc] initNavigationButton:[UIImage imageNamed:imageName]];
    [self showBarButton:position button:button];
}

- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button{
    if (NAV_LEFT == position) {
        [button addTarget:self action:@selector(leftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        if (IOS7_OR_LATER) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if (NAV_RIGHT == position){
        [button addTarget:self action:@selector(rightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)setTitleView:(UIView *)titleView{
    self.navigationItem.titleView = titleView;
}

- (void)leftButtonTouch{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonTouch{
}

-(void)addSubView:(UIView *)view
           extend:(EzAlignExtend)extend{
    [self.view addSubview:view];
    if(IOS7_OR_LATER){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    [self.view sendSubviewToBack:view];
    if(IOS7_OR_LATER){
        [view alignTopEdgeWithView:view.superview predicate:
         (extend == EXTEND_TOP||extend == EXTEND_TOP_BOTTOM)?@"64":@"0"];
    }else{
        [view alignTopEdgeWithView:view.superview predicate:@"0"];
    }
    [view alignBottomEdgeWithView:view.superview predicate:
     (extend == EXTEND_BOTTOM||extend == EXTEND_TOP_BOTTOM)?@"-49":@"0"];
    [view alignLeading:@"0" trailing:@"0" toView:view.superview];
}

- (void)addScrollView:(UIScrollView *)view
               extend:(EzAlignExtend)extend
                inset:(EzAlignInset)inset{
    [self addSubView:view extend:extend];
    short top = 0;
    if(IOS7_OR_LATER && (inset == INSET_TOP||inset==INSET_TOP_BOTTOM)){
        top = 64;
    }
    short bottom = (inset == INSET_BOTTOM||inset==INSET_TOP_BOTTOM)?49:0;
    view.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
}

@end
