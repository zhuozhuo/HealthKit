//
//  ViewController.h
//  HealthKit
//
//  Created by aimoke on 16/9/20.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *showTableView;


@end
