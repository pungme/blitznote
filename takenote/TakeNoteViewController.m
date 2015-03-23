//
//  FirstViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "TakeNoteViewController.h"

@interface TakeNoteViewController ()

@end

@implementation TakeNoteViewController

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
    
//    self.view.backgroundColor = [UIColor blueColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0)
    {
        NSLog(@"to the toppp");
        [self dismissViewControllerAnimated:YES completion:nil];
//        NSLog(@"content offset y = %f",scrollView.contentOffset.y);
    }else {
        NSLog(@"normal scroll");
    }
}

//-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    NSLog(@"to the toppp");
//}

-(void) appBecomeActive: (NSNotification *)noification{
    NSLog(@"app become active again ...");
}

-(void) appEnterBackground:(NSNotification *)notification{
    NSLog(@"app enter background mode ... ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
