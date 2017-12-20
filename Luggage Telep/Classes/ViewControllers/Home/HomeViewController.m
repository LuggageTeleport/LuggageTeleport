//
//  HomeViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "HomeViewController.h"
#import "AirPortToHotelViewController.h"
#import "AirportToAirportViewController.h"
#import "HotelToAirportViewController.h"
#import "HotelToHotelViewController.h"
#import "CNPPopupController.h"
#import "MKDropdownMenu.h"
#import "BookingDetailViewController.h"
#import "Constant.h"
#import "AccountUtilities.h"

@interface HomeViewController ()<MKDropdownMenuDelegate, CNPPopupControllerDelegate>{
    NSTimer     *timer;
    NSInteger   dialog_count;
}

@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIView *black_bg;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIImageView *ic_usericon;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.black_bg.hidden = YES;
    self.popUpView.hidden = YES;
    if(self.isBookingNow){
        
        if(dialog_count == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Luggage Teleport"
                                                            message:@"Your order has been processed and we look forward to picking your bags up."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert setTag:0];
            [alert show];
        }else{
            [self showPopUpView];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(methodTime:)
                                       userInfo:nil repeats:YES];
        dialog_count = 1;
    }else{
        self.popUpView.hidden = YES;
        self.black_bg.hidden = YES;
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
}

- (void)methodTime:(NSTimer *)timer{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"TimeEnterBackground"];
    [defaults synchronize];
    
    NSDate *enterBackground = [defaults objectForKey:@"TimeEnterBackground"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"hh:mm:ss a"];
    NSString *a = [NSString stringWithFormat:@"%@ %@", self.booking.pickupDate, [dateFormatter stringFromDate:self.booking.estiamtedTime]] ;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *myDate = [df dateFromString: a];
    NSInteger dayBackground = [myDate timeIntervalSince1970] - [enterBackground timeIntervalSince1970];

    if(dayBackground <= -900){
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Luggage Teleport"
                                                        message:@"Thank you for your order."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert setTag:1];
        [alert show];
        self.isBookingNow = false;
        self.popUpView.hidden = YES;
        self.black_bg.hidden = YES;
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }else{
        NSLog([NSString stringWithFormat:@"%i", dayBackground]);
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    dialog_count = 0;
    _ic_usericon.layer.cornerRadius = _ic_usericon.layer.frame.size.height/2;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) initBooking:(BookingAuth *)booking{
    self.booking = booking;
}

- (void) initTotalPrice:(float) cost{
    self.priceTotal = cost;
}

- (void) showPopUpView{
    self.black_bg.hidden = NO;
    self.popUpView.hidden = NO;
    
    [self.mScrollView setContentOffset:CGPointMake(0, 75) animated:true];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(alertView.tag == 0){
            [self showPopUpView];
        }
        
    }else{
        NSLog(@"cancel");
    }
}

- (IBAction)clicked_viewTracker:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookingDetailViewController *bookVC = [story instantiateViewControllerWithIdentifier:@"BookingDetailViewController"];
    [bookVC initBooking:self.booking];
    [bookVC initTotalPrice:self.priceTotal];
    [self.navigationController pushViewController:bookVC animated:YES];
    [self.popupController dismissPopupControllerAnimated:YES];
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

- (IBAction)clicked_airport_airport:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AirportToAirportViewController *airportVC = [story instantiateViewControllerWithIdentifier:@"AirportToAirportViewController"];
    [self.navigationController pushViewController:airportVC animated:YES];
}
- (IBAction)clicked_hotel_airport:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HotelToAirportViewController *airportVC = [story instantiateViewControllerWithIdentifier:@"HotelToAirportViewController"];
    [self.navigationController pushViewController:airportVC animated:YES];
}
- (IBAction)clicked_hotel_hotel:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HotelToHotelViewController *airportVC = [story instantiateViewControllerWithIdentifier:@"HotelToHotelViewController"];
    [self.navigationController pushViewController:airportVC animated:YES];
}

@end
