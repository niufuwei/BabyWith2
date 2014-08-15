//
//  NumberDescriptionViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-8-6.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NumberDescriptionViewController.h"

@interface NumberDescriptionViewController ()
{

    UITextField *appel;

}
@end

@implementation NumberDescriptionViewController

-(id)initWithPhoneNumber:(NSString *)phoneNumber
{
    
    self = [super init];
    if (self) {
        _phone = phoneNumber;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self titleSet:@"账号备注名"];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 30)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = @"请填写账号备注名，该名称将优先显示";
    descriptionLabel.font = [UIFont systemFontOfSize:16.0];
    descriptionLabel.textColor = [UIColor grayColor];
    [self.view addSubview:descriptionLabel];
    
    
    appel = [[UITextField alloc] initWithFrame:CGRectMake(20, descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + 20, 280, 30)];
    appel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"输入框.png"]];
    appel.font = [UIFont systemFontOfSize:15.0];
    appel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    appel.placeholder = @"账号备注名，如父亲、张三等";
    appel.layer.cornerRadius = 1.5;
    [self.view addSubview:appel];
    
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(44, appel.frame.origin.y + appel.frame.size.height + 50, 232, 35);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"qietu_146"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(setAppelName:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}
-(void)setAppelName:(UIButton *)dender
{
    
    

    [self performSelectorOnMainThread:@selector(changeName) withObject:nil waitUntilDone:YES];
    
    [self.navigationController popViewControllerAnimated:YES];


}
-(void)changeName
{
    
    NSString *loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    NSString *deviceId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Device_selected"] objectForKey:@"device_id"];


    [[NSUserDefaults standardUserDefaults] setObject:appel.text forKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]];
    
//    NSLog(@"description is %@",[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]);
//    
//    NSLog(@"name is %@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]]);
//
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
