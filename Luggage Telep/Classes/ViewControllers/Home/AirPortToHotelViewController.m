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
#import "CNPPopupController.h"
#import "BookingDetailViewController.h"
#import "MainViewController.h"

@interface AirPortToHotelViewController ()<UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate, CNPPopupControllerDelegate>{
    Boolean isYes;
    Boolean isNo;
}
@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropAirportMenu;
@property (weak, nonatomic) IBOutlet UILabel *airlineName;
@property (weak, nonatomic) IBOutlet UILabel *txt_airportName;

@property (weak, nonatomic) IBOutlet UIView *nextButView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_fightNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_arrivalTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelName;
@property (weak, nonatomic) IBOutlet UITextField *txt_guestName;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelConfirmNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_pickDate;
@property (weak, nonatomic) IBOutlet UITextField *txt_deliveryDate;
@property (weak, nonatomic) IBOutlet UIImageView *image_YES;
@property (weak, nonatomic) IBOutlet UIImageView *imageNO;

@property (strong, nonatomic) NSArray<NSString *> *airLineList;
@property (strong, nonatomic) NSArray<NSString *> *airPortList;
@end

@implementation AirPortToHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isYes = false;
    isNo = true;
    self.nextButView.layer.cornerRadius = self.nextButView.frame.size.height/2;
    
    self.airLineList = @[@"Cathy",
                         @"Qatar",
                         @"Singapore"];
    self.airPortList = @[@"San Francisco Airport Terminal 1",
                         @"San Francisco Airport Terminal 2",
                         @"San Francisco Airport Terminal 3",
                         @"San Francisco Airport International Terminal",];
    
    self.dropdownMenu.dropdownShowsTopRowSeparator = NO;
    self.dropdownMenu.dropdownShowsBottomRowSeparator = NO;
    self.dropdownMenu.dropdownShowsBorder = YES;
    self.dropdownMenu.disclosureIndicatorImage.accessibilityElementsHidden = true;
    self.dropdownMenu.backgroundDimmingOpacity = 0.0;
    
    self.dropAirportMenu.dropdownShowsTopRowSeparator = NO;
    self.dropAirportMenu.dropdownShowsBottomRowSeparator = NO;
    self.dropAirportMenu.dropdownShowsBorder = YES;
    self.dropAirportMenu.disclosureIndicatorImage.accessibilityElementsHidden = true;
    self.dropAirportMenu.backgroundDimmingOpacity = 0.0;
    
    if(self.isBookingNow){
        [self showPopupWithStyle:CNPPopupStyleActionSheet];
    }
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
    [self.popupController presentPopupControllerAnimated:YES];
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
    [self.dropdownMenu closeAllComponentsAnimated:NO];
    [self.dropAirportMenu closeAllComponentsAnimated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:mainVC animated:NO];
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
    if(dropdownMenu.tag == 2){
        return self.airLineList.count;
    }else{
        return self.airPortList.count;
    }
    
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
    if(dropdownMenu.tag == 2){
        AirlineSelectView *shapeSelectView = (AirlineSelectView *)view;
        if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[AirlineSelectView class]]) {
            shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AirlineSelectView class]) owner:nil options:nil] firstObject];
        }
        shapeSelectView.textLabel.text = self.airLineList[row];
        
        return shapeSelectView;
    }else{
        AirlineSelectView *shapeSelectView = (AirlineSelectView *)view;
        if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[AirlineSelectView class]]) {
            shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AirlineSelectView class]) owner:nil options:nil] firstObject];
        }
        shapeSelectView.textLabel.text = self.airPortList[row];
        
        return shapeSelectView;
    }
    

}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {

    return nil;
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (dropdownMenu.tag == 2) {
        self.airlineName.text = self.airLineList[row];
        [self.dropdownMenu closeAllComponentsAnimated:NO];
    }else{
        self.txt_airportName.text = self.airPortList[row];
        [self.dropAirportMenu closeAllComponentsAnimated:NO];
    }
    
    [dropdownMenu reloadComponent:component];
    

}

@end
