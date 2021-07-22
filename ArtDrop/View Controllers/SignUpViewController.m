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

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.nameField resignFirstResponder];
    return YES;
}

#pragma mark - IBActions

- (IBAction)handleSignUp:(id)sender {
    if(([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) || [self.nameField.text isEqual:@""] ) {
        [self _showErrorAlert];
    }
    [self _registerUser];
}

- (IBAction)handleLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private methods

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
    self.usernameField.layer.cornerRadius= 8.0f;
    self.usernameField.layer.masksToBounds=YES;
    self.usernameField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.usernameField.layer.borderWidth= 1.0f;
    self.usernameField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.passwordField.layer.cornerRadius= 8.0f;
    self.passwordField.layer.masksToBounds=YES;
    self.passwordField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.passwordField.layer.borderWidth= 1.0f;
    self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.emailField.layer.cornerRadius= 8.0f;
    self.emailField.layer.masksToBounds=YES;
    self.emailField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.emailField.layer.borderWidth= 1.0f;
    self.emailField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.nameField.layer.cornerRadius= 8.0f;
    self.nameField.layer.masksToBounds=YES;
    self.nameField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.nameField.layer.borderWidth= 1.0f;
    self.nameField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.signupButton.layer.cornerRadius = 10;
    self.signupButton.layer.masksToBounds=YES;
}

@end
