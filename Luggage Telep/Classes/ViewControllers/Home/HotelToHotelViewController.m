//
//  HotelToHotelViewController.m
//  Luggage Telep
//
//  Created by MacOS on 12/19/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "HotelToHotelViewController.h"
#import "Constant.h"
#import "MKDropdownMenu.h"
#import "ActionSheetPicker.h"
#import "AccountUtilities.h"
#import "AirlineSelectView.h"

@interface HotelToHotelViewController ()<UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (weak, nonatomic) IBOutlet UITextField *txt_arrivalAirport;
@property (weak, nonatomic) IBOutlet UITextField *txt_departureAirport;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pickupDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deliveryDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pickupTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_deliveryTime;

@end

@implementation HotelToHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
    
    self.nextBtn.layer.cornerRadius = self.nextBtn.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ActionSheet Delegate

- (IBAction)clicked_pickupDate:(id)sender {
    [self.txt_arrivalAirport resignFirstResponder];
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

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    return NO;
}


@end
