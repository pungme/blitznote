//
//  FirstViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "TakeNoteViewController.h"


#define NOTE_LIST_KEY @"listOfAllNotes"
#define NOTE_CONTENT @"noteContent"
#define NOTE_DATE @"noteDate"

@interface TakeNoteViewController ()

@end
//BOOL isSaving = NO;

@implementation TakeNoteViewController

//- (void)viewDi

//- (void)viewDidAppear:(BOOL)animated{
//    self.noteTextView.text = @"";
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *swipeDownLabel = [[UILabel alloc]init];
//    swipeDownLabel.text = @"SWIPE DOWN TO SAVE";
//    swipeDownLabel.center = self.view.center;
//    
//    [self.view addSubview:swipeDownLabel];

    self.swipeDownLabel.hidden = YES;
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
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"]){
        _isFirstLaunch = YES;
    }else{
        _isFirstLaunch = NO;
        
    }
    
    if(self.isFirstLaunch){
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstLaunch"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        self.noteTextView.text = @"swipe down to save note";
        //TODO: user tutorial
        //        [self showIntroWithCrossDissolve];
    }
//    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    self.isSaving = NO;
}

- (void)saveData {
    
    if([self.noteTextView.text length] != 0){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    defaults set
    //    [defaults setInteger:9001 forKey:@"HighScore"];
        
        // the mutalbe array of all debts
        NSMutableArray * allNoteRecords = [[NSMutableArray alloc] init];
        NSMutableArray * currentNoteRecords = [defaults objectForKey:NOTE_LIST_KEY];
        
        if(currentNoteRecords.count > 0){ // if there are any current record ...
            //do the freaking copy
            allNoteRecords = [[defaults objectForKey:NOTE_LIST_KEY] mutableCopy];
        }
        
        NSString * noteContent = self.noteTextView.text; // change this shit
        NSDate * date = [NSDate date];
        
        NSDictionary * newNote = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:noteContent,date, nil]
                                                               forKeys:[NSArray arrayWithObjects:NOTE_CONTENT,NOTE_DATE, nil]];
        [allNoteRecords insertObject:newNote atIndex:0];
        if(self.isFirstLaunch){
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"firstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSDictionary * tutorialNote = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"swipe left to delete/edit/share",date, nil]
                                                                 forKeys:[NSArray arrayWithObjects:NOTE_CONTENT,NOTE_DATE, nil]];
            [allNoteRecords addObject:tutorialNote];
//            self.noteTextView.text = @"swipe down to save note";
            //TODO: user tutorial
            //        [self showIntroWithCrossDissolve];
        }
        
    //    NSLog(@"new record = %@",newNote);
    //    NSLog(@"all note record = %@", allNoteRecords);
        [defaults setObject:allNoteRecords forKey:NOTE_LIST_KEY];
        // do not forget to save changes
        [defaults synchronize];
    }
    self.isSaving = NO;
        
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"content offset = %f", scrollView.contentOffset.y);
    
    // set background color according to the contentOffset ...
    
    ///TODO: make it swipe down and reveal the note page
    [UIView transitionWithView:self.swipeDownLabel
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    if( scrollView.contentOffset.y < 0){
        //animate
        self.swipeDownLabel.hidden = NO;
    }else{
        self.swipeDownLabel.hidden = YES;
    }
    self.swipeDownLabel.frame = CGRectMake(self.swipeDownLabel.frame.origin.x,
                                          10 - scrollView.contentOffset.y/2,
                                           self.swipeDownLabel.frame.size.width,
                                           self.swipeDownLabel.frame.size.height);
    
//    self.view.frame = CGRectMake(self.view.frame.origin.x,
//                                            - scrollView.contentOffset.y,
//                                           self.view.frame.size.width,
//                                           self.view.frame.size.height);
    
    NSLog(@"contentOffset = %f",scrollView.contentOffset.y);
    CGFloat colorOffset = (scrollView.contentOffset.y) / 320;
//    NSLog(@"color offset = %f",colorOffset);
    self.view.backgroundColor = [UIColor colorWithRed:1.0 + colorOffset green:1.0+colorOffset blue:1.0+colorOffset alpha:1.0];
    
    if (scrollView.contentOffset.y < -110)
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
    NSLog(@"app become active again ...");
    // reset the textField ...
}

-(void) appEnterBackground:(NSNotification *)notification{
    NSLog(@"app enter background mode ... ");
    [self saveData];
    self.noteTextView.text = @"";
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
