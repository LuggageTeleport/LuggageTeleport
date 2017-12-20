//
//  BookingSummaryViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "BookingSummaryViewController.h"
#import "AirPortToHotelViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"
#import "HomeViewController.h"
#import "MKDropdownMenu.h"
#import "AirlineSelectView.h"
#import "AddCardViewController.h"


#define kEachBugPrice    30
#define kEachBugTax     1.0875

#define kClientName         @"44RuqL5sT3"
#define kTransactionKey     @"2qJR5f5rN77NeA2C"
#define kClientKey          @"3f8SLz3X26Ccr4fEsqw45c3LhhRBS29TC83ebR4BXYUzK5u4yMr5ht6xTb3L3Fp6"

@interface BookingSummaryViewController ()<UIScrollViewDelegate, UITextFieldDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate>{
    NSString    *visa_cardNumber;
    float       totalPrice;
    NSString    *firstname;
    NSString    *lastname;
    NSString    *username;
    NSString    *email;
    NSString    *phone;
    NSString    *arrivetime;
}

@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownVisaCode;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btn_book;
@property (weak, nonatomic) IBOutlet UITextField *txt_promoCode;
@property (weak, nonatomic) IBOutlet UILabel *lbl_airport;
@property (weak, nonatomic) IBOutlet UILabel *lbl_hotelName;
@property (weak, nonatomic) IBOutlet UITextField *txt_pickupDate;
@property (weak, nonatomic) IBOutlet UITextField *txt_overnight;
@property (weak, nonatomic) IBOutlet UITextField *txt_guestName;
@property (weak, nonatomic) IBOutlet UITextField *txt_hotelConfirm;
@property (weak, nonatomic) IBOutlet UILabel *lbl_bags;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_priceTax;
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalTax;
@property (weak, nonatomic) IBOutlet UILabel *lbl_taxTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbl_visaCode;

@property (strong, nonatomic) NSArray<NSString *> *visaList;

@end

