//
//  ArtistViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/20/21.
//

#import "ArtistViewController.h"
#import "ArtAPIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ArtistViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.artistNameLabel.text = self.artist.name;
    self.bioLabel.text = self.artist.bio;
    
    NSURL *artistPhoto = [NSURL URLWithString:self.artist.photoUrl];
    [self.profilePhoto setImageWithURL:artistPhoto];
    self.profilePhoto.layer.cornerRadius = 60;
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
