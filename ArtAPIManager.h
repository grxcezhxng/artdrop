//
//  ArtAPIManager.h
//  ArtDrop
//
//  Created by gracezhg on 7/28/21.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArtAPIManager : NSObject

@property (nonatomic, strong) NSURLSession *session;

- (void)fetchArtistInfo:(void(^)(Artist *artist, NSError *error))completion withName:(NSString*) name;

@end

NS_ASSUME_NONNULL_END

