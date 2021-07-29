//
//  UITextField+Extensions.m
//  ArtDrop
//
//  Created by gracezhg on 7/29/21.
//

#import "UITextField+Extensions.h"

@implementation UITextField (Extensions)

- (void)setupTheme {
    self.layer.cornerRadius= 8.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor grayColor]CGColor];
    self.layer.borderWidth= 1.0f;
    self.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.textColor = [UIColor blackColor];
}

@end
