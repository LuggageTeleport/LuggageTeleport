//
//  Constant.h
//  Luggage Telep
//
//  Created by mac on 10/9/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define USER_SHARE [NSUserDefaults standardUserDefaults]

#define USER_SHARE [NSUserDefaults standardUserDefaults]

#define IOS_VERSION             [[[UIDevice currentDevice] systemVersion] floatValue]
#define APP_DELEGATE            (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
#define LANGUAGE(key)           [Language GetStringByKey:key]
#define IMAGE(key)              [UIImage imageNamed:key]
#define FONT(key)               [UIFont systemFontOfSize:key]
#define BOLDFONT(key)           [UIFont boldSystemFontOfSize:key]
#define CURRENT_DATE            [NSDate date]
#define USERNAME                [LoginManager sharedInstance].username
#define PASSWORD                [LoginManager sharedInstance].password

//URL
#define REGISTER_URL            @"https://infinite-garden-74421.herokuapp.com/user/signup"
#define LOGIN_URL               @"https://infinite-garden-74421.herokuapp.com/user/signIN"
#define BOOKING_URL             @"https://infinite-garden-74421.herokuapp.com/api/sendmail"
#define DOWNLOAD_PROFILE_URL    @"https://infinite-garden-74421.herokuapp.com/user/getProfile"
#define UPDATE_PROFILE_URL      @"https://infinite-garden-74421.herokuapp.com/user/update"
#define ADD_CARD_URL            @"https://infinite-garden-74421.herokuapp.com/user/addCard"

#define KEY_TOKEN               @"key_token"
#define KEY_PASSWORD            @"key_password"
#define KEY_USERNAME            @"key_username"
#define KEY_EMAIL               @"key_email"
#define KEY_AVATAR              @"key_avatar"
#define KEY_CARDS               @"key_cards"
#define KEY_FIRSTNAME           @"key_firstname"
#define KEY_LASTNAME            @"key_lastname"
#define KEY_PHONENUMBER         @"key_phonenumber"
#define KEY_CARDNUMBER          @"key_cardnumber"

@interface Constant : NSObject

@end
