//
//  ArtAnnotation.m
//  ArtDrop
//
//  Created by gracezhg on 7/28/21.
//

#import <Foundation/Foundation.h>
#import "ArtAnnotation.h"
#import "Post.h"

@interface ArtAnnotation()

@end

@implementation ArtAnnotation

- (NSString *)title {
    return self.post.title;
}

- (NSString *)subtitle {
    return self.post.artist.name;
}

@end
