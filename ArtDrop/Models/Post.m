//
//  Post.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "Post.h"
#import "Artist.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic artist;
@dynamic location;
@dynamic title;
@dynamic image;
@dynamic createdAt;
@dynamic medium;
@dynamic year;
@dynamic size;
@dynamic price;
@dynamic isLiked;
@dynamic likedByUser;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)postUserImage: ( UIImage * _Nullable )image withTitle: ( NSString * _Nullable )title withArtist: ( Artist * _Nullable )artist withMedium: ( NSString * _Nullable )medium withYear: ( NSString * _Nullable )year withSize: ( NSString * _Nullable )size withPrice: ( NSString * _Nullable )price withDescription: ( NSString * _Nullable )description withLocation: ( Location * _Nullable )location withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Post *const newPost = [Post new];
    newPost.image = [self _getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.artist = artist;
    newPost.title = title;
    newPost.medium = medium;
    newPost.year = year;
    newPost.size = size;
    newPost.description = description;
    newPost.location = location; 
    newPost.isLiked = NO;
    newPost.likedByUser = [NSMutableArray new];
    newPost.createdAt = [NSDate date];
    
    if ([price isEqualToString:@""]) {
        newPost.price = @"Not for sale";
    }
    else {
        newPost.price = [NSString stringWithFormat:@"%@%@", @"$", price];
    }
    
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
