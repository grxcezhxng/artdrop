//
//  LoginViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Extensions.h"
#import "UITextField+Extensions.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    [self _renderStyling];
}

#pragma mark - IBAction methods

- (IBAction)handleLogin:(id)sender {
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self _showErrorAlert];
    }
    [self _loginUser];
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    return YES;
}

#pragma mark - Private Methods

- (void)_loginUser {
    NSString *const username = self.usernameField.text;
    NSString *const password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            SceneDelegate *const delegate = (SceneDelegate *) self.view.window.windowScene.delegate;
            UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
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

- (void)_renderStyling {
    [self.usernameField setupTheme];
    [self.passwordField setupTheme];
    [self.loginButton setupTheme];
}

@end
