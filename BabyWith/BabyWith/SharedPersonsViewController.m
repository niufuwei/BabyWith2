//
//  SharedPersonsViewController.m
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "SharedPersonsViewController.h"
#import "MainAppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "PersonEditViewController.h"

@implementation SharedPersonsViewController

- (id)initWithDeviceID:(NSString *)deviceID
{
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
    }
        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self titleSet:@"分享人员"];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    // Do any additional setup after loading the view.
    _sharedPersonTableView =  [[UITableView alloc] init];
    _sharedPersonTableView.delegate = self;
    _sharedPersonTableView.dataSource = self;
    _sharedPersonTableView.backgroundColor = [UIColor clearColor];
    _sharedPersonTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if (IOS7) {
        _sharedPersonTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    _label = [[UILabel alloc] init];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isScreen" ] isEqualToString:@"yes"])
    {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    [_sharedPersonTableView reloadData];
    
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]]];
//    NSLog(@"arr is %d",[arr count]);
    
    
    if ([arr count] == 0)
    {
        
        _sharedPersonTableView.frame = CGRectMake(0, 0, 0, 0);
        _label.frame = CGRectMake(20, 200, 280, 60);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text =@"您还没有将设备分享给别人";
        _label.hidden = NO;
        _label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_label];
       
    }
    else
    {
        _label.hidden = YES;
        _sharedPersonTableView.frame = CGRectMake(0, 0, 320, 45.0*[self tableView:_sharedPersonTableView numberOfRowsInSection:0]);
        if (45.0*[self tableView:_sharedPersonTableView numberOfRowsInSection:0] > self.view.frame.size.height - 64)
        {
            _sharedPersonTableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height );
        }
        
        
    }
    [self.view addSubview:_sharedPersonTableView];


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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSLog(@"self.device id is %@",self.deviceID);
    NSLog(@"数量是%d",[[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] count]);
    return [[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 45;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier  = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = babywith_color(0x373737);
         cell.contentView.backgroundColor = [UIColor whiteColor];
        
        
        accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(320-25,16, 7, 13)];
        [accessoryView setImage:[UIImage imageNamed:@"qietu_40.png"]];
        [cell addSubview:accessoryView];
        
        
        statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.textLabel.frame.size.width + 20, 17.5 , 10, 10)];
        statusImage.tag = indexPath.row + 10000;
        
        
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 30, 45)];
        statusLabel.backgroundColor = [UIColor clearColor];
        
        statusLabel.font = [UIFont systemFontOfSize:14.0];
        statusLabel.tag = indexPath.row + 100000;
        [cell addSubview:statusImage];
        
        [cell addSubview:statusLabel];

        
        
    }
//    else
//    {
//        
//            [statusImage removeFromSuperview];
//            [statusLabel removeFromSuperview];
//            [accessoryView removeFromSuperview];
//        
//    }
    
   
    NSString *phone = [[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] objectAtIndex:indexPath.row];
    
    NSString *loginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    NSString *deviceId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Device_selected"] objectForKey:@"device_id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,phone]])
    {
        cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,phone]];
        CGSize size = CGSizeMake(320, 45);
        CGSize labelsize = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@",loginName,deviceId,phone]] sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        [cell.textLabel setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
//        NSLog(@"cell.width is %f",cell.textLabel.frame.size.width);
    }
    else
    {
    
        cell.textLabel.text = phone;
        CGSize size = CGSizeMake(320, 45);
        CGSize labelsize = [phone sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        [cell.textLabel setFrame:CGRectMake(0, 0, labelsize.width, labelsize.height)];
//        NSLog(@"cell.width 1 is %f",cell.textLabel.frame.size.width);

    
    }
    
    
    ((UIImageView *)[cell viewWithTag:indexPath.row + 10000]).frame = CGRectMake(cell.textLabel.frame.size.width + 20, 17.5 , 10, 10);
    NSString * key =   [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@_%@_status",loginName,deviceId,phone]];
    

    if (key)
    {
        if ([key isEqualToString:@"1"])
        {
            ((UIImageView *)[cell viewWithTag:indexPath.row + 10000]).image = [UIImage imageNamed:@"分享人员 (1)"];
            ((UILabel *)[cell viewWithTag:indexPath.row + 100000]).text  = @"开启";
            ((UILabel *)[cell viewWithTag:indexPath.row + 100000]).textColor = babywith_color(0x373737);
        }
        else
        {
            
            ((UIImageView *)[cell viewWithTag:indexPath.row + 10000]).image = [UIImage imageNamed:@"分享人员 (2)"];
            ((UILabel *)[cell viewWithTag:indexPath.row + 100000]).text  = @"关闭";
            ((UILabel *)[cell viewWithTag:indexPath.row + 100000]).textColor = babywith_color(0xff5b7e);
            
        }
    }
    else
    {
        
        ((UIImageView *)[cell viewWithTag:indexPath.row + 10000]).image = [UIImage imageNamed:@"分享人员 (1)"];
        ((UILabel *)[cell viewWithTag:indexPath.row + 100000]).text  = @"开启";
        ((UILabel *)[cell viewWithTag:indexPath.row + 100000]).textColor = babywith_color(0x373737);

        
    }

    
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",[[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] objectAtIndex:indexPath.row]);
    PersonEditViewController *editVC = [[PersonEditViewController alloc] initWithPhoneNumber:[[appDelegate.appDefault arrayForKey:[NSString stringWithFormat:@"%@_number",self.deviceID]] objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:editVC animated:YES];

}
-(NSString *)getNameBytel:(NSString *)telstr
{
    NSMutableArray* personArray = [[NSMutableArray alloc] init];
    //打开电话本数据库
    CFErrorRef error = NULL;
    ABAddressBookRef addressRef= ABAddressBookCreateWithOptions(NULL, &error);
    NSString *firstName, *lastName, *fullName;
    //返回所有联系人到一个数组中
    personArray = (__bridge_transfer NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressRef);
    
  
    NSUInteger peopleCounter = 0;
    for (peopleCounter = 0; peopleCounter < [personArray count]; peopleCounter++)
    {
         ABRecordRef person = (__bridge ABRecordRef)[personArray objectAtIndex:peopleCounter];
        firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);;
        lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (lastName !=nil)
        {
            fullName = [lastName stringByAppendingFormat:@"%@",firstName];
            
        }
        else
        {
            fullName = firstName;
        }
//        NSLog(@"===%@",fullName);
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
        {
            NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSLog(@"===%@",phone); 
            if ([phone isEqualToString:telstr])
            {
                return fullName;
            }
        } 
    }
    return nil;
}
@end
