//
//  SupportViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/3/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "SupportViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"

@interface SupportViewController ()<UITextFieldDelegate, UITextViewDelegate>{
    BOOL isName, isEmail, isMessage;
}
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextView *txt_message;
@property (weak, nonatomic) IBOutlet UILabel *lbl_first;
@property (weak, nonatomic) IBOutlet UILabel *lbl_second;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;


@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _nameView.layer.cornerRadius = _nameView.layer.frame.size.height/2;
    _emailView.layer.cornerRadius = _emailView.layer.frame.size.height/2;
    _messageView.layer.cornerRadius = 20;
    _submitView.layer.cornerRadius = _submitView.layer.frame.size.height/2;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == 568.0) {
        [_lbl_first setFont:[UIFont systemFontOfSize: 12]];
        [_lbl_second setFont:[UIFont systemFontOfSize: 12]];
    }else if (screenHeight == 667.0){
        [_lbl_first setFont:[UIFont systemFontOfSize: 13]];
        [_lbl_second setFont:[UIFont systemFontOfSize: 13]];
    }else if (screenHeight == 667.0){
        [_lbl_first setFont:[UIFont systemFontOfSize: 14]];
        [_lbl_second setFont:[UIFont systemFontOfSize: 14]];
    }else{
        [_lbl_first setFont:[UIFont systemFontOfSize: 14]];
        [_lbl_second setFont:[UIFont systemFontOfSize: 14]];
    }
    
    _txt_message.text = @"Message *";
    _txt_message.textColor =[UIColor lightGrayColor];
    
    isName = false;
    isEmail =false;
    isMessage = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_submit:(id)sender {
    [self setInput];
    if(isEmail && isName && isMessage){
        [kACCOUNT_UTILS showWorking:self.view string:@""];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSDictionary *params = [NSDictionary alloc];
        
        params = @{@"username" : self.txt_name.text,
                   @"email" : self.txt_email.text,
                   @"message" : self.txt_message.text,
                   };
        
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:SUPPORT_URL parameters:params error:nil];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
                [kACCOUNT_UTILS showFailure:self.view withString:@"Failed to send mail" andBlock:nil];
                [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
            } else{
                [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
            }
        }];
        [dataTask resume];
    }
    
}

- (void) setInput {
    if(_txt_name.text.length == 0){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your username" dismiss:@"OK" sender:self];
    }else{
        isName = true;
        if(_txt_email.text.length == 0){
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your email" dismiss:@"OK" sender:self];
        }else{
            isEmail = true;
            if([_txt_message.text isEqualToString:@"Message *"]){
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please write message" dismiss:@"OK" sender:self];
            }else{
                isMessage = true;
            }
        }
    }
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 3) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_name) {
        [self.txt_email becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 40) animated:true];
    }
    else {
        [self.mScrollView setContentOffset:CGPointMake(0, 110) animated:true];
    }
}

#pragma mark - TextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.mScrollView setContentOffset:CGPointMake(0, 160) animated:true];
    if([textView.text isEqualToString:@"Message *"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Message *";
        textView.textColor =[UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}


@end
