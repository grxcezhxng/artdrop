//
//  Location.m
//  ArtDrop
//
//  Created by gracezhg on 7/21/21.
//

#import "Location.h"
#import <MapKit/MapKit.h>

@implementation Location

@dynamic name;
@dynamic address;
@dynamic latitude;
@dynamic longitude;

+ (nonnull NSString *)parseClassName {
    return @"Location";
}

+ (Location *)createLocation:(NSString*)name address:(NSString*)address latitude:( NSNumber * _Nullable )latitude longitude:( NSNumber * _Nullable )longitude withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Location *const newLocation = [Location new];
    newLocation.name = name;
    newLocation.address = address;
    newLocation.latitude = latitude;
    newLocation.longitude = longitude;
    
    [newLocation saveInBackgroundWithBlock: completion];
    return newLocation;
}

+ (MKMapView *)annotateFromAddress:(NSString*)address withMapView:(MKMapView *)mapView {
    NSString *const location = address;
    CLGeocoder *const geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *const topResult = [placemarks objectAtIndex:0];
            MKPlacemark *const placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
            
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            MKCoordinateRegion region = mapView.region;
            region.center = placemark.region.center;
            region.span.longitudeDelta /= 8.0;
            region.span.latitudeDelta /= 8.0;
            
            [mapView setRegion:region animated:YES];
            [mapView addAnnotation:placemark];
        }
    }
     ];
    return mapView;
}

+ (MKMapView *)annotateFromCoords:(NSString*)name latitude:( NSNumber * _Nullable )latitude longitude:( NSNumber * _Nullable )longitude withMapView:(MKMapView *)mapView {
    const CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    const MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    const MKCoordinateRegion region = {coord, span};
    MKPointAnnotation *const annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    [annotation setTitle:name]; //You can set the subtitle too
    [mapView setRegion:region animated:false];
    [mapView addAnnotation:annotation];
    return mapView;
}

@end
