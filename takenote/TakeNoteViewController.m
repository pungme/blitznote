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
