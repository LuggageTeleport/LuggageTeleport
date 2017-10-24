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

#define kEachBugPrice    30
#define kEachBugTax     1.09

@interface BookingSummaryViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btn_book;
@property (weak, nonatomic) IBOutlet UITextField *txt_promoCode;
@property (weak, nonatomic) IBOutlet UITextField *txt_visaCode;
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

@end

@implementation BookingSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    float totalPrice = 0;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_bookNow:(id)sender {
    
    [kACCOUNT_UTILS showWorking:self.view string:@"Booking..."];
    NSDictionary *params = @{@"listAirNameTml" : self.booking.airPortName,
                             @"airline" : self.booking.airlineName,
                             @"flightNumber" : self.booking.flightNumber,
                             @"estTimeArrival" : self.booking.estiamtedTime,
                              @"listHtlNameCity" : self.booking.hotelName,
                             @"guestName" : self.booking.guestName,
                             @"htlConfNumber" : self.booking.hotelConfirmNumber,
                             @"pickDate" : self.booking.pickupDate,
                             @"overngtStorage" : self.booking.overnightStorage?@true:@false,
                             @"deliveryDate" : self.booking.deliveryDate,
                             };

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:BOOKING_URL parameters:params error:nil];

        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
                [kACCOUNT_UTILS showFailure:self.view withString:@"Failed to send mail" andBlock:nil];
            } else{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewController *homeVC = [story instantiateViewControllerWithIdentifier:@"HomeViewController"];
                homeVC.isBookingNow = YES;
                [self.navigationController pushViewController:homeVC animated:NO];
            }
        }];
        [dataTask resume];

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
