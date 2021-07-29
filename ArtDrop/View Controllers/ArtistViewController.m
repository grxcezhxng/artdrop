//
//  ArtistViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/20/21.
//

#import "ArtistViewController.h"
#import "ArtAPIManager.h"
#import "UIImageView+AFNetworking.h"
#import "ArtistCollectionCell.h"

@interface ArtistViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self _fetchArtistPosts];
    [self _renderStyling];
    [self _renderData];
}

#pragma mark - Collection View Data Source Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArtistCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtistCollectionCell" forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
    
    // Fade in the image
    PFFileObject *const postFile = post[@"image"];
    NSURL *const postUrl = [NSURL URLWithString: postFile.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:postUrl];
    __weak ArtistCollectionCell *weakSelf = cell;
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil
                                   success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            weakSelf.imageView.alpha = 0.0;
            weakSelf.imageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.imageView.alpha = 1.0;
            }];
        } else {
            weakSelf.imageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
    }];
    
    return cell;
}

#pragma mark - Network Calls

- (void)_fetchArtistPosts {
    ArtAPIManager *manager = [ArtAPIManager new];
    [manager fetchArtistPosts:^(NSArray * _Nonnull posts, NSError * _Nonnull error) {
        self.arrayOfPosts = posts;
        [self.collectionView reloadData];
    } withArtist:self.artist];
}

#pragma mark - Private Methods

- (void)_renderData {
    self.artistNameLabel.text = self.artist.name;
    self.bioLabel.text = self.artist.bio;
    
    NSURL *artistPhoto = [NSURL URLWithString:self.artist.photoUrl];
    [self.profilePhoto setImageWithURL:artistPhoto];
}

- (void)_renderStyling {
    self.profilePhoto.layer.cornerRadius = 60;
    UICollectionViewFlowLayout *const layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 4;
    const CGFloat margin = 30;
    const CGFloat postersPerLine = 2;
    const CGFloat itemWidth = (self.collectionView.frame.size.width - margin * 2)/postersPerLine;
    const CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

@end
