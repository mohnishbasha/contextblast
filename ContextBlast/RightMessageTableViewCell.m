//
//  RightMessageTableViewCell.m
//  ContextBlast
//
//  Created by Adam Levy on 9/11/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

#import "RightMessageTableViewCell.h"

@implementation RightMessageTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.layer.cornerRadius = 15;
    self.label.layer.masksToBounds = YES;
}

@end
