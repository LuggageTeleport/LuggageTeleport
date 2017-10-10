//
//  AirPortToHotelViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AirPortToHotelViewController.h"
#import "Constant.h"
#import "MKDropdownMenu.h"
#import "AirlineSelectView.h"

@interface AirPortToHotelViewController ()<UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>{
    Boolean isYes;
    Boolean isNo;
}

@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenu;
@property (weak, nonatomic) IBOutlet UILabel *airlineName;

@property (weak, nonatomic) IBOutlet UIView *nextButView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_airportName;
@property (weak, nonatomic) IBOutlet UITextField *txt_fightNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_arrivalTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelName;
@property (weak, nonatomic) IBOutlet UITextField *txt_guestName;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelConfirmNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_pickDate;
@property (weak, nonatomic) IBOutlet UITextField *txt_deliveryDate;
@property (weak, nonatomic) IBOutlet UIImageView *image_YES;
@property (weak, nonatomic) IBOutlet UIImageView *imageNO;

@property (strong, nonatomic) NSArray<NSString *> *airLineTitles;
@end

@implementation AirPortToHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isYes = false;
    isNo = true;
    self.nextButView.layer.cornerRadius = self.nextButView.frame.size.height/2;
    self.airLineTitles = @[@"San Francisco Airport Terminal 1",
                             @"San Francisco Airport Terminal 2",
                             @"San Francisco Airport Terminal 3",
                             @"San Francisco Airport International Terminal",];
    
    self.dropdownMenu.dropdownShowsTopRowSeparator = NO;
    self.dropdownMenu.dropdownShowsBottomRowSeparator = NO;
    self.dropdownMenu.dropdownShowsBorder = YES;
    
    self.dropdownMenu.backgroundDimmingOpacity = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Delegate

- (IBAction)clicked_YES:(id)sender {
    isYes = true;
    isNo = false;
    [self switchCheckBox];
}

- (IBAction)clicked_NO:(id)sender {
    isYes = false;
    isNo = true;
    [self switchCheckBox];
}
- (void) switchCheckBox {
    if(isYes){
        _image_YES.image = IMAGE(@"ic_check_box.jpg");
        _imageNO.image = IMAGE(@"ic_uncheck_box.jpg");
    }else{
        _image_YES.image = IMAGE(@"ic_uncheck_box.jpg");
        _imageNO.image = IMAGE(@"ic_check_box.jpg");
    }
}
- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 9) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }

    if (textField == self.txt_airportName) {
        [self.txt_fightNumber becomeFirstResponder];
    }else if(textField == self.txt_fightNumber) {
        [self.txt_arrivalTime becomeFirstResponder];
    }else if(textField == self.txt_arrivalTime) {
        [self.txt_hotelName becomeFirstResponder];
    }else if(textField == self.txt_hotelName) {
        [self.txt_guestName becomeFirstResponder];
    }else if(textField == self.txt_guestName) {
        [self.txt_hotelConfirmNumber becomeFirstResponder];
    }else if(textField == self.txt_hotelConfirmNumber) {
        [self.txt_pickDate becomeFirstResponder];
    }else if(textField == self.txt_pickDate) {
        [self.txt_deliveryDate becomeFirstResponder];
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
        [self.mScrollView setContentOffset:CGPointMake(0, 20) animated:true];
    }
    else if (textField.tag == 6) {
        [self.mScrollView setContentOffset:CGPointMake(0, 70) animated:true];
    }
    else if (textField.tag == 7) {
        [self.mScrollView setContentOffset:CGPointMake(0, 110) animated:true];
    }
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 190) animated:true];
    }
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return self.airLineTitles.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return 0;
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return self.dropdownMenu.layer.frame.size.width;
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

        AirlineSelectView *shapeSelectView = (AirlineSelectView *)view;
        if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[AirlineSelectView class]]) {
            shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AirlineSelectView class]) owner:nil options:nil] firstObject];
        }
        shapeSelectView.textLabel.text = self.airLineTitles[row];

        return shapeSelectView;

}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {

    return nil;
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

        self.airlineName.text = self.airLineTitles[row];
        [dropdownMenu reloadComponent:component];

}

@end
