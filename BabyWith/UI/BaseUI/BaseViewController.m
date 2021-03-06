//
//  BaseViewController.m
//  meiliyue
//
//  Created by Fly on 12-11-22.
//  Copyright (c) 2012年 Fly. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if (![self isNavRootViewController]) {
//        [self addNavBackButtonWithDefaultAction:@"后退"];
//    }
    
    self.view.backgroundColor = babywith_color(0xf5f5f5);
    
    if (IOS7) {
//        self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"导航栏背景.png"];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"qietu_310.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"qietu_307.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
    if (IOS7_OR_LATER) {
        self.navigationController.navigationBar.barTintColor = babywith_color(0x2da7e7);
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        [self leftButtonItemWithImageName:@"导航返回.png"];
    }
}


//- (void)showAlertView:(NSString*)msg{
//    [WCAlertView showAlertWithTitle:@"系统提示" message:msg customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc{
//    NSLog(@"%@->dealloc",NSStringFromClass([self class]));
}
#pragma mark -
#pragma mark customButton

- (void)titleSet:(NSString *)aTitle
{
    if (self.navigationController) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = aTitle;
        titleLabel.font = [UIFont systemFontOfSize:20.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = titleLabel;

    }
}
- (void)configurationForGreenButton:(UIButton *)button
{
    [button setTitleColor:babywith_text_background_color forState:UIControlStateNormal];
    [button setBackgroundColor:babywith_green_color];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0];
}
- (void)leftButtonItemWithImageName:(NSString *)imageName
{
    //左导航-主选择页面
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 0, 10, 20)];
    [navButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //[navButton setImage:[UIImage imageNamed:@"goMain_highlight.png"] forState:UIControlStateHighlighted];
    [navButton addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftItem;
    }

    
//    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)rightButtonTitle:(NSString *)titleName
{
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [navButton setTitle:titleName  forState:UIControlStateNormal];
    [navButton setBackgroundColor:[UIColor whiteColor]];
    [navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[navButton setImage:[UIImage imageNamed:@"goMain_highlight.png"] forState:UIControlStateHighlighted];
    [navButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
    self.navigationItem.rightBarButtonItem = leftItem;

}

- (void)rightButtonItemWithImageName:(NSString *)imageName
{
    //右导航-主选择页面
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 49)];
    [navButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //[navButton setImage:[UIImage imageNamed:@"goMain_highlight.png"] forState:UIControlStateHighlighted];
    [navButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
    self.navigationItem.rightBarButtonItem = leftItem;
}
-(void)skip:(id)sender
{
    [_delegate RightButtonClick];
}
- (void)pop:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
