//
//  SettingsViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/31/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "SettingsViewController.h"
#define NOTE_LIST_KEY @"listOfAllNotes"
#define NOTE_CONTENT @"noteContent"
#define NOTE_DATE @"noteDate"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    self.myNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    
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
    NSUInteger randomIndex = arc4random() % [self.myNotes count];
    
    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:10]; // TODO : random the time
    UIApplication* app = [UIApplication sharedApplication];
    
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init] ;
    if (notifyAlarm)
    {
        notifyAlarm.fireDate = alertTime;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        [notifyAlarm setRepeatInterval:NSCalendarUnitDay];
        //        [notifyAlarm setRepeatInterval:kCFCalendarUnitDay];
        notifyAlarm.alertBody = [[self.myNotes objectAtIndex:randomIndex] objectForKey:NOTE_CONTENT];
        [app scheduleLocalNotification:notifyAlarm];
    }
}

-(void)registerToReceivePushNotification {
    // Register for push notifications
    UIApplication* application =[UIApplication sharedApplication];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}
- (IBAction)randomNotifySwitchChange:(id)sender {
    BOOL isOn = [self.randomNotifySwitch isOn];
    if(isOn == YES){
        [self registerToReceivePushNotification];
        [self removeScheduledLocalNotification];
        [self setUpLocalNotification];
    }
//    NSLog(@"hello there");
//    NSLog(@"switch state = %i",[self.randomNotifySwitch isOn]);
}

- (IBAction)notiTestTap:(id)sender {
//        [self registerToReceivePushNotification];
//        [self removeScheduledLocalNotification];
//        [self setUpLocalNotification];
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
