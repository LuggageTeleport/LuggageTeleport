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
    Boolean isFirstName;
    Boolean isLastName;
    Boolean isEmail;
    Boolean isMobile;
    Boolean isPassword;
    Boolean isConfirm;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_firstName;
@property (weak, nonatomic) IBOutlet UITextField *txt_lastName;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_confirm;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isFirstName = false;
    isLastName = false;
    isEmail = false;
    isMobile = false;
    isPassword = false;
    isConfirm = false;
    self.registerBtn.layer.cornerRadius = self.registerBtn.layer.frame.size.height/2;
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
    if(isFirstName && isLastName && isEmail && isMobile && isPassword){
        
        [kACCOUNT_UTILS showWorking:self.view string:@"Creating Account"];
        
        NSDictionary *params = @{@"username"     : _txt_email.text,
                                 @"password"     : _txt_password.text,
                                 @"firstname"    : _txt_firstName.text,
                                 @"lastname"     : _txt_lastName.text,
                                 @"mobileNumber" : _txt_mobile.text};
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:REGISTER_URL parameters:params error:nil];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
                [kACCOUNT_UTILS showFailure:self.view withString:@"Invalid Create" andBlock:nil];
            } else {
                [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                NSLog(@"%@", responseObject);
                NSNumber *number = [responseObject objectForKey:@"success"];
                if( [number intValue] == 1){
                    
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
                    [self.navigationController pushViewController:mainVC animated:YES];
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                             message:@"Username alredy exists"
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }];
        [dataTask resume];
    }
}

- (void) checkInputs{
    if(_txt_firstName.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your first name"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        isFirstName = true;
    }
    
    if(_txt_lastName.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your last name"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        isLastName = true;
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
    
    if(_txt_mobile.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your mobile number"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        isMobile = true;
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
    
    if(_txt_password.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your confirm password"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        if([_txt_password.text isEqualToString:_txt_confirm.text]){
            isConfirm = true;
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                     message:@"Not matched password and confirm"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}



#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 7) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_firstName) {
        [self.txt_lastName becomeFirstResponder];
    }else if(textField == self.txt_lastName) {
        [self.txt_email becomeFirstResponder];
    }else if(textField == self.txt_email) {
        [self.txt_mobile becomeFirstResponder];
    }else if(textField == self.txt_mobile) {
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
        [self.mScrollView setContentOffset:CGPointMake(0, 30) animated:true];
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
