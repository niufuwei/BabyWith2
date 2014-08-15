//
//  AddDeviceViewController.m
//  SkyEye
//
//  Created by shanchen on 14-7-8.
//  Copyright (c) 2014年 kang_dong. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "MainAppDelegate.h"
#import "MBProgressHUD.h"
#import "Configuration.h"
#import "DeviceConnectManager.h"
#import "WebInfoManager.h"
#import "UIViewController+Alert.h"
#import "Activity.h"
#import "DeviceListCell.h"
@interface AddDeviceViewController ()
{

    Activity *activity;

}
@end

@implementation AddDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{

    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                
                        [device unlockForConfiguration];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"绑定设备";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    
    [self leftButtonItemWithImageName:@"导航返回.png"];
    
    //右导航--设置按钮
    setButton = [[UIButton alloc] initWithFrame:CGRectMake(30, -30, 20, 20)];
    [setButton setBackgroundImage:[UIImage imageNamed:@"开灯.png"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(turnTorchOn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: setButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    isOn = YES;
    
    
    isFirst = TRUE;
    [self ShowZBarView];
    [self loadButtomView];
    
    _cameraSearchList = [[NSMutableArray alloc] initWithCapacity:1];
    _alreadyGotDeviceIdArr =  [[NSMutableArray alloc] initWithCapacity:1];
    _searchDeviceIdArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    
//    NSLog(@"already is %@",[appDelegate.deviceConnectManager getDeviceInfoList]);
    for (id obj in [appDelegate.deviceConnectManager getDeviceInfoList])
    {
        if (![_alreadyGotDeviceIdArr containsObject:[obj objectForKey:@"device_id"]])
        {
            [_alreadyGotDeviceIdArr addObject:[obj objectForKey:@"device_id"]];

        }
//        NSLog(@"already arr is %@",_alreadyGotDeviceIdArr);
    }
    
    
    
    //局域网搜索
    _pSearchDVS = new CSearchDVS();
    _pSearchDVS->searchResultDelegate = self;
    
    
}
//局域网搜索设备
-(void)SearchDevice{
    
    
    
    [activity start];
    _pSearchDVS->Close();
    
    [_cameraSearchList removeAllObjects];
    
    //[deviceListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    _pSearchDVS->Open();
}
//搜索设备的代理方法
- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    
//    NSLog(@"11111111111111111111111111111111111111name is %@,did is %@",name,did);
    int  flag = 0;
    //去掉重复
    for (NSDictionary *dic in _cameraSearchList)
    {
        if ([[dic objectForKey:@"uid"] isEqualToString:did])
        {
            flag = 1;
//            NSLog(@"去除重复");
            break;
        }
        
        
        
    }
    
    if (flag == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name", did, @"uid", nil];
        [_cameraSearchList addObject:dic];
//        NSLog(@"调用刷新方法");
       [deviceListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
}
-(void)tableviewReloadData
{
    
    
    [activity stop];
    
   

}
-(void)loadButtomView
{

    NSInteger yyyy=0;
    if(isFirst)
    {
        yyyy =self.view.frame.size.height-50 - 50 - 10;
        isFirst = FALSE;
    }
    else
    {
        yyyy=self.view.frame.size.height-50 - 50 -10;
    }
    
    if (IOS7) {
        yyyy=self.view.frame.size.height-50 - 50 -10;
    }
    else
    {
        yyyy=self.view.frame.size.height-50 - 50 +10;
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, yyyy, self.view.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor blackColor]];
    
    //NSArray * arr = [[NSArray alloc] initWithObjects:@"二维码",@"局域网",@"手动输入", nil];
    
    NSInteger xxx=0;
    
    for(int i=0;i<3;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xxx, 0, self.view.frame.size.width/3, 50);
        
        button.tag = i+1;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        if (button.tag == 1)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"绑定设备-选中 (1)"] forState:UIControlStateNormal];
            button.enabled = NO;
        }
        else
        {
            
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"绑定-未选 (%d)",i+1 ]] forState:UIControlStateNormal];
            
        }
        
        xxx = button.frame.size.width+button.frame.origin.x;
    }
    [self.view addSubview:view];

}

