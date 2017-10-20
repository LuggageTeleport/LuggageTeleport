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

@interface AirPortToHotelViewController ()<UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate, CNPPopupControllerDelegate>{
    Boolean isYes;
    Boolean isNo;
}
@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropAirportMenu;
@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropHotelMenu;
@property (weak, nonatomic) IBOutlet UILabel *airlineName;
@property (weak, nonatomic) IBOutlet UILabel *txt_airportName;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;

@property (weak, nonatomic) IBOutlet UIView *nextButView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_flightNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_estimatedTime;
@property (weak, nonatomic) IBOutlet UITextField *txt_guestName;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelConfirmNumber;
@property (weak, nonatomic) IBOutlet UITextField *txt_pickDate;
@property (weak, nonatomic) IBOutlet UITextField *txt_deliveryDate;
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
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [self.navigationController pushViewController:mainVC animated:NO];
}

- (IBAction)clicked_Next:(id)sender {
    BookingAuth *booking = [BookingAuth bookingWithAirPortName:_txt_airportName.text
                                                andAirLineName:_airlineName.text
                                               andFlightNumber:_txt_flightNumber.text
                                              andEstimatedTime:_txt_estimatedTime.text
                                                  andHotelName:_hotelName.text
                                                  andGuestName:_txt_guestName.text
                                         andHotelConfirmNumber:_txt_hotelConfirmNumber.text
                                                 andPickupDate:_txt_pickDate.text
                                               andDeliveryDate:_txt_deliveryDate.text
                                           andOvernightStorate:isYes];
    
//    NSLog(booking.flightNumber);
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NumberOfBagsViewController *bagsVC = [story instantiateViewControllerWithIdentifier:@"NumberOfBagsViewController"];
    [bagsVC initBooking:booking];
    [self.navigationController pushViewController:bagsVC animated:YES];
}


#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 9) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }

    if(textField == self.txt_flightNumber) {
        [self.txt_estimatedTime becomeFirstResponder];
    }else if(textField == self.txt_estimatedTime) {
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
        [self.mScrollView setContentOffset:CGPointMake(0, 120) animated:true];
    }
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 200) animated:true];
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
