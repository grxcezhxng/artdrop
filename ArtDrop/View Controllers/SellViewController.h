//
//  SellViewController.h
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Artist.h"
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface SellViewController : UIViewController

@property (strong, nonatomic) Artist *artist;
@property (strong, nonatomic) Location *location;

@end

NS_ASSUME_NONNULL_END
