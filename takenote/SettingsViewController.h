//
//  SettingsViewController.h
//  takenote
//
//  Created by Worathiti Manosroi on 3/31/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *myNotes;
@property (weak, nonatomic) IBOutlet UISwitch *randomNotifySwitch;

@end
