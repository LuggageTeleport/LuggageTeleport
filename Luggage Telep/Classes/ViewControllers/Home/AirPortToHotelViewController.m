//
//  AirPortToHotelViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AirPortToHotelViewController.h"

@interface AirPortToHotelViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *nextButView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@end

@implementation AirPortToHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextButView.layer.cornerRadius = self.nextButView.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSInteger nextTag = textField.tag + 1;
//    if (nextTag == 3) {
//        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
//    }
//
//    if (textField == self.txt_username) {
//        [self.txt_password becomeFirstResponder];
//    } else {
        [textField resignFirstResponder];
//    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 7) {
        [self.mScrollView setContentOffset:CGPointMake(0, 50) animated:true];
    }
//    else if (textField.tag == 2) {
//        [self.mScrollView setContentOffset:CGPointMake(0, 130) animated:true];
//    }
}

@end
