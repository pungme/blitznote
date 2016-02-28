//
//  NotesViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "NotesViewController.h"
#import "EditNoteViewController.h"
#import "UIColor+CustomColors.h"
#import <pop/POP.h>

#define NOTE_LIST_KEY @"listOfAllNotes"
#define NOTE_CONTENT @"noteContent"
#define NOTE_DATE @"noteDate"

@interface MyNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UILabel *noteDate;

@end

@implementation MyNoteCell
@end

@interface NotesViewController () <POPAnimationDelegate>
@property(nonatomic) UIControl *takeNoteButton;
@property(nonatomic) UIControl *settingButton;
@property (strong, nonatomic) IBOutlet UITableView *noteTableView;

@end

BOOL isFirstTime = YES;
BOOL isScrollUp = NO;
CGPoint pointNow;

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    self.view.layer.cornerRadius = 8.f;
    self.noteTableView.layer.cornerRadius = 8.f;
//    self.oButton = [CircleLineButton buttonWithType:UIButtonTypeRoundedRect];
    self.isComeFromShortcut = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    self.myNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.blitznote.TodayExtensionSharingDefaults"];
    [sharedDefaults setObject:[defaults objectForKey:NOTE_LIST_KEY] forKey:NOTE_LIST_KEY];
    [sharedDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appBecomeActive:)
                                                 name: @"didBecomeActive"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appComesFromShortcutItem:)
                                                 name: @"didComeFromShortcutItem"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appComesFromWidget:)
                                                 name: @"didComeFromWidget"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appEnterBackground:)
                                                 name: @"didEnterBackground"
                                               object: nil];
    
    [self addTakeNoteButton];
    [self addSettingButton];
    
    [self.noteTableView setShowsVerticalScrollIndicator:NO];
    self.noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"takenoteOnStart"] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"takenoteOnStart"];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"saveOnSleep"] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"saveOnSleep"];
    }

//    self.noteTableView.alwaysBounceVertical = YES;
    //load user defaults data ...
//    [self addOverlayButton];

//    _searchBar = [[UISearchBar alloc] init];
//    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
//    searchController.delegate = self;
//    searchController.searchResultsDataSource = self;
//    self.noteTableView.tableHeaderView = _searchBar;
//    self.noteTableView.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.frame));
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 51)];
    _searchBar.delegate = self;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.barTintColor = [UIColor clearColor];
    _searchBar.placeholder = @"Search notes";
    
    _searchBar.layer.shadowColor = [UIColor blackColor].CGColor;
    _searchBar.layer.shadowOffset = CGSizeMake(-1, 1);
    _searchBar.layer.shadowOpacity = 0.2;
    _searchBar.layer.shadowRadius = 4.0;
//    _searchBar.layer.opacity = 0.4;
    
    self.noteTableView.tableHeaderView = _searchBar;
    self.noteTableView.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.frame));
    
//    [self addTakeNoteButton];
//    [self addSettingButton];
    
//    [self.view addSubview:_searchBar];
    
}

- (UIColor*)getColorFromWeekDay:(NSString*)weekday{
    UIColor *color = [UIColor customBlueColor];
    if([weekday isEqualToString:@"1"]){
        color = [UIColor customRedColor];
    }else if([weekday isEqualToString:@"2"]){
        color = [UIColor customYellowColor];
    }else if([weekday isEqualToString:@"3"]){
        color = [UIColor customPinkColor];
    }else if([weekday isEqualToString:@"4"]){
        color = [UIColor customGreenColor];
    }else if([weekday isEqualToString:@"5"]){
        color = [UIColor customGrayColor];
    }else if([weekday isEqualToString:@"6"]){
        color = [UIColor customOrangeColor];
    }else if([weekday isEqualToString:@"7"]){
        color = [UIColor customPurpleColor];
    }
    
    return color;
}

