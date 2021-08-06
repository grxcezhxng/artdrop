//
//  Post.h
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import <Parse/Parse.h>
#import "Artist.h"
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) Artist *artist;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) BOOL isLiked;
@property (nonatomic, strong) NSMutableArray *likedByUser;

+ (void)postUserImage:(UIImage * _Nullable)image withTitle:(NSString * _Nullable)title withArtist:(Artist * _Nullable)artist withMedium:(NSString * _Nullable)medium withYear:( NSString * _Nullable)year withWidth: (NSNumber * _Nullable)width withHeight: (NSNumber * _Nullable)height withPrice:(NSString * _Nullable)price withDescription:(NSString * _Nullable)description withLocation:(Location * _Nullable)location withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
