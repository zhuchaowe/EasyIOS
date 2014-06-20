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
    [_action.msg addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    self.hasAddActionObserver =YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.hasAddActionObserver){
        [_action.msg removeObserver:self forKeyPath:@"state"];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"state"])
    {
        [self handleActionMsg:_action.msg];
    }
}

-(void)handleActionMsg:(ActionData *)msg{
    if(msg.sending){
        NSLog(@"sending:%@",msg.url);
    }else if(msg.succeed){
        NSLog(@"success:%@",msg.output);
    }else if(msg.failed){
        NSLog(@"failed:%@",msg.error);
    }
}
- (void)SEND_ACTION:(NSDictionary *)dict{
}
- (void)SEND_ACTION{
    
}
- (void)SEND_CACHE_ACTION{
    [self.action readFromCache];
    [self SEND_ACTION];
}
- (void)SEND_NO_CACHE_ACTION{
    [self.action notReadFromCache];
    [self SEND_ACTION];
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

@end
