//
//  BookingAuth.h
//  Luggage Telep
//
//  Created by mac on 10/15/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBookingAuth [BookingAuth currenctBook]

@interface BookingAuth : NSObject

@property (nonatomic, strong) NSString     *airPortName;
@property (nonatomic, strong) NSString     *airlineName;
@property (nonatomic, strong) NSString     *flightNumber;
@property (nonatomic, strong) NSDate       *estiamtedTime;
@property (nonatomic, strong) NSString     *hotelName;
@property (nonatomic, strong) NSString     *guestName;
@property (nonatomic, strong) NSString     *hotelConfirmNumber;
@property (nonatomic, strong) NSString     *pickupDate;
@property (nonatomic, strong) NSString     *deliveryDate;
@property  (assign) BOOL        overnightStorage;

- (id) initWithAirPortName:(NSString *)airportName  andAirLineName:(NSString *)airlineName andFlightNumber:(NSString *)flightNumber andEstimatedTime:(NSDate *)estimatedTime andHotelName:(NSString *)hotelName andGuestName:(NSString *)guestName andHotelConfirmNumber:(NSString *)hotelConfirm andPickupDate:(NSString *)pickedDate andDeliveryDate:(NSString *)deliveryDate andOvernightStorate:(BOOL)overnightStorate;

+ (instancetype) bookingWithAirPortName:(NSString *)airportName  andAirLineName:(NSString *)airlineName andFlightNumber:(NSString *)flightNumber andEstimatedTime:(NSDate *)estimatedTime andHotelName:(NSString *)hotelName andGuestName:(NSString *)guestName andHotelConfirmNumber:(NSString *)hotelConfirm andPickupDate:(NSString *)pickedDate andDeliveryDate:(NSString *)deliveryDate andOvernightStorate:(BOOL)overnightStorate;

@end
