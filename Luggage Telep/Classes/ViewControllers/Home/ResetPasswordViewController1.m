//
//  ResetPasswordViewController1.m
//  Luggage Telep
//
//  Created by MacOS on 12/12/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "ResetPasswordViewController1.h"
#import "ResetPasswordViewController2.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"

@interface ResetPasswordViewController1 ()<UITextFieldDelegate>{
    Boolean isMobileOrEmail;
}

@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UIButton *sendmailBtn;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;

@end

@implementation ResetPasswordViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mobileView.layer.cornerRadius = 8.f;
    _mobileView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _mobileView.layer.borderWidth= 1.0f;
    _sendmailBtn.layer.cornerRadius = _sendmailBtn.layer.frame.size.height/2;
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_sendCode:(id)sender {
    [self checkInputs];
    if(isMobileOrEmail){
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        if([self validateEmailWithString:_txt_mobile.text]){
            NSDictionary *params = @{@"email": _txt_mobile.text };
            [manager POST:SENDCODETOMAIL_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if([[responseObject objectForKey:@"success"] intValue] == 1){
                    NSLog(@"Success");
                }
                else{
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Failed Update Credit Card" dismiss:@"OK" sender:self];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error: %@", error);
            }];
        }else{
            NSDictionary *params = @{@"phoneNumber": _txt_mobile.text,
                                     @"countryCode": @"+1"
                                     };
            [manager POST:SENDCODETOMOBILE_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if([[responseObject objectForKey:@"result"] intValue] == 1){
                    NSLog(@"Success");
                }
                else{
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Failed Update Credit Card" dismiss:@"OK" sender:self];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error: %@", error);
            }];
        }
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ResetPasswordViewController2 *resetVC = [story instantiateViewControllerWithIdentifier:@"ResetPasswordViewController2"];
        resetVC.emailAddress = _txt_mobile.text;
        [self.navigationController pushViewController:resetVC animated:YES];
    }
}

- (void) checkInputs{
    if(_txt_mobile.text.length == 0){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your Mobile Number or Email" dismiss:@"OK" sender:self];
    }else{
        isMobileOrEmail = true;
    }
}

#pragma mark - Utility Handler -
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
