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

@end

@implementation MyNoteCell
@end

@interface NotesViewController () <POPAnimationDelegate>
@property(nonatomic) UIControl *takeNoteButton;
@property (strong, nonatomic) IBOutlet UITableView *noteTableView;

@end

BOOL isFirstTime = YES;
CGPoint pointNow;
@implementation NotesViewController

- (void)addTakeNoteButton
{
    float circleRadius = 85; // screen width factor ...
    
    self.takeNoteButton = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, circleRadius, circleRadius)];
    self.takeNoteButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 70);
    self.takeNoteButton.layer.cornerRadius = CGRectGetWidth(self.takeNoteButton.bounds)/2;
    self.takeNoteButton.backgroundColor = [UIColor customBlueColor];
    
    // drop shadow ...
    self.takeNoteButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.takeNoteButton.layer.shadowOffset = CGSizeMake(-2, 2);
    self.takeNoteButton.layer.shadowOpacity = 0.3;
    self.takeNoteButton.layer.shadowRadius = 6.0;
    // [self.dragView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    //    [self.draggableCircle addGestureRecognizer:recognizer];
    
    
    //star
//    UIImageView *starlogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
//    float logoMargin = 30;
//    starlogo.frame = CGRectMake(15,10 , circleRadius - logoMargin, circleRadius - logoMargin);
//    
//    starlogo.layer.shadowColor = [UIColor blackColor].CGColor;
//    starlogo.layer.shadowOffset = CGSizeMake(-2, 2);
//    starlogo.layer.shadowOpacity = 0.3;
//    starlogo.layer.shadowRadius = 4.0;
    //    starlogo.center = self.dragView.center;
//    [self.draggableCircle addSubview:starlogo];
    
    //animation stuff
//    [self.takeNoteButton addTarget:self action:@selector(scaleToSmall:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.takeNoteButton addTarget:self action:@selector(takeNoteTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.takeNoteButton addTarget:self action:@selector(scaleToDefault:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.view insertSubview:self.takeNoteButton aboveSubview:self.noteTableView];
//    [self.view addSubview:self.draggableCircle];
}

//- (void)scaleToSmall:(UIControl *)sender
//{
//    [sender.layer pop_removeAllAnimations];
//    
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.90f, 0.90f)];
//    [sender.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
////        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
////        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.90f, 0.90f)];
////        [self.dragView pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
//}

//- (void)scaleAnimation:(UIControl *)sender
//{
////    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
////    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
////    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
////    scaleAnimation.springBounciness = 18.0f;
////    [sender.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
////    
//    //    [self playSound:@"pop_effect" :@"wav"];
//    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
//}

//- (void)scaleToDefault:(UIControl *)sender
//{
//    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    [sender.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
    self.noteTableView.layer.cornerRadius = 8.f;
    self.oButton = [CircleLineButton buttonWithType:UIButtonTypeRoundedRect];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appBecomeActive:)
                                                 name: @"didBecomeActive"
                                               object: nil];
    
    [self addTakeNoteButton];
    //load user defaults data ...
//    [self addOverlayButton];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pointNow = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
      self.takeNoteButton.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y<pointNow.y) {
        NSLog(@"down");
        //push the button up
    } else if (scrollView.contentOffset.y>pointNow.y) {
        NSLog(@"up");
        // push the button down
    }
//    CGRect tableBounds = self.noteTableView.bounds;
//    CGRect floatingButtonFrame = self.takeNoteButton.frame;
//    floatingButtonFrame.origin.y = 200 + tableBounds.origin.y;
//    self.takeNoteButton.frame = floatingButtonFrame;
}

//- (void)addOverlayButton {
//    [self.oButton drawCircleButton:[UIColor blueColor]];
////    self.oButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.oButton addTarget:self
//                action:@selector(takeNoteTap:)
//      forControlEvents:UIControlEventTouchDown];
////    [self.oButton setTitle:@"Take Note" forState:UIControlStateNormal];
//    self.oButton.frame = CGRectMake(0, 200, 160.0, 40.0);
//    [self.view insertSubview:self.oButton aboveSubview:self.noteTableView];
////    [self.view addSubview:oButton];
////    [self.view insertSubview:oButton aboveSubview:_scrollView];  // same result as addSubview.
//    // Both solutions let the button float over the content.
//}
- (void)viewDidAppear:(BOOL)animated{
    
    //tryout
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    self.myNotes = [defaults objectForKey:NOTE_LIST_KEY];
    NSLog(@"note list =%@",self.myNotes);
//    NSLog(@"note content = %@", [self.myNotes[0] objectForKey:NOTE_CONTENT]);
    
    if(isFirstTime == YES){
        isFirstTime = NO;
        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
    
//    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _itemsCount;//self.boxes.count;
    return [self.myNotes count];
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyNoteCell";
    
    MyNoteCell *cell = (MyNoteCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.noteTextView.text = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:@"noteContent"];
//    PFObject *box = [_boxes objectAtIndex:indexPath.row];
//    cell.boxNameLabel.text = box[kDDBoxTitleKey];
//    cell.boxSubtitleLabel.text = box[kDDBoxSubtitleKey];
//    // use sd_ version only with a placeholder, otherwise it doesn't show up
//    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:box.boxImageURL]];
//    PFFile *boxImageFile = box[kDDBoxImageKey];
//    PFFile *boxIconFile = box[kDDBoxIconImageKey];
//    
//    if (boxImageFile.url.length) {
//        [cell.boxImageView setImageWithURL:[NSURL URLWithString:boxImageFile.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    }
//    
//    if (boxIconFile.url.length){
//        [cell.boxIconImageView setImageWithURL:[NSURL URLWithString:boxIconFile.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    }
    
    return cell;
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
