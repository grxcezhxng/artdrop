//
//  SignUpViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "SignUpViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import "UIButton+Extensions.h"
#import "UITextField+Extensions.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    self.nameField.delegate = self;
    [self _renderStyling];
}

#pragma mark - IBActions

- (IBAction)handleSignUp:(id)sender {
    if (([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) || [self.nameField.text isEqual:@""]) {
        [self _showErrorAlert];
    }
    [self _registerUser];
}

- (IBAction)handleLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleBack:(id)sender {
    if(self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.nameField resignFirstResponder];
    return YES;
}

#pragma mark - Private Methods

- (void)_registerUser {
    PFUser *const newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
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
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)_renderStyling {
    [self.usernameField setupTheme];
    [self.passwordField setupTheme];
    [self.usernameField setupTheme];
    [self.emailField setupTheme];
    [self.usernameField setupTheme];
    [self.nameField setupTheme];
    [self.signupButton setupTheme];
}

@end
