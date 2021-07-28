//
//  ArtAnnotation.h
//  ArtDrop
//
//  Created by gracezhg on 7/28/21.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

//@interface ArtAnnotation : NSObject <MKAnnotation>
@interface ArtAnnotation : MKAnnotationView

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) Post *post;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END

