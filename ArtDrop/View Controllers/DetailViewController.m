//
//  DetailViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/14/21.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ArtistViewController.h"
#import "Artist.h"
#import <MapKit/MapKit.h>

@interface DetailViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *artworkView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediumLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sellerProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerBioLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *inquireButton;
@property (weak, nonatomic) IBOutlet UILabel *forSaleLabel;
@property (weak, nonatomic) IBOutlet UIView *saleIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *artistProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *artistDescription;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _renderData];
    [self _renderStyling];
    [self _renderMapView];
}

#pragma mark - IB Actions

- (IBAction)handleLike:(id)sender {
    self.post.isLiked = !self.post.isLiked;
    [self.post saveInBackgroundWithBlock: nil];
    [self _renderData];
}

- (IBAction)handleInquire:(id)sender {
    NSString *const messageBody = @"iOS programming is so fun!";
    NSArray *const toRecipents = [NSArray arrayWithObject:self.post.author.email];
    MFMailComposeViewController *const picker = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Test mail"];
        [picker setMessageBody:messageBody isHTML:NO];
        [picker setToRecipients:toRecipents];
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - MFMailCompose

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private Methods

- (void)_renderMapView {
    self.mapView.delegate = self;
    [Location annotateFromAddress:self.post.location.address withMapView:self.mapView];
}

- (void)_renderData {
    PFFileObject *const postPhoto = self.post.image;
    NSURL *const imageURL = [NSURL URLWithString:postPhoto.url];
    [self.artworkView setImageWithURL:imageURL];
    
    self.artistLabel.text = self.post.artist.name;
    self.titleLabel.text = self.post[@"title"];
    self.yearLabel.text = self.post[@"year"];
    self.mediumLabel.text = self.post[@"medium"];
    self.priceLabel.text = self.post[@"price"];
    self.descriptionLabel.text = self.post[@"description"];
    self.sellerNameLabel.text = self.post.author[@"name"];
    self.sellerBioLabel.text = self.post.author[@"bio"];
    if(self.post.author[@"profilePhoto"]) {
        PFFileObject *const file = self.post.author[@"profilePhoto"];
        NSURL *const url = [NSURL URLWithString: file.url];
        [self.sellerProfilePhoto setImageWithURL:url];
    }
    if([self.post[@"price"] isEqualToString:@"Not for sale"]) {
        self.forSaleLabel.text = @"Not for sale";
        self.saleIndicator.backgroundColor = UIColor.redColor;
    }
    else {
        self.forSaleLabel.text = @"For Sale";
        self.saleIndicator.backgroundColor = UIColor.greenColor;
    }
    self.artistName.text = self.post.artist.name;
    
    [self.likeButton setTintColor:(self.post.isLiked ? [UIColor redColor] :  [UIColor whiteColor])];
    [self.likeButton setImage: (self.post.isLiked ? [UIImage systemImageNamed:@"heart.fill"] : [UIImage systemImageNamed:@"heart"]) forState: UIControlStateNormal];
}

- (void)_renderStyling {
    self.artistProfilePhoto.layer.cornerRadius = 33;
    self.saleIndicator.layer.cornerRadius = 5;
    self.mapView.layer.cornerRadius = 8;
    self.artworkView.layer.cornerRadius = 5;
    self.inquireButton.layer.cornerRadius = 10;
    self.sellerProfilePhoto.layer.masksToBounds = YES;
    self.sellerProfilePhoto.layer.cornerRadius = 33;
    self.likeButton.layer.cornerRadius = 16;
    self.likeButton.layer.opacity = 0.65;
    self.likeButton.layer.zPosition = MAXFLOAT;
    self.likeButton.backgroundColor = UIColor.blackColor;
    const CGFloat spacing = 1;
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

@end
