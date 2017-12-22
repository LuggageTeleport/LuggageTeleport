//
//  HotelToAirportViewController.m
//  Luggage Telep
//
//  Created by MacOS on 12/19/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "HotelToAirportViewController.h"
#import "Constant.h"
#import "MKDropdownMenu.h"
#import "ActionSheetPicker.h"
#import "AccountUtilities.h"
#import "AirlineSelectView.h"

@interface HotelToAirportViewController ()<UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *txt_arrivalAirport;
@property (weak, nonatomic) IBOutlet UITextField *txt_departureAirport;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pickupDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deliveryDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pickupTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deliveryTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_airLine;
@property (weak, nonatomic) IBOutlet UITextField *txt_flightNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_departureTime;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropAirlineMenu;

@property (strong, nonatomic) NSArray<NSString *> *airLineList;

@end

@implementation HotelToAirportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.frame.size.height/2;
    
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
    
    self.airLineList = @[@"Aer Lingus",
                         @"Aeroméxico",
                         @"Air Canada",
                         @"Air China",
                         @"Air France",
                         @"Air India",
                         @"Air New Zealand",
                         @"Alaska Airlines",
                         @"All Nippon Airways",
                         @"American Airlines",
                         @"American Eagle",
                         @"Asiana Airlines",
                         @"Avianca El Salvador",
                         @"British Airways",
                         @"Cathay Pacific",
                         @"China Airlines",
                         @"China Eastern Airlines",
                         @"China Southern Airlines",
                         @"Copa Airlines",
                         @"Delta Air Lines",
                         @"Delta Connection",
                         @"Delta Shuttle",
                         @"Emirates",
                         @"Etihad Airways",
                         @"EVA Air",
                         @"Fiji Airways",
                         @"Finnair",
                         @"Frontier Airlines",
                         @"Hawaiian Airlines",
                         @"Hong Kong Airlines",
                         @"Iberia",
                         @"Japan Airlines",
                         @"JetBlue Airways",
                         @"KLM",
                         @"Korean Air",
                         @"Lufthansa",
                         @"Philippine Airlines",
                         @"Qantas",
                         @"Scandinavian Airlines",
                         @"Singapore Airlines",
                         @"Southwest Airlines",
                         @"Sun Country Airlines",
                         @"Swiss International Air Lines",
                         @"Thomas Cook Airlines",
                         @"Turkish Airlines",
                         @"United Airlines",
                         @"United Express",
                         @"Virgin America",
                         @"Virgin Atlantic",
                         @"Volaris",
                         @"WestJet",
                         @"WOW air",
                         @"XL Airways France"];
    self.dropAirlineMenu.dropdownShowsTopRowSeparator = NO;
    self.dropAirlineMenu.dropdownShowsBottomRowSeparator = NO;
    self.dropAirlineMenu.dropdownShowsBorder = YES;
    self.dropAirlineMenu.disclosureIndicatorImage.accessibilityElementsHidden = true;
    self.dropAirlineMenu.backgroundDimmingOpacity = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.dropAirlineMenu closeAllComponentsAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ActionSheet Delegate

- (IBAction)clicked_pickupDate:(id)sender {
    [self.txt_arrivalAirport resignFirstResponder];
    [self.txt_flightNumber resignFirstResponder];
    [self.txt_departureAirport resignFirstResponder];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1970];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    
     ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                       datePickerMode:UIDatePickerModeDate
                                                         selectedDate:self.selectedDate
                                                               target:self
                                                               action:@selector(dateWasSelected1:element:)
                                                               origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    
    actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
}

- (IBAction)clicked_pickupTime:(id)sender {
    [self.txt_arrivalAirport resignFirstResponder];
    [self.txt_flightNumber resignFirstResponder];
    [self.txt_departureAirport resignFirstResponder];
    NSInteger minuteInterval = 5;
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time"
                                                                      datePickerMode:UIDatePickerModeTime
                                                                        selectedDate:self.selectedTime
                                                                              target:self
                                                                              action:@selector(timeWasSelected1:element:)
                                                                              origin:sender];
    datePicker.minuteInterval = minuteInterval;
    [datePicker showActionSheetPicker];
}

- (IBAction)clicked_deliveryDate:(id)sender {
    [self.txt_arrivalAirport resignFirstResponder];
    [self.txt_flightNumber resignFirstResponder];
    [self.txt_departureAirport resignFirstResponder];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1970];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    
    ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                                             datePickerMode:UIDatePickerModeDate
                                                                               selectedDate:self.selectedDate
                                                                                     target:self
                                                                                     action:@selector(dateWasSelected2:element:)
                                                                                     origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    
    actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
}

- (IBAction)clicked_deliveryTime:(id)sender {
    [self.txt_arrivalAirport resignFirstResponder];
    [self.txt_flightNumber resignFirstResponder];
    [self.txt_departureAirport resignFirstResponder];
    NSInteger minuteInterval = 5;
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time"
                                                                      datePickerMode:UIDatePickerModeTime
                                                                        selectedDate:self.selectedTime
                                                                              target:self
                                                                              action:@selector(timeWasSelected2:element:)
                                                                              origin:sender];
    datePicker.minuteInterval = minuteInterval;
    [datePicker showActionSheetPicker];
}
- (IBAction)clicked_departureTime:(id)sender {
    [self.txt_arrivalAirport resignFirstResponder];
    [self.txt_flightNumber resignFirstResponder];
    [self.txt_departureAirport resignFirstResponder];
    NSInteger minuteInterval = 5;
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time"
                                                                      datePickerMode:UIDatePickerModeTime
                                                                        selectedDate:self.selectedTime
                                                                              target:self
                                                                              action:@selector(timeWasSelected3:element:)
                                                                              origin:sender];
    datePicker.minuteInterval = minuteInterval;
    [datePicker showActionSheetPicker];
}

- (void)dateWasSelected1:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.lbl_pickupDate.text = [dateFormatter stringFromDate:selectedDate];
    self.lbl_pickupDate.textColor = [UIColor blackColor];
}

- (void)dateWasSelected2:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.lbl_deliveryDate.text = [dateFormatter stringFromDate:selectedDate];
    self.lbl_deliveryDate.textColor = [UIColor blackColor];
}
-(void)timeWasSelected1:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.lbl_pickupTime.text = [dateFormatter stringFromDate:selectedTime];
    self.lbl_pickupTime.textColor = [UIColor blackColor];
}
-(void)timeWasSelected2:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.lbl_deliveryTime.text = [dateFormatter stringFromDate:selectedTime];
    self.lbl_deliveryTime.textColor = [UIColor blackColor];
}
-(void)timeWasSelected3:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.lbl_departureTime.text = [dateFormatter stringFromDate:selectedTime];
    self.lbl_departureTime.textColor = [UIColor blackColor];
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return self.airLineList.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return 0;
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return self.dropAirlineMenu.layer.frame.size.width;
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [self.txt_flightNumber resignFirstResponder];
    
    AirlineSelectView *shapeSelectView = (AirlineSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[AirlineSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AirlineSelectView class]) owner:nil options:nil] firstObject];
    }
    shapeSelectView.textLabel.text = self.airLineList[row];
    
    return shapeSelectView;

}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.txt_flightNumber resignFirstResponder];
    self.lbl_airLine.text = self.airLineList[row];
    [self.dropAirlineMenu closeAllComponentsAnimated:NO];
    
    [dropdownMenu reloadComponent:component];
}


#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.dropAirlineMenu closeAllComponentsAnimated:NO];
    
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 50) animated:true];
    }
}



@end
