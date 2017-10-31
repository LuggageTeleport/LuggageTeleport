//
//  BookingDetailViewController.h
//  Luggage Telep
//
//  Created by mac on 10/10/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingAuth.h"

@interface BookingDetailViewController : UIViewController

@property BookingAuth *booking;
@property float       priceTotal;

- (void) initBooking:(BookingAuth *)booking;
- (void) initTotalPrice:(float) cost;

@end
