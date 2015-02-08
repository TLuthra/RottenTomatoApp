//
//  MovieTableViewCell.h
//  RottenTomatoes
//
//  Created by Tanooj Luthra on 2/7/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@end
