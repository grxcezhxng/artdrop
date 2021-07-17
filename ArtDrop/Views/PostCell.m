//
//  PostCell.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "PostCell.h"
#import "Artist.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCellData {
    _post = self.post;

    self.imageView.layer.cornerRadius = 10;
    
    PFFileObject *const postPhoto = self.post.image;
    NSURL *const imageURL = [NSURL URLWithString:postPhoto.url];
    [self.artworkView setImageWithURL:imageURL];
    self.artworkView.layer.cornerRadius = 5;
    
    self.artistLabel.text = self.post.artist.name;
    self.titleLabel.text = self.post[@"title"];
    self.yearLabel.text = self.post[@"year"];
    self.priceLabel.text = self.post[@"price"];
    [self.likeButton setTintColor:(self.post.isLiked ? [UIColor redColor] :  [UIColor whiteColor])];
    [self.likeButton setBackgroundImage: (self.post.isLiked ? [UIImage systemImageNamed:@"heart.fill"] : [UIImage systemImageNamed:@"heart"]) forState: UIControlStateNormal];
}

//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//
//    if (highlighted) {
//        self.likeButton.backgroundColor = [UIColor lightGrayColor];
//    } else {
//        self.likeButton.backgroundColor = [UIColor blackColor];
//    }
//}

- (IBAction)handleLike:(id)sender {
    self.post.isLiked = !self.post.isLiked;
    [self setCellData];
}

@end
