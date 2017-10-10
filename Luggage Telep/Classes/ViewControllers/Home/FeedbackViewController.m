//
//  FeedbackViewController.m
//  Luggage Telep
//
//  Created by mac on 10/11/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txt_message;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _txt_message.text = @"Please leave your feedback";
    _txt_message.textColor =[UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Please leave your feedback"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Please leave your feedback";
        textView.textColor =[UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
