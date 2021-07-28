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
    self.mapModule.layer.cornerRadius = 15;
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
