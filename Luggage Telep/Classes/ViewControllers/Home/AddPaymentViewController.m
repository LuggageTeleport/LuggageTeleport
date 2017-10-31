//
//  AddPaymentViewController.m
//  Luggage Telep
//
//  Created by mac on 10/8/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AddPaymentViewController.h"
#import "AddCardViewController.h"


@interface AddPaymentViewController ()

@end

@implementation AddPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButtons Delegate

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
