//
//  TodayViewController.m
//  pin-widget
//
//  Created by Worathiti Manosroi on 2/28/16.
//  Copyright © 2016 Worathiti Manosroi. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#define NOTE_LIST_KEY @"listOfAllNotes"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *list1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
//    list1.text = @"bla bla bla bla";
//    list1.textColor = [UIColor whiteColor];
//    
//    [self.view addSubview:list1];
//    NSLog(@"I am here");
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.blitznote.TodayExtensionSharingDefaults"];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.myNotes = [NSMutableArray arrayWithArray:[sharedDefaults objectForKey:NOTE_LIST_KEY]];
    NSLog(@"note count = %lu",(unsigned long)[self.myNotes count]);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.pinNoteTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight/3) style:UITableViewStylePlain];
    self.pinNoteTableView.delegate = self;
    self.pinNoteTableView.dataSource = self;
    
//    self.preferredContentSize = self.pinNoteTableView.contentSize;
    self.preferredContentSize = CGSizeMake(0, screenHeight/3 -15);
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.pinNoteTableView];
//    self.view.frame = CGRectMake(0, 0, screenWidth, screenHeight/2);
//    NSMutableArray *allNotes = [NSMutableArray arrayWithArray:[defaults objectForKey:NOTE_LIST_KEY]];
//    NSMutableArray *filteredNotes = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.blitznote.TodayExtensionSharingDefaults"];
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.myNotes = [NSMutableArray arrayWithArray:[sharedDefaults objectForKey:NOTE_LIST_KEY]];
    [self.pinNoteTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.blitznote.TodayExtensionSharingDefaults"];
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.myNotes = [NSMutableArray arrayWithArray:[sharedDefaults objectForKey:NOTE_LIST_KEY]];
    [self.pinNoteTableView reloadData];
    
    completionHandler(NCUpdateResultNewData);
}

#pragma mark UITableViewDelegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    NSURL *pjURL = [NSURL URLWithString:@"blitznote://home"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pinNoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
//    cell.textLabel.text = @"HEYYY";
    cell.textLabel.text = [[self.myNotes objectAtIndex:indexPath.row] objectForKey:@"noteContent"];
    cell.textLabel.textColor = [UIColor whiteColor];
    //etc.
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _itemsCount;//self.boxes.count;
//    return [self.myNotes count];
    return 5;
    
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

@end
