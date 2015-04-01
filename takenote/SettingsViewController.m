//
//  SettingsViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/31/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

///TODO :
-(void) removeScheduledLocalNotification{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        [app cancelLocalNotification:oneEvent];
        //        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
        //        if ([uid isEqualToString:uidtodelete])
        //        {
        //            //Cancelling local notification
        //            [app cancelLocalNotification:oneEvent];
        //            break;
        //        }
    }
}

- (void) setUpLocalNotification{
    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:10]; // TODO : random the time
    UIApplication* app = [UIApplication sharedApplication];
    
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init] ;
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        //        notifyAlarm.repeatInterval = 0;
        [notifyAlarm setRepeatInterval:NSCalendarUnitMinute];
        //        [notifyAlarm setRepeatInterval:kCFCalendarUnitDay];
        notifyAlarm.alertBody = @"Test notification"; // random from your note
        
        [app scheduleLocalNotification:notifyAlarm];
    }
}

-(void)registerToReceivePushNotification {
    // Register for push notifications
    UIApplication* application =[UIApplication sharedApplication];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}
- (IBAction)notiTestTap:(id)sender {
        [self registerToReceivePushNotification];
        [self removeScheduledLocalNotification];
        [self setUpLocalNotification];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
