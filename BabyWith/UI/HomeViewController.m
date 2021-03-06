//
//  HomeViewController.m
//  BabyAgent
//
//  Created by Fly on 14-3-12.
//  Copyright (c) 2014年 lifei. All rights reserved.
//

#import "HomeViewController.h"
#import "CameraAddingViewController.h"
#import "DeviceConnectManager.h"
#import "MainAppDelegate.h"
#import "CameraPlayViewController.h"
#import "NewMessageViewController.h"
#import "CommonProblemsGuideViewController.h"
#include "Configuration.h"
#import "WebInfoManager.h"
#import "Activity.h"
#import "HomeCell.h"
#import "AddDeviceViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()
{

    Activity *activity;

}
@property (strong ,nonatomic) NSMutableArray *deviceArray;

@end

@implementation HomeViewController

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
    
    // Do any additional setup after loading the view from its nib.
    _homeTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44 - 50) style:UITableViewStylePlain];
    _homeTableView1.delegate = self;
    _homeTableView1.dataSource = self;
    _homeTableView1.backgroundView = nil;
    _homeTableView1.backgroundColor = [UIColor whiteColor];
    if (IOS7) {
        _homeTableView1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.view addSubview:_homeTableView1];
    
    activity = [[Activity alloc] initWithActivity:self.view];
    
    //tempState = @"设备正在连接...";

    deviceDic = [[NSMutableDictionary alloc] init];
    
    //常见问题指南等视图
    [self HeaderView];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(30, -30, 20, 20)];
    [navButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(bind:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    mycontinue = TRUE;
    //[self titleSet:@"主页"];
    
    titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页.png"]];
    titleImage.frame = CGRectMake(110, 10, 100, 25);
    [self.navigationController.navigationBar addSubview:titleImage];
    _willDeleteDevice = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    _wifiFlag = 0;
    
    

//        if (_switchFlag == 0)
//        {
//            
//            //检测网络状态
//            Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//            
//            if ([r currentReachabilityStatus] == NotReachable)
//            {
//                [self makeAlert:@"网络中断，请确认"];
//                _wifiFlag = 0;
//                return;
//            }
//            else if([r currentReachabilityStatus] == ReachableViaWWAN)
//            {
//                
//                if (_wifiFlag == 0)
//                {
//                    //[self makeAlert:@"检测到非WIFI网络，如有需要，请手动开启视频"];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到非WIFI网络，确认开启视频吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认开启", nil];
//                    alert.tag = 100;
//                    [alert show];
//                    _wifiFlag = 1;
//                    return;
//                }
//                
//            }
//            else
//            {
//                _wifiFlag = 0;
//            }
//            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                
//                NSLog(@"%d",[self.deviceArray count]);
//                
//                for(int i=0;i<[self.deviceArray count];i++)
//                {
//                    NSLog(@"dddd");
//                    _switchFlag = 0;
//                    mycontinue = TRUE;
//
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                        //开启
//                        [self ConnectCamForUnEqual:[self.deviceArray objectAtIndex:i] currentNum:i];
//                    });
//                    while (mycontinue) {
//                        NSLog(@"我再等待你");
//                    }
//                }
//
//            });
//                       
//        }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageCount:) name:@"changeCount" object:nil];
    
}

-(void)HeaderView
{
    
    NSArray * arr = [[NSArray alloc] initWithObjects:@"常见问题指南",@"新设备分享", nil];
    
    NSInteger yyy = 0;
    
    for(int i=0;i<[arr count];i++)
    {
        
        UIButton * buttonTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonTitle setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        buttonTitle.titleLabel.font = [UIFont systemFontOfSize:13.0];
        buttonTitle.frame = CGRectMake(0, yyy, 320, 45);
        [buttonTitle setBackgroundImage:[UIImage imageNamed:@"主页- 消息背景 (2).png"] forState:UIControlStateNormal];
        [buttonTitle setBackgroundImage:[UIImage imageNamed:@"主页- 消息背景 (2).png"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
        [buttonTitle setBackgroundColor:[UIColor clearColor]];
        [buttonTitle setAdjustsImageWhenHighlighted:NO];
        buttonTitle.titleLabel.textColor = babywith_color(0x626262);
        buttonTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        buttonTitle.contentEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
        buttonTitle.tag = i+101;
        [buttonTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonTitle addTarget:self action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttonTitle];
        
        UIImageView * jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-25,17.5, 7, 13)];
        [jiantou setImage:[UIImage imageNamed:@"qietu_40.png"]];
        [buttonTitle addSubview:jiantou];
        
        if(i==1)
        {
            
            aImageVie = [[UIImageView alloc] initWithFrame:CGRectMake(260, 12.5, 20, 20)];
            aImageVie.image = [UIImage imageNamed:@"主页-消息.png"];
            [buttonTitle addSubview:aImageVie];
            tuisongLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            tuisongLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)[[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count]];
            tuisongLabel.textColor = [UIColor whiteColor];
            tuisongLabel.textAlignment = NSTextAlignmentCenter;
            tuisongLabel.backgroundColor = [UIColor clearColor];
            //tuisongLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"主页-消息.png"]];
            [aImageVie addSubview:tuisongLabel];
            
            if ([[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count] == 0)
            {
                aImageVie.hidden = YES;
            }
            else
            {
                aImageVie.hidden = NO;
               [((UIButton *)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:@"系统消息未读背景.png"] forState:UIControlStateNormal];
            }

        }
        
        
        yyy = 45;
    }
    
    CGRect yyyyy = _homeTableView1.frame;
    if(IOS7)
    {
       yyyyy.origin.y = yyy+60;
    }
    else
    {
        yyyyy.origin.y = yyy+60;
    }
    
    yyyyy.size.height = self.view.frame.size.height - yyy- 44 - 50+10;
    _homeTableView1.frame = yyyyy;
    
}


-(void)onclick:(id)sender
{
    [appDelegate hideTabbar];
    UIButton * btn = (UIButton *) sender;
    switch (btn.tag) {
        case 101:
        {
            CommonProblemsGuideViewController *guideVC = [[CommonProblemsGuideViewController alloc] init];
            [self.navigationController pushViewController:guideVC animated:YES];
        }
            break;
        case 102:
        {
            [((UIButton *)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:@"主页- 消息背景 (2).png"] forState:UIControlStateNormal];
            NewMessageViewController * newMessageVC = [[NewMessageViewController alloc] init];
            [self.navigationController pushViewController:newMessageVC animated:YES];
        }
            break;
        default:
            break;
    }
}

////未连接或者不在线
//- (void)ConnectCamForUnEqual:(NSMutableDictionary *)dic currentNum:(NSInteger)number{
//    NSLog(@"ConnectCamForUnEqual");
//    
//    [_m_PPPPChannelMgtCondition lock];
//    if (appDelegate.m_PPPPChannelMgt == NULL)
//    {
//        [_m_PPPPChannelMgtCondition unlock];
//        return;
//    }
//    currentDevice = number;
//    currentDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
//    
//    //每次都重新给last_device_id赋值
//    _cameraID = [currentDic objectForKey:@"device_id"];
//    [appDelegate.appDefault setObject:_cameraID forKey:@"Last_device_id"];
//    
//    appDelegate.m_PPPPChannelMgt->pCameraViewController = self;
//    appDelegate.m_PPPPChannelMgt->ChangeStatusDelegate([_cameraID  UTF8String], self);
//    
//    appDelegate.m_PPPPChannelMgt->Stop((char *)[_cameraID UTF8String]);
//    
//    dispatch_async(dispatch_get_main_queue(),^{
//        //        _playView.image = [UIImage imageNamed:@"cameraBackView.png"];
//    });
//    
//    //    [_currentDeviceDic addEntriesFromDictionary:[appDelegate.appDefault objectForKey:@"Device_selected"]];
//    
//    
//    _finishFlag = 1;
//    _passwordFlag = 0;
//    _stopConnectFlag = 0;
//    _errorMsg = @"看护器连接错误";
//    NSLog(@"password 3 is %d",_passwordFlag);
//    MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView:self.view];
//   
//    [indicator showAnimated:YES whileExecutingBlock:^{
//        
//        [self performSelector:@selector(startPPPP:) withObject:currentDic];
//        
//        NSLog(@"stop connect Flag 222222222= [%d] [%d]", _finishFlag, _stopConnectFlag);
//        
//        while (_finishFlag != 0 && _stopConnectFlag == 0) {
//            
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//            
//            
//        }
//    } completionBlock:^{
//        
//        [_m_PPPPChannelMgtCondition unlock];
//        
//        sleep(0.1);
//        
//        if (_stopConnectFlag != 0) {
//            _finishFlag = 0;
//            return;
//        }
//        
//        if (_switchFlag == 1)
//        {
//            NSIndexPath * index = [NSIndexPath indexPathForRow:number inSection:0];
//            tempState = @"摄像机已连接";
//            [_homeTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//        }
//        else if (_switchFlag == 0)
//        {
//            
//            if (_errorFlag == 5)
//            {
//                
//                _finishFlag = 1;
//                _passwordFlag = 0;
//                _stopConnectFlag = 0;
//                NSLog(@"password 4 is %d",_passwordFlag);
//                MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView:self.view];
//                indicator.labelText = _errorMsg;
//                indicator.dimBackground = YES;
//                // [self addTapGest:indicator];
//                [self.view addSubview:indicator];
//                [indicator showAnimated:YES whileExecutingBlock:^{
//                    
//                    while (_finishFlag != 0 && _stopConnectFlag == 0)
//                    {
//                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//                    }
//                } completionBlock:^{
//                    [indicator removeFromSuperview];
//                    
//                }];
//                
//                while (_finishFlag != 0 && _stopConnectFlag == 0)
//                {
//                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//                }
//                
//                if (_stopConnectFlag != 0)
//                {
//                    _finishFlag = 0;
//                    return;
//                }
//                
//                if (_switchFlag == 1)
//                {
////                    NSIndexPath * index = [NSIndexPath indexPathForRow:number inSection:0];
////                    tempState = @"摄像机已连接";
////                    [_homeTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    
//                }else{
//                    //                    [self makeAlert:_errorMsg];
//                    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                    
//                }
//            }else{
//                if ([_errorMsg length] == 0) {
//                    _errorMsg = @"看护器连接错误";
//                }
//                //                [self makeAlert:_errorMsg];
//                
//                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                
//            }
//        }
//        
//    }];
//    
//}
//
//-(void)startPPPP:(NSDictionary *)device{
//    appDelegate.m_PPPPChannelMgt->Start([[device objectForKey:@"device_id"] UTF8String], (char *)[DeviceInitUser UTF8String],[[device objectForKey:@"pass"] UTF8String]);
//}
//
//#pragma mark -PPPPStatusDelegate
//- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status
//{
//    NSString* strPPPPStatus;
//    switch (status)
//    {
//        case PPPP_STATUS_UNKNOWN:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_CONNECTING:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_INITIALING:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_CONNECT_FAILED:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_DISCONNECT:
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
//            if(_finishFlag != 1 && _switchFlag == 1)
//            {
//                //视频播放中 连接失败
//                [self ConnectCamForUnEqual:[self.deviceArray objectAtIndex:currentDevice] currentNum:currentDevice];
//            }
//            
//            break;
//        case PPPP_STATUS_INVALID_ID:
//            NSLog(@"PPPP_STATUS_INVALID_ID");
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
//            if (_finishFlag == 1) {
//                _errorFlag = 1; //序列号错误
//                _errorMsg = @"看护器序列号错误";
//                
//                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//            }
//            break;
//        case PPPP_STATUS_ON_LINE:
//            NSLog(@"PPPP_STATUS_ON_LINE");
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
//            NSLog(@"PPPP_STATUS_DEVICE_NOT_ON_LINE");
//            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
//            if (_finishFlag == 1) {
//                _errorFlag = 2;
//                _errorMsg = @"看护器不在线";
//                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//            }
//            break;
//        case PPPP_STATUS_CONNECT_TIMEOUT:
//            NSLog(@"time out===============================");
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
//            if (_finishFlag == 1) {
//                _errorFlag = 3;
//                _errorMsg = @"看护器连接超时";
//                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//            }
//            break;
//        case PPPP_STATUS_INVALID_USER_PWD:
//            NSLog(@"PPPP_STATUS_INVALID_USER_PWD");
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
//            
//            //校验密码是否为初始密码，如果不是，用初始密码重新连接
//            if (![[currentDic objectForKey:@"pass"] isEqualToString:DeviceInitPass])
//            {
//                NSLog(@"passwordFlag is5 %d",_passwordFlag);
//                
//                if (_passwordFlag != 1)
//                {
//                    _passwordFlag = 1;
//                    //校验密码
//                    appDelegate.m_PPPPChannelMgt->CheckUser((char *)[_cameraID UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[DeviceInitPass UTF8String]);
//                    NSLog(@"password 6 is %d",_passwordFlag);
//                }
//                else
//                {
//                    NSLog(@"password 7 is %d",_passwordFlag);
//                    
//                    _errorFlag = 4;
//                    _errorMsg = @"看护器连接错误，请重置看护器";
//                    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                    [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//                }
//            }
//            else
//            {
//                _errorFlag = 4;
//                _errorMsg = @"看护器账号连接错误，请重置看护器";
//                tempState = @"看护器账号连接错误，请重置看护器";
//                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//                
//            }
//            
//            break;
//        case PPPP_STATUS_VALID_USER_PWD:
//            NSLog(@"PPPP_STATUS_VALID_USER_PWD");
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPP_STATUS_VALID_USER_PWD", @STR_LOCALIZED_FILE_NAME, nil);
//            //校验密码是否为初始密码，如果是，修改密码 -- 可放置在对象中完成
//            if (![[currentDic objectForKey:@"pass"] isEqualToString:DeviceInitPass])
//            {
//                if (_passwordFlag == 1)
//                {
//                    
//                    NSLog(@"password 8 is %d",_passwordFlag);
//                    //修改密码
//                    appDelegate.m_PPPPChannelMgt->SetUserPwdForOther((char *)[_cameraID UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[DeviceInitPass UTF8String]);
//                    
//                    //重启看护器
//                    appDelegate.m_PPPPChannelMgt->RebootDevice((char *)[_cameraID UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[DeviceInitPass UTF8String]);
//                    
//                    _errorFlag = 5;
//                    _errorMsg = @"看护器重启中,\n请等待";
//                    tempState = @"看护器重启中，请等待...";
//                    [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//                    
//                }
//                else
//                {
//                    
//                    appDelegate.m_PPPPChannelMgt->SetOnlineFlag((char *)[_cameraID UTF8String], 2);
//                    NSLog(@"camera id is %@",_cameraID);
//                    NSLog(@"camera dic is %@",currentDic);
//                    
//                    if ([[[currentDic objectForKey:@"id_member"] stringValue] isEqualToString:@"1"])
//                    {
//                        
//                        
//                        
//                        
//                        if ([appDelegate.appDefault objectForKey:_cameraID] == nil)
//                        {
//                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"512", @"quality", @"0", @"sense",@"0",@"inputSense", nil];
//                            [appDelegate.appDefault setObject:dic  forKey:_cameraID];
//                        }
//                        
//                    }
//                    else
//                    {
//                        
//                        if ([appDelegate.appDefault objectForKey:_cameraID] == nil)
//                        {
//                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"512", @"quality",nil];
//                            [appDelegate.appDefault setObject:dic  forKey:_cameraID];
//                        }
//                        
//                        
//                        
//                    }
//                    _finishFlag = 0;
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSIndexPath * index = [NSIndexPath indexPathForRow:currentDevice inSection:0];
//                        tempState = @"摄像机已连接";
//                        mycontinue = FALSE;
//                        [_homeTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"connectDevice"];
//                        _switchFlag = 1;
//
//                    });
//                  
//                    
//                    
//                    
//                    //设置视频质量
//                    appDelegate.m_PPPPChannelMgt->CameraControl( (char *)[_cameraID UTF8String],13, [[[appDelegate.appDefault objectForKey:_cameraID] objectForKey:@"quality"] integerValue]);
//                    
//                    
//                    if ([[[currentDic objectForKey:@"id_member"] stringValue] isEqualToString:@"1"])
//                    {
//                        appDelegate.m_PPPPChannelMgt->SetAlarmDelegate((char *)[_cameraID UTF8String],appDelegate);
//                        //移动侦测回调接收
//                        appDelegate.m_PPPPChannelMgt->SetSensorAlarmDelegate((char *)[_cameraID UTF8String],appDelegate);
//                        //设置移动侦测
//                        appDelegate.m_PPPPChannelMgt->SetAlarm((char *)[_cameraID UTF8String],[[[appDelegate.appDefault objectForKey:_cameraID] objectForKey:@"sense"] integerValue], 1, [[[appDelegate.appDefault objectForKey:_cameraID] objectForKey:@"inputSense"] integerValue], 0, 0, 1, 0, 0, 0, 0);
//                    }
//                    
//                }
//            }
//            else
//            {
//                //生成随机数，修改密码
//                int randInt = [[currentDic objectForKey:@"pass"] integerValue];
//                while (randInt == [[currentDic objectForKey:@"pass"] integerValue])
//                {
//                    randInt = [self getRandomNumber:100000 to:999999];
//                }
//                //                randInt = 888888;
//                
//                //通知服务器密码已修改
//                BOOL result = [appDelegate.webInfoManger UserModifyDevicePasswordUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:_cameraID DeviceUser:[currentDic objectForKey:@"name"] DevicePasswd:[NSString stringWithFormat:@"%d", randInt]];
//                
//                if (result) {
//                    //修改密码
//                    appDelegate.m_PPPPChannelMgt->SetUserPwd((char *)[_cameraID UTF8String], (char *)"", (char *)"", (char *)"", (char *)"", (char *)[[currentDic objectForKey:@"name"] UTF8String], (char *)[[NSString stringWithFormat:@"%d", randInt] UTF8String]);
//                    
//                    //设置devicelist
//                    [appDelegate.deviceConnectManager modifyDevicePassword:_cameraID Password:[NSString stringWithFormat:@"%d", randInt]];
//                    [currentDic addEntriesFromDictionary:[appDelegate.deviceConnectManager getDeviceInfo:_cameraID]];
//                    
//                    NSLog(@"current device = [%@][%@]",currentDic, [appDelegate.deviceConnectManager getDeviceInfo:_cameraID]);
//                    
//                    //重启看护器
//                    appDelegate.m_PPPPChannelMgt->PPPPSetSystemParams((char *)[_cameraID UTF8String], MSG_TYPE_REBOOT_DEVICE, nil, 0);
//                    
//                    //重设账户密码
//                    appDelegate.m_PPPPChannelMgt->SetUserAndPwd((char *)[_cameraID UTF8String], (char *)[DeviceInitUser UTF8String], (char *)[[NSString stringWithFormat:@"%d", randInt] UTF8String]);
//                    
//                    _errorFlag = 5;
//                    _errorMsg = @"看护器重启中,\n请等待";
//                    [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//                }else{
//                    _errorFlag = 6;
//                    _errorMsg = @"设备连接错误";
//                    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"connectDevice"];
//
//                    [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//                }
//            }
//            break;
//        case PPPP_STATUS_CONNECT_SUCCESS:
//            NSLog(@"PPPP_STATUS_CONNECT_SUCCESS, manager = [%@]", self);
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectSuccess", @STR_LOCALIZED_FILE_NAME, nil);
//            break;
//        default:
//            NSLog(@"PPPPStatusUnknown");
//            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
//            [self performSelectorOnMainThread:@selector(Finish:) withObject:@"0" waitUntilDone:NO];
//            break;
//    }
//    NSLog(@"PPPPStatus  %@",strPPPPStatus);
//}
//
//-(void)Finish:(NSString *)flag{
//    if (_finishFlag == 0) {
//        _switchFlag = 0;
//        NSIndexPath * index = [NSIndexPath indexPathForRow:currentDevice inSection:0];
//        tempState = _errorMsg;
//        mycontinue = FALSE;
//        [_homeTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    }else{
//        _finishFlag = 0;
//        NSIndexPath * index = [NSIndexPath indexPathForRow:currentDevice inSection:0];
//        tempState = @"摄像机已连接";
//        mycontinue = FALSE;
//        [_homeTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"connectDevice"];
//        _switchFlag = [flag integerValue];
//    }
//    
//}

-(void)changeMessageCount:(NSNotification*)NSNotification
{
    tuisongLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)[[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count]];
    
    if ([[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count] == 0)
    {
        aImageVie.hidden = YES;
        [((UIButton *)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:@"主页- 消息背景 (2).png"] forState:UIControlStateNormal];
    }
    else
    {
        aImageVie.hidden = NO;
        [((UIButton *)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:@"系统消息未读背景.png"] forState:UIControlStateNormal];
    }

}
- (void)viewWillAppear:(BOOL)animated{
    
//    NSLog(@"view will appear");
    //获取设备列表，并且刷新数据
     [appDelegate showTabbar];
    self.deviceArray = [appDelegate.deviceConnectManager getDeviceInfoList];
    
    NSLog(@">>>>>%@",self.deviceArray);
    
    [_homeTableView1 reloadData];
    titleImage.hidden = NO;
    
    if (50.0*[self tableView:_homeTableView1 numberOfRowsInSection:0] > self.view.frame.size.height- 90 - 15 - 50)
    {
        _homeTableView1.frame = CGRectMake(0, 105, 320, self.view.frame.size.height - 90   - 50 - 15);
    }
    else
    {
        _homeTableView1.frame = CGRectMake(0, 105, 320, 50.0*[self tableView:_homeTableView1 numberOfRowsInSection:0]);
        
    }
    
    tuisongLabel.text =[NSString stringWithFormat:@"%lu",(unsigned long)[[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count]];
    
    if ([[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@$",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count] == 0)
    {
        aImageVie.hidden = YES;
        [((UIButton *)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:@"主页- 消息背景 (2).png"] forState:UIControlStateNormal];
    }
    else
    {
        aImageVie.hidden = NO;
        [((UIButton *)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:@"系统消息未读背景.png"] forState:UIControlStateNormal];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{

    titleImage.hidden = YES;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//进入到添加设备页面
- (void)bind:(UIBarButtonItem *)item
{
    
    [appDelegate hideTabbar];
    AddDeviceViewController *vc = [[AddDeviceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    NSLog(@"array is %@",self.deviceArray);
    return [self.deviceArray count];
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *cellIdentifier3 = @"cell3";
    HomeCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    if (!cell3) {
        cell3 = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
    }
    

//    if([deviceDic objectForKey:[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"device_id"]])
//    {
//        if([[deviceDic objectForKey:[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"device_id"]] isEqualToNumber:[NSNumber numberWithInt:2]])
//        {
//            cell3.isShare.text = @"分享自好友";
//        }
//        else
//        {
//            cell3.isShare.hidden = YES;
//        }
//    }
//    [deviceDic setObject:[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"id_member"] forKey:[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"device_id"]];
    
    [cell3.image setImage:[UIImage imageNamed:@"主页摄像头.png"]];
    cell3.title.text =[[self.deviceArray  objectAtIndex: indexPath.row ]objectForKey:@"name"];
    
    
//    NSLog(@"《1----》%d》《3----》%@》",indexPath.row,[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"id_member"]);
    
    if([[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"id_member"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [cell3.isShare setHidden:NO];
        cell3.state.text = @"我的设备";
    }
    else
    {
        cell3.isShare.hidden = NO;
        if ([[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"nickeName"])
        {
            if ([[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"nickeName"] length] == 0)
            {
                cell3.state.text = @"被分享的设备";
            }
            else
            {
            cell3.state.text = [NSString stringWithFormat:@"来自%@的设备",[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"nickeName"]];
            }
        }
        else
        {
        
            cell3.state.text = @"被分享的设备";
        
        }
        
    }
    cell3.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   return YES;
  
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _willDeleteDevice =[NSMutableDictionary dictionaryWithDictionary:[[appDelegate.deviceConnectManager getDeviceInfoList] objectAtIndex:indexPath.row]];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要解绑该设备吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 2046;
    [alert show];
    
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 2046)
    {
       
    if (buttonIndex == 1)
    {
        
        [activity start];
        //设备解绑
        BOOL result = [appDelegate.webInfoManger UserUnbindDeviceUsingToken:[appDelegate.appDefault objectForKey:@"Token"] DeviceId:[_willDeleteDevice objectForKey:@"device_id"]];
        
        if (result)
        {
            [activity stop];
            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView: self.view];
            indicator.labelText = @"设备解绑成功";
            indicator.mode = MBProgressHUDModeText;
            [self.view addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                
                if ([self.deviceArray containsObject:_willDeleteDevice])
                {
                    [self.deviceArray removeObject:_willDeleteDevice];
                    
                    NSLog(@"sense and inputSense are %@,%@",[[appDelegate.appDefault objectForKey:[_willDeleteDevice objectForKey:@"device_id"]] objectForKey:@"sense"],[[appDelegate.appDefault objectForKey:[_willDeleteDevice objectForKey:@"device_id"]] objectForKey:@"inputSense"]);
                    
                    if ([[appDelegate.appDefault objectForKey:[_willDeleteDevice objectForKey:@"device_id"]] objectForKey:@"sense"])
                    {
                        [appDelegate.appDefault removeObjectForKey:[[appDelegate.appDefault objectForKey:[_willDeleteDevice objectForKey:@"device_id"]] objectForKey:@"sense"]];
                    }
                    
                    if ([[appDelegate.appDefault objectForKey:[_willDeleteDevice objectForKey:@"device_id"]] objectForKey:@"inputSense"])
                    {
                        [appDelegate.appDefault removeObjectForKey:[[appDelegate.appDefault objectForKey:[_willDeleteDevice objectForKey:@"device_id"]] objectForKey:@"inputSense"]];
                    }
                    

                    [_homeTableView1 reloadData];
                    if (50.0*[self tableView:_homeTableView1 numberOfRowsInSection:0] > self.view.frame.size.height- 90 - 15 - 50)
                    {
                        _homeTableView1.frame = CGRectMake(0, 105, 320, self.view.frame.size.height - 90   - 50 - 15);
                    }
                    else
                    {
                        _homeTableView1.frame = CGRectMake(0, 105, 320, 50.0*[self tableView:_homeTableView1 numberOfRowsInSection:0]);
                        
                    }
                }
            }];
            
        }
        else
        {
            [activity stop];
            
            
//            NSLog(@"sdasdddddddddd%@",[appDelegate.appDefault objectForKey:@"Error_message"]);
            
            if ([[appDelegate.appDefault objectForKey:@"Error_message"] isEqualToString:@"该设备已被分享者解绑"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[appDelegate.appDefault objectForKey:@"提示"] message:[NSString stringWithFormat:@"%@,是否删除该设备？",[appDelegate.appDefault objectForKey:@"Error_message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 2049;
                [alert show];
            }
            else
            {
                
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[appDelegate.appDefault objectForKey:@"提示"] message:[appDelegate.appDefault objectForKey:@"Error_message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 2048;
            [alert show];
            }
        }
    }
        
    }
    else if (alertView.tag == 2048)
    {
        
    
        if ([[appDelegate.appDefault objectForKey:@"login_expired"] isEqualToString:@"1"])
        {
            [appDelegate.appDefault setObject:@"" forKey:@"Username"];
            [appDelegate.appDefault setObject:@"" forKey:@"Password"];
            
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [appDelegate hideTabbar];
            [self.navigationController pushViewController:loginVC animated:YES];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToLogin" object:nil];
        }
        else
        {
            
//            NSLog(@"没有被踢");
            
        }
        
    }
    else if (alertView.tag == 2049)
    {
    
        if (buttonIndex == 1)
        {
            
//            NSLog(@"device id is %@",[_willDeleteDevice objectForKey:@"device_id"]);
            [appDelegate.deviceConnectManager removeDeviceInfo:[_willDeleteDevice objectForKey:@"device_id"]];
            if ([self.deviceArray containsObject:_willDeleteDevice])
            {
                [self.deviceArray removeObject:_willDeleteDevice];
            }
//            NSLog(@"jjjjjjjj%@",self.deviceArray);
            [_homeTableView1 reloadData];
            if (50.0*[self tableView:_homeTableView1 numberOfRowsInSection:0] > self.view.frame.size.height- 90 - 15 - 50)
            {
                _homeTableView1.frame = CGRectMake(0, 105, 320, self.view.frame.size.height - 90   - 50 - 15);
            }
            else
            {
                _homeTableView1.frame = CGRectMake(0, 105, 320, 50.0*[self tableView:_homeTableView1 numberOfRowsInSection:0]);
                
            }
            
            
        }
        else
        {
        
            [_homeTableView1 reloadData];
        
        }
    
    
    
    
    }
//    else if(alertView.tag ==5588)
//    {
//        if(buttonIndex==0)
//        {
//            NSIndexPath * index = [NSIndexPath indexPathForRow:currentDevice inSection:0];
//            tempState = @"设备正在连接...";
//            [_homeTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self ConnectCamForUnEqual:[self.deviceArray objectAtIndex:currentDevice] currentNum:currentDevice];
//        }
//        else
//        {
//            
//        }
//    }
    


}
#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //HomeCell * cell = (HomeCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if([cell.state.text isEqualToString:@"设备正在连接..."])
//    {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备正在连接，请等待..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else
//    {
//        int result = appDelegate.m_PPPPChannelMgt->CheckOnlineReturn((char *)[[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"device_id"] UTF8String]);
//        
//        if (result <= 0)
//        { //不在线 或未连接，
//            NSLog(@"device is not connected or is not online============");
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备未开启，请重新开启." delegate:self cancelButtonTitle:@"重新开启" otherButtonTitles:@"取消", nil];
//            currentDevice = indexPath.row;
//            alert.tag = 5588;
//            [alert show];
//        }
//        else
//        {
//            [appDelegate.appDefault setObject:[self.deviceArray objectAtIndex:indexPath.row] forKey:@"Device_selected"];
//            NSLog(@"存入的设备是%@",[appDelegate.appDefault objectForKey:@"Device_selected"]);
//            CameraPlayViewController *vc = [[CameraPlayViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
    
    [appDelegate hideTabbar];
    [appDelegate.appDefault setObject:[self.deviceArray objectAtIndex:indexPath.row] forKey:@"Device_selected"];
    
    if ([[[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"id_member"] stringValue] isEqualToString:@"2"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat:@"%@_number",[[self.deviceArray objectAtIndex:indexPath.row] objectForKey:@"device_id"]]];
        
        
        
    }
//    NSLog(@"存入的设备是%@",[appDelegate.appDefault objectForKey:@"Device_selected"]);
    CameraPlayViewController *vc = [[CameraPlayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
