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
    [self.takeNoteButton addTarget:self action:@selector(takeNoteTap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.takeNoteButton addTarget:self action:@selector(scaleToDefault:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.view insertSubview:self.takeNoteButton aboveSubview:self.noteTableView];
//    [self.view addSubview:self.draggableCircle];
}




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
    //load user defaults data ...
//    [self addOverlayButton];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pointNow = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
      self.takeNoteButton.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
//    NSLog(@"content offset= %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < pointNow.y) {
//        NSLog(@"down");
        //push the button up
    } else if (scrollView.contentOffset.y > pointNow.y) {
//        NSLog(@"up");
        // push the button down
    }

}

- (void)viewDidAppear:(BOOL)animated{
    
    //tryout
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    self.myNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
//    self.myNotes = [defaults objectForKey:NOTE_LIST_KEY];
//    NSLog(@"note list =%@",self.myNotes);
//    NSLog(@"note content = %@", [self.myNotes[0] objectForKey:NOTE_CONTENT]);
    
    if(isFirstTime == YES){
        isFirstTime = NO;
        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
    
//    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
}
#pragma mark - UITableView
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return(YES);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [[self myNotes] removeObjectAtIndex:[indexPath row]];
        [[self noteTableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.noteTableView reloadData];
        NSLog(@"delete at indexPath = %@",indexPath );
        // Delete the row from the data source
//        [self.noteTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

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
