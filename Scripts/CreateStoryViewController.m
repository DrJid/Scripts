//
//  CreateStoryViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "CreateStoryViewController.h"

@interface CreateStoryViewController ()

@end

@implementation CreateStoryViewController

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
    
    self.firstEntryField.placeholder = @"Write your Story :D";
    self.summaryField.placeholder = @"Write a summary for your story!!!";
    
    UITapGestureRecognizer *dismissKeyboardRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboardRecognizer];
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
- (IBAction)submit:(id)sender {
    
    NSString *title = [self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *summary = [self.summaryField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstStoryEntry = [self.firstEntryField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   
    
    PFObject *story = [PFObject objectWithClassName:@"Story"];
    [story setObject:title forKey:@"title"];
    [story setObject:summary forKey:@"summary"];
    
    PFObject *storyEntry = [PFObject objectWithClassName:@"StoryEntry"];
    [storyEntry setObject:firstStoryEntry forKey:@"text"];
    [storyEntry setObject:[PFUser currentUser] forKey:@"user"];
    [story setObject:@[storyEntry] forKey:@"storyEntries"];

    //Get users location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"no location error");
            [storyEntry setObject:geoPoint forKey:@"location"];
        } else {
            NSLog(@"crap location error");

            //it would set to null. We think.
        }
        
        [story saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"uh oh");
            } else {
                NSLog(@"Yay!");
                
                //Push to All Stories. 
            }
        }];
    }];
    
    
   
}

- (void)submit2:(id)sender
{
    
    
    /*
     - (IBAction)signUp:(id)sender {
     // get data
     NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     
     NSLog(@"%@ and %@", username, password);
     
     // check if null
     if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
     message:@"Make sure you've entered a username, password and email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alertView show];
     }
     
     else {
     // if not null, get the data
     PFUser *newUser = [PFUser user];
     newUser.username = username;
     newUser.password = password;
     newUser.email = email;
     
     [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (error) {
     // error
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry." message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     
     [alertView show];
     }
     else {
     // add the new user & get back to the root view controller
     [self.navigationController popToRootViewControllerAnimated:YES];
     
     }
     }];
     }
*/
}


@end
