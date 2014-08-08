//
//  MessagViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-3-19.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MessagViewController.h"
#import "MainAppDelegate.h"
#import "WebInfoManager.h"
#import "MessageCell.h"
@interface MessagViewController ()

@end

@implementation MessagViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self titleSet:@"系统消息"];
    
    
    
    if ([[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@*",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count] == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text =@"暂时没有系统消息";
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
    
    
    
    
    
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44)];
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.backgroundColor = [UIColor clearColor];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_messageTableView];
    
    
    if (75.0*[self tableView:_messageTableView numberOfRowsInSection:0] > self.view.frame.size.height)
    {
        _messageTableView.frame = CGRectMake(0, 0, 320,self.view.frame.size.height -64);

    } else {
        _messageTableView.frame = CGRectMake(0, 0, 320, 75.0*[self tableView:_messageTableView numberOfRowsInSection:0]);

    }
    
   
    

    
}






-(void)getBackName:(void (^)(NSString *))backName
{
    if(self)
    {
        _backName = backName;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{

    [appDelegate showTabbar];
    _backName(@"0");
    NSLog(@"删除之前是%@",[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@#",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]]);
    NSMutableArray *arr = [NSMutableArray arrayWithArray:(NSArray*)[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@#",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]]];
    [arr removeAllObjects];
    [appDelegate.appDefault setObject:arr forKey:[NSString stringWithFormat:@"%@#",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]];
    NSLog(@"删除之后是%@",[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@#",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]]);
}
-(void)viewWillAppear:(BOOL)animated
{

    [appDelegate hideTabbar];
    [super viewWillAppear:YES];
    [_messageTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@*",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 75;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    static NSString *identifier = @"Message_identifier";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    //判断未读消息
//    cell.tag =(indexPath.row +1) *200;
//    
//    NSLog(@"......%d",cell.tag);
//   
    NSLog(@">>>>>>>%d",[[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@#",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count]);
    
    if ([[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@#",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count] > indexPath.row)
    {

        cell.backgroundColor = babywith_color(0xdce6ff);
        
    }
    else {
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    

    
    cell.alertLabel.text =[[[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@*",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] objectAtIndex:indexPath.row] objectForKey:@"alert"];
    
    int i = [[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@*",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] count];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    for (int j = i -1 ;j >= 0;j--)
    {
        [arr addObject:[[appDelegate.appDefault objectForKey:[NSString stringWithFormat:@"%@*",[[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]]] objectAtIndex:j]];
        
    }
    
    cell.timeLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"messageTime"];
    
    
    return cell;
}

@end
