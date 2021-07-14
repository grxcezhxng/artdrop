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

    self.imageView.layer.cornerRadius = 5;
    
    PFFileObject *const postPhoto = self.post.image;
    NSURL *const imageURL = [NSURL URLWithString:postPhoto.url];
    [self.artworkView setImageWithURL:imageURL];
    
//    PFUser *const author = self.post[@"author"];
    
//    PFFileObject *const profilePhoto = author[@"profilePhoto"];
//    NSURL *const profileImageURL = [NSURL URLWithString:profilePhoto.url];
//    [self.profilePhoto setImageWithURL:profileImageURL];
//    self.profilePhoto.layer.cornerRadius = 25;
    
    self.artistLabel.text = self.post.artist.name;
    self.titleLabel.text = self.post[@"title"];
    self.yearLabel.text = self.post[@"year"];
    self.priceLabel.text = self.post[@"price"];
}

@end
