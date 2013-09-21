//
//  StoryViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "StoryViewController.h"
#import "StoryViewCell.h"
#import "StoryEntriesViewController.h"

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *theTableView;

@end

@implementation StoryViewController

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
	// Do any additional setup after loading the view.
    
    }

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query includeKey:@"storyEntries"];
    [query includeKey:@"storyEntries.user"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
        }
        
        else {
            self.storyArray = objects;
            NSLog(@"Objects: %@", objects);
            
            [self.theTableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.storyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"StoryCell";
    StoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)  {
        cell = [[StoryViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    //Customize Cell
    
    PFObject *story = [self.storyArray objectAtIndex:indexPath.row];
    
    cell.titleField.text = [story objectForKey:@"title"];
    cell.summaryField.text = [story objectForKey:@"summary"];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showStoryEntry"]) {
        StoryEntriesViewController *sevc = (StoryEntriesViewController *) [segue destinationViewController];
        sevc.story = [self.storyArray objectAtIndex:[[self.theTableView indexPathForSelectedRow] row]];
    }
}

#pragma mark - Tv delegate
#pragma mark - UITableViewDelegate


@end
