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
#import "BookingAuth.h"
#import "NumberOfBagsViewController.h"
#import "ActionSheetPicker.h"
#import "AccountUtilities.h"

@interface AirPortToHotelViewController ()<UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate, CNPPopupControllerDelegate>{
    Boolean isYes;
    Boolean isNo;
    
    Boolean isAirport, isAirline, isFlightNumber, isPickupDate, isEstimateTime, isHotelName, isHotelBooking, isHotelReservation, isDropDate;
}
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropAirportMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropHotelMenu;
@property (weak, nonatomic) IBOutlet UILabel *airlineName;
@property (weak, nonatomic) IBOutlet UILabel *txt_airportName;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pickDaate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dropDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_estimatedTime;

@property (weak, nonatomic) IBOutlet UIView *nextButView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_flightNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_guestName;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelConfirmNumber;
@property (weak, nonatomic) IBOutlet UIImageView *image_YES;
@property (weak, nonatomic) IBOutlet UIImageView *imageNO;

@property (strong, nonatomic) NSArray<NSString *> *airLineList;
@property (strong, nonatomic) NSArray<NSString *> *airPortList;
@property (strong, nonatomic) NSArray<NSString *> *hotelList;
@end

@implementation AirPortToHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isYes = false;
    isNo = true;
    isAirport = false;
    isAirline= false;
    isFlightNumber = false;
    isPickupDate = false;
    isEstimateTime = false;
    isHotelName = false;
    isHotelBooking = false;
    isHotelReservation = false;
    isDropDate = false;
    
    self.nextButView.layer.cornerRadius = self.nextButView.frame.size.height/2;
    
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
    self.airPortList = @[@"San Francisco Airport Terminal 1",
                         @"San Francisco Airport Terminal 2",
                         @"San Francisco Airport Terminal 3",
                         @"San Francisco Airport International Terminal",];
    self.hotelList = @[@"Aloft San Francisco Airport",
                       @"Argonaut Hotel San Francisco",
                       @"Casa Luna San Francisco",
                       @"Clift San Francisco",
                       @"Club Donatello Owners Association San Francisco",
                       @"Courtyard by Marriott San Francisco Fisherman's Wharf",
                       @"Embassy Suites by Hilton San Francisco Airport Waterfront",
                       @"Fairmont Heritage Place, Ghirardelli Square San Francisco",
                       @"Four Seasons Hotel & Residences San Francisco",
                       @"Grand Hyatt San Francisco",
                       @"Hilton San Francisco Airport Bayfront",
                       @"Hilton San Francisco Financial District",
                       @"Hilton San Francisco Union Square",
                       @"Holiday Inn San Francisco-Civic Center",
                       @"Holiday Inn San Francisco-Civic Center",
                       @"Hotel Drisco",
                       @"Hotel Fairmont",
                       @"Hotel Nikko San Francisco",
                       @"Hotel Vitale",
                       @"Hotel Zelos San Francisco",
                       @"Hotel Zetta San Francisco",
                       @"Huntington Hotel",
                       @"Hyatt Centric Fisherman's Wharf San Francisco",
                       @"Hyatt Regency San Francisco Airport",
                       @"Hyatt Regency SFO",
                       @"Inn On Castro",
                       @"Inter Continental SFO",
                       @"JW Marriott SFO Union Square",
                       @"Kimpton Sir Francis Drake",
                       @"Le Méridien SFO",
                       @"Loews Regency San Francisco",
                       @"Marriott Fisherman's Wharf",
                       @"Omni San Francisco",
                       @"Palace Hotel, a Luxury Collection Hotel, SFO",
                       @"Parc 55 San Francisco",
                       @"Park Central Hotel San Francisco",
                       @"Payne Mansion Hotel",
                       @"Renaissance San Francisco Stanford Court Hotel",
                       @"San Francisco Airport Marriott Waterfront",
                       @"San Francisco Marriott Marquis",
                       @"San Francisco Marriott Union Square",
                       @"San Mateo Marriott San Francisco Airport",
                       @"Serrano Hotel San Francisco",
                       @"Sheraton Fisherman's Wharf San Francisco",
                       @"Staybridge Suites San Francisco Airport",
                       @"Taj Campton Place San Francisco",
                       @"The Donatello San Francisco",
                       @"The Marker San Francisco",
                       @"The Metro Hotel San Francisco",
                       @"The Orchard Garden Hotel San Francisco",
                       @"The Ritz-Carlton Club, San Francisco",
                       @"The Ritz-Carlton San Francisco",
                       @"The St. Regis San Francisco",
                       @"The Westin San Francisco Airport",
                       @"The Westin St. Francis San Francisco on Union Square",
                       @"University Club of San Francisco",
                       @"W San Francisco",
                       ];
    
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
    
    self.dropHotelMenu.dropdownShowsTopRowSeparator = NO;
    self.dropHotelMenu.dropdownShowsBottomRowSeparator = NO;
    self.dropHotelMenu.dropdownShowsBorder = YES;
    self.dropHotelMenu.disclosureIndicatorImage.accessibilityElementsHidden = true;
    self.dropHotelMenu.backgroundDimmingOpacity = 0.0;
    
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
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
    [self.dropHotelMenu closeAllComponentsAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_Next:(id)sender {
    BookingAuth *booking = [BookingAuth bookingWithAirPortName:_txt_airportName.text
                                                andAirLineName:_airlineName.text
                                               andFlightNumber:_txt_flightNumber.text
                                              andEstimatedTime:_lbl_estimatedTime.text
                                                  andHotelName:_hotelName.text
                                                  andGuestName:_txt_guestName.text
                                         andHotelConfirmNumber:_txt_hotelConfirmNumber.text
                                                 andPickupDate:_lbl_pickDaate.text
                                               andDeliveryDate:_lbl_dropDate.text
                                           andOvernightStorate:isYes];
    
    [self checkBookingItem];
    
    if(isAirport == true && isAirline == true && isFlightNumber == true && isPickupDate == true && isEstimateTime == true && isHotelName == true && isHotelBooking == true && isHotelReservation == true && isDropDate == true){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NumberOfBagsViewController *bagsVC = [story instantiateViewControllerWithIdentifier:@"NumberOfBagsViewController"];
        [bagsVC initBooking:booking];
        [self.navigationController pushViewController:bagsVC animated:YES];
    }
}

- (void) checkBookingItem{
    if([_txt_airportName.text isEqualToString:@"Choose Airport for Pick up"]){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Choose Airport for Pick up" dismiss:@"OK" sender:self];
    }else{
        isAirport = true;
        if([_airlineName.text isEqualToString:@"Airline"]){
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Choose Airline for Pick up" dismiss:@"OK" sender:self];
        }else{
            isAirline = true;
            if(_txt_flightNumber.text.length == 0){
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input the Flight Number" dismiss:@"OK" sender:self];
            }else{
                isFlightNumber = true;
                if([_lbl_pickDaate.text isEqualToString:@"Pick up Date"]){
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Choose Pick up Date" dismiss:@"OK" sender:self];
                }else{
                    isPickupDate = true;
                    if([_lbl_estimatedTime.text isEqualToString:@"Estimated time of Arrival"]){
                        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Choose Estimated time of Arrival" dismiss:@"OK" sender:self];
                    }else{
                        isEstimateTime = true;
                        if([_hotelName.text isEqualToString:@"Hotel for Drop off"]){
                            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Choose Hotel" dismiss:@"OK" sender:self];
                        }else{
                            isHotelName = true;
                            if(_txt_hotelConfirmNumber.text.length == 0){
                                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Input Hotel Booking Reference" dismiss:@"OK" sender:self];
                            }else{
                                isHotelBooking = true;
                                if(_txt_guestName.text.length == 0){
                                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Input Guest Name" dismiss:@"OK" sender:self];
                                }else{
                                    isHotelReservation = true;
                                    if([_lbl_dropDate.text isEqualToString:@"Drop off Date"]){
                                        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Choose Drop Date" dismiss:@"OK" sender:self];
                                    }else{
                                        isDropDate = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - ActionSheet Delegate

- (IBAction)clicked_pickUpDate:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                       datePickerMode:UIDatePickerModeDate
                                                         selectedDate:self.selectedDate
                                                               target:self
                                                               action:@selector(dateWasSelected:element:)
                                                               origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];

    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}
- (IBAction)clicked_dropOffDate:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                       datePickerMode:UIDatePickerModeDate
                                                         selectedDate:self.selectedDate
                                                               target:self
                                                               action:@selector(dateWasSelected1:element:)
                                                               origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)estimatedTime:(id)sender {
    NSInteger minuteInterval = 5;
    //clamp date
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {/// round up
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
    }
    
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedTime target:self action:@selector(timeWasSelected:element:) origin:sender];
    datePicker.minuteInterval = minuteInterval;
    [datePicker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    self.lbl_pickDaate.text = [dateFormatter stringFromDate:selectedDate];
    self.lbl_pickDaate.textColor = [UIColor blackColor];
}

- (void)dateWasSelected1:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.lbl_dropDate.text = [dateFormatter stringFromDate:selectedDate];
    self.lbl_dropDate.textColor = [UIColor blackColor];
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.lbl_estimatedTime.text = [dateFormatter stringFromDate:selectedTime];
    self.lbl_estimatedTime.textColor = [UIColor blackColor];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];

    [textField resignFirstResponder];

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
        [self.mScrollView setContentOffset:CGPointMake(0, 60) animated:true];
    }
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 110) animated:true];
    }
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    if(dropdownMenu.tag == 2){
        return self.airLineList.count;
    }else if (dropdownMenu.tag == 3){
        return self.hotelList.count;
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
    }else if(dropdownMenu.tag == 3){
        AirlineSelectView *shapeSelectView = (AirlineSelectView *)view;
        if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[AirlineSelectView class]]) {
            shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AirlineSelectView class]) owner:nil options:nil] firstObject];
        }
        shapeSelectView.textLabel.text = self.hotelList[row];
        
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
    }else if (dropdownMenu.tag == 3){
        self.hotelName.text = self.hotelList[row];
        [self.dropHotelMenu closeAllComponentsAnimated:NO];
    }else{
        self.txt_airportName.text = self.airPortList[row];
        [self.dropAirportMenu closeAllComponentsAnimated:NO];
    }
    
    [dropdownMenu reloadComponent:component];
    

}

@end