- (void)addSettingButton
{
    float circleRadius = 30; // screen width factor ...
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    self.settingButton = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, circleRadius, circleRadius)];
    self.settingButton.center = CGPointMake(screenWidth - 30, 65);
    self.settingButton.layer.cornerRadius = CGRectGetWidth(self.settingButton.bounds)/2;
    
    ///// TODO : change according to the weekday ...
    //    NSCalendar* cal = [NSCalendar currentCalendar];
    //    NSDateComponents* comp = [cal components:kCFCalendarUnitWeekday fromDate:[NSDate date]];
    //    return [comp weekday];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//    [dateFormatter setDateFormat:@"e"];
//    NSString *weekDay = [dateFormatter stringFromDate:[NSDate date]] ;
    
    //    NSLog(@"%i", intWeekDay);
    
//    self.settingButton.backgroundColor = [self getColorFromWeekDay:weekDay];
    
    // drop shadow ...
    self.settingButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.settingButton.layer.shadowOffset = CGSizeMake(-2, 2);
    self.settingButton.layer.shadowOpacity = 0.3;
    self.settingButton.layer.shadowRadius = 6.0;
    self.settingButton.layer.opacity = 0.4;
    
    
    UIImageView *gearsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings"]];
    gearsIcon.frame = CGRectMake(0,0 , circleRadius , circleRadius );
    
    gearsIcon.layer.shadowColor = [UIColor blackColor].CGColor;
    gearsIcon.layer.shadowOffset = CGSizeMake(-2, 2);
    gearsIcon.layer.shadowOpacity = 0.3;
    gearsIcon.layer.shadowRadius = 4.0;
    //    starlogo.center = self.dragView.center;
    [self.settingButton addSubview:gearsIcon];
    
    [self.settingButton addTarget:self action:@selector(settingTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.settingButton aboveSubview:self.noteTableView];
}

- (void)addTakeNoteButton
{
    float circleRadius = 65; // screen width factor ...
    
    
    self.takeNoteButton = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, circleRadius, circleRadius)];
    self.takeNoteButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 45);
    self.takeNoteButton.layer.cornerRadius = CGRectGetWidth(self.takeNoteButton.bounds)/2;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"e"];
    NSString *weekDay = [dateFormatter stringFromDate:[NSDate date]] ;

//    NSLog(@"%i", intWeekDay);
    
    
    self.takeNoteButton.backgroundColor = [self getColorFromWeekDay:weekDay];
    
    // drop shadow ...
    self.takeNoteButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.takeNoteButton.layer.shadowOffset = CGSizeMake(-2, 2);
    self.takeNoteButton.layer.shadowOpacity = 0.3;
    self.takeNoteButton.layer.shadowRadius = 6.0;
    // [self.dragView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    //    [self.draggableCircle addGestureRecognizer:recognizer];
    
    UIImageView *gearsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"takenote3"]];
    gearsIcon.frame = CGRectMake(15,15 , circleRadius-30 , circleRadius-30 );

    gearsIcon.layer.opacity = 0.5;
    [self.takeNoteButton addSubview:gearsIcon];
    
    [self.takeNoteButton addTarget:self action:@selector(takeNoteTap:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.takeNoteButton addTarget:self action:@selector(scaleToDefault:) forControlEvents:UIControlEventTouchDragExit];
    
    //add icon
    
//    UIImageView *writeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"takenotebutton"]];
////    float logoMargin = 30;
//    writeIcon.frame = CGRectMake(0,0 , circleRadius , circleRadius);
//    
//    writeIcon.layer.shadowColor = [UIColor blackColor].CGColor;
//    writeIcon.layer.shadowOffset = CGSizeMake(-2, 2);
//    writeIcon.layer.shadowOpacity = 0.3;
//    writeIcon.layer.shadowRadius = 4.0;
    //    starlogo.center = self.dragView.center;
//    UILabel * plusLabel = [[UILabel alloc] init];
//    plusLabel.text = @"+";
//    [self.takeNoteButton addSubview:plusLabel];
    
    
    
    [self.view insertSubview:self.takeNoteButton aboveSubview:self.noteTableView];
    //    [self.view addSubview:self.draggableCircle];
}

