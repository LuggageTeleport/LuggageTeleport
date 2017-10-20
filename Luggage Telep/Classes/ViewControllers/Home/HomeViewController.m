//
//  HomeViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "HomeViewController.h"
#import "AirPortToHotelViewController.h"
#import "CNPPopupController.h"
#import "MKDropdownMenu.h"
#import "BookingDetailViewController.h"
#import "Constant.h"

@interface HomeViewController ()<MKDropdownMenuDelegate, CNPPopupControllerDelegate>

@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.isBookingNow){
        [self showPopupWithStyle:CNPPopupStyleActionSheet];
    }
//    [self.mScrollView setContentOffset:CGPointMake(0, 20) animated:true];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Edward" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"LuggageTeleport Truck" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor darkGrayColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
    UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    customLabel.numberOfLines = 0;
    customLabel.attributedText = title;
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button setTitle:@"Edward" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.selectionHandler = ^(CNPPopupButton *button){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BookingDetailViewController *bookVC = [story instantiateViewControllerWithIdentifier:@"BookingDetailViewController"];
        [self.navigationController pushViewController:bookVC animated:YES];
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 20)];
    companyLabel.numberOfLines = 0;
    companyLabel.attributedText = lineOne;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 55)];
    UIImageView *userPhoto = [[UIImageView alloc] initWithImage:IMAGE(@"user_placeholder.png")];
    userPhoto.frame = CGRectMake(5, 7, 40, 40);
    
    UIView *nameView =  [[UIView alloc] initWithFrame:CGRectMake(65, 7, 150, 40)];
    
    UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(220, 17, 65, 25)];
    textFied.borderStyle = UITextBorderStyleNone;
    textFied.text = @"";
    textFied.borderStyle = UITextBorderStyleBezel;
    
    
    [nameView addSubview:button];
    [nameView addSubview:companyLabel];
    
    [customView addSubview:userPhoto];
    [customView addSubview:nameView];
    [customView addSubview:textFied];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[customView]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.mScrollView setContentOffset:CGPointMake(0, 95) animated:true];
    [self.popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

- (void)popupControllerDidDismiss:(nonnull CNPPopupController *)controller{
    NSLog(@"Popup controller Dismiss.");
     [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_airport_hotel:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AirPortToHotelViewController *airportVC = [story instantiateViewControllerWithIdentifier:@"AirPortToHotelViewController"];
    [self.navigationController pushViewController:airportVC animated:YES];
}


@end
