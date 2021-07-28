//
//  SearchCell.m
//  ArtDrop
//
//  Created by gracezhg on 7/28/21.
//

#import "SearchCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCellData {
    _post = self.post;
    
    self.artworkImage.layer.cornerRadius = 10;
    PFFileObject *const postPhoto = self.post.image;
    NSURL *const imageURL = [NSURL URLWithString:postPhoto.url];
    [self.artworkImage setImageWithURL:imageURL];
    self.artworkImage.layer.cornerRadius = 5;
    self.titleLabel.text = self.post[@"title"];
    self.artistLabel.text = self.post.artist.name;
}
@end
