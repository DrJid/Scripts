//
//  StoryEntriesViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "StoryEntriesViewController.h"
#import "StoryMapViewController.h"
#import "StoryViewEntryCell.h"
#import <SVProgressHUD.h>

@interface StoryEntriesViewController () <UITextViewDelegate>
@property (nonatomic, strong) NSArray *storyEntries;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (weak, nonatomic) IBOutlet UITextView *aTextView;
@property (nonatomic, strong) NSMutableString *storyText;
@end

@implementation StoryEntriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.entryField.placeholderColor = [UIColor whiteColor];

    self.entryField.placeholder = @"Continue this story...";
    [self.entryField setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
    
    NSLog(@"story: %@", self.story);
    NSLog(@"story Entries: %@", [self.story objectForKey:@"storyEntries"]);
    self.storyEntries = [self.story objectForKey:@"storyEntries"];

    //NSLog(@"se 1 text: %@", [storyEntries[0] objectForKey:@"text"]);
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *dismissKeyboardRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboardRecognizer];
    
    self.storyText = [[NSMutableString alloc] init];
    for (PFObject *entry in self.storyEntries) {
        NSString *text = [entry objectForKey:@"text"];
        [self.storyText appendString:text];
        [self.storyText appendString:@"\n\n"];
    }
    NSLog(@"Stot: %@", self.storyText);
    self.aTextView.text = self.storyText;
}


- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextView
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text view returneddddd");
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [SVProgressHUD showWithStatus:@"Adding to story!"];
        NSLog(@"send");
        NSString *text = textView.text;
        
        //[self.story setObject:@[storyEntry] forKey:@"storyEntries"];
        PFObject *newStoryEntry = [PFObject objectWithClassName:@"StoryEntry"];
        [newStoryEntry setObject:text forKey:@"text"];
        [newStoryEntry setObject:[PFUser currentUser] forKey:@"user"];
        
        NSMutableArray *newStoryEntries = [NSMutableArray arrayWithArray:self.storyEntries];
        [newStoryEntries addObject:newStoryEntry];
        self.storyEntries = newStoryEntries; 
        NSLog(@"newSE: %@" , newStoryEntries);
        
        
        [self.story setObject:newStoryEntries forKey:@"storyEntries"];
        
        //Get users location
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                NSLog(@"no location error");
                [newStoryEntry setObject:geoPoint forKey:@"location"];
            } else {
                NSLog(@"crap location error");
                
                //it would set to null. We think.
            }
            
            [self.story saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"uh oh");
                    
                } else {
                    NSLog(@"Yay!");
                    [textView resignFirstResponder];
                    textView.text = @"";
//                    [self.theTableView reloadData];
                    [self.storyText appendString:text];
                    self.aTextView.text = self.storyText;
                    [SVProgressHUD showSuccessWithStatus:@"Entry added!"];
                }
            }];
        }];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMap"]) {
        StoryMapViewController *smvc = (StoryMapViewController *)segue.destinationViewController;
        smvc.storyEntries = self.storyEntries;
    }
}


@end
