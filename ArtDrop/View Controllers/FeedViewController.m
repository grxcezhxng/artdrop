//
//  FeedViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailViewController.h"
#import "Artist.h"
#import "ArtistViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfPosts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIRefreshControl *const refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _fetchFeed];
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table View Data Source Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *const post = self.arrayOfPosts[indexPath.row];
    cell.post = post;
    [cell setCellData];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

#pragma mark - Refresh Control

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    NSURLSession *const session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                delegate:nil
                                                           delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [self _fetchFeed];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class] ]){
        UITableViewCell *const tappedCell = sender;
        NSIndexPath *const indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *const post = self.arrayOfPosts[indexPath.row];
        DetailViewController *const detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
    
    //     if ([segue.destinationViewController isKindOfClass:[ArtistViewController class] ]){
    //         
    //         UITableViewCell *const tappedCell = sender;
    //         NSIndexPath *const indexPath = [self.tableView indexPathForCell:tappedCell];
    //         Post *const post = self.arrayOfPosts[indexPath.row];
    //         Artist *const artist = post.artist;
    //         ArtistViewController *const artistViewController = [segue destinationViewController];
    //         artistViewController.artist = artist;
    //     }
}

#pragma mark - Private Helper Methods

- (void)_fetchFeed {
    PFQuery *const postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"artist"];
    [postQuery includeKey:@"location"];
    postQuery.limit = 40;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


@end