@implementation BookingSummaryViewController

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [[defaults objectForKey:KEY_CARDNUMBER] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(number){
        visa_cardNumber = number;
        NSString *cardName = [NSString stringWithFormat:@"%@", [number substringWithRange:NSMakeRange(number.length-4, 4)]];
        
        NSString *str_header = [number substringWithRange:NSMakeRange(0,2)];


        if ([str_header isEqualToString:@"34"] || [str_header isEqualToString:@"37"]){
            self.visaList = @[[NSString stringWithFormat:@"AMEX XXXX-XXXX-XXXX-%@", cardName], @"Add Payment"];
        }
        else if ([str_header isEqualToString:@"50"] || [str_header isEqualToString:@"51"] || [str_header isEqualToString:@"52"] || [str_header isEqualToString:@"53"] || [str_header isEqualToString:@"54"] || [str_header isEqualToString:@"55"]){
            self.visaList = @[[NSString stringWithFormat:@"MasterCard XXXX-XXXX-XXXX-%@", cardName], @"Add Payment"];
        }
        else{
            self.visaList = @[[NSString stringWithFormat:@"Visa XXXX-XXXX-XXXX-%@", cardName], @"Add Payment"];
        }
        
    }else{
        self.visaList = @[@"Add Payment"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.dropdownVisaCode.dropdownShowsTopRowSeparator = NO;
    self.dropdownVisaCode.dropdownShowsBottomRowSeparator = NO;
    self.dropdownVisaCode.dropdownShowsBorder = YES;
    self.dropdownVisaCode.disclosureIndicatorImage.accessibilityElementsHidden = true;
    self.dropdownVisaCode.backgroundDimmingOpacity = 0.0;
    
    self.btn_book.layer.cornerRadius = self.btn_book.frame.size.height/2;
    
    _lbl_airport.text = self.booking.airPortName;
    _lbl_hotelName.text = self.booking.hotelName;
    _txt_pickupDate.text = self.booking.pickupDate;
    _txt_guestName.text = self.booking.guestName;
    _txt_hotelConfirm.text = self.booking.hotelConfirmNumber;
    
    if(self.booking.overnightStorage){
        _txt_overnight.text = @"Yes";
    }else{
        _txt_overnight.text = @"No";
    }
    
    _lbl_bags.text = [NSString stringWithFormat:@"%ld", self.count_bags];
    
    [self calculatePrice];
}

- (void) initBooking:(BookingAuth *)booking{
    self.booking = booking;
}

- (void) set_count_bags: (NSInteger) count{
    self.count_bags = count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) calculatePrice{
    NSInteger subTotal = 0;
    totalPrice = 0;
    if(self.count_bags > 2){
        subTotal = kEachBugPrice + (self.count_bags-2)*10;
        totalPrice = kEachBugTax * (kEachBugPrice + 10*(self.count_bags-2));
    }
    else{
        subTotal = kEachBugPrice;
        totalPrice = kEachBugTax * kEachBugPrice ;
    }
    float subTaxTotal = totalPrice - subTotal;
    
    self.lbl_subTotal.text = [NSString stringWithFormat:@"$ %ld", subTotal];
    self.lbl_totalTax.text = [NSString stringWithFormat:@"$ %.01f", subTaxTotal];
    self.lbl_taxTotalPrice.text = [NSString stringWithFormat:@"$ %.1f", totalPrice];
    
    if (self.count_bags == 0){
        subTotal = 0.01;
        totalPrice = 0.01;
        self.lbl_subTotal.text = @"$ 0.01";
        self.lbl_totalTax.text =@"$ 0.0";
        self.lbl_taxTotalPrice.text = @"$ 0.01";
    }
    
}

- (IBAction)clicked_Back:(id)sender {
    [self.dropdownVisaCode closeAllComponentsAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_bookNow:(id)sender {
    [kACCOUNT_UTILS showWorking:self.view string:@"Booking..."];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    arrivetime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.booking.estiamtedTime]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:KEY_TOKEN];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{@"":@""};
    [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        firstname = [[responseObject objectForKey:@"profile"] objectForKey:@"firstname"];
        lastname = [[responseObject objectForKey:@"profile"] objectForKey:@"lastname"];
        username = [[responseObject objectForKey:@"profile"] objectForKey:@"username"];
        email = [[responseObject objectForKey:@"profile"] objectForKey:@"email"];
        phone = [[responseObject objectForKey:@"profile"] objectForKey:@"phoneNumber"];
        
        [self sendmail];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];

}

- (void) sendmail{
    if(_txt_promoCode.text.length > 0 ){
        if(_lbl_visaCode.text.length > 15){
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            NSDictionary *params = [NSDictionary alloc];
            if(firstname){
                params = @{@"listAirNameTml" : self.booking.airPortName,
                             @"airline" : self.booking.airlineName,
                             @"flightNumber" : self.booking.flightNumber,
                             @"estTimeArrival" : arrivetime,
                             @"listHtlNameCity" : self.booking.hotelName,
                             @"guestName" : self.booking.guestName,
                             @"htlConfNumber" : self.booking.hotelConfirmNumber,
                             @"pickDate" : self.booking.pickupDate,
                             @"overngtStorage" : self.booking.overnightStorage? @true: @false,
                             @"deliveryDate" : self.booking.deliveryDate,
                             @"firstName" : firstname,
                             @"lastName" : lastname,
                             @"userName" : username,
                             @"email" : email,
                             @"phone" : phone,
                             @"numOfBags": _lbl_bags.text
                         };
            }else{
                params = @{@"listAirNameTml" : self.booking.airPortName,
                             @"airline" : self.booking.airlineName,
                             @"flightNumber" : self.booking.flightNumber,
                             @"estTimeArrival" : arrivetime,
                             @"listHtlNameCity" : self.booking.hotelName,
                             @"guestName" : self.booking.guestName,
                             @"htlConfNumber" : self.booking.hotelConfirmNumber,
                             @"pickDate" : self.booking.pickupDate,
                             @"overngtStorage" : self.booking.overnightStorage? @true: @false,
                             @"deliveryDate" : self.booking.deliveryDate,
                             @"userName" : username,
                             @"email" : email,
                             @"numOfBags": _lbl_bags.text
                         };
            }
            
            NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:BOOKING_URL parameters:params error:nil];

            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                    [kACCOUNT_UTILS showFailure:self.view withString:@"Failed to send mail" andBlock:nil];
                    [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                } else{
                    [self sendPromoCode];
                }
            }];
            [dataTask resume];
        }
        else{
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input Payment Number" dismiss:@"OK" sender:self];
            [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        }
    }
    else{
        if([_lbl_visaCode.text isEqualToString:@"Payment Number"]){
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input Promo code or select the Payment Number" dismiss:@"OK" sender:self];
             [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        }else{
            if([_lbl_visaCode.text isEqualToString:@"Add Payment"]){
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please add the credit card" dismiss:@"OK" sender:self];
            }else{
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                NSDictionary *params = [NSDictionary alloc];
                if(firstname){
                    params = @{@"listAirNameTml" : self.booking.airPortName,
                               @"airline" : self.booking.airlineName,
                               @"flightNumber" : self.booking.flightNumber,
                               @"estTimeArrival" : arrivetime,
                               @"listHtlNameCity" : self.booking.hotelName,
                               @"guestName" : self.booking.guestName,
                               @"htlConfNumber" : self.booking.hotelConfirmNumber,
                               @"pickDate" : self.booking.pickupDate,
                               @"overngtStorage" : self.booking.overnightStorage? @true: @false,
                               @"deliveryDate" : self.booking.deliveryDate,
                               @"firstName" : firstname,
                               @"lastName" : lastname,
                               @"userName" : username,
                               @"email" : email,
                               @"phone" : phone,
                               @"numOfBags": _lbl_bags.text
                               };
                }else{
                    params = @{@"listAirNameTml" : self.booking.airPortName,
                               @"airline" : self.booking.airlineName,
                               @"flightNumber" : self.booking.flightNumber,
                               @"estTimeArrival" : arrivetime,
                               @"listHtlNameCity" : self.booking.hotelName,
                               @"guestName" : self.booking.guestName,
                               @"htlConfNumber" : self.booking.hotelConfirmNumber,
                               @"pickDate" : self.booking.pickupDate,
                               @"overngtStorage" : self.booking.overnightStorage? @true: @false,
                               @"deliveryDate" : self.booking.deliveryDate,
                               @"userName" : username,
                               @"email" : email,
                               @"numOfBags": _lbl_bags.text
                               };
                }

                NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:BOOKING_URL parameters:params error:nil];

                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                        [kACCOUNT_UTILS showFailure:self.view withString:@"Failed to send mail" andBlock:nil];
                        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                    } else{
                        [self sendTransaction];

                    }
                }];
                [dataTask resume];
            }
        }
    }
}

