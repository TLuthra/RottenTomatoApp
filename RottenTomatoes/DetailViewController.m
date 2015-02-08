//
//  DetailViewController.m
//  RottenTomatoes
//
//  Created by Tanooj Luthra on 2/7/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
@property (nonatomic, assign) CGPoint lastContentOffset;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"title: %@", self.titleLabel.text);
//    self.titleLabel.text = self.movie[@"title"];
    
//    self.posterView.image = cell.posterView.image;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"], self.movie[@"year"]];
    self.ratingsLabel.text = [NSString stringWithFormat:@"Critics Rating: %@, Audience Rating: %@", self.movie[@"ratings"][@"critics_score"], self.movie[@"ratings"][@"audience_score"]];
    self.descriptionLabel.text = self.movie[@"synopsis"];
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel sizeToFit];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(320, 20 + self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y);
    self.backgroundView.frame = CGRectMake(0, 350, 320, self.scrollView.contentSize.height);

//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame =  CGRectMake(0, -20, self.backgroundView.bounds.size.width, 300);
//    gradient.colors = @[(id)[[UIColor colorWithWhite:1.0 alpha:0.0] CGColor],
//                        (id)[[UIColor blackColor] CGColor]];
//    [self.backgroundView.layer insertSublayer:gradient atIndex:0];
    
    NSString *thumbnail = self.movie[@"posters"][@"thumbnail"];
    NSURL *thumbnailUrl = [NSURL URLWithString:thumbnail];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:thumbnailUrl];
    [self.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.posterView.alpha = 0.0;
        self.posterView.image = image;
        [UIView animateWithDuration:0.25 animations:^{
            self.posterView.alpha = 1.0;
        }];
        NSString *highquality = [thumbnail stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
        [self.posterView setImageWithURL:[NSURL URLWithString:highquality]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error: %@", error);
    }];

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"top: %f %f", scrollView.contentOffset.y, scrollView.frame.origin.y);
    
//    if (scrollView.contentOffset.y > 0) {
//        CGRect rect = CGRectMake(0, 350 - scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height);
//        [scrollView setFrame:rect];
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    } else {
//        
//    }
//    
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
//    }
//    else if (scrollView.frame.origin.y >= 0) {
//        float additionalHeight = MAX(350 - scrollView.contentOffset.y,0);
//        CGRect rect = CGRectMake(0, additionalHeight, scrollView.frame.size.width, 218 + additionalHeight);
//        [scrollView setFrame:rect];
////        [scrollView setContentOffset:CGPointMake(0, additionalHeight)];
//    }

//    if (scrollView.frame.origin.y <= 350) {
//        float yDiff = self.lastContentOffset.y - scrollView.contentOffset.y;
//        
//        CGRect rect = CGRectMake(0, scrollView.frame.origin.y + yDiff, scrollView.frame.size.width,scrollView.frame.size.height);
//        
//        [scrollView setFrame:rect];
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//        self.lastContentOffset = scrollView.contentOffset;
//    }
    
//    CGRect rect = CGRectMake(0, scrollView.frame.origin.y - 1, scrollView.frame.size.width,scrollView.frame.size.height);
//    [scrollView setFrame:rect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
