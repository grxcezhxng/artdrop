//
//  Artist.m
//  ArtDrop
//
//  Created by gracezhg on 7/13/21.
//

#import "Artist.h"

@implementation Artist

@dynamic userID;
@dynamic name;
@dynamic bio;
@dynamic photoUrl;
@dynamic nationality;
@dynamic birthYear;

+ (nonnull NSString *)parseClassName {
    return @"Artist";
}

+ (Artist *)createArtist:(NSString * _Nullable)name withBio:(NSString * _Nullable)bio withImageUrl:(NSString * _Nullable)imageUrl withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    Artist *const newArtist = [Artist new];
    newArtist.name = name;
    newArtist.bio = bio;
    newArtist.photoUrl = imageUrl;
    
    [newArtist saveInBackgroundWithBlock: completion];
    return newArtist;
};

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
