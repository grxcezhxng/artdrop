//
//  SettingsViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/16/21.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextField+Extensions.h"
#import "UITextView+Extensions.h"
#import "ArtHelper.h"

@interface SettingsViewController () <UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioField;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _renderData];
    [self _renderStyling];
}

#pragma mark - IB Actions

- (IBAction)handleLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *const loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    }];
}

- (IBAction)handleTapPhoto:(id)sender {
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)handleBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    ArtHelper *const imageHelper = [ArtHelper new];
    UIImage *const resizedImage = [imageHelper resizeImage:editedImage withSize:CGSizeMake(100, 100)];
    self.profilePhoto.image = resizedImage;
    self.profilePhoto.layer.cornerRadius = 60;
    UIImage *const latestPhoto = [imageHelper resizeImage:self.profilePhoto.image withSize:CGSizeMake(100, 100)];
    
    // Save new profile photo for user
    NSData *const imageData = UIImagePNGRepresentation(latestPhoto);
    PFFileObject *const file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    [PFUser.currentUser setObject:file forKey:@"profilePhoto"];
    
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Sucessfully saved user photo");
        } else {
            NSLog(@"error: %@", error);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.emailField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.emailField.layer.borderWidth= 1.0f;
    self.emailField.textColor = [UIColor blackColor];
    self.emailLabel.textColor = [UIColor darkGrayColor];
    [PFUser.currentUser setObject:self.emailField.text forKey:@"email"];
    [PFUser.currentUser saveInBackgroundWithBlock:nil];
    [self.emailField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.emailField.layer.borderColor=[[UIColor systemIndigoColor]CGColor];
    self.emailField.layer.borderWidth= 1.5f;
    self.emailLabel.textColor = [UIColor systemIndigoColor];
}

#pragma mark - UITextView Delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.bioField.text = @"";
    self.bioField.textColor = [UIColor blackColor];
    self.bioField.layer.borderColor=[[UIColor systemIndigoColor]CGColor];
    self.bioField.layer.borderWidth= 1.5f;
    self.bioLabel.textColor = [UIColor systemIndigoColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        if(self.bioField.text.length == 0) {
            self.bioField.textColor = [UIColor blackColor];
            self.bioLabel.textColor = [UIColor darkGrayColor];
            self.bioField.text = @"Your bio goes here!";
            [self.bioField resignFirstResponder];
        } else {
            [PFUser.currentUser setObject:self.bioField.text forKey:@"bio"];
        }
        [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                NSLog(@"Sucessfully saved user bio");
            } else {
                NSLog(@"error: %@", error);
            }
        }];
        self.bioField.layer.borderColor=[[UIColor grayColor]CGColor];
        self.bioField.layer.borderWidth= 1.0f;
        [self.bioField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods

- (void)_renderData {
    self.nameLabel.text = PFUser.currentUser[@"name"];
    self.usernameLabel.text  = [NSString stringWithFormat:@"%@%@", @"@", PFUser.currentUser.username];
    self.emailField.delegate = self; 
    self.emailField.text = PFUser.currentUser[@"email"];
    self.bioField.delegate = self;
    if(PFUser.currentUser[@"bio"]) {
        self.bioField.text = PFUser.currentUser[@"bio"];
    } else {
        self.bioField.textColor = [UIColor blackColor];
        self.bioField.text = @"Your bio goes here!";
    }
    
    self.profilePhoto.userInteractionEnabled = YES;
    self.profilePhoto.layer.cornerRadius = 60;
    if(PFUser.currentUser[@"profilePhoto"]) {
        PFFileObject *const file = PFUser.currentUser[@"profilePhoto"];
        NSURL *const url = [NSURL URLWithString: file.url];
        [self.profilePhoto setImageWithURL:url];
    }
}

- (void)_renderStyling {
    [self.emailField setupTheme];
    [self.bioField setupTheme];
}

@end
