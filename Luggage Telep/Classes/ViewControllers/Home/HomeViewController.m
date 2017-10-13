//
//  HomeViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "HomeViewController.h"
#import "AirPortToHotelViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_airport_hotel:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AirPortToHotelViewController *airportVC = [story instantiateViewControllerWithIdentifier:@"AirPortToHotelViewController"];
    airportVC.isBookingNow = NO;
    [self.navigationController pushViewController:airportVC animated:YES];
}


@end
