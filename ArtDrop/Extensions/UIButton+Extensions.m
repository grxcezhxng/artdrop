//
//  UIButton+Extensions.m
//  ArtDrop
//
//  Created by gracezhg on 7/29/21.
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)

- (void)setupTheme
{
    self.backgroundColor = [UIColor systemIndigoColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
}

@end