- (void)hideSettingButton
{
//    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
//    [self.settingButton.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    layerPositionAnimation.toValue = @(self.view.bounds.size.width + 65);
    [self.settingButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}
- (void)showSettingButton
{
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    layerPositionAnimation.toValue = @(self.view.bounds.size.width - 30);
    [self.settingButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
    
}

- (void)hideTakeNoteButton
{
//    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
//    [self.takeNoteButton.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.view.bounds.size.height + 65);
    [self.takeNoteButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}
- (void)showTakeNoteButton
{
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.view.bounds.size.height - 45);
    [self.takeNoteButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pointNow = scrollView.contentOffset;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    show the button
    if (scrollView.contentOffset.y == 0)
    {
            [self showSettingButton];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//        self.view.frame = CGRectMake(self.view.frame.origin.x,
//                                                - scrollView.contentOffset.y,
//                                               self.view.frame.size.width,
//                                               self.view.frame.size.height);
    
      self.takeNoteButton.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
      self.settingButton.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);

    if (scrollView.contentOffset.y < pointNow.y) {
//        NSLog(@"down");
        if(isScrollUp == YES){
            isScrollUp = NO;
            NSLog(@"down");
            [self showTakeNoteButton];
        }
        //push the button up
    } else if (scrollView.contentOffset.y > pointNow.y) {
        
        if(isScrollUp == NO){
            isScrollUp = YES;
            NSLog(@"up");
            [self hideSettingButton];
            [self hideTakeNoteButton];
            /// take the button down
        }
        // push the button down
    }

}

- (void)viewDidAppear:(BOOL)animated{
    
    //tryout
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    self.myNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    
    if(isFirstTime == YES){
        isFirstTime = NO;
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"takenoteOnStart"] == 1){
            [self performSegueWithIdentifier: @"takenotesegue" sender: self];
        }else{
            [self.noteTableView reloadData];
        }
//        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }else{
        [self.noteTableView reloadData];
        if([self.myNotes count] > 0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.noteTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
//        [self.noteTableView reloadData];
//        [self.noteTableView reloadRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationFade];
    }
    
//    [self.noteTableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.noteTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [self.noteTableView reloadData];
//    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    
    
    // for widgets
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.blitznote.TodayExtensionSharingDefaults"];
    [sharedDefaults setObject: self.myNotes forKey:NOTE_LIST_KEY];
    [sharedDefaults synchronize];
}



- (void)deleteNoteAtIndex:(NSInteger)index {
    //tryout
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray * allNoteRecords = [[NSMutableArray alloc] init];
    NSMutableArray * currentNoteRecords = [defaults objectForKey:NOTE_LIST_KEY];

    if(currentNoteRecords.count > 0){ // if there are any current record ...
        //do the freaking copy
        allNoteRecords = [[defaults objectForKey:NOTE_LIST_KEY] mutableCopy];
    }
    
    [allNoteRecords removeObjectAtIndex:index];

    [defaults setObject:allNoteRecords forKey:NOTE_LIST_KEY];
//    // do not forget to save changes
    [defaults synchronize];
}

#pragma mark - UITableView
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return(YES);
}

-(void)shareNote:(NSString*)note{
    NSString *textToShare = note;
//    NSURL *myWebsite = [NSURL URLWithString:@"http://www.onestar.reviews/"];
    
    NSArray *objectsToShare = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self hideSettingButton];
    
    MyNoteCell *cell = (MyNoteCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.noteTextView.userInteractionEnabled = NO;
    
//    static NSString *identifier = @"MyNoteCell";
//    MyNoteCell *cell = (MyNoteCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Share");
        NSString *note = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:@"noteContent"];
        [self shareNote:note];
        // maybe show an action sheet with more options
//        [self.noteTableView setEditing:NO];
    }];
    shareAction.backgroundColor = [UIColor customGreenColor];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Edit");
        ///TODO: we probably need editIndex
        self.editingRow = indexPath;
        [self performSegueWithIdentifier: @"editnotesegue" sender: self];
        
    }];
    editAction.backgroundColor = [UIColor customBlueColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [[self myNotes] removeObjectAtIndex:[indexPath row]];
        [[self noteTableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self deleteNoteAtIndex:[indexPath row]];
        //        [self.noteTableView reloadData];
        NSLog(@"delete at indexPath = %@",indexPath );
    }];
    
    UITableViewRowAction *pinAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Pin"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//        [[self myNotes] removeObjectAtIndex:[indexPath row]];
