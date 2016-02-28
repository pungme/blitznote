//
//  TodayViewController.h
//  pin-widget
//
//  Created by Worathiti Manosroi on 2/28/16.
//  Copyright © 2016 Worathiti Manosroi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *myNotes;
@property (nonatomic, strong) UITableView* pinNoteTableView;
@end
