//
//  ArtistCollectionCell.m
//  ArtDrop
//
//  Created by gracezhg on 7/28/21.
//

#import "ArtistCollectionCell.h"

@implementation ArtistCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
}

@end
