//
//  Artist.h
//  ArtDrop
//
//  Created by gracezhg on 7/13/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Artist : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSDate *birthYear;

+ (Artist *) createArtist:( NSString * _Nullable )name withBio: ( NSString * _Nullable )bio withImageUrl:( NSString * _Nullable )imageUrl withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
