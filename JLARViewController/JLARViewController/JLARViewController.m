//
//  JLARViewController.m
//  JLARViewController
//
//  Created by Jose Luis Rodriguez on 25/08/15.
//  Copyright (c) 2015 jlrodv. All rights reserved.
//

#define FOV 60

#import "JLARViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JLARViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation JLARViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized){
    
        
        [self startCameraView];
    }
    else{
    
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
            
            if(granted){
                
                [self startCameraView];
            }
            else{
                NSLog(@"no jala esto");
            }
            
        }];
    }
    
   
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        [self startLocationManager];
    
    }
    else{
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // Do any additional setup after loading the view.
}

-(void)startCameraView{
    
    dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(sessionQueue, ^{
    
        self.session = [[AVCaptureSession alloc] init];
        
        
        AVCaptureDeviceInput *device = [[AVCaptureDeviceInput alloc] initWithDevice:[JLARViewController deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack] error:nil];
        
        [self.session beginConfiguration];
        
        for(AVCaptureDeviceInput *device in self.session.inputs){
            [self.session removeInput:device];
        }
        
        [self.session addInput:device];
        
        [self.session commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AVCaptureVideoPreviewLayer *videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
            videoLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:videoLayer];

        });
        
        [self.session startRunning];
        
    
    });
    
}

-(void)startLocationManager{
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingHeading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{

    if(status==kCLAuthorizationStatusAuthorizedWhenInUse){
        [self startLocationManager];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"%f %f", newHeading.magneticHeading, newHeading.trueHeading);

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
