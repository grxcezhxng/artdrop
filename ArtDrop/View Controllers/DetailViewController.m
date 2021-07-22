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

@interface DetailViewController ()

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

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _renderData];
    [self _renderStyling];
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.post.location.latitude.floatValue, self.post.location.longitude.floatValue);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion sfRegion = {coord, span};
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [annotation setTitle:self.post.location.name]; //You can set the subtitle too
    [self.mapView setRegion:sfRegion animated:false];
    [self.mapView addAnnotation:annotation];
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
    
    [self.likeButton setTintColor:(self.post.isLiked ? [UIColor redColor] :  [UIColor whiteColor])];
    [self.likeButton setImage: (self.post.isLiked ? [UIImage systemImageNamed:@"heart.fill"] : [UIImage systemImageNamed:@"heart"]) forState: UIControlStateNormal];
}

- (IBAction)hanldeLike:(id)sender {
    self.post.isLiked = !self.post.isLiked;
    [self.post saveInBackgroundWithBlock: nil];
    [self _renderData];
}

- (void)_renderStyling {
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
