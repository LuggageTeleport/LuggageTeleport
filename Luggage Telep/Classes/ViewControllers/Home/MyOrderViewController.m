//
//  MyOrderViewController.m
//  Luggage Telep
//
//  Created by mac on 10/9/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "MyOrderViewController.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
