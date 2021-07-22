//
//  Location.h
//  ArtDrop
//
//  Created by gracezhg on 7/21/21.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : PFObject<PFSubclassing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

+ (Location *)createLocation:(NSString*)name address:(NSString*)address latitude:( NSNumber * _Nullable )latitude longitude:( NSNumber * _Nullable )longitude withCompletion: (PFBooleanResultBlock  _Nullable)completion;
//- (MKMapItem*)mapItem;

@end

NS_ASSUME_NONNULL_END
