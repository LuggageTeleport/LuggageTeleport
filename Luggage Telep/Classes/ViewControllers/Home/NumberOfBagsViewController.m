//
//  NumberOfBagsViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "NumberOfBagsViewController.h"

#define bagsOfCount = 2;

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
    
    _nextButView.layer.cornerRadius = _nextButView.layer.frame.size.height/2;
    
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
@end
