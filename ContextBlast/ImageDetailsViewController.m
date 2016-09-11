//
//  ImageDetailsViewController.m
//  ContextBlast
//
//  Created by Adam Levy on 9/10/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

#import "ImageDetailsViewController.h"
#import "CloudSight.h"
#import <CoreLocation/CoreLocation.h>

@interface ImageDetailsViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *laserView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *laserYConstraint;
@property (nonatomic) NSTimer *laserTimer;
@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation ImageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
     [self.locationManager requestLocation];
    
    self.imageView.image = self.image;
    
    self.laserView.layer.cornerRadius = 4;
    self.laserView.layer.shadowOpacity = .9;
    self.laserView.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.laserView.layer.shadowOffset = CGSizeMake(2,2);
    //self.laserView.layer.shadowRadius = 10;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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


- (void)updateLaserPosition {
    if (self.laserYConstraint.constant < self.view.frame.size.height) {
        self.laserYConstraint.constant +=1;
    } else {
        self.laserYConstraint.constant = 0;
        [self.view setNeedsLayout];
    }
}

- (void)searchWithImage:(UIImage *)image location:(CLLocation *)location {
    NSString *deviceIdentifier = @"";  // This can be any unique identifier per device, and is optional - we like to use UUIDs
    
    // We recommend sending a JPG image no larger than 1024x1024 and with a 0.7-0.8 compression quality,
    // you can reduce this on a Cellular network to 800x800 at quality = 0.4
    CGPoint focalPoint = CGPointMake(0, 0);
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.7);
    
    // Create the actual query object
    CloudSightQuery *query = [[CloudSightQuery alloc] initWithImage:imageData
                                                         atLocation:focalPoint
                                                       withDelegate:self
                                                        atPlacemark:location
                                                       withDeviceId:deviceIdentifier];
    
    self.laserTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
        [self updateLaserPosition];
    }];
    // Start the query process
    [query start];
}

#pragma mark CloudSightQueryDelegate

- (void)cloudSightQueryDidFinishIdentifying:(CloudSightQuery *)query {
    [self.laserTimer invalidate];
    
    if (query.skipReason != nil) {
        NSLog(@"Skipped: %@", query.skipReason);
    } else {
        NSLog(@"Identified: %@", query.title);
    }
}

- (void)cloudSightQueryDidFail:(CloudSightQuery *)query withError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
    [self searchWithImage:self.image location:[locations firstObject]];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
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
