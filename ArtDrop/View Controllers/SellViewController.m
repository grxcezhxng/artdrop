//
//  SellViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "SellViewController.h"
#import "Post.h"
#import "Artist.h"
#import "Location.h"
#import <MapKit/MapKit.h>

@interface SellViewController () <UIImagePickerControllerDelegate, UITextViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *artistField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *mediumField;
@property (weak, nonatomic) IBOutlet UITextField *dimensionsField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.mapView.delegate = self;
    self.descriptionTextView.delegate = self;
    self.titleField.delegate = self;
    self.artistField.delegate = self;
    self.yearField.delegate = self;
    self.mediumField.delegate = self;
    self.dimensionsField.delegate = self;
    self.priceField.delegate = self;
    self.imageView.userInteractionEnabled = YES;
    [self _renderStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - IB Actions

- (IBAction)handleTapPhoto:(id)sender {
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)handleSubmit:(id)sender {
    [self _submitData];
}

#pragma mark - Search Bar Delegate Methods

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        NSString *const location = searchBar.text;
        self.location.name = searchBar.text;
        self.location.address = searchBar.text;
        
        CLGeocoder *const geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error){
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *const topResult = [placemarks objectAtIndex:0];
                MKPlacemark *const placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                
                CLLocation *location = placemark.location;
                CLLocationCoordinate2D coordinate = location.coordinate;
                
                self.location.latitude = [NSNumber numberWithDouble:coordinate.latitude];
                self.location.longitude = [NSNumber numberWithDouble:coordinate.longitude];
                
            }
        }
         ];
        
        self.location = [Location createLocation:searchBar.text address:searchBar.text latitude:self.location.latitude longitude:self.location.longitude withCompletion:nil];
        
        [Location annotateFromAddress:self.location.address withMapView:self.mapView];
    }
    return YES;
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    
    self.imageView.backgroundColor = UIColor.whiteColor;
    UIImage *const resizedImage = [self _resizeImage:editedImage withSize:CGSizeMake(350, 350)];
    self.imageView.image = resizedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextView Delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.descriptionTextView.text = @"";
    self.descriptionTextView.textColor = [UIColor blackColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        if(self.descriptionTextView.text.length == 0) {
            self.descriptionTextView.textColor = [UIColor lightGrayColor];
            self.descriptionTextView.text = @"Description!";
            [self.descriptionTextView resignFirstResponder];
        }
        [self.descriptionTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods

- (void)_submitData {
    NSString *const artistName = self.artistField.text;
    PFQuery *const artistQuery = [PFQuery queryWithClassName:@"Artist"];
    [artistQuery includeKey:@"name"];
    [artistQuery whereKey:@"name" equalTo:artistName];
    artistQuery.limit = 1;
    
    [artistQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Successlyfully fetched artist");
            if([objects count] == 0) {
                self.artist = [Artist createArtist:artistName withBio:@"" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded){
                        NSLog(@"Artist created successfully");
                    } else {
                        NSLog(@"Artist error: %@", error);
                    }
                }];
            }
            else {
                self.artist = objects[0];
            }
            
            [Post postUserImage:self.imageView.image withTitle:self.titleField.text withArtist:self.artist withMedium:self.mediumField.text withYear:self.yearField.text withSize:self.dimensionsField.text withPrice:self.priceField.text withDescription:self.descriptionTextView.text withLocation:self.location withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    NSLog(@"Posted successfully");
                    [self _showSubmitConfirmation];
                    [self _resetForm];
                } else {
                    NSLog(@"Posting error: %@", error);
                }
            }];
        } else {
            NSLog(@"Artist error: %@", error);
        }
    }];
}

- (void)_showSubmitConfirmation {
    UIAlertController *const alert = [UIAlertController alertControllerWithTitle:@"Successfully uploaded :)" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *const okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
    }];
}

- (void)_resetForm {
    self.titleField.text = @"";
    self.artistField.text = @"";
    self.mediumField.text = @"";
    self.yearField.text = @"";
    self.dimensionsField.text = @"";
    self.priceField.text = @"";
    self.descriptionTextView.text = @"";
    self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imageView setTintColor:[UIColor lightGrayColor]];
    self.searchBar.text = @"";
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *const resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *const newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)_renderStyling {
    self.mapView.layer.cornerRadius = 5;
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    self.descriptionTextView.text = @"Description";
    self.descriptionTextView.layer.cornerRadius=8.0f;
    self.descriptionTextView.layer.masksToBounds=YES;
    self.descriptionTextView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.descriptionTextView.layer.borderWidth= 1.0f;
    self.descriptionTextView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.titleField.layer.cornerRadius= 8.0f;
    self.titleField.layer.masksToBounds=YES;
    self.titleField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.titleField.layer.borderWidth= 1.0f;
    self.titleField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.artistField.layer.cornerRadius= 8.0f;
    self.artistField.layer.masksToBounds=YES;
    self.artistField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.artistField.layer.borderWidth= 1.0f;
    self.artistField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.yearField.layer.cornerRadius= 8.0f;
    self.yearField.layer.masksToBounds=YES;
    self.yearField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.yearField.layer.borderWidth= 1.0f;
    self.yearField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.mediumField.layer.cornerRadius= 8.0f;
    self.mediumField.layer.masksToBounds=YES;
    self.mediumField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.mediumField.layer.borderWidth= 1.0f;
    self.mediumField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.dimensionsField.layer.cornerRadius= 8.0f;
    self.dimensionsField.layer.masksToBounds=YES;
    self.dimensionsField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.dimensionsField.layer.borderWidth= 1.0f;
    self.dimensionsField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.priceField.layer.cornerRadius= 8.0f;
    self.priceField.layer.masksToBounds=YES;
    self.priceField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.priceField.layer.borderWidth= 1.0f;
    self.priceField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.submitButton.layer.cornerRadius = 10;
    self.submitButton.layer.masksToBounds=YES;
}

@end