//        [[self noteTableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self deleteNoteAtIndex:[indexPath row]];
//        //        [self.noteTableView reloadData];
//        NSLog(@"delete at indexPath = %@",indexPath );
    }];
    
    pinAction.backgroundColor = [UIColor customGrayColor];
    // not yet
    
    
    return @[
//             pinAction,
             editAction, shareAction,deleteAction];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //we need this just to enable swipe options
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
////        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
////        [[self myNotes] removeObjectAtIndex:[indexPath row]];
////        [[self noteTableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
////        [self deleteNoteAtIndex:[indexPath row]];
//////        [self.noteTableView reloadData];
////        NSLog(@"delete at indexPath = %@",indexPath );
//        // Delete the row from the data source
////        [self.noteTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _itemsCount;//self.boxes.count;
    return [self.myNotes count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"MyNoteCell";
//    MyNoteCell *cell = (MyNoteCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    CGFloat defaultRowHeight = 90.f; // assume that this is the defaut size
    if ([indexPath isEqual:self.expandedRow]) {
        
        ///TODO: check if we have a second line !!!
        NSString *note = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:@"noteContent"];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:27]};
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        NSString *text = note;
        CGRect rect = [text boundingRectWithSize:CGSizeMake(screenWidth, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
//        _constraintTextViewHeight.constant = CGRectGetHeight(rect)
        
        //// calculate the row height here ?
//        NSLog(@"height of items = %f", CGRectGetHeight(rect));
        CGFloat newRowHeight = CGRectGetHeight(rect) + 75.f;
        if(newRowHeight>defaultRowHeight){
            return CGRectGetHeight(rect) + 75.f;
        }
    }

    return defaultRowHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyNoteCell";
    
    MyNoteCell *cell = (MyNoteCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.noteTextView.userInteractionEnabled =NO;
    [cell.noteTextView setDataDetectorTypes:UIDataDetectorTypeAll];
    cell.noteTextView.text = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:@"noteContent"];
    cell.noteTextView.textColor = [UIColor blackColor];
    
    NSDate *noteDate = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:NOTE_DATE];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM YYYY HH:mm"];
//    cell.noteDate.text = [formatter stringFromDate:noteDate];
    cell.noteDate.text = [noteDate timeAgo];
//    cell.noteDate.hidden = YES;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
//    NSDate *gmtDateTime=[gmtFormatter dateFromString:strGMT];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyNoteCell *cell = (MyNoteCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.noteTextView.userInteractionEnabled = NO;
//    cell.noteTextView.selectable = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     MyNoteCell *cell = (MyNoteCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.noteTextView.userInteractionEnabled = YES;
    NSLog(@"Detail Disclosure Tapped");
    [self.searchBar resignFirstResponder]; // resign searchbar
    // Set expanded cell then tell tableView to redraw with animation
    self.expandedRow = indexPath;
    [self.noteTableView beginUpdates];
    [self.noteTableView endUpdates];
}


