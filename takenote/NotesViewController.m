//
//  NotesViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "NotesViewController.h"
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
@property (strong, nonatomic) IBOutlet UITableView *noteTableView;

@end

BOOL isFirstTime = YES;
BOOL isScrollUp = NO;
CGPoint pointNow;

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
    self.noteTableView.layer.cornerRadius = 8.f;
//    self.oButton = [CircleLineButton buttonWithType:UIButtonTypeRoundedRect];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appBecomeActive:)
                                                 name: @"didBecomeActive"
                                               object: nil];
    
    [self addTakeNoteButton];
    
    [self.noteTableView setShowsVerticalScrollIndicator:NO];
    self.noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //load user defaults data ...
//    [self addOverlayButton];
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

- (void)addTakeNoteButton
{
    float circleRadius = 65; // screen width factor ...
    
    self.takeNoteButton = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, circleRadius, circleRadius)];
    self.takeNoteButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 45);
    self.takeNoteButton.layer.cornerRadius = CGRectGetWidth(self.takeNoteButton.bounds)/2;
    
    ///// TODO : change according to the weekday ...
//    NSCalendar* cal = [NSCalendar currentCalendar];
//    NSDateComponents* comp = [cal components:kCFCalendarUnitWeekday fromDate:[NSDate date]];
//    return [comp weekday];
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

- (void)hideTakeNoteButton
{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenHeight = screenRect.size.height;
    
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.takeNoteButton.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.view.bounds.size.height + 65);
    [self.takeNoteButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}
- (void)showTakeNoteButton
{
//    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
//    [self.takeNoteButton.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(self.view.bounds.size.height - 45);
    [self.takeNoteButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
    
//    self.loginWithFacebookButton.layer.opacity = 1.0;
//    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    layerScaleAnimation.springBounciness = 18;
//    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    [self.loginWithFacebookButton.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];
//    
//    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    //    layerPositionAnimation.toValue = @(self.dragView.layer.position.y + self.dragView.intrinsicContentSize.height + 220);
//    
//    layerPositionAnimation.toValue = @(self.view.frame.size.height - 75);
//    
//    layerPositionAnimation.springBounciness = 12;
//    [self.loginWithFacebookButton.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
//    
//    ///// Show title Label  ///////
//    self.titleLabel.layer.opacity = 1.0;
//    POPSpringAnimation *titleLayerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    titleLayerScaleAnimation.springBounciness = 18;
//    titleLayerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    [self.titleLabel.layer pop_addAnimation:titleLayerScaleAnimation forKey:@"titleLabelScaleAnimation"];
//    
//    POPSpringAnimation *titleLayerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    titleLayerPositionAnimation.toValue = @(70);
//    titleLayerPositionAnimation.springBounciness = 12;
//    [self.titleLabel.layer pop_addAnimation:titleLayerPositionAnimation forKey:@"titleLayerPositionAnimation"];
//    
//    ///// Show logline Label  ///////
//    self.loglineLabel.layer.opacity = 1.0;
//    POPSpringAnimation *loglineLayerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    loglineLayerScaleAnimation.springBounciness = 18;
//    loglineLayerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    [self.loglineLabel.layer pop_addAnimation:loglineLayerScaleAnimation forKey:@"loglineLabelScaleAnimation"];
//    
//    POPSpringAnimation *loglineLayerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    loglineLayerPositionAnimation.toValue = @(113);
//    loglineLayerPositionAnimation.springBounciness = 12;
//    [self.loglineLabel.layer pop_addAnimation:loglineLayerPositionAnimation forKey:@"loglineLayerPositionAnimation"];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pointNow = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
      self.takeNoteButton.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
//    NSLog(@"content offset= %f",scrollView.contentOffset.y);
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
            [self hideTakeNoteButton];
            /// take the button down
        }
        // push the button down
    }

}

- (void)viewDidAppear:(BOOL)animated{
    
    //tryout
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    self.myNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    
    if(isFirstTime == YES){
        isFirstTime = NO;
        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }else{
//        [self.noteTableView reloadData];
//        [self.noteTableView reloadRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.noteTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.noteTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [self.noteTableView reloadData];
//    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MyNoteCell";
    MyNoteCell *cell = (MyNoteCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Share");
        // maybe show an action sheet with more options
//        [self.noteTableView setEditing:NO];
    }];
    shareAction.backgroundColor = [UIColor customGreenColor];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Edit");
        
//        push to another "edit" view
//        cell.noteTextView.editable = YES;
//        cell.noteTextView.userInteractionEnabled = YES;

        // maybe show an action sheet with more options
        //        [self.noteTableView setEditing:NO];
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
    
    return @[editAction, shareAction,deleteAction];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //we need this just
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
        NSLog(@"height of items = %f", CGRectGetHeight(rect));
        CGFloat newRowHeight = CGRectGetHeight(rect) + 55.f;
        if(newRowHeight>defaultRowHeight){
            return CGRectGetHeight(rect) + 55.f;
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
    cell.noteTextView.text = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:@"noteContent"];
    
    NSDate *noteDate = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:NOTE_DATE];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MM YYYY HH:mm"];
    cell.noteDate.text = [formatter stringFromDate:noteDate];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
//    NSDate *gmtDateTime=[gmtFormatter dateFromString:strGMT];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Detail Disclosure Tapped");
    // Set expanded cell then tell tableView to redraw with animation
    self.expandedRow = indexPath;
    [self.noteTableView beginUpdates];
    [self.noteTableView endUpdates];
}

- (void) takeNoteTap :(id)sender{
    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
}

-(void) appBecomeActive: (NSNotification *)noification{
    NSLog(@"app become active again ...");
    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
