//
//  SignUpViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "SignUpViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.nameField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (IBAction)handleSignUp:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""] || [self.nameField.text isEqual:@""] ) {
        [self _showErrorAlert];
    }
    [self _registerUser];
}

#pragma mark - Private methods

- (void)_registerUser {
    PFUser *const newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser setObject:self.nameField.text forKey:@"name"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)_showErrorAlert {
    UIAlertController *const alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username or password field can not be empty" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *const cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction *const okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
    }];
}

@end
