//
//  ImageDetailsViewController.m
//  ContextBlast
//
//  Created by Adam Levy on 9/10/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

#import "ImageDetailsViewController.h"

@interface ImageDetailsViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *laserView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *laserYConstraint;

@end

@implementation ImageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    
    self.laserView.layer.cornerRadius = 4;
    self.laserView.layer.shadowOpacity = .9;
    self.laserView.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.laserView.layer.shadowOffset = CGSizeMake(2,2);
    //self.laserView.layer.shadowRadius = 10;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateLaserPosition];
}

- (void)animateLaserPosition {
    [self.view layoutIfNeeded];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.laserYConstraint.constant = self.view.frame.size.height;
    [UIView animateWithDuration:2 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.laserYConstraint.constant = 0;
        [self animateLaserPosition];
    }];
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
