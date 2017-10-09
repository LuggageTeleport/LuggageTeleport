//
//  SupportViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/3/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "SupportViewController.h"

@interface SupportViewController ()<UITextFieldDelegate, UITextViewDelegate>
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
