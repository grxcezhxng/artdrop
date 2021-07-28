//
//  MapViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/27/21.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
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
            
            for (int i = 0; i < [self.arrayOfLocations count]; i++) {
                
                CLLocation *location = self.arrayOfLocations[i];
                CLLocationCoordinate2D coordinate = [location coordinate];
                Post *post = self.arrayOfPosts[i];
                
                // Set the coordinate and post for the annotation
                MKPointAnnotation *const annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = coordinate;
//                annotation.post = post;
                
                [self.mapView addAnnotation:annotation];
            }
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    
    annotationView.image = [UIImage systemImageNamed:@"square.grid.2x2.fill"];
    annotationView.canShowCallout = YES;
    annotationView.calloutOffset = CGPointMake(-5, 5);

    return annotationView;
    
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
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