-(void)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    if(btn.tag == 1)
    {
        [_aTimer invalidate];
        _aTimer = nil;
        
        [activity stop];
        btn.enabled = NO;
        ((UIButton*)[self.view viewWithTag:2]).enabled = YES;
        if (timer != nil)
        {
            [timer invalidate];
            timer = nil;
        }
        loadDevice = NO;
        _pSearchDVS->Close();
        [_searchDeviceIdArr removeAllObjects];
        
        if (self.previewLayer)
        {
            [self.previewLayer removeFromSuperlayer];
        }
        if (_labIntroudction)
        {
            [_labIntroudction removeFromSuperview];
        }
        if (_line)
        {
            [_line removeFromSuperview];
        }
        if (_imageView)
        {
            [_imageView removeFromSuperview];
        }
            [inputView removeFromSuperview];
            [deviceListView removeFromSuperview];
            [((UIButton*)[self.view viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"绑定-未选 (2)"] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"绑定-未选 (3)"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"绑定设备-选中 (1)"] forState:UIControlStateNormal];
            [self ShowZBarView];
            
        
    }
    else if(btn.tag == 3)
    {
        [_aTimer invalidate];
        _aTimer = nil;
        [activity stop];
        
        ((UIButton *)[self.view viewWithTag:1]).enabled = YES;
        ((UIButton*)[self.view viewWithTag:2]).enabled = YES;
        if (timer != nil)
        {
            [timer invalidate];
            timer = nil;
        }
        loadDevice = NO;
         _pSearchDVS->Close();
        [_searchDeviceIdArr removeAllObjects];

        if (self.previewLayer)
        {
            [self.previewLayer removeFromSuperlayer];
        }
        if (_labIntroudction)
        {
            [_labIntroudction removeFromSuperview];
        }
        if (_line)
        {
            [_line removeFromSuperview];
        }
        if (_imageView)
        {
            [_imageView removeFromSuperview];
        }
        [inputView removeFromSuperview];
        [deviceListView removeFromSuperview];


        
        [((UIButton*)[self.view viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"绑定-未选 (1)"] forState:UIControlStateNormal];
        [((UIButton*)[self.view viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"绑定-未选 (2)"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"绑定设备-选中 (3)"] forState:UIControlStateNormal];
        
        
        inputView = [[UIView alloc] initWithFrame:CGRectMake(10, 74, 300, 130)];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.layer.cornerRadius = 5.0;
        
        UILabel *inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 200, 20)];
        inputLabel.backgroundColor = [UIColor clearColor];
        inputLabel.font = [UIFont systemFontOfSize:13.0];
        inputLabel.text = @"请输入15位产品序列号";
        [inputView addSubview:inputLabel];
        
        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 40, 268, 33)];
        inputTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"输入框"]];
        inputTextField.font = [UIFont systemFontOfSize:13.0];
        inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        inputTextField.placeholder = @"产品序列号";
        inputTextField.tag = 20;
        inputTextField.layer.cornerRadius = 1.5;
        [inputView addSubview:inputTextField];
        
        UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bindBtn.frame = CGRectMake(45, 90, 210, 31);
        [bindBtn setBackgroundImage:[UIImage imageNamed:@"qietu_164.png"] forState:UIControlStateNormal];
        [bindBtn addTarget:self action:@selector(ButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:bindBtn];
        [self.view addSubview:inputView];
        
       
    }
    else if(btn.tag == 2)
    {
         btn.enabled = NO;
        [activity stop];
        _pSearchDVS->Close();
        loadDevice = NO;
        [_searchDeviceIdArr removeAllObjects];
        ((UIButton *)[self.view viewWithTag:1]).enabled = YES;

        [inputView removeFromSuperview];
        if (timer != nil)
        {
            [timer invalidate];
            timer = nil;
        }
        
        
        if (self.previewLayer)
        {
            [self.previewLayer removeFromSuperlayer];
        }
        if (_labIntroudction)
        {
            [_labIntroudction removeFromSuperview];
        }
        if (_line)
        {
            [_line removeFromSuperview];
        }
        if (_imageView)
        {
            [_imageView removeFromSuperview];
        }
        [deviceListView removeFromSuperview];

        
        [((UIButton*)[self.view viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"绑定-未选 (1)"] forState:UIControlStateNormal];
        [((UIButton*)[self.view viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"绑定-未选 (3)"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"绑定设备-选中 (2)"] forState:UIControlStateNormal];
        
        
        deviceListView = [[UIView alloc] initWithFrame:CGRectMake(10, 74, 300, 130)];
        deviceListView.backgroundColor = [UIColor whiteColor];
        deviceListView.layer.cornerRadius = 5.0;
        
        
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 100, 20)];
        warnLabel.text = @"请选择设备";
        warnLabel.textAlignment = NSTextAlignmentCenter;
        warnLabel.backgroundColor = [UIColor clearColor];
        warnLabel.font = [UIFont systemFontOfSize:14.0];
        [deviceListView addSubview:warnLabel];
        
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 31, 300, 1)];
        lineImage.image = [UIImage imageNamed:@"分隔栏.png"];
        [deviceListView addSubview:lineImage];
        
        
        deviceListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, 300, 95) style:UITableViewStylePlain];
        deviceListTableView.backgroundColor = [UIColor clearColor];
        deviceListTableView.delegate = self;
        deviceListTableView.dataSource = self;
        if (IOS7) {
            deviceListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        
        [deviceListView addSubview:deviceListTableView];
        
        
        [self.view addSubview:deviceListView];
        
        [deviceListView setHidden:YES];
        activity = [[Activity alloc] initWithActivity:self.view];

        
        [self SearchDevice];
//        NSLog(@",,,,,,,,,,,,,,,,,%@",_cameraSearchList);
        
    _aTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(searchResultCharge) userInfo:nil repeats:NO];
        
        
        
    }
}
-(void)searchResultCharge
{

    if ([_cameraSearchList count] == 0)
    {
//        NSLog(@"没有搜到设备");
        [activity stop];
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"没有搜到设备";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
        }];
        
        
    }
    

}
- (void) turnTorchOn{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (isOn) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                isOn = NO;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                
                isOn = YES;
            }
            [device unlockForConfiguration];
        }
    }
}
-(void)ShowZBarView{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0)
    {
        //使用系统自带的二维码扫描
        [self readQRcode];
        
    }
    else
    {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        
        //扫面范围
        CGRect scanMaskRect = CGRectMake(40, CGRectGetMidY(reader.view.frame)-166, 240, 240);
        reader.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:reader.view.bounds];
        UITextField *backgroundTF = [[UITextField alloc]initWithFrame:scanMaskRect];
        backgroundTF.borderStyle = UITextBorderStyleBezel;
        backgroundTF.userInteractionEnabled = NO;
        [reader.view addSubview:backgroundTF];
        
        //扫描横线
        UIImageView *animaitionView = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMidY(reader.view.frame)-166, 240, 2)];
        animaitionView.image = [UIImage imageNamed:@"line.png"];
        [reader.view addSubview:animaitionView];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, CGRectGetMidY(reader.view.frame)-166 - 5, 250, 250)];
        imageView.image = [UIImage imageNamed:@"pick_bg"];
        [reader.view addSubview:imageView];
        
        
        UILabel *description = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMidY(reader.view.frame)+ 100, 260, 20)];
        description.backgroundColor = [UIColor clearColor];
        description.textAlignment=YES;
        description.numberOfLines=1;
        description.textColor=[UIColor whiteColor];
        description.text=@"将设备底部二维码放入框内,可自动扫描";
        description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        [reader.view addSubview:description];
        
        
        reader.readerDelegate = self;
        //reader.showsZBarControls = YES;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        reader.showsHelpOnFail = NO;
        [reader setToolbarItems:nil];
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        
        
        [self presentViewController:reader animated:YES completion:^{
            
        } ];
        
        [self performSelector:@selector(animation:) withObject:animaitionView afterDelay:1.0];
        
    }
    
}

