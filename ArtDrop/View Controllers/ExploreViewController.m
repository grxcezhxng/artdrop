//
//  ExploreViewController.m
//  ArtDrop
//
//  Created by gracezhg on 7/23/21.
//

#import "ExploreViewController.h"
#import "DetailViewController.h"
#import "SearchCell.h"
#import "Post.h"
#import "ArtAPIManager.h"
#import "ArtHelper.h"

@interface ExploreViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mapModule;
@property (weak, nonatomic) IBOutlet UIView *highlightModule;
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

- (IBAction)handleSearch:(id)sender {
    self.mapModule.hidden = TRUE;
    self.highlightModule.hidden = TRUE;
    self.tableView.hidden = FALSE;
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
    self.highlightModule.hidden = TRUE;
    self.tableView.hidden = FALSE;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.mapModule.hidden = FALSE;
    self.highlightModule.hidden = FALSE;
    self.tableView.hidden = TRUE;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.mapModule.hidden = TRUE;
    self.highlightModule.hidden = TRUE;
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class] ]) {
        UITableViewCell *const tappedCell = sender;
        NSIndexPath *const indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *const post = self.arrayOfPosts[indexPath.row];
        DetailViewController *const detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
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

- (void)_renderStyling {
    self.tableView.hidden = TRUE;
    self.mapModule.layer.cornerRadius = 15;
    self.mapModule.layer.opacity = 0.8;
    self.highlightModule.layer.cornerRadius = 15;
    self.highlightModule.layer.opacity = 0.8;
//    ArtHelper *const imageHelper = [ArtHelper new];
//    UIImage *const resizedMapImage = [imageHelper resizeImage:[UIImage imageNamed:@"map.png"] withSize:CGSizeMake(375, 250)];
//    [self.mapModule setBackgroundColor:[UIColor colorWithPatternImage:resizedMapImage]];
//    UIImage *const resizedSearchImage = [imageHelper resizeImage:[UIImage imageNamed:@"search.png"] withSize:CGSizeMake(375, 250)];
//    [self.highlightModule setBackgroundColor:[UIColor colorWithPatternImage:resizedSearchImage]];
}

@end
