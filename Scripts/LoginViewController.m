//
//  LoginViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.navigationItem.hidesBackButton = YES;
    
    UITapGestureRecognizer *dismissKeyboardRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismissKeyboardRecognizer];
    
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-10,320,400);
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.usernameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"Password: %@ Username: %@", password, username);
    
    // check if null
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There's a username and a password field for a reason. Yeah, I'm looking at you, jackass." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }
    
    // actual login
    else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WHO ARE YOU!?!?!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

@end
