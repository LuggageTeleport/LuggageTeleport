//
//  HotelToAirportViewController.h
//  Luggage Telep
//
//  Created by MacOS on 12/19/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelToAirportViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic, strong) NSDate    *selectedDate;
@property (nonatomic, strong) NSDate    *selectedTime;

@end
