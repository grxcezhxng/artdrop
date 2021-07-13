//
//  Post.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic artist;
@dynamic title;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic createdAt;
@dynamic medium;
@dynamic year;
@dynamic size;
@dynamic price;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)postUserImage: ( UIImage * _Nullable )image withTitle: ( NSString * _Nullable )title withMedium: ( NSString * _Nullable )medium withYear: ( NSString * _Nullable )year withSize: ( NSString * _Nullable )size withPrice: ( NSString * _Nullable )price withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Post *const newPost = [Post new];
    newPost.image = [self _getPFFileFromImage:image];
    newPost.artist = [PFUser currentUser];
    newPost.title = title;
    newPost.medium = medium;
    newPost.year = year;
    newPost.size = size;
    newPost.price = price;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.createdAt = [NSDate date];
    
    [newPost saveInBackgroundWithBlock: completion];
}

#pragma mark - Private Methods

+ (PFFileObject *)_getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *const imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
