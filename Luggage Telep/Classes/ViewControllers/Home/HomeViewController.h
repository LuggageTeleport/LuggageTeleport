//
//  HomeViewController.h
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingAuth.h"

@interface HomeViewController : UIViewController

@property (nonatomic, assign) BOOL isBookingNow;

@property BookingAuth   *booking;
@property float         priceTotal;

- (void) initBooking:(BookingAuth *)booking;
- (void) initTotalPrice:(float) cost;

@end
