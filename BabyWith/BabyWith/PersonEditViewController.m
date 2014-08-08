//
//  PersonEditViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-8-6.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "PersonEditViewController.h"
#import "NumberDescriptionViewController.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "Activity.h"
@interface PersonEditViewController ()

@end

@implementation PersonEditViewController

-(id)initwithPhoneNumber:(NSString *)phoneNumber
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
    
    [self titleSet:@"分享设置"];
    
    _descriptionArray = [[NSArray alloc] initWithObjects:@"分享账号",@"账号备注名",@"开启视频分享", nil];

    NSLog(@"phone is %@",_phone);
    // Do any additional setup after loading the view.
    self.view.backgroundColor = babywith_background_color;
    _shareEditTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 135) style:UITableViewStylePlain];
    _shareEditTable.backgroundColor = [UIColor clearColor];
    _shareEditTable.dataSource = self;
    _shareEditTable.delegate = self;
    [self.view addSubview:_shareEditTable];
    

    
  
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [_shareEditTable reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
        cell.textLabel.text = [_descriptionArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = babywith_color(0x373737);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (indexPath.row == 0)
        {
            
            phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 120, 45)];
            phoneLabel.font = [UIFont systemFontOfSize:14.0];
            phoneLabel.textColor = babywith_color(0x373737);
            phoneLabel.textAlignment = NSTextAlignmentRight;
            phoneLabel.backgroundColor = [UIColor clearColor];
            NSLog(@"ppppppphone is %@",_phone);
            [cell addSubview:phoneLabel];
        }
        if (indexPath.row == 1)
        {
            UIImageView * jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(320-25,18.5, 7, 13)];
            [jiantou setImage:[UIImage imageNamed:@"qietu_40.png"]];
            [cell addSubview:jiantou];
            
            
            
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 110, 45)];
            nameLabel.font = [UIFont systemFontOfSize:14.0];
            nameLabel.textColor = babywith_color(0x373737);
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.tag = indexPath.row;
            nameLabel.backgroundColor = [UIColor clearColor];
            [cell addSubview:nameLabel];
            
            
           
            
            
        }
        if (indexPath.row == 2)
        {
            switchImage = [[UIImageView alloc] initWithFrame:CGRectMake(250, 12.5, 50, 20)];
            [cell addSubview:switchImage];
        }

       
    }
    
    
    
    
    if (indexPath.row == 0)
    {
        
       
        phoneLabel.text = _phone;
    }
    if (indexPath.row == 1)
    {
        
        
        NSString *loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
        NSString *deviceId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Device_selected"] objectForKey:@"device_id"];
        
        NSLog(@"description is is %@",[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]);
        NSLog(@"cell name is %@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]]);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]])
        {
            nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,_phone]];
        }
        else
        {
        
            nameLabel.text = @"无";
        
        }
        
        
    }
    if (indexPath.row == 2)
    {
        NSString *loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
        NSString *deviceId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Device_selected"] objectForKey:@"device_id"];
        NSString * key =   [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@_status",loginName,deviceId,_phone]];
        NSLog(@"key is %@",key);
        
        if (key)
        {
            if ([key isEqualToString:@"1"])
            {
                switchImage.image = [UIImage imageNamed:@"切换 (1).png"];

            }
            if ([key isEqualToString:@"0"])
            {
                switchImage.image = [UIImage imageNamed:@"切换 (2).png"];
            }
            
        }
        else
        {
        
            switchImage.image = [UIImage imageNamed:@"切换 (1).png"];
        
            
        }
        
    }
    
    return  cell;

    


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1)
    {
        
        NumberDescriptionViewController *Vc = [[NumberDescriptionViewController alloc] initwithPhoneNumber:_phone];
        [self.navigationController pushViewController:Vc animated:YES];
        
    }
     if(indexPath.row == 2)
    {
        
        Activity *activity = [[Activity alloc] initWithActivity:self.view];
        [activity start];
        NSString *loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
        NSString *deviceId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Device_selected"] objectForKey:@"device_id"];
        NSString *key = [NSString stringWithFormat:@"%@_%@_%@_status",loginName,deviceId,_phone];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        NSLog(@"key is %@",key);

        if (switchImage.image == [UIImage imageNamed:@"切换 (2).png"])
        {
            
            
            if ([appDelegate.webInfoManger UserSetSahreDeviceStatusUsingDeviceId:deviceId Type:@"1" ToUser:_phone User:loginName Token:token] == YES)
            {
                [activity stop];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:key];
                NSString * key1 =   [[NSUserDefaults standardUserDefaults] objectForKey:key];
                NSLog(@"key1 is %@",key1);
                switchImage.image = [UIImage imageNamed:@"切换 (1).png"];


            }
            else
            {
                 [activity stop];
                //提示框提示错误
                [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
            
            }
            
            
        }
        else
        {
            if ([appDelegate.webInfoManger UserSetSahreDeviceStatusUsingDeviceId:deviceId Type:@"0" ToUser:_phone User:loginName Token:token] == YES)
            {
                [activity stop];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:key];
                NSString * key2 =   [[NSUserDefaults standardUserDefaults] objectForKey:key];
                NSLog(@"key2 is %@",key2);
                
                switchImage.image = [UIImage imageNamed:@"切换 (2).png"];
                
                
            }
            else
            {
                 [activity stop];
                //提示框提示错误
                [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
                
            }
        
            
            
        
        }
        
    
    
    }

    

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
