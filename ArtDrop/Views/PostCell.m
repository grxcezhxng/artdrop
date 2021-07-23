//
//  PostCell.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "PostCell.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _renderStyling];
}

- (void)setCellData {
    _post = self.post;
    
    self.imageView.layer.cornerRadius = 10;
    
    PFFileObject *const postPhoto = self.post.image;
    NSURL *const imageURL = [NSURL URLWithString:postPhoto.url];
    [self.artworkView setImageWithURL:imageURL];
    self.artworkView.layer.cornerRadius = 5;
    
    [self.artistButton setTitle:self.post.artist.name forState:UIControlStateNormal];
    self.titleLabel.text = self.post[@"title"];
    self.yearLabel.text = self.post[@"year"];
    self.priceLabel.text = self.post[@"price"];
    self.post.isLiked = [self.post.likedByUser containsObject:PFUser.currentUser.objectId];
    [self.likeButton setTintColor:(self.post.isLiked ? [UIColor redColor] :  [UIColor whiteColor])];
    [self.likeButton setImage: (self.post.isLiked ? [UIImage systemImageNamed:@"heart.fill"] : [UIImage systemImageNamed:@"heart"]) forState: UIControlStateNormal];
}

- (IBAction)handleLike:(id)sender {
    if(self.post.isLiked){
        self.post.isLiked = NO;
        [self.post.likedByUser removeObject:PFUser.currentUser.objectId];
        [self.post setObject:self.post.likedByUser forKey:@"likedByUser"];
        [self.post saveInBackground];
        
    } else  {
        self.post.isLiked = YES;
        [self.post.likedByUser addObject:PFUser.currentUser.objectId];
        [self.post setObject:self.post.likedByUser forKey:@"likedByUser"];
        [self.post saveInBackground];
    }
    [self setCellData];
}

- (void)_renderStyling {
    self.likeButton.layer.cornerRadius = 16;
    self.likeButton.layer.opacity = 0.65;
    self.likeButton.layer.zPosition = MAXFLOAT;
    self.likeButton.backgroundColor = UIColor.blackColor;
    const CGFloat spacing = 1;
    self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

@end
