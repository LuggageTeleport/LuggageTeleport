//
//  BookingAuth.m
//  Luggage Telep
//
//  Created by mac on 10/15/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "BookingAuth.h"

@implementation BookingAuth

@synthesize airPortName;
@synthesize airlineName;
@synthesize flightNumber;
@synthesize estiamtedTime;
@synthesize hotelName;
@synthesize guestName;
@synthesize hotelConfirmNumber;
@synthesize pickupDate;
@synthesize deliveryDate;
@synthesize overnightStorage;

- (id) initWithAirPortName:(NSString *)airportName  andAirLineName:(NSString *)airlineName andFlightNumber:(NSString *)flightNumber andEstimatedTime:(NSString *)estimatedTime andHotelName:(NSString *)hotelName andGuestName:(NSString *)guestName andHotelConfirmNumber:(NSString *)hotelConfirm andPickupDate:(NSString *)pickedDate andDeliveryDate:(NSString *)deliveryDate andOvernightStorate:(BOOL)overnightStorate{
    self = [super init];
    if(self){
        self.airPortName = airportName;
        self.airlineName = airlineName;
        self.flightNumber = flightNumber;
        self.estiamtedTime = estimatedTime;
        self.hotelName = hotelName;
        self.guestName = guestName;
        self.hotelConfirmNumber = hotelConfirm;
        self.pickupDate = pickedDate;
        self.deliveryDate = deliveryDate;
        self.overnightStorage = overnightStorate;
    }
    return self;
}

+ (instancetype) bookingWithAirPortName:(NSString *)airportName  andAirLineName:(NSString *)airlineName andFlightNumber:(NSString *)flightNumber andEstimatedTime:(NSString *)estimatedTime andHotelName:(NSString *)hotelName andGuestName:(NSString *)guestName andHotelConfirmNumber:(NSString *)hotelConfirm andPickupDate:(NSString *)pickedDate andDeliveryDate:(NSString *)deliveryDate andOvernightStorate:(BOOL)overnightStorate{
    BookingAuth *booking = [[BookingAuth alloc] initWithAirPortName:airportName andAirLineName:airlineName andFlightNumber:flightNumber andEstimatedTime:estimatedTime andHotelName:hotelName andGuestName:guestName andHotelConfirmNumber:hotelConfirm andPickupDate:pickedDate andDeliveryDate:deliveryDate andOvernightStorate:overnightStorate];
    return booking;
}

@end
