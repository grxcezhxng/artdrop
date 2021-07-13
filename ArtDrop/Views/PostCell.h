//
//  PostCell.h
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;

- (void)setCellData;

@end

NS_ASSUME_NONNULL_END
