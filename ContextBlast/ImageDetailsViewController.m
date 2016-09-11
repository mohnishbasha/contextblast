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
#import "ContextBlast-Swift.h"
#import "ImageContextTableViewController.h"
#import "ImageContext.h"

@interface ImageDetailsViewController () <VisualRecognitionWrapperDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *laserView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *laserYConstraint;
@property (nonatomic) NSTimer *laserTimer;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) VisualRecognitionWrapper *visualWrapper;

@end

@implementation ImageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //[self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager requestLocation];
    
    self.imageView.image = self.image;
    
    self.laserView.layer.cornerRadius = 4;
    self.laserView.layer.shadowOpacity = .9;
    self.laserView.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.laserView.layer.shadowOffset = CGSizeMake(2,2);
    //self.laserView.layer.shadowRadius = 10;
    
    [self searchImage:self.image];
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

- (void)searchImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.7);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    // Save image.
    if ([UIImagePNGRepresentation(self.image) writeToFile:filePath atomically:YES]) {
        self.laserTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                           target:self
                                                         selector:@selector(updateLaserPosition)
                                                         userInfo:nil
                                                          repeats:YES];
        
        self.visualWrapper = [[VisualRecognitionWrapper alloc] init];
        self.visualWrapper.delegate = self;
        [self.visualWrapper fetchImage:url];
    }
}

- (void)searchWithImage:(UIImage *)image location:(CLLocation *)location {
    NSString *deviceIdentifier = @"";  // This can be any unique identifier per device, and is optional - we like to use UUIDs
    
    // We recommend sending a JPG image no larger than 1024x1024 and with a 0.7-0.8 compression quality,
    // you can reduce this on a Cellular network to 800x800 at quality = 0.4
    CGPoint focalPoint = CGPointMake(0, 0);
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.7);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    // Save image.
    if ([UIImagePNGRepresentation(self.image) writeToFile:filePath atomically:YES]) {
        self.laserTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                           target:self
                                                         selector:@selector(updateLaserPosition)
                                                         userInfo:nil
                                                          repeats:YES];
        
        self.visualWrapper = [[VisualRecognitionWrapper alloc] init];
        self.visualWrapper.delegate = self;
        [self.visualWrapper fetchImage:url];
    }
    
    // Create the actual query object
//    CloudSightQuery *query = [[CloudSightQuery alloc] initWithImage:imageData
//                                                         atLocation:focalPoint
//                                                       withDelegate:self
//                                                        atPlacemark:location
//                                                       withDeviceId:deviceIdentifier];
//    
    
    
    
    
    // Start the query process
    //[query start];
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
    [manager stopUpdatingLocation];
    NSLog(@"%@", [locations lastObject]);
    [self searchWithImage:self.image location:[locations firstObject]];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
}

#pragma mark - Image Delegate
- (void)imageRecognized:(NSString *)context {
    ImageContextTableViewController *imageContextViewController = [[UIStoryboard storyboardWithName:@"Main"
                               bundle:NULL] instantiateViewControllerWithIdentifier:@"ImageContextTableViewController"];
    
    ImageContext *imageContext = [[ImageContext alloc] init];
    imageContext.image = self.image;
    imageContext.title = context;
    
    imageContextViewController.imageContext = imageContext;
    
    [self.navigationController pushViewController:imageContextViewController animated:YES];
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
