//
//  PYAEventListTableViewCell.m
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import "PYAEventListTableViewCell.h"

@interface PYAEventListTableViewCell ()
@property (nonatomic, weak)IBOutlet UILabel *nameLabel;
@end


@implementation PYAEventListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)value {
    _name = [value copy];
    
    self.nameLabel.text = _name;
}

@end
