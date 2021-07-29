//
//  ArtAPIManager.m
//  ArtDrop
//
//  Created by gracezhg on 7/28/21.
//

#import "ArtAPIManager.h"
#import "Artist.h"
#import "Parse/Parse.h"

@implementation ArtAPIManager

- (id)init {
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

// Fetch all posts 
- (void)fetchFeed:(void(^)(NSArray *posts, NSError *error))completion {
    PFQuery *const postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"artist"];
    [postQuery includeKey:@"location"];
    postQuery.limit = 40;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion(posts, nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// Fetch current user's posts
- (void)fetchUserPosts:(void(^)(NSArray *posts, NSError *error))completion {
    PFQuery *const userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [userQuery orderByDescending:@"createdAt"];
    [userQuery includeKey:@"author"]; // pointers
    userQuery.limit = 30;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion(posts, nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// Fetch posts by a certain artist 
- (void)fetchArtistPosts:(void(^)(NSArray *posts, NSError *error))completion withArtist:(Artist*) artist {
    PFQuery *const userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery whereKey:@"artist" equalTo:artist];
    [userQuery orderByDescending:@"createdAt"];
    [userQuery includeKey:@"artist"];
    userQuery.limit = 30;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            completion(posts, nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// Fetch artist info from Artsy API
- (void)fetchArtistInfo:(void(^)(Artist* artist, NSError *error))completion withName:(NSString*) name {
    NSString *const slug = [[name stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];
    NSString *const token = @"eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6IiIsInN1YmplY3RfYXBwbGljYXRpb24iOiI2MTAxZmMxOTQ3ZDY4MDAwMGY1YTFmMGIiLCJleHAiOjE2MjgxMjQ4MjUsImlhdCI6MTYyNzUyMDAyNSwiYXVkIjoiNjEwMWZjMTk0N2Q2ODAwMDBmNWExZjBiIiwiaXNzIjoiR3Jhdml0eSIsImp0aSI6IjYxMDFmYzE5N2RkODRjMDAwZmYwZWVjOSJ9.vvaLwBIbriqcGGrWWl1v1qX18tUw8re6SIF_Er-d-yo";
    [[NSUserDefaults standardUserDefaults] setObject: token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *const urlString = [NSString stringWithFormat:@"https://api.artsy.net/api/artists/%@", slug];
    NSURL *const url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *const request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSDictionary *const headers = @{ @"Authorization": [[NSUserDefaults standardUserDefaults] valueForKey:@"token"],@"Cache-Control": @"no-cache"};
    [request setAllHTTPHeaderFields:headers];
    [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"token"] forHTTPHeaderField:@"X-Xapp-Token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *const task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSString *artistImageUrl = dataDictionary[@"_links"][@"image"][@"href"];
            artistImageUrl = [artistImageUrl stringByReplacingOccurrencesOfString:@"{image_version}"
                                                                       withString:@"square"];
            
            Artist *const artist = [Artist createArtist:dataDictionary[@"name"] withBio:dataDictionary[@"location"] withImageUrl:artistImageUrl withCompletion:nil];
            completion(artist, nil);
        }
    }];
    [task resume];
}

@end
