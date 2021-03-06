//
//  PhotoScanViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-3.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//
#import "PhotoScanViewController.h"
#import "AppGlobal.h"
#import "MainAppDelegate.h"
#import "SQLiteManager.h"
#import <stdio.h>
#import <stdlib.h>
#import <string>


@implementation PhotoScanViewController

- (id)initWithArray:(NSArray *)array Type:(int )type CurrentPage:(int)currentPage Delegate:(NSObject *)delegate
{
    self = [super init];
    if (self) {
        // Custom initialization
        _photoArray = [[NSMutableArray alloc] initWithArray:array];
        _type = type;
        _delegate = delegate;
        _currentPage = currentPage;
    }
    return self;
}


//-(void)dealloc{
//    [_photoArray release];
//    [_photoScrollView release];
//    [_image release];
//    [super dealloc];
//}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    imageIsLoad = [[NSMutableDictionary alloc] init];
    //导航条设置
    {
        
        
//        
//        UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(30, -30, 20, 20)];
//        [navButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
//        [navButton addTarget:self action:@selector(bind:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: navButton];
//        self.navigationItem.rightBarButtonItem = rightItem;
        
        
        //右导航--删除按钮
        UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 74, 36)];
        
        [setButton addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
        [setButton setTitle:@"删除" forState:UIControlStateNormal];
        setButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        setButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        setButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
     
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: setButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        
        //        [setButton release];
        
        
        
        pageCount = [_photoArray count];
        _image = [[UIImage alloc]init];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [NSString stringWithFormat:@"%d/%d", _currentPage+1, pageCount];
        titleLabel.textColor = babywith_text_background_color;
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        //        [titleLabel release];
    }
    
    int contentHeight = self.view.frame.size.height;
    if (IOS7) {
        _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
    }
    else
    {
        _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
    }
    if (IOS7) {
        _photoScrollView.contentSize = CGSizeMake(320*pageCount,contentHeight - 64);
    }
    else
    {
        _photoScrollView.contentSize = CGSizeMake(320*pageCount,contentHeight - 44);
    }
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.scrollEnabled = YES;
    
    
    _playView = [[UIImageView alloc] init];
    _playView.userInteractionEnabled = YES;
    
    
    int i=0;
    for (NSDictionary *dic in _photoArray)
    {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*320, 0, 320, _photoScrollView.frame.size.height)] ;
        view.tag = i+1;
        UIImageView *imageView = [[UIImageView alloc] init] ;
        if(iPhone5)
        {
            [imageView setImage:[UIImage imageNamed:@"image2.png"]];

        }
        else
        {
            [imageView setImage:[UIImage imageNamed:@"image.png"]];

        }
        imageView.tag = (i+1)*1000000;
        
      
        if (IOS7)
        {
            imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-60);

        }
        else
        {
            imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-40);

        }

        
        
        //是视频图片的话要添加开始按钮一样的东西作为普通图片和视频区别
        if ([[dic objectForKey:@"is_vedio"] intValue] ==1)
        {
            UIImageView *startImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"播放视频 (4).png"]] ;
            startImage.frame = CGRectMake(128, 58, 64, 64);
            [imageView addSubview:startImage];
            
            
            UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPlay)] ;
            
            gester.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:gester];
            
            
            
        }
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
        [_photoScrollView addSubview:view];
    
        i++;
    }
    
    [self.view addSubview:_photoScrollView];
    
    CGRect temp = _photoScrollView.frame;
    CGPoint tem =_photoScrollView.contentOffset;
    tem.x = temp.size.width*_currentPage;
    [_photoScrollView setContentOffset:tem];
    
    
    [self getImage:_currentPage];
}


-(void)getImage:(NSInteger)indexPath
{
    
    NSDictionary * dic = [_photoArray objectAtIndex:indexPath];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfFile: [babywith_sandbox_address stringByAppendingPathComponent:[dic objectForKey:@"path"]]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSArray * arr = [NSArray arrayWithObjects:image,[NSString stringWithFormat:@"%d",indexPath],dic, nil];
        [self performSelectorOnMainThread:@selector(upDateImage:) withObject:arr waitUntilDone:NO];
        
    });
}

-(void)upDateImage:(NSArray*)arr
{
    
//    NSLog(@"%@",[_photoScrollView subviews]);
//    NSLog(@"%@",arr);
    for(UIView * view in [_photoScrollView subviews])
    {
        for(UIView * view2  in [view subviews])
        {
            if(view2.tag ==([[arr objectAtIndex:1] intValue]+1) *1000000)
            {
                UIImageView * imageView  = (UIImageView*)view2;
                [imageView stopAnimating];
                [imageView setImage:[arr objectAtIndex:0]];
                
                if ([[[arr objectAtIndex:2]  objectForKey:@"height_image"] integerValue] == 180) {
                    imageView.frame = CGRectMake(0, (view.frame.size.height - 180)/2 - 60, view.frame.size.width,180);
                    
                }

            }
            else
            {
                
            }
        }
    }
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate hideTabbar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [appDelegate showTabbar];
}


