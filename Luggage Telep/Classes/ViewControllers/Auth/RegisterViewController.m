//
//  RegisterViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/6/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_firstName;
@property (weak, nonatomic) IBOutlet UITextField *txt_lastName;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UITextField *txt_address;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_confirm;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.registerBtn.layer.cornerRadius = self.registerBtn.layer.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_Signin:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [story instantiateViewControllerWithIdentifier:@"NavigationController"];
    [navigationController setViewControllers:@[[story instantiateViewControllerWithIdentifier:@"HomeViewController"]]];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 8) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_firstName) {
        [self.txt_lastName becomeFirstResponder];
    }else if(textField == self.txt_lastName) {
        [self.txt_email becomeFirstResponder];
    }else if(textField == self.txt_email) {
        [self.txt_mobile becomeFirstResponder];
    }else if(textField == self.txt_mobile) {
        [self.txt_address becomeFirstResponder];
    }else if(textField == self.txt_address) {
        [self.txt_password becomeFirstResponder];
    }else if(textField == self.txt_password) {
        [self.txt_confirm becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if (textField.tag == 3) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if (textField.tag == 4) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if (textField.tag == 5) {
        [self.mScrollView setContentOffset:CGPointMake(0, 40) animated:true];
    }
    else if (textField.tag == 6) {
        [self.mScrollView setContentOffset:CGPointMake(0, 70) animated:true];
    }
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 90) animated:true];
    }
}


#pragma mark - Utility Handler -
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