-(void)animation1
{
    if (upOrdown == NO)
    {
        num ++;
        _line.frame = CGRectMake(50, 60+2*num, 220, 2);
        if (2*num == 220)
        {
            upOrdown = YES;
        }
    }
    else
    {
        num --;
        _line.frame = CGRectMake(50, 60+2*num, 220, 2);
        if (num == 0)
        {
            upOrdown = NO;
        }
    }
    
}
-(void)readQRcode
{
//    NSArray * viewArray = self.view.subviews;
//    for (UIView *view in viewArray)
//    {
//        view.hidden = YES;
//    }
    
    _labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(30, 290, 260, 50)];
    _labIntroudction.backgroundColor = [UIColor clearColor];
    _labIntroudction.textAlignment=YES;
    _labIntroudction.numberOfLines=1;
    _labIntroudction.textColor=[UIColor whiteColor];
    _labIntroudction.text=@"将设备底部二维码放入框内,可自动扫描";
    _labIntroudction.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [self.view addSubview:_labIntroudction];
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 50, 240, 240)];
    _imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:_imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    
    
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    [session addInput:input];
    
    [session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    
    self.previewLayer = preview;
    
    [session startRunning];
    
    
    
    self.session = session;
    
    
    
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    
    [self.session stopRunning];
    
    [self.previewLayer removeFromSuperlayer];
    
    [_labIntroudction removeFromSuperview];
    [self.line removeFromSuperview];
    [_imageView removeFromSuperview];
    [timer invalidate];
    
    NSArray * viewArray = self.view.subviews;
    for (UIView *view in viewArray)
    {
        view.hidden = NO;
    }
    
    
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self ShowNextSetting:obj.stringValue];
        
    }
}
- (void)animation:(UIImageView *)view
{   //扫描框内动画
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        view.frame = CGRectMake(40, CGRectGetMidY(view.superview.frame)-166+240-2, 240, 2) ;
    } completion:^(BOOL finished) {
        
    }];
}
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    //条形码
    if (symbol.type == 0x80) {
        return;
    }
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToShowTabarMenu" object:self];
    
    [reader dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    /*************************** 二维码通信部分 **************************/
//    NSLog(@"得到的二维码是 %@",symbol.data);
    if (symbol.data.length != 0) {
        
        [self ShowNextSetting:symbol.data];
    }
}
-(void)ButtonPressed
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:20];
    if ([textField.text length] == 0)
    {
        [self makeAlert:@"手动输入序列号不可为空"];
        return;
    }
    [self ShowNextSetting:textField.text];
}

