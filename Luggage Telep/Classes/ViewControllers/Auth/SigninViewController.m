//
//  SigninViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "SigninViewController.h"
#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"

@interface SigninViewController () <UITextFieldDelegate>{
    Boolean isEmail;
    Boolean isPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isEmail = false;
    isPassword = false;
    self.signinBtn.layer.cornerRadius = self.signinBtn.layer.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_Signin:(UIButton *)sender {
    [self checkInputs];
    if(isEmail && isPassword){
        [kACCOUNT_UTILS showWorking:self.view string:@"Logging In..."];
        NSDictionary *params = @{@"username"     : _txt_username.text,
                                 @"password"     : _txt_password.text,};
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:LOGIN_URL parameters:params error:nil];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
                [kACCOUNT_UTILS showFailure:self.view withString:@"Invalid account" andBlock:nil];
            } else {
                [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                NSLog(@"%@", responseObject);
                NSNumber *number = [responseObject objectForKey:@"success"];
                if( [number intValue] == 1){
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
                    [self.navigationController pushViewController:mainVC animated:YES];
                }else{
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Authenication failed. User not found" dismiss:@"OK" sender:self];
                }
            }
        }];
        [dataTask resume];
    }
}

- (void) checkInputs{
    if(_txt_username.text.length == 0){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your email" dismiss:@"OK" sender:self];
    }else{
        if([kACCOUNT_UTILS verifyEmail:self.txt_username.text]){
            isEmail = true;
        }else{
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please enter valid email" dismiss:@"OK" sender:self];
        }
    }
    
    if(_txt_password.text.length == 0){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your password" dismiss:@"OK" sender:self];
    }else{
        isPassword = true;
    }
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 3) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_username) {
        [self.txt_password becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 80) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 130) animated:true];
    }
}


#pragma mark - Utility Handler -
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
