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
#define REGISTER_URL        @"https://infinite-garden-74421.herokuapp.com/user/signup"
#define LOGIN_URL            @"https://infinite-garden-74421.herokuapp.com/user/signIN"

@interface Constant : NSObject

@end
