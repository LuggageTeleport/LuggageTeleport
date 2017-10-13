//
//  PaymentViewController.m
//  Luggage Telep
//
//  Created by mac on 10/8/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()<UITextFieldDelegate>{
    Boolean *isGiftView;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *lightBG;
@property (weak, nonatomic) IBOutlet UITextField *txt_promo;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    self.btn_cancel.layer.cornerRadius = self.btn_cancel.layer.frame.size.height/2;
    self.btn_add.layer.cornerRadius = self.btn_add.layer.frame.size.height/2;
    
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_add_promo:(id)sender {
    isGiftView = true;
    _giftView.hidden = NO;
    _lightBG.hidden = NO;
}

- (IBAction)clicked_canel:(id)sender {
    [self.txt_promo resignFirstResponder];
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
}

- (IBAction)clicked_add:(id)sender {
    [self.txt_promo resignFirstResponder];
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
}

#pragma mark - TextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    
    [textField resignFirstResponder];

    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 200) animated:true];
    }
}

@end
