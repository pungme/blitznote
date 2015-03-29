//
//  FirstViewController.h
//  takenote
//
//  Created by Worathiti Manosroi on 3/23/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeNoteViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (nonatomic) BOOL isSaving;
@end

