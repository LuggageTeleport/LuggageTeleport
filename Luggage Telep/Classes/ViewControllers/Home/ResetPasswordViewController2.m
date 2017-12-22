//
//  ResetPasswordViewController2.m
//  Luggage Telep
//
//  Created by MacOS on 12/12/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "ResetPasswordViewController2.h"
#import "SigninViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"

@interface ResetPasswordViewController2 ()<UITextFieldDelegate>{
    Boolean isCode;
    Boolean isPassword;
    Boolean isConfirm;
}
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *txt_validation;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_confirm;

@end

@implementation ResetPasswordViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _codeView.layer.cornerRadius = 8.f;
    _codeView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _codeView.layer.borderWidth= 1.0f;
    _passwordView.layer.cornerRadius = 8.f;
    _passwordView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _passwordView.layer.borderWidth= 1.0f;
    _confirmView.layer.cornerRadius = 8.f;
    _confirmView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _confirmView.layer.borderWidth= 1.0f;
    
    _sendCodeBtn.layer.cornerRadius = _sendCodeBtn.layer.frame.size.height/2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_sendValidationCode:(id)sender {
    [self checkInputs];
    if(isCode && isPassword && isConfirm){
        [kACCOUNT_UTILS showWorking:self.view string:@"Changing password"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *params = [[NSDictionary alloc] init];
        if([self validateEmailWithString:self.emailAddress]){
            params = @{@"code": _txt_validation.text,
                     @"email": self.emailAddress,
                     @"password": _txt_password.text
                     };
            [manager POST:VERIFY_EMAILCODE_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if([[responseObject objectForKey:@"success"] intValue] == 1){
                    NSLog(@"Success");
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SigninViewController *signinVC = [story instantiateViewControllerWithIdentifier:@"SigninViewController"];
                    [self.navigationController pushViewController:signinVC animated:YES];
                }
                else{
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Failed send code" dismiss:@"OK" sender:self];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error: %@", error);
            }];
        }
        else{
            params = @{@"code": _txt_validation.text,
                     @"phoneNumber": self.emailAddress,
                     @"countryCode": @"+1",
                     @"password": _txt_password.text
                     };
            [manager POST:VERIFY_MOBILECODE_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if([[responseObject objectForKey:@"success"] intValue] == 1){
                    NSLog(@"Success");
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SigninViewController *signinVC = [story instantiateViewControllerWithIdentifier:@"SigninViewController"];
                    [self.navigationController pushViewController:signinVC animated:YES];
                }
                else{
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Failed send code" dismiss:@"OK" sender:self];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error: %@", error);
            }];
        }
        
        
        
    }
}

- (void) checkInputs{
    if(_txt_validation.text.length == 0){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input the validation code" dismiss:@"OK" sender:self];
    }else{
        isCode = true;
        if(_txt_password.text.length == 0){
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input the password" dismiss:@"OK" sender:self];
        }else{
            isPassword = true;
            if(_txt_confirm.text.length == 0){
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input the confirm password" dismiss:@"OK" sender:self];
            }else{
                isConfirm = true;
            }
        }
    }
}

#pragma mark - Utility Handler -
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
