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
#import "ArtAPIManager.h"
#import "ArtHelper.h"
#import "DetailViewController.h"

@interface MapViewController () <MKMapViewDelegate, UISearchBarDelegate, MKLocalSearchCompleterDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (nonatomic, strong) NSArray *arrayOfLocations;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray <MKLocalSearchCompletion *> *searchResults;

@end

@implementation MapViewController {
    MKLocalSearchCompleter *searchCompleter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _fetchLocations];
    self.mapView.delegate = self;
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = TRUE;
    self.mapView.layer.cornerRadius = 20;
    const CLLocationCoordinate2D sf = CLLocationCoordinate2DMake(37.783333, -122.416667);
    [self.mapView setRegion: MKCoordinateRegionMakeWithDistance(sf, 1000000, 1000000)];
    
    searchCompleter = [[MKLocalSearchCompleter alloc] init];
    searchCompleter.delegate = self;
    self.searchResults = [[NSArray alloc] init];
}

#pragma mark - Pragma Mark

- (IBAction)handleBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchCompleter.queryFragment = searchText;
    self.tableView.hidden = FALSE;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.tableView.hidden = TRUE;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    self.tableView.hidden = TRUE;
    return YES;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    MKLocalSearchCompletion *const completion = self.searchResults[indexPath.row];
    
    NSString *const location = completion.title;
    CLGeocoder *const geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *const topResult = [placemarks objectAtIndex:0];
            MKPlacemark *const placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
            
            CLLocation *const location = placemark.location;
            const CLLocationCoordinate2D coordinate = location.coordinate;
            
            [self.mapView setRegion: MKCoordinateRegionMakeWithDistance(coordinate, 6000, 6000) animated:YES];
        }
    }
    ];
    self.tableView.hidden = TRUE;
}

#pragma mark - TableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"MapSearchCell"];
    MKLocalSearchCompletion *const result = self.searchResults[indexPath.row];
    cell.textLabel.text = result.title;
    cell.detailTextLabel.text = result.subtitle;
    return cell;
}

#pragma mark - MKLocalSearchCompleter Delegate Methods
- (void)completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    self.searchResults = completer.results;
    [self.tableView reloadData];
}

#pragma mark - MKMapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[ArtAnnotation class]]) {
        ArtAnnotation *const artAnnotation = (ArtAnnotation *)annotation;
        
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [button addTarget:self action:@selector(handleShowDetail) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = button;
            pinView.calloutOffset = CGPointMake(0, 4);
            if (artAnnotation.image) {
                UIImageView *const calloutImage = (UIImageView*)pinView.leftCalloutAccessoryView;
                calloutImage.image = artAnnotation.image;
                pinView.image = artAnnotation.image;
            }
        } else {
            pinView.annotation = annotation;
        }
        pinView.image = artAnnotation.image;
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control API_UNAVAILABLE(tvos) {
    ArtAnnotation *const artAnnotation = (ArtAnnotation *)(view.annotation);
    self.post = artAnnotation.post;
    [self performSegueWithIdentifier:@"mapToDetails" sender:control];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mapToDetails"]) {
        Post *const post = self.post;
        DetailViewController *const detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}

#pragma mark - Network Calls

- (void)_fetchLocations {
    ArtAPIManager *const manager = [ArtAPIManager new];
    [manager fetchFeed:^(NSArray * _Nonnull posts, NSError * _Nonnull error) {
        self.arrayOfPosts = posts;
        NSMutableArray *const locations = [[NSMutableArray alloc] init];
        for (Post *post in self.arrayOfPosts) {
            if (post.location.latitude && post.location.longitude) {
                double latitude = [post.location.latitude doubleValue];
                double longitude = [post.location.longitude doubleValue];
                CLLocation *const location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                [locations addObject:location];
            }
        }
        self.arrayOfLocations = locations;
        [self _addAnnotations];
    }];
}

#pragma mark - Private Methods

- (void)_addAnnotations {
    NSMutableArray *const arrAnnotation = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.arrayOfLocations count]; i++) {
        Post *const post = self.arrayOfPosts[i];
        ArtAnnotation *const annotation = [[ArtAnnotation alloc] init];
        annotation.post = post;
        CLLocation *const location = self.arrayOfLocations[i];
        const CLLocationCoordinate2D coordinate = [location coordinate];
        annotation.coordinate = coordinate;
        
        PFFileObject *const imageFile = post.image;
        if (imageFile) {
            NSURL *const url = [NSURL URLWithString: imageFile.url];
            NSData *const fileData = [NSData dataWithContentsOfURL: url];
            UIImage *const photo = [[UIImage alloc] initWithData:fileData];
            ArtHelper *const imageHelper = [ArtHelper new];
            annotation.image = [imageHelper resizeImage:photo withSize:CGSizeMake(50.0, 50.0)];
        }
        [arrAnnotation addObject:annotation];
    }
    [self.mapView addAnnotations:arrAnnotation];
}

@end
