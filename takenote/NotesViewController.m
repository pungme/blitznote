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
    
    if(isFirstTime == YES){
        isFirstTime = NO;
        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }else{
//        [self.noteTableView reloadData];
//        [self.noteTableView reloadRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.noteTableView reloadData];

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
//
//    NSString * noteContent = self.noteTextView.text; // change this shit
//    NSDate * date = [NSDate date];
//    
//    NSDictionary * newNote = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:noteContent,date, nil]
//                                                         forKeys:[NSArray arrayWithObjects:NOTE_CONTENT,NOTE_DATE, nil]];
//    
//    //    NSLog(@"new record = %@",newNote);
//    [allNoteRecords insertObject:newNote atIndex:0];
//    //    NSLog(@"all note record = %@", allNoteRecords);
    [defaults setObject:allNoteRecords forKey:NOTE_LIST_KEY];
//    // do not forget to save changes
    [defaults synchronize];
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
        [self deleteNoteAtIndex:[indexPath row]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 100.f; // assume the small size by default
    //TODO : predict by the length of text ...
//    PFObject *trendBox = [self.loadedObjects objectAtIndex:indexPath.row];
//    if ([trendBox[kDDBoxSizeTypeKey] isEqualToString:kDDBoxSizeTypeLarge]) {
//        rowHeight = 240.f;
//    }
    return rowHeight;
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
