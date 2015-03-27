//
//  NotesViewController.h
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CircleLineButton.h"

@interface NotesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UITableView *noteTableView;
@property (nonatomic, strong) NSMutableArray *myNotes;
//@property (nonatomic, strong) CircleLineButton *oButton;
@end
