//
//  Location.m
//  ArtDrop
//
//  Created by gracezhg on 7/21/21.
//

#import "Location.h"

@implementation Location

@dynamic name;
@dynamic address;
@dynamic latitude;
@dynamic longitude;

+ (nonnull NSString *)parseClassName {
    return @"Location";
}

+ (Location *) createLocation:(NSString*)name address:(NSString*)address latitude:( NSNumber * _Nullable )latitude longitude:( NSNumber * _Nullable )longitude withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Location *const newLocation = [Location new];
    newLocation.name = name;
    newLocation.address = address;
    newLocation.latitude = latitude;
    newLocation.longitude = longitude;
    
    [newLocation saveInBackgroundWithBlock: completion];
    return newLocation;
}

//- (MKMapItem*)mapItem {
//    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
//
//    MKPlacemark *placemark = [[MKPlacemark alloc]
//                              initWithCoordinate:self.coordinate
//                              addressDictionary:addressDict];
//
//    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//    mapItem.name = self.title;
//
//    return mapItem;
//}

@end
