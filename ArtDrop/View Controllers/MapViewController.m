//
//  MapViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/27/21.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ArtAnnotation.h"
#import "Parse/Parse.h"
#import "Post.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (nonatomic, strong) NSArray *arrayOfLocations;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _fetchLocations];
    self.mapView.delegate = self;
    self.mapView.layer.cornerRadius = 20;
}

#pragma mark - MKMapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if ([annotation isKindOfClass:[ArtAnnotation class]]) {
        ArtAnnotation *artAnnotation = (ArtAnnotation *)annotation;
        
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.calloutOffset = CGPointMake(0, 4);
            if (artAnnotation.image) {
                UIImageView *calloutImage = (UIImageView*)pinView.leftCalloutAccessoryView;
                calloutImage.image = artAnnotation.image;
                pinView.image = artAnnotation.image;
            }
        }
        else {
            pinView.annotation = annotation;
        }
        pinView.image = artAnnotation.image;
        return pinView;
    }
    return nil;
}

#pragma mark - Private Helper Methods

- (void)_fetchLocations {
    PFQuery *const postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"artist"];
    [postQuery includeKey:@"location"];
    postQuery.limit = 40;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            NSMutableArray *locations = [[NSMutableArray alloc] init];
            for (Post *post in self.arrayOfPosts) {
                if (post.location.latitude && post.location.longitude) {
                    double latitude = [post.location.latitude doubleValue];
                    double longitude = [post.location.longitude doubleValue];
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                    [locations addObject:location];
                }
            }
            self.arrayOfLocations = locations;
            
            NSMutableArray *arrAnnotation = [[NSMutableArray alloc] init];
            for (int i = 0; i < [self.arrayOfLocations count]; i++) {
                Post *post = self.arrayOfPosts[i];
                ArtAnnotation *annotation = [[ArtAnnotation alloc] init];
                annotation.post = post;
                CLLocation *location = self.arrayOfLocations[i];
                CLLocationCoordinate2D coordinate = [location coordinate];
                annotation.coordinate = coordinate;
                
                PFFileObject *imageFile = post.image;
                if (imageFile) {
                    NSURL *url = [NSURL URLWithString: imageFile.url];
                    NSData *fileData = [NSData dataWithContentsOfURL: url];
                    UIImage *photo = [[UIImage alloc] initWithData:fileData];
                    annotation.image = [self _resizeImage:photo withSize:CGSizeMake(50.0, 50.0)];
                }
                [arrAnnotation addObject:annotation];
            }
            [self.mapView addAnnotations:arrAnnotation];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
