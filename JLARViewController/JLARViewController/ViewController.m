//
//  ViewController.m
//  JLARViewController
//
//  Created by Jose Luis Rodriguez on 25/08/15.
//  Copyright (c) 2015 jlrodv. All rights reserved.
//

#import "ViewController.h"
#import "JLARViewController.h"

@interface ViewController ()
- (IBAction)goToAR:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{

    
}

-(void)showARController{
    
    JLARViewController *arView = [[JLARViewController alloc] init];
    [self presentViewController:arView animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToAR:(UIButton *)sender {
    
    [self showARController];
}
@end
