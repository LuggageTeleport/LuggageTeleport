//
//  NumberOfBagsViewController.h
//  Luggage Telep
//
//  Created by MacOS on 10/7/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingAuth.h"

@interface NumberOfBagsViewController : UIViewController

@property BookingAuth *booking;

- (void) initBooking:(BookingAuth *)booking;

@end
