//
//  ProfileViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/12/21.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "PostCollectionCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrayOfPosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self _renderData];
    [self _renderStyling];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _fetchUserPosts];
    [self _renderData];
    [self _renderStyling];
}

#pragma mark - Collection View Data Source Methods

- (void)_fetchUserPosts {
    PFQuery *const userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [userQuery orderByDescending:@"createdAt"];
    [userQuery includeKey:@"author"]; // pointers
    userQuery.limit = 30;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Collection View Delegate Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *const post = self.arrayOfPosts[indexPath.row];
    
    PFFileObject *const postFile = post[@"image"];
    NSURL *const postUrl = [NSURL URLWithString: postFile.url];
    [cell.imageView setImageWithURL:postUrl];
    
    return cell;
}

#pragma mark - Private Helper Methods

- (void)_renderData {
    self.nameLabel.text = PFUser.currentUser[@"name"];
    self.usernameLabel.text  = [NSString stringWithFormat:@"%@%@", @"@", PFUser.currentUser.username];
    self.profilePhoto.userInteractionEnabled = YES;
    self.profilePhoto.layer.cornerRadius = 50;
    if(PFUser.currentUser[@"profilePhoto"]) {
        PFFileObject *const file = PFUser.currentUser[@"profilePhoto"];
        NSURL *const url = [NSURL URLWithString: file.url];
        [self.profilePhoto setImageWithURL:url];
    }
}

- (void)_renderStyling {
    UICollectionViewFlowLayout *const layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    const CGFloat margin = 21;
    const CGFloat postersPerLine = 3;
    const CGFloat itemWidth = (self.collectionView.frame.size.width - margin * 2)/postersPerLine ;
    const CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
