//
//  NewMessageViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NewMessageViewController.h"
#import "MainAppDelegate.h"
#import "NewMessageCell.h"
#import "WebInfoManager.h"
#import "DeviceConnectManager.h"
#import "Activity.h"
@interface NewMessageViewController ()


@end

@implementation NewMessageViewController

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
    _messageTableView = [[UITableView alloc] init];
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.allowsSelection = NO;
    _messageTableView.backgroundColor = [UIColor clearColor];
    _label = [[UILabel alloc] init];
    
    [self titleSet:@"分享设备"];
    
    messageArray1 = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 666)
    {
        if (buttonIndex == 0)
        {
            if ([[appDelegate.appDefault objectForKey:@"login_expired"] isEqualToString:@"1"])
                
            {
                
                [appDelegate.appDefault setObject:@"" forKey:@"Username"];
                [appDelegate.appDefault setObject:@"" forKey:@"Password"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToLogin" object:nil];
                
                
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
    
        if (buttonIndex == 0)
        {
            if ([[appDelegate.appDefault objectForKey:@"login_expired"] isEqualToString:@"1"])
                
            {
                
                [appDelegate.appDefault setObject:@"" forKey:@"Username"];
                [appDelegate.appDefault setObject:@"" forKey:@"Password"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToLogin" object:nil];
                
                
            }
            else
            {
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    
    }
    

}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    Activity *activity = [[Activity alloc] initWithActivity:self.view];
    [activity start];
    messageListDic =  [appDelegate.webInfoManger UserGetMessageUsingToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]];
//    NSLog(@"dic is %@",messageListDic);
    if (!messageListDic)
    {
        [activity stop];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[appDelegate.appDefault objectForKey:@"Error_message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 666;
        [alert show];
    }
    else
    {
        messageArray1 =[NSMutableArray arrayWithArray:[messageListDic  objectForKey:@"info"]];
//        NSLog(@"message array is %@",messageArray1);
        [appDelegate.appDefault setObject:messageArray1 forKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]];
        [activity stop];
    }
    
    [self loadUI];


}
-(void)loadUI
{
    [_messageTableView reloadData];
    
    
    if ([messageArray1 count]== 0)
    {
        
        _messageTableView.frame = CGRectMake(0, 0, 0, 0);
        
        _label.frame = CGRectMake(20, 200, 280, 60);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text =@"您还没有设备分享信息";
        _label.hidden = NO;
        _label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_label];
    }
    else
    {
        _label.hidden = YES;
        
        
        if (130.0*[self tableView:_messageTableView numberOfRowsInSection:0] > self.view.frame.size.height - 66)
        {
            _messageTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        else
        {
            _messageTableView.frame = CGRectMake(0, 0, 320, 130.0*[self tableView:_messageTableView numberOfRowsInSection:0]);
            
        }
    }
    [self.view addSubview:_messageTableView];
    

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
#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   return  [messageArray1 count];
    


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"NewMessageIdentifier";
    
    NewMessageCell *cell = (NewMessageCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewMessageCell1" owner:self options:nil];
       cell = [nib objectAtIndex:0];
    }
    
    
    cell.messageLabel.text = [[messageArray1 objectAtIndex:indexPath.row] objectForKey:@"msgContent"];
    
    
    [cell.agreeShareBtn addTarget:self action:@selector(agreeShare:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeShareBtn.tag = indexPath.row + 100;
    [cell.refuseShareBtn addTarget:self action:@selector(refuseShare:) forControlEvents:UIControlEventTouchUpInside];
    cell.refuseShareBtn.tag = indexPath.row + 1000;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 90.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}


#pragma mark shareFunction

-(void)agreeShare:(UIButton *)btn
{
    
//    NSLog(@"btn tag is %d",btn.tag);
    Activity *activity = [[Activity alloc] initWithActivity:self.view];

    [activity start];
//    NSLog(@"同意分享1");
//    NewMessageCell *cell = (NewMessageCell *)[btn superview];
//    NSIndexPath *indexPath = [self.messageTableView indexPathForCell:cell];
//    
    
    //根据message id 去同意分享
    NSString *IDMer = [[messageArray1 objectAtIndex:btn.tag - 100] objectForKey:@"id"];
    
    
//    NSLog(@"iiiiiiiiiiiiii%@",IDMer);
    if ([appDelegate.webInfoManger UserAgreeAddDeviceUsingIDMer:IDMer Toekn:[appDelegate.appDefault objectForKey:@"Token"]] == YES)
    {
//        NSLog(@"分享成功");
        
        [activity stop];
//        NSLog(@"messageArray is %@",appDelegate.messageArray);
        
        [appDelegate.messageArray addObjectsFromArray: [appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]]];
        [appDelegate.messageArray removeObjectAtIndex:btn.tag - 100];
//        NSLog(@"message array is %@",messageArray1);
        [messageArray1 removeObjectAtIndex:btn.tag - 100];
        [appDelegate.appDefault setObject:appDelegate.messageArray forKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]];
        [appDelegate.messageArray removeAllObjects];
        [self.messageTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
     else
    {
    
        [activity stop];
        //提示框提示错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[appDelegate.appDefault objectForKey:@"Error_message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         alert.tag = 555;
         [alert show];
  
    }
    

}
 -(void)refuseShare:(UIButton *)btn
    
{
    
    
//    NSLog(@"refuse btn tag is %d",btn.tag);

    Activity *activity = [[Activity alloc] initWithActivity:self.view];

    [activity start];

//    NSLog(@"拒绝别人的分享");
   //根据message id 去同意分享
    NSString *IDMer = [[messageArray1 objectAtIndex:btn.tag - 1000] objectForKey:@"id"];
//     NSLog(@"jjjjjjjjjjjjjjjj%@",IDMer);
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
    if ([appDelegate.webInfoManger UserRefuseDeviceUsingDeviceId:@"" MessageId:IDMer SharePersonNumber:@"" ToUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"] Token:token] == YES)
    {
         [activity stop];
        [appDelegate.messageArray addObjectsFromArray: [appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]]];
        [appDelegate.messageArray removeObjectAtIndex:btn.tag - 1000];
//        NSLog(@"message array 1 is %@,index is %d",messageArray1,btn.tag - 1000);
        [messageArray1 removeObjectAtIndex:btn.tag - 1000];
        [appDelegate.appDefault setObject:appDelegate.messageArray forKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]];
        [appDelegate.messageArray removeAllObjects];
        [self.messageTableView reloadData];
        
        
        if ([[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count]==0)
        {
            [_messageTableView removeFromSuperview];
            _label.frame = CGRectMake(20, 200, 280, 60);
            _label.textAlignment = NSTextAlignmentCenter;
            _label.text =@"您还没有设备分享信息";
            _label.hidden = NO;
            _label.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_label];
        }
        
        
        
    }
    else
    {
         [activity stop];
        //提示框提示错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[appDelegate.appDefault objectForKey:@"Error_message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 444;
        [alert show];

    
    }
    
    [activity stop];



}

@end
