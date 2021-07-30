//
//  ArtHelper.h
//  ArtDrop
//
//  Created by gracezhg on 7/29/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArtHelper : NSObject

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
