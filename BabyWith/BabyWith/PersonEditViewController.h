//
//  PersonEditViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-8-6.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonEditViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_shareEditTable;
    NSArray *_descriptionArray;
    NSString *_phone;
    UILabel *phoneLabel;
    UILabel *nameLabel;
    UIImageView *switchImage ;

}
-(id)initwithPhoneNumber:(NSString *)phoneNumber;
@end