-(void)startPlay
{
    _isBack=FALSE;
    
    __block typeof(self) tmpself = self;
    
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        [UIApplication sharedApplication].statusBarHidden = YES;
        tmpself.navigationController.navigationBarHidden = YES;
        _photoScrollView.hidden = YES;
        [tmpself.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
        [tmpself.view addSubview:_playView];
        
        [UIView animateWithDuration:0.0f animations:^{
            
            _playView.backgroundColor = [UIColor blackColor];
            if(kIsIphone5)
            {
                //添加导航栏
                aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 568, 44)];
                aView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"导航栏背景"]];
                aView.alpha=0.5;
                
                
                
                //添加返回按钮
                UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//                [backBtn setBackgroundImage:[UIImage imageNamed:@"导航返回.png"] forState:UIControlStateNormal];
                
                aBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
                aBackImage.image = [UIImage imageNamed:@"导航返回.png"];
                
                
                [backBtn addSubview:aBackImage];
                
                [backBtn addTarget:self action:@selector(btnTouchDown) forControlEvents:UIControlEventTouchDown];

                [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
                backBtn.frame=CGRectMake(7.5, 12, 60, 30);
                [aView addSubview:backBtn];
                
                
                
    
                UILabel *playLabel = [[UILabel alloc] initWithFrame:CGRectMake(204, 0, 160, 44)];
                playLabel.backgroundColor = [UIColor clearColor];
                playLabel.text = @"视频播放";
                playLabel.font = [UIFont systemFontOfSize:20.0];

                playLabel.textColor = [UIColor whiteColor];
                playLabel.textAlignment = NSTextAlignmentCenter;
                [aView addSubview:playLabel];
                
                
                
                [_playView addSubview:aView];
                
                _playView.frame = CGRectMake(0, 0, 568, 320);
                
            }
            
            else
            {
                aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
                aView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"导航栏背景"]];
                aView.alpha=0.5;
                //添加返回按钮
                UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//                [backBtn setBackgroundImage:[UIImage imageNamed:@"导航返回.png"] forState:UIControlStateNormal];
                aBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
                aBackImage.image = [UIImage imageNamed:@"导航返回.png"];
                
                
                [backBtn addSubview:aBackImage];
                
                [backBtn addTarget:self action:@selector(btnTouchDown) forControlEvents:UIControlEventTouchDown];
                [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
                backBtn.frame=CGRectMake(7.5, 12, 60, 30);
                [aView addSubview:backBtn];
                
                
                UILabel *playLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 44)];
                playLabel.backgroundColor = [UIColor clearColor];
                playLabel.text = @"视频播放";
                playLabel.font = [UIFont systemFontOfSize:20.0];
                playLabel.textColor = [UIColor whiteColor];
                playLabel.textAlignment = NSTextAlignmentCenter;
                [aView addSubview:playLabel];
                
                [_playView addSubview:aView];
                _playView.frame = CGRectMake(0, 0, 480, 320);
                
            }
            
            
        }];
        
        
    });
    
    //副线程处理数据，在主线程更新完UI之后，在提示加载的同时
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *vedioPath = [[_photoArray objectAtIndex:_currentPage] objectForKey:@"record_data_path"];
        NSString *vedioPath1 = [NSString stringWithFormat:@"%@",[babywith_sandbox_address stringByAppendingPathComponent:vedioPath]];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:[[_photoArray objectAtIndex:_currentPage] objectForKey:@"record_data_path"]])
        {
            _frameLenght = 1382400;
            _frameWidth = 1280;
            _frameHeight = 720;
        }
        else
        {
//            NSLog(@"当前视频的每一帧的长度是%@",[[NSUserDefaults standardUserDefaults] objectForKey:[[_photoArray objectAtIndex:_currentPage] objectForKey:@"record_data_path"]]);
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:[[_photoArray objectAtIndex:_currentPage] objectForKey:@"record_data_path"]] isEqualToString:@"460800"])
            {
                _frameLenght = 460800;
                _frameWidth = 640;
                _frameHeight = 480;
            }
            
            else if ([[[NSUserDefaults standardUserDefaults] objectForKey:[[_photoArray objectAtIndex:_currentPage] objectForKey:@"record_data_path"]] isEqualToString:@"115200"])
            {
                _frameLenght = 115200;
                _frameWidth = 320;
                _frameHeight = 240;
            }
            
            
        }
        
        FileHandle =NULL;
        
        FileHandle =fopen([vedioPath1 UTF8String],"rb");
        
        if (FileHandle != NULL)
        {
            int idxPos = 0;
            uint8_t * byte;
            if ((byte = (uint8_t*)malloc (_frameLenght)) != NULL)
            {
                while(1)  {
                    
                    fseek(FileHandle, idxPos, SEEK_SET);
                    
                    
                    idxPos +=_frameLenght;
                    memset(byte,0,_frameLenght);
                    
                    if(fread(byte, 1, _frameLenght, FileHandle)==0)
                    {
                        break;
                    }
                    @autoreleasepool {
                        _image = [APICommon YUV420ToImage:(uint8_t*)byte width:_frameWidth height:_frameHeight];
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            CGSize imageSize = _image.size;
                            imageSize.height = 320;
                            imageSize.width = self.view.frame.size.width - 64;
                            [_playView setImage:_image];
                            
                            
                        });
                        
                    }
                    
                }
                
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if (_isBack) {
                    [aView removeFromSuperview];
                    return ;
                }
                else
                {
                    [aView removeFromSuperview];
                    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stopPlaying) userInfo:nil repeats:NO];
                }
                
            });
            
        }
        
        
    });
    
    
}

