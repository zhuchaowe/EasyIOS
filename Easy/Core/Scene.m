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

-(void)handlePullLoader:(MJRefreshBaseView *)view state:(PullLoaderState)state{
    
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

- (void)leftButtonTouch{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonTouch{
}

-(void)setTitleText:(NSString *)str{
    if(self.navigationItem.titleView != nil){
        [self.navigationItem.titleView removeFromSuperview];
        self.navigationItem.titleView = nil;
    }
    
    if(![self.title isEqualToString:@""]){
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        EzUILabel *titleLabel = [[EzUILabel alloc]initWithFrame:CGRectMake(0, 0, titleView.width, 44)];
        titleLabel.tag = 100;
        titleLabel.text = str;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        titleLabel.frame = CGRectMake(0, 0, titleLabel.autoSize.width, 44);
        titleView.frame = titleLabel.frame;
        [titleView addSubview:titleLabel];
        self.navigationItem.titleView = titleView;
    }
}
@end
