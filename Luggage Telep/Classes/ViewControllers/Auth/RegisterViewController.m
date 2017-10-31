//
//  RegisterViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/6/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"

@interface RegisterViewController ()<UITextFieldDelegate>{
    Boolean isuserName;
    Boolean isEmail;
    Boolean isPassword;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isuserName = false;
    isEmail = false;
    isPassword = false;
    self.registerBtn.layer.cornerRadius = self.registerBtn.layer.frame.size.height/2;
    self.nameView.layer.cornerRadius = self.nameView.layer.frame.size.height/2;
    self.emailView.layer.cornerRadius = self.emailView.layer.frame.size.height/2;
    self.passwordView.layer.cornerRadius = self.passwordView.layer.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_Register:(id)sender {
    [self checkInputs];
    if(isuserName && isEmail && isPassword){
        
        [kACCOUNT_UTILS showWorking:self.view string:@"Creating Account"];

        NSDictionary *params = @{@"username"    : _txt_name.text,
                                 @"email"       : _txt_email.text,
                                 @"password"    : _txt_password.text
                                 };

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:REGISTER_URL parameters:params error:nil];

        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
                [kACCOUNT_UTILS showFailure:self.view withString:@"Invalid Create" andBlock:nil];
            } else {
                NSNumber *number = [responseObject objectForKey:@"success"];
                if( [number intValue] == 1){
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:[responseObject objectForKey:@"token"] forKey:KEY_TOKEN];
                    [defaults setValue:_txt_password.text forKey:KEY_PASSWORD];
                    [defaults synchronize];
                    NSString *token = [responseObject objectForKey:@"token"];
                    
                    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                    NSDictionary *dict = @{@"":@""};
                    [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"success!");
                        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setValue:nil forKey:KEY_CARDNUMBER];
                        NSArray *array = [[responseObject objectForKey:@"profile"] objectForKey:@"cards"];
                        if(array.count > 0){
                            NSDictionary *dictionary = [array objectAtIndex:0];
                            NSString *cardNumber = [dictionary objectForKey:@"cardNumber"];
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setValue:cardNumber forKey:KEY_CARDNUMBER];
                        }
                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
                        [self.navigationController pushViewController:mainVC animated:YES];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"error: %@", error);
                    }];
                    
                }else{
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Authenication failed. User not found" dismiss:@"OK" sender:self];
                }
            }
        }];
        [dataTask resume];
    }
}

- (void) checkInputs{
    if(_txt_name.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your username"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        isuserName = true;
    }
    

    
    if(_txt_email.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your last name"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        if([self validateEmailWithString:_txt_email.text]){
            isEmail = true;
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                     message:@"Not valid email address"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    
    
    if(_txt_password.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your password"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        if(_txt_password.text.length < 6){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                     message:@"Password must be at least 6 characters"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            isPassword = true;
        }
    }
}



#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 4) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_name) {
        [self.txt_email becomeFirstResponder];
    }else if(textField == self.txt_email) {
        [self.txt_password becomeFirstResponder];
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
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 60) animated:true];
    }
}


#pragma mark - Utility Handler -
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