-(void)btnTouchDown
{
    
    aBackImage.image = [UIImage imageNamed:@"qietu_56.png"];
    
}


-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}


-(void)stopPlaying
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    _photoScrollView.hidden = NO;
    [UIView animateWithDuration:0.0f animations:^{
        
        [self.view setTransform: CGAffineTransformRotate(self.view.transform,(-M_PI/2))];
        
        
    }];
    _count = 0;
    _vedioData = nil;
    [_playView removeFromSuperview];
    
    
}
-(void)backBtn
{
    _isBack=TRUE;
    fclose(FileHandle);
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    _photoScrollView.hidden = NO;
    [UIView animateWithDuration:0.0f animations:^{
        
        [self.view setTransform: CGAffineTransformRotate(self.view.transform,(-M_PI/2))];
        
    }];
    _count = 0;
    _vedioData = nil;
    [_playView removeFromSuperview];
}

#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    _currentPage = (_scrollView.contentOffset.x /_scrollView.frame.size.width);
    ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"%d/%d", _currentPage+1, pageCount];
    
    if([[imageIsLoad objectForKey:[NSString stringWithFormat:@"%d",_currentPage]] isEqualToString:@"ok"])
    {

    }
    else
    {
        [imageIsLoad setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",_currentPage]];

        [self getImage:_currentPage];

    }
    
}

-(void)deletePic
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"是否确定删除" message:nil delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alert.tag=10010;
    [alert show];
    
}
#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        int index = _currentPage;
        pageCount -= 1;

        //删除当前页面
        [[_photoScrollView viewWithTag:index+1] removeFromSuperview];

        //把下载记录清空
        [imageIsLoad removeAllObjects];
        
        
        if (pageCount == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            _photoScrollView.contentSize = CGSizeMake(320*(pageCount),self.view.frame.size.height-44-60-30);
        }
        
        _currentPage =  (_photoScrollView.contentOffset.x /_photoScrollView.frame.size.width);
        
        
        
        ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"%d/%d", _currentPage+1, pageCount];
        
        [appDelegate.sqliteManager removeRecordInfo:[[_photoArray objectAtIndex:index] objectForKey:@"id_record"] deleteType:1];
        
        //看是否是有视频，有视频就删除视频
        if ([[[_photoArray objectAtIndex:index] objectForKey:@"is_vedio"] intValue]==1)
        {
            //删除视频
            NSString *vedioPath = [NSString stringWithFormat:@"%@",[babywith_sandbox_address
                                                                    stringByAppendingPathComponent:[[_photoArray objectAtIndex:index] objectForKey:@"record_data_path"]]];
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:vedioPath error:&error];
            if (!error)
            {
//                NSLog(@"删除视频成功");
            }
        }
        
        [_photoArray removeObjectAtIndex:index];
         
        for(UIView * view in [_photoScrollView subviews])
        {
            if(view.tag >index+1)
            {
                view.tag = view.tag-1;
                CGRect xx = view.frame;
                xx.origin.x = view.frame.origin.x - self.view.frame.size.width;
                view.frame = xx;
                for(UIView*view2 in [view subviews])
                {
                    view2.tag = view2.tag -1000000;
                   
                }
            }
        }
        
        CGRect temp = _photoScrollView.frame;
        CGPoint tem =_photoScrollView.contentOffset;
        tem.x = temp.size.width*_currentPage;
        [_photoScrollView setContentOffset:tem];
        
        //重新请求数据
//        NSLog(@"%d---->page==>%d",index,pageCount);
        
        if(pageCount !=0)
        {
            if(index ==pageCount)
            {
                [self getImage:index-1];
                
            }
            else
            {
                [self getImage:index];
                
            }

        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageCollectionReload" object:self];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewDidUnload{
    
    _photoScrollView = nil;
    
    _photoArray = nil;
    
    
}


@end
