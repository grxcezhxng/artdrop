//
//  ExploreViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/23/21.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapModule;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = TRUE;
//    self.mapModule.hidden = TRUE;
    // Do any additional setup after loading the view.
}

#pragma mark - Private Helper Methods

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)_renderStyling {
    self.mapModule.layer.cornerRadius = 15;
    self.mapModule.layer.opacity = 0.8;
    UIImage *const resizedImage = [self _resizeImage:[UIImage imageNamed:@"map.png"] withSize:CGSizeMake(375, 200)];
    [self.mapModule setBackgroundColor:[UIColor colorWithPatternImage:resizedImage]];
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
