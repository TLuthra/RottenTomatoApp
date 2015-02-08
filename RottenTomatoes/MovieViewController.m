//
//  MovieViewController.m
//  RottenTomatoes
//
//  Created by Tanooj Luthra on 2/7/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <AFNetworkReachabilityManager.h>
#import "UINavigationController+M13ProgressViewBar.h"

@interface MovieViewController ()
@property (strong, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *selected;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *dvds;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *filterData;
@property (strong, nonatomic) IBOutlet UIView *offlineView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;

    self.movieTableView.delegate = self;
    self.movieTableView.dataSource = self;
    
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.movieTableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieTableViewCell"];
    self.movieTableView.rowHeight = 135;
    self.title = @"Movies";
    self.movieTableView.separatorColor = [UIColor darkGrayColor];
    
    self.apiKey = @"v693dwf4vj9x63326tp3qqwk";
    [self makeRequestToAPI];

    self.offlineView.hidden = true;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusNotReachable) {
            self.offlineView.hidden = false;
            NSLog(@"disconnected");

        } else {
            NSLog(@"connected again");
            self.offlineView.hidden = true;
        }
        [self.offlineView setNeedsDisplay];
        [self.movieTableView reloadData];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    CGRect frame = CGRectMake(0, -1000, 320, 5800);
    UIView* grayView = [[UIView alloc] initWithFrame:frame];
    grayView.backgroundColor = [UIColor darkTextColor];
    [self.movieTableView insertSubview:grayView atIndex:0];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(makeRequestToAPI) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:globalTint];
    [self.movieTableView addSubview:self.refreshControl];
    
    self.searchBar.delegate = self;
    UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor darkTextColor];
    txfSearchField.textColor = [UIColor lightTextColor];
    
    self.filterData = [[NSMutableArray alloc] init];
    [self.navigationController showProgress];
    
    self.tabBar.delegate = self;
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    self.selected = @"movies";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeRequestToAPI {
    [self.navigationController setProgress:0 animated:YES];

    __block bool movieDone = false;
    __block bool dvdDone = false;
    
    NSString *rottenTomatoesURL = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=25&apikey=%@", self.apiKey];
    NSURL *url = [NSURL URLWithString:rottenTomatoesURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            self.offlineView.hidden = false;
            return;
        }
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = responseDictionary[@"movies"];
        
        if ([self.tabBar.items indexOfObject:[self.tabBar selectedItem]] == 0) {
            self.tableData = self.movies;
        } else {
            self.tableData = self.dvds;
        }
        
        [self.refreshControl endRefreshing];
        
        movieDone = true;
        if (dvdDone && movieDone) {
            NSLog(@"asdf");
            [self.navigationController setProgress:1 animated:YES];
            [self.movieTableView reloadData];
            [self.navigationController finishProgress];
        }
    }];


    NSString *rottenTomatoesURLDVD = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=25&apikey=%@", self.apiKey];
    NSURL *urlDVD = [NSURL URLWithString:rottenTomatoesURLDVD];
    NSURLRequest *requestDVD = [[NSURLRequest alloc] initWithURL:urlDVD cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    [NSURLConnection sendAsynchronousRequest:requestDVD queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            self.offlineView.hidden = false;
            return;
        }

        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.dvds = responseDictionary[@"movies"];
        if ([self.tabBar.items indexOfObject:[self.tabBar selectedItem]] == 0) {
            self.tableData = self.movies;
        } else {
            self.tableData = self.dvds;
        }

        [self.refreshControl endRefreshing];

        dvdDone = true;
        if (dvdDone && movieDone) {
                        NSLog(@"1234");
            [self.navigationController setProgress:1 animated:YES];
            [self.movieTableView reloadData];
            [self.navigationController finishProgress];
        }
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchBar.text.length == 0) {
        return self.tableData.count;
    } else {
        return self.filterData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell" forIndexPath:indexPath];
    
    cell.posterView.image = nil;
    
    NSDictionary *movie;
    
    if (self.searchBar.text.length == 0) {
        movie = self.tableData[indexPath.row];
    } else {
        movie = self.filterData[indexPath.row];
    }
    
    
    NSString *thumbnail = movie[@"posters"][@"thumbnail"];
    NSURL *thumbnailUrl = [NSURL URLWithString:thumbnail];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:thumbnailUrl];
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.posterView.alpha = 0.0;
        cell.posterView.image = image;
        [UIView animateWithDuration:0.25 animations:^{
            cell.posterView.alpha = 1.0;
        }];
        NSString *highquality = [thumbnail stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
        [cell.posterView setImageWithURL:[NSURL URLWithString:highquality]];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error: %@", error);
    }];

    cell.titleLabel.text = movie[@"title"];
    cell.yearLabel.text = [NSString stringWithFormat:@"%@", movie[@"year"]];
    cell.descriptionLabel.text = movie[@"synopsis"];
    cell.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.descriptionLabel.numberOfLines = 0;

    return cell;

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.movieTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *movie;
    
    if (self.searchBar.text.length == 0) {
        movie = self.tableData[indexPath.row];
    } else {
        movie = self.filterData[indexPath.row];
    }
    MovieTableViewCell *cell = (MovieTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.movie = movie;
    dvc.title = movie[@"title"];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = (MovieTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor darkTextColor];
    cell.backgroundColor = [UIColor darkTextColor];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = (MovieTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;

    cell.contentView.backgroundColor = globalTint;
    cell.backgroundColor = globalTint;
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.movieTableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.filterData removeAllObjects];

    if ([searchText isEqualToString:@""] || searchText == nil) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.0];

        [self.movieTableView reloadData];
        return;
    }
    
    for (NSDictionary *movie in self.tableData) {
        NSRange r = [movie[@"title"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (r.location != NSNotFound) {
            [self.filterData addObject:movie];
        }
    }
    
    [self.movieTableView reloadData];
    return;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    int selectedIndex = [tabBar.items indexOfObject:item];
    if (selectedIndex == 0 && [self.selected isEqualToString:@"Movies"]) {
        [self.movieTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        return;
    }
    if (selectedIndex == 1 && [self.selected isEqualToString:@"DVDs"]) {
        [self.movieTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        return;
    }
    [self.filterData removeAllObjects];
    if (selectedIndex == 0) {
        self.selected = @"Movies";
        self.tableData = self.movies;
    } else {
        self.selected = @"DVDs";
        self.tableData = self.dvds;
    }
    
    self.title = self.selected;
    
    self.searchBar.text = @"";
    [self.searchBar performSelector: @selector(resignFirstResponder)
                    withObject: nil
                    afterDelay: 0.1];
    [self.movieTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    [self.movieTableView reloadData];
}

@end
