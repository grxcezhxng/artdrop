//
//  ArtistViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/20/21.
//

#import "ArtistViewController.h"

@interface ArtistViewController ()

@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.artistNameLabel.text = self.artist.name;
    // Do any additional setup after loading the view.
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
