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
@property (strong, nonatomic) NSArray *arrayOfUserPosts;
@property (strong, nonatomic) NSMutableArray *arrayOfUserLikes;
@property (weak, nonatomic) IBOutlet UILabel *worksLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self _renderData];
    [self _renderStyling];
    self.segmentControl.selectedSegmentIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _fetchUserPosts];
    [self _fetchUserLikes];
    [self _renderData];
}

#pragma mark - IB Actions

- (IBAction)indexChanged:(id)sender {
    [self.collectionView reloadData];
}

#pragma mark - Collection View Data Source Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.segmentControl.selectedSegmentIndex == 0) {
        return self.arrayOfUserPosts.count;
    }
    return self.arrayOfUserLikes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post;
    if(self.segmentControl.selectedSegmentIndex == 0) {
        post = self.arrayOfUserPosts[indexPath.row];
    }
    else {
        post = self.arrayOfUserLikes[indexPath.row];
    }
    // Fade in the image
    PFFileObject *const postFile = post[@"image"];
    NSURL *const postUrl = [NSURL URLWithString: postFile.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:postUrl];
    __weak PostCollectionCell *weakSelf = cell;
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil
                                   success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {;
            weakSelf.imageView.alpha = 0.0;
            weakSelf.imageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.imageView.alpha = 1.0;
            }];
        }
        else {
            weakSelf.imageView.image = image;
        }
    }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    
    return cell;
}

#pragma mark - Private Methods

- (void)_fetchUserPosts {
    PFQuery *const userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [userQuery orderByDescending:@"createdAt"];
    [userQuery includeKey:@"author"]; // pointers
    userQuery.limit = 30;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfUserPosts = posts;
            self.worksLabel.text = [NSString stringWithFormat:@"%i", self.arrayOfUserPosts.count];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)_fetchUserLikes {
    self.arrayOfUserLikes = [[NSMutableArray alloc] init];
    PFQuery *const userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery orderByDescending:@"updatedAt"];
    [userQuery includeKey:@"author"]; // pointers
    [userQuery includeKey:@"likedByUser"];
    userQuery.limit = 100;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            for (Post* post in posts) {
                if([post.likedByUser containsObject:PFUser.currentUser.objectId]) {
                    [self.arrayOfUserLikes addObject:post];
                }
            }
            self.likesLabel.text = [NSString stringWithFormat:@"%i", self.arrayOfUserLikes.count];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)_renderData {
    self.nameLabel.text = PFUser.currentUser[@"name"];
    NSString *const bioText = [NSString stringWithFormat:@"%@%@", @"@", PFUser.currentUser.username];
    self.usernameLabel.text  = [NSString stringWithFormat:@"%@ | %@", bioText, PFUser.currentUser[@"bio"]];
    self.profilePhoto.userInteractionEnabled = YES;
    self.profilePhoto.layer.cornerRadius = 50;
    
    if(PFUser.currentUser[@"profilePhoto"]) {
        PFFileObject *const file = PFUser.currentUser[@"profilePhoto"];
        NSURL *const url = [NSURL URLWithString: file.url];
        [self.profilePhoto setImageWithURL:url];
    }
}

- (void)_renderStyling {
    [self.segmentControl setImage:[UIImage systemImageNamed:@"square.grid.2x2.fill"] forSegmentAtIndex:0];
    [self.segmentControl setImage:[UIImage systemImageNamed:@"suit.heart.fill"] forSegmentAtIndex:1];
    
    UICollectionViewFlowLayout *const layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 4;
    const CGFloat margin = 21;
    const CGFloat postersPerLine = 2;
    const CGFloat itemWidth = (self.collectionView.frame.size.width - margin * 2)/postersPerLine;
    const CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

@end