////////////////////////////// NOTIFICATION TRYOUT ///////////////////////////
//////////////////////////////////////////////////////////////////////////////
////// Move this shit to settings view //////
//-(void) removeScheduledLocalNotification{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//    for (int i=0; i<[eventArray count]; i++)
//    {
//        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//        NSDictionary *userInfoCurrent = oneEvent.userInfo;
//         [app cancelLocalNotification:oneEvent];
////        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
////        if ([uid isEqualToString:uidtodelete])
////        {
////            //Cancelling local notification
////            [app cancelLocalNotification:oneEvent];
////            break;
////        }
//    }
//}
//
//- (void) setUpLocalNotification{
//    NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:10]; // TODO : random the time
//    UIApplication* app = [UIApplication sharedApplication];
//    
//    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init] ;
//    if (notifyAlarm)
//    {
//        notifyAlarm.fireDate = alertTime;
//        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
////        notifyAlarm.repeatInterval = 0;
//        [notifyAlarm setRepeatInterval:NSCalendarUnitDay];
////        [notifyAlarm setRepeatInterval:kCFCalendarUnitDay];
//        notifyAlarm.alertBody = @"Test notification"; // random from your note
//        
//        [app scheduleLocalNotification:notifyAlarm];
//    }
//}
//
//-(void)registerToReceivePushNotification {
//    // Register for push notifications
//    UIApplication* application =[UIApplication sharedApplication];
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//}

- (void) settingTap :(id)sender{
    //This is all testing /// to move to another view ...
    //TODO : goes to settings
//    [self registerToReceivePushNotification];
//    [self removeScheduledLocalNotification];
//    [self setUpLocalNotification];
    
    [self performSegueWithIdentifier: @"settingsegue" sender: self];
}
////////////////////////////// NOTIFICATION TRYOUT ///////////////////////////
//////////////////////////////////////////////////////////////////////////////

- (void) takeNoteTap :(id)sender{
    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
}

-(void) appBecomeActive: (NSNotification *)noification{
    NSLog(@"app become active again ...");
    NSLog(@"take note on start = %li",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"takenoteOnStart"]);
    
    if(_isComeFromShortcut == YES){return;}
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"takenoteOnStart"] == 1){
        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
}
- (void)appComesFromWidget:(id)sender{
    _isComeFromShortcut = YES;
}

- (void)appComesFromShortcutItem: (NSNotification *)noification{
    // random note and show it.
    _isComeFromShortcut = YES;
    
    NSUInteger randomIndex = arc4random() % [self.myNotes count];
    NSIndexPath *path = [NSIndexPath indexPathForRow:randomIndex inSection:0];
    NSLog(@"path = %@",path);
    self.editingRow = path;
    [self performSegueWithIdentifier: @"editnotesegue" sender: self];
//    [[self.myNotes objectAtIndex:randomIndex] objectForKey:NOTE_CONTENT];
    //TODO: we should check what kind of shortcut but in this case, we only have one ...
    NSLog(@"did comes from shortcut item");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////// segue stuff

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"editnotesegue"]) {
        EditNoteViewController *editNoteViewController = [segue destinationViewController];
        editNoteViewController.indexPath = self.editingRow;
//        [editNoteViewController setIndexPath:self.editingRow];
//        [segue.destinationViewController setHappiness:100];
    } 
}

#pragma mark SearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //here we filter in table View
//    NSLog(@"myNotes = %@", self.myNotes);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *allNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    NSMutableArray *filteredNotes = [[NSMutableArray alloc] init];
    //filter from all Notes
    [filteredNotes removeAllObjects];
    if(searchText.length == 0){
        self.myNotes = allNotes;
//        [self.noteTableView reloadData];
    }else{
        //user type something
        for(id note in allNotes){
            NSString *noteContent = note[NOTE_CONTENT];
            if([[noteContent lowercaseString] containsString:[searchText lowercaseString]]){
//                NSLog(@"noteContent = %@", No)
                [filteredNotes addObject:note];
            }
//            NSLog(@"noteContent = %@", noteContent);
        }
        NSLog(@"search results = %@",filteredNotes);
        self.myNotes = filteredNotes;
    }
    [self.noteTableView reloadData];
//    self.myNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"displayName_lowercase" containsString:[searchBar.text lowercaseString]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
//        if (!error) {
//            //            NSLog(@"%@", users);
//            self.userList = [NSMutableArray arrayWithArray:users];
//            [self.userResultsTableView reloadData];
//        } else {
//            NSLog(@"Error fetching users");
//        }
//    }];
}

-(void) appEnterBackground:(NSNotification *)notification{
    NSLog(@"app enter background mode ... ");
    _isComeFromShortcut = NO; // reset the shit
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
