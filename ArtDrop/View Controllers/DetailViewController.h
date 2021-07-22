//
//  DetailViewController.h
//  ArtDrop
//
//  Created by gracezhg on 7/14/21.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