- (void) sendTransaction {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"amount": [NSString stringWithFormat:@"%0.2f", totalPrice],
                             @"cardNumber": visa_cardNumber,
                             @"expDate":  [defaults objectForKey:KEY_EXPDATE],
                             @"cardCode": [defaults objectForKey:KEY_CVV]
                             };

    [manager POST:TRANSFER_MONEY_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        NSNumber *number = [responseObject objectForKey:@"success"];
        if( [number intValue] == 1){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *homeVC = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
            homeVC.isBookingNow = YES;
            [homeVC initBooking:self.booking];
            [homeVC initTotalPrice:totalPrice];
            [self.navigationController pushViewController:homeVC animated:NO];
        }
        else{
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Your booking has been received, but payment was not processed. Please pay by cash when you meet our staff, or use the Support Form to cancel your order." dismiss:@"OK" sender:self];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [kACCOUNT_UTILS showFailure:self.view withString:@"Failed Creadit Card" andBlock:nil];
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
    }];
}

- (void)sendPromoCode {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{ @"promoCode": _txt_promoCode.text,
                             };
    
    [manager POST:PROMOCODE_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        NSNumber *number = [responseObject objectForKey:@"success"];
        if( [number intValue] == 1){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *homeVC = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
            homeVC.isBookingNow = YES;
            [homeVC initBooking:self.booking];
            [homeVC initTotalPrice:totalPrice];
            [self.navigationController pushViewController:homeVC animated:NO];
        }else{
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Your booking has been received, but payment was not processed. Please pay by cash when you meet our staff, or use the Support Form to cancel your order." dismiss:@"OK" sender:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [kACCOUNT_UTILS showFailure:self.view withString:@"Failed Creadit Card" andBlock:nil];
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
    }];
}

#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return self.visaList.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return 0;
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return self.dropdownVisaCode.layer.frame.size.width;
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [self.txt_promoCode resignFirstResponder];
    AirlineSelectView *shapeSelectView = (AirlineSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[AirlineSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AirlineSelectView class]) owner:nil options:nil] firstObject];
    }
    shapeSelectView.textLabel.text = self.visaList[row];
    
    return shapeSelectView;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([self.visaList[row] isEqualToString:@"Add Payment"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddCardViewController *addCardVC = [story instantiateViewControllerWithIdentifier:@"AddCardViewController"];
        self.lbl_visaCode.text = self.visaList[row];
        [self.navigationController pushViewController:addCardVC animated:YES];
    }else{
        self.lbl_visaCode.text = self.visaList[row];
    }
    [self.dropdownVisaCode closeAllComponentsAnimated:NO];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];

    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.dropdownVisaCode closeAllComponentsAnimated:NO];
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 35) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 70) animated:true];
    }
}

@end
