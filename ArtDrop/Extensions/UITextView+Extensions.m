//
//  UITextView+Extensions.m
//  ArtDrop
//
//  Created by gracezhg on 7/29/21.
//

#import "UITextView+Extensions.h"

@implementation UITextView (Extensions)

- (void)setupTheme
{
    self.textColor = [UIColor lightGrayColor];
    self.layer.cornerRadius=8.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor grayColor]CGColor];
    self.layer.borderWidth= 1.0f;
    self.layer.sublayerTransform = CATransform3DMakeTranslation(3, 0, 0);
}

@end

