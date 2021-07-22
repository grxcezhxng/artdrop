//
//  PostCollectionCell.m
//  ArtDrop
//
//  Created by gracezhg on 7/15/21.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 3;
}

@end
