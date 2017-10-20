//
//  BookingSummaryViewController.h
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingAuth.h"
@interface BookingSummaryViewController : UIViewController

@property BookingAuth *booking;
@property (assign) NSInteger count_bags;

- (void) initBooking:(BookingAuth *)booking;
- (void) set_count_bags: (NSInteger) count;
@end
