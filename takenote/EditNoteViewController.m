//
//  FirstViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "EditNoteViewController.h"


#define NOTE_LIST_KEY @"listOfAllNotes"
#define NOTE_CONTENT @"noteContent"
#define NOTE_DATE @"noteDate"

@interface EditNoteViewController ()

@end

@implementation EditNoteViewController

//- (void)viewDi

//- (void)viewDidAppear:(BOOL)animated{
//    self.noteTextView.text = @"";
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noteTextView.delegate = self;
    self.noteTextView.scrollsToTop = YES;
    [self.noteTextView becomeFirstResponder];
    self.view.layer.cornerRadius = 8.f;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appEnterBackground:)
                                                 name: @"didEnterBackground"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appBecomeActive:)
                                                 name: @"didBecomeActive"
                                               object: nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    id theHighScore = [defaults objectForKey:@"listOfAllDebts"];
    NSMutableArray *allNote = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
    self.noteTextView.text = [[allNote objectAtIndex:self.indexPath.row] objectForKey:NOTE_CONTENT];
    NSLog(@"text to edit = %@",[allNote objectAtIndex:self.indexPath.row]);
    //    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    self.isSaving = NO;
//    self loadData
}

//- (void)setIndexPath:(NSIndexPath*)indexPath{
//    NSLog(@"Hi");
////    self.indexPath = indexPath;
//}

- (void)loadDataAtIndex:(NSInteger)index{
    //// set textView to that data ...
}

- (void)saveData {
    /// save again at index path ...
    if([self.noteTextView.text length] != 0){
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

//        NSMutableArray * allNoteRecords = [[NSMutableArray alloc] init];
//        NSMutableArray * currentNoteRecords = [defaults objectForKey:NOTE_LIST_KEY];
//
//        if(currentNoteRecords.count > 0){ // if there are any current record ...
//            //do the freaking copy
//            allNoteRecords = [[defaults objectForKey:NOTE_LIST_KEY] mutableCopy];
//        }
//        
//        NSString * noteContent = self.noteTextView.text; // change this shit
//        NSDate * date = [NSDate date];
//        
//        NSDictionary * newNote = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:noteContent,date, nil]
//                                                             forKeys:[NSArray arrayWithObjects:NOTE_CONTENT,NOTE_DATE, nil]];
//        
//        //    NSLog(@"new record = %@",newNote);
//        [allNoteRecords insertObject:newNote atIndex:0];
//        //    NSLog(@"all note record = %@", allNoteRecords);
//        [defaults setObject:allNoteRecords forKey:NOTE_LIST_KEY];
//        // do not forget to save changes
//        [defaults synchronize];
    }
    self.isSaving = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"content offset = %f", scrollView.contentOffset.y);
    
    // set background color according to the contentOffset ...
    
    ///TODO: make it swipe down and reveal the note page
    //    self.view.frame = CGRectMake(self.view.frame.origin.x,
    //                                            - scrollView.contentOffset.y,
    //                                           self.view.frame.size.width,
    //                                           self.view.frame.size.height);
    
    //    NSLog(@"contentOffset = %f",scrollView.contentOffset.y);
    CGFloat colorOffset = (scrollView.contentOffset.y) / 350;
    //    NSLog(@"color offset = %f",colorOffset);
    self.view.backgroundColor = [UIColor colorWithRed:1.0 + colorOffset green:1.0+colorOffset blue:1.0+colorOffset alpha:1.0];
    
    if (scrollView.contentOffset.y < -100)
    {
        NSLog(@"dismiss ...");
        [self dismissViewControllerAnimated:YES completion:^{
            // to make it call only once ...
            //            if([self.noteTextView.text length] != 0){
            //                [self saveData];
            //            }
        }];
        
        if(self.isSaving == NO){
            self.isSaving = YES;
            [self saveData];
        }
        //check if text is empty.
        //        NSLog(@"content offset y = %f",scrollView.contentOffset.y);
    }else {
        //        NSLog(@"normal scroll");
    }
}

//-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    NSLog(@"to the toppp");
//}

-(void) appBecomeActive: (NSNotification *)noification{
//    NSLog(@"app become active again ...");
    // reset the textField ...
}

-(void) appEnterBackground:(NSNotification *)notification{
//    NSLog(@"app enter background mode ... ");
//    [self saveData];
//    self.noteTextView.text = @"";
    //    TODO : save data then reset the textView ?
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
