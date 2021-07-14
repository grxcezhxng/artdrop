//
//  Post.h
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import <Parse/Parse.h>
#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) Artist *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *price;

+ (void)postUserImage: ( UIImage * _Nullable )image withTitle: ( NSString * _Nullable )title withArtist: ( Artist * _Nullable )artist withMedium: ( NSString * _Nullable )medium withYear: ( NSString * _Nullable )year withSize: ( NSString * _Nullable )size withPrice: ( NSString * _Nullable )price withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
