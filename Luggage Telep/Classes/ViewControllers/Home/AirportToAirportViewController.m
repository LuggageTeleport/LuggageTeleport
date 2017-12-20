//
//  AirportToAirportViewController.m
//  Luggage Telep
//
//  Created by MacOS on 12/19/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AirportToAirportViewController.h"

@interface AirportToAirportViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation AirportToAirportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clicked_Back:(id)sender {
//    [self.dropdownMenu closeAllComponentsAnimated:NO];
//    [self.dropAirportMenu closeAllComponentsAnimated:NO];
//    [self.dropHotelMenu closeAllComponentsAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
