//
//  NewMessageViewController.h
//  BabyWith
//
//  Created by eliuyan_mac on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "BaseViewController.h"

@interface NewMessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{

    UILabel *_label;
    NSDictionary * messageListDic;
    NSMutableArray *messageArray1;

}

@property (nonatomic,retain) UITableView *messageTableView;
@end
