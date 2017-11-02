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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:KEY_CARDNUMBER];
    if(number){
        visa_cardNumber = number;
        NSString *cardName = [NSString stringWithFormat:@"%@", [number substringWithRange:NSMakeRange(number.length-4, 4)]];
        self.visaList = @[[NSString stringWithFormat:@"Visa XXXX-XXXX-XXXX-%@", cardName], @"Add Payment"];
    }else{
        self.visaList = @[@"Add Payment"];
    }
    
//    [self getCreditCardNumber];
    
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
    }else{
        subTotal = kEachBugPrice;
        totalPrice = kEachBugTax * kEachBugPrice ;
    }
    float subTaxTotal = totalPrice - subTotal;
    
    self.lbl_subTotal.text = [NSString stringWithFormat:@"$ %ld", subTotal];
    self.lbl_totalTax.text = [NSString stringWithFormat:@"$ %.01f", subTaxTotal];
    self.lbl_taxTotalPrice.text = [NSString stringWithFormat:@"$ %.1f", totalPrice];
}

- (IBAction)clicked_Back:(id)sender {
    [self.dropdownVisaCode closeAllComponentsAnimated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_bookNow:(id)sender {

    if([_lbl_visaCode.text isEqualToString:@"Payment Number"]){
       [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please select the Payment Number" dismiss:@"OK" sender:self];
    }else{
        [kACCOUNT_UTILS showWorking:self.view string:@"Booking..."];
        
        
        if([_lbl_visaCode.text isEqualToString:@"Add Payment"]){
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please add the credit card" dismiss:@"OK" sender:self];
        }else{
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            NSDictionary *params = @{@"":@""};
            NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:BOOKING_URL parameters:params error:nil];

            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                    [kACCOUNT_UTILS showFailure:self.view withString:@"Failed to send mail" andBlock:nil];
                } else{
                    [self sendTransaction];
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    HomeViewController *homeVC = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    homeVC.isBookingNow = YES;
                    [homeVC initBooking:self.booking];
                    [homeVC initTotalPrice:totalPrice];
                    [self.navigationController pushViewController:homeVC animated:NO];
                }
            }];
            [dataTask resume];
        }
    }
}

- (void) sendTransaction {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"amount": [NSString stringWithFormat:@"%.01f", totalPrice],
                             @"cardNumber": visa_cardNumber,
                             @"expDate":  [defaults objectForKey:KEY_EXPDATE],
                             @"cardCode": [defaults objectForKey:KEY_CVV]
                             };

    [manager POST:TRANSFER_MONEY_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *token = [defaults stringForKey:KEY_TOKEN];
        
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
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 30) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 70) animated:true];
    }
}

@end
