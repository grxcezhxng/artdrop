//
//  ExploreViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/23/21.
//

#import "ExploreViewController.h"
#import "SearchCell.h"
#import "Post.h"
#import "ArtAPIManager.h"

@interface ExploreViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mapModule;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (strong, nonatomic) NSArray *arrayOfFilteredPosts;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _renderStyling];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self _fetchResults];
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table View Data Source Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    Post *const post = self.arrayOfFilteredPosts[indexPath.row];
    cell.post = post;
    [cell setCellData];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfFilteredPosts.count;
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mapModule.hidden = TRUE;
    self.tableView.hidden = FALSE;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.mapModule.hidden = FALSE;
    self.tableView.hidden = TRUE;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.mapModule.hidden = TRUE;
    self.tableView.hidden = FALSE;
    
    if (searchText.length != 0) {
        NSPredicate *const filterByName = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText] || [evaluatedObject[@"artist"][@"name"] containsString:searchText];
        }];
        self.arrayOfFilteredPosts = [self.arrayOfPosts filteredArrayUsingPredicate:filterByName];
    } else {
        self.arrayOfFilteredPosts = self.arrayOfPosts;
    }
    [self.tableView reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - Network Calls

- (void)_fetchResults {
    ArtAPIManager *const manager = [ArtAPIManager new];
    [manager fetchFeed:^(NSArray * _Nonnull posts, NSError * _Nonnull error) {
        self.arrayOfPosts = posts;
        self.arrayOfFilteredPosts = posts;
        [self.tableView reloadData];
    }];
}

#pragma mark - Private Methods

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *const resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *const newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)_renderStyling {
    self.tableView.hidden = TRUE;
    self.mapModule.layer.cornerRadius = 15;
    self.mapModule.layer.opacity = 0.8;
    UIImage *const resizedImage = [self _resizeImage:[UIImage imageNamed:@"map.png"] withSize:CGSizeMake(375, 200)];
    [self.mapModule setBackgroundColor:[UIColor colorWithPatternImage:resizedImage]];
}

@end
