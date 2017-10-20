//
//  NumberOfBagsViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "NumberOfBagsViewController.h"
#import "BookingSummaryViewController.h"

#define bagsOfCount = 1;

@interface NumberOfBagsViewController (){
    int count;
}
@property (weak, nonatomic) IBOutlet UIView *nextButView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_countOfbags;



@end

@implementation NumberOfBagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    count = 1;
    _nextButView.layer.cornerRadius = _nextButView.layer.frame.size.height/2;
    
}

- (void) initBooking:(BookingAuth *)booking{
    self.booking = booking;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_plus:(id)sender {
    count ++;
    self.lbl_countOfbags.text = [NSString stringWithFormat:@"%i", count];
}
- (IBAction)clicked_minue:(id)sender {
    count --;
    if(count < 1){
        count = 1;
    }
    self.lbl_countOfbags.text = [NSString stringWithFormat:@"%i", count];
}
- (IBAction)clicked_next:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookingSummaryViewController *bagsVC = [story instantiateViewControllerWithIdentifier:@"BookingSummaryViewController"];
    [bagsVC initBooking:self.booking];
    [bagsVC set_count_bags:count];
    [self.navigationController pushViewController:bagsVC animated:YES];
}
@end
