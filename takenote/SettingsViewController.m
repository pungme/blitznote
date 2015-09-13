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
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"takenoteOnStart"]){
        [self.takenoteOnStartSwitch setOn:NO];
//        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"saveOnSleep"]){
        [self.saveOnSleepSwitch setOn:NO];
//        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"randomlyNotifyNote"]){
        [self.randomlyNotifyNoteSwitch setOn:NO];
        //        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

///TODO :
//-(void) removeScheduledLocalNotification{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//    for (int i=0; i<[eventArray count]; i++)
//    {
//        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
////        NSDictionary *userInfoCurrent = oneEvent.userInfo;
//        [app cancelLocalNotification:oneEvent];
//        //        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
//        //        if ([uid isEqualToString:uidtodelete])
//        //        {
//        //            //Cancelling local notification
//        //            [app cancelLocalNotification:oneEvent];
//        //            break;
//        //        }
//    }
//}
//
//- (void) setUpLocalNotification{
//    NSUInteger randomIndex = arc4random() % [self.myNotes count];
//    
//    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:10]; // TODO : random the time
//    UIApplication* app = [UIApplication sharedApplication];
//    
//    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init] ;
//    if (notifyAlarm)
//    {
//        notifyAlarm.fireDate = alertTime;
//        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
//        [notifyAlarm setRepeatInterval:NSCalendarUnitDay];
//        //        [notifyAlarm setRepeatInterval:kCFCalendarUnitDay];
//        notifyAlarm.alertBody = [[self.myNotes objectAtIndex:randomIndex] objectForKey:NOTE_CONTENT];
//        [app scheduleLocalNotification:notifyAlarm];
//    }
//}

//-(void)registerToReceivePushNotification {
//    // Register for push notifications
//    UIApplication* application =[UIApplication sharedApplication];
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//}

- (IBAction)doneButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)randomNotifySwitchChange:(id)sender {
//    BOOL isOn = [self.randomNotifySwitch isOn];
//    if(isOn == YES){
//        [self registerToReceivePushNotification];
//        [self removeScheduledLocalNotification];
//        [self setUpLocalNotification];
//    }
////    NSLog(@"hello there");
////    NSLog(@"switch state = %i",[self.randomNotifySwitch isOn]);
//}

- (IBAction)takenoteWhenStartSwitchTap:(id)sender {
//    NSLog(@"takenote on start state = %i",[self.takenoteOnStartSwitch isOn]);
    if([self.takenoteOnStartSwitch isOn]){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"takenoteOnStart"];
    }else {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"takenoteOnStart"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)saveOnDeviceSleepSwitchTap:(id)sender {
//    NSLog(@"save on sleep state = %i",[self.saveOnSleepSwitch isOn]);
    if([self.saveOnSleepSwitch isOn]){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"saveOnSleep"];
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"saveOnSleep"];
    }
}

- (IBAction)randomlyNotifyNotes:(id)sender {
//    if([self.randomlyNotifyNoteSwitch isOn]){
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"randomlyNotifyNote"];
//        [self registerToReceivePushNotification];
//        [self removeScheduledLocalNotification];
//        [self setUpLocalNotification];
//    }else{
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"randomlyNotifyNote"];
//    }
    //TODO: randomly notify notes within the note that you took, default as false
}

//- (IBAction)notiTestTap:(id)sender {
////        [self registerToReceivePushNotification];
////        [self removeScheduledLocalNotification];
////        [self setUpLocalNotification];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
