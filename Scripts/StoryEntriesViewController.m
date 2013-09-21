//
//  StoryEntriesViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "StoryEntriesViewController.h"

@interface StoryEntriesViewController () <UITextViewDelegate>
@property (nonatomic, strong) NSArray *storyEntries;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
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
    NSLog(@"story: %@", self.story);
    NSLog(@"story Entries: %@", [self.story objectForKey:@"storyEntries"]);
    self.storyEntries = [self.story objectForKey:@"storyEntries"];

//    NSLog(@"se 1 text: %@", [storyEntries[0] objectForKey:@"text"]);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storyEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"storyEntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        
    }
    
    //Customize Cell
    PFObject *storyEntry = self.storyEntries[indexPath.row];
    cell.textLabel.text = [storyEntry objectForKey:@"text"];
    
    return cell;
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
        NSLog(@"send");
        NSString *text = textView.text;
        
      //  [self.story setObject:@[storyEntry] forKey:@"storyEntries"];
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
                    [self.theTableView reloadData];
                    
                    
                }
            }];
        }];
    }
    return YES;
}


@end
