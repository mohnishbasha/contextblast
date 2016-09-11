//
//  ViewController.m
//  ContextBlast
//
//  Created by Adam Levy on 9/10/16.
//  Copyright © 2016 Adam Levy. All rights reserved.
//

#import "ViewController.h"
#import "CameraOverlayView.h"
#import "ImageDetailsViewController.h"
#import "ContextBlast-Bridging-Header.h"

@interface ViewController () <UIImagePickerControllerDelegate>

@property (nonatomic) CameraOverlayView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //self.overlayView = [[[NSBundle mainBundle] loadNibNamed:@"CameraOverlayView" owner:self options:nil] objectAtIndex:0];
    
    //self.imagePickerController.cameraOverlayView = self.overlayView;
    [self.view addSubview:self.imagePickerController.view];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"image: %@", image);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ImageDetailsViewController *viewController =
    [[UIStoryboard storyboardWithName:@"Main"
                               bundle:NULL] instantiateViewControllerWithIdentifier:@"ImageDetailsViewController"];
    viewController.image = image;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
