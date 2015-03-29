//
//  EditNoteViewController.h
//  takenote
//
//  Created by Worathiti Manosroi on 3/29/15.
//  Copyright (c) 2015 Worathiti Manosroi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNoteViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (nonatomic) BOOL isSaving;
@property (nonatomic) NSIndexPath* indexPath;;
@end
