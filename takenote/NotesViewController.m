//
//  NotesViewController.m
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import "NotesViewController.h"

BOOL isFirstTime = YES;
@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.f;
    
}

- (void)viewDidAppear:(BOOL)animated{
    if(isFirstTime == YES){
        isFirstTime = NO;
        [self performSegueWithIdentifier: @"takenotesegue" sender: self];
    }
    
//    [self performSegueWithIdentifier: @"takenotesegue" sender: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
