//
//  ProfileViewController.m
//  Scripts
//
//  Created by Maijid Moujaled on 9/20/13.
//  Copyright (c) 2013 Maijid Moujaled. All rights reserved.
//

#import "ProfileViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <SVProgressHUD.h>


@interface ProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@end

@implementation ProfileViewController

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
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(71/255.0) green:(169/255.0) blue:(162/255.0) alpha:1];;
    
    
    
    
    UITapGestureRecognizer *tapProfileGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUploadImagePicker)];
    [self.profileImageView addGestureRecognizer:tapProfileGesture];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser];
    
    NSString *title = user.username;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", [[title substringToIndex:1] uppercaseString], [title substringFromIndex:1]];
    
    if (user) {
        NSLog(@"Current User: %@", user);
        self.usernameLabel.text = user.username;
        self.emailLabel.text = user.email;
        
        PFFile *imageFile = [[PFUser currentUser] objectForKey:@"image"];
        self.profileImageView.file = imageFile;
        [self.profileImageView loadInBackground];

    }
    
    else {
        self.usernameLabel.text = @"";
        self.emailLabel.text = @"";
        
        self.profileImageView.image = [UIImage imageNamed:@"rarr.jpg"];
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
   }


- (void)showUploadImagePicker
{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = NO;
    
    //        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    //            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //        } else {
    //            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //        }
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    self.imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePickerController.sourceType];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

#pragma mark - Camera Delegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    self.tabBarController.selectedIndex = 0;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Get the mediaType
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //A photo was taken or selected!
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.profileImageView.image = image;
        
        
        NSData *fileData;
        NSString *fileName;
        
        if (image) {
            UIImage *newImage = [self resizeImage:image toWidth:320.0f andHeight:320.0f];

            fileData = UIImagePNGRepresentation(newImage);
            fileName =  [NSString stringWithFormat:@"%@-profile-picture", [[PFUser currentUser] username]];
            
            PFFile *file = [PFFile fileWithName:fileName data:fileData];
            
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //Create a message object that associates this file to the recipients selected.
                   // [SVProgressHUD showWithStatus:@"Uploading photo!"];
                    
                    
                    //Update the user object.
                    [[PFUser currentUser] setObject:file forKey:@"image"];
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSLog(@"No error!");
                        }
                    }];
                    
                   
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh-oh!" message:error.userInfo[@"error"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                }
            }];

        }
        
        //If camera is used, save the image.
        /*
        if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        */
    } else {
        //A video was taken or selected
        /*
        self.videoFilePath  = (__bridge NSString *)([[info objectForKey: UIImagePickerControllerMediaURL] path]) ;
        
        if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
        */
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