-(void)ShowNextSetting:(NSString *)deviceID{
    
//    NSLog(@"%@",deviceID);
    if([deviceID isEqualToString:@"手动输入"])
    {
//        [self TempMakeAlert:@"未输入看护器序列号"];
         [self makeAlert:@"未输入看护器序列号"];
        return;
    }
    if(![deviceID hasPrefix:@"VST"] || [deviceID length] != 15)
    {
//        [self TempMakeAlert:@"看护器序列号不正确"];
        [self makeAlert:@"看护器序列号不正确"];
        return;
    }
    
    [activity start];
    self.view.userInteractionEnabled = NO;
    //添加设备
    NSString *token = [appDelegate.appDefault objectForKey:@"Token"];
    int i = [appDelegate.deviceConnectManager getDeviceCount];
    BOOL result = [appDelegate.webInfoManger UserAddDeviceUsingDeviceId:deviceID DeviceName:[NSString stringWithFormat:@"第%d个设备",i + 1] Token:token];
    
    if (result)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"看护器绑定成功";
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            [activity stop];
            
            
            
            //绑定设备的时间
            NSDate *date = [NSDate date];
            //            NSTimeInterval time = [date timeIntervalSince1970];
            NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy.MM.dd"];
            
            
            NSString *bindTime = [formatter stringFromDate:date];
//            NSLog(@"%@",bindTime);
            [appDelegate.appDefault setObject:bindTime forKey:[NSString stringWithFormat:@"%@_time",deviceID]];

            
            self.view.userInteractionEnabled = YES;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveToMain" object:nil];
            
            
        }];
        
    }else{
        //提示错误
        [activity stop];
        self.view.userInteractionEnabled = YES;

        [self makeAlertForServerUseTitle:[appDelegate.appDefault objectForKey:@"Error_message"] Code:[appDelegate.appDefault objectForKey:@"Error_code"]];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    return [_cameraSearchList count];
    

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
   
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.text =[NSString stringWithFormat:@"设备%@", [[_cameraSearchList objectAtIndex:indexPath.row] objectForKey:@"uid"]];
    
    
    
//    NSLog(@"cameraSearchList is %@",_cameraSearchList);
        for (id obj in _cameraSearchList)
        {
            
            if (![_searchDeviceIdArr containsObject:[obj objectForKey:@"uid"]])
            {
                [_searchDeviceIdArr addObject:[obj objectForKey:@"uid"]];
                
            }
        }
    
    
    [activity stop];
    [deviceListView setHidden:NO];
//    NSLog(@"arr 1 and arr2 %@,,,,,%@",_searchDeviceIdArr,_alreadyGotDeviceIdArr);
//    NSLog(@"number oof rows is %d",[tableView numberOfRowsInSection:0]);
//    NSLog(@"current row is%d",indexPath.row);

    if([_searchDeviceIdArr objectAtIndex:indexPath.row])
    {
        if ([_alreadyGotDeviceIdArr  containsObject:[_searchDeviceIdArr objectAtIndex:indexPath.row]])
        {
            cell.accLabel.text = @"已绑定";
            cell.accLabel.textColor = [UIColor blackColor];
            
            
            
            
        }
        else
        {
            cell.accLabel.text =  @"未绑定";
            cell.accLabel.textColor = [UIColor grayColor];
            
        }

        
    
    }
    
   
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self ShowNextSetting:[[_cameraSearchList objectAtIndex:indexPath.row] objectForKey:@"uid"] ];

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
