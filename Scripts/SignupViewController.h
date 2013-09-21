//
//  SignupViewController.h
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@class TPKeyboardAvoidingScrollView;

@interface SignupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

-(IBAction)signUp:(id)sender;
@end
