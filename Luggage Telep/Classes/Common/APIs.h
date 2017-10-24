//
//  APIs.h
//  Luggage Telep
//
//  Created by mac on 10/9/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIs : NSObject

+ (void) RegisterWithUsername:(NSString *)useremail FirstName:(NSString *)userfirstname LastName:(NSString *)userlastname MobileNumber:(NSString *)usernumber Address:(NSString *)useraddress Password:(NSString *)userpassword;

@end
