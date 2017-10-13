//
//  BookingDetailViewController.m
//  Luggage Telep
//
//  Created by mac on 10/10/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "BookingDetailViewController.h"
#import "CNPPopupController.h"

@interface BookingDetailViewController () <CNPPopupControllerDelegate>

@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation BookingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_contact:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleActionSheet];
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Contact Edward" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"If you're using a new number, tap Edit" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor darkGrayColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"CHAT" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:240.f/255 green:216.f/255 blue:6.f/255 alpha:1.0];
    button.layer.cornerRadius = 8;
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 setTitle:@"CALL" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:240.f/255 green:216.f/255 blue:6.f/255 alpha:1.0];
    button1.layer.cornerRadius = 8;
    button1.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 55)];
//    customView.backgroundColor = [UIColor lightGrayColor];
//    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
//    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [button1 setTitle:@"Edit" forState:UIControlStateNormal];
//    button1.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
//    button1.layer.cornerRadius = 4;
    
    UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 180, 35)];
    textFied.borderStyle = UITextBorderStyleRoundedRect;
    textFied.text = @"+1 405 2223-2234";
    textFied.borderStyle = UITextBorderStyleNone;
    [customView addSubview:textFied];
//    [customView addSubview:button1];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, customView, button, button1]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}


@end
