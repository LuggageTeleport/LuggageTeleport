//
//  AccountUtilities.h
//  Luggage Telep
//
//  Created by mac on 10/9/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"

#define kACCOUNT_UTILS        [AccountUtilities sharedManager]

@interface AccountUtilities : NSObject

+ (AccountUtilities *) sharedManager;
- (void)showStandardAlertWithTitle:(NSString *)string body:(NSString *)body dismiss:(NSString *)cancel sender:(id)sender;
- (void) showWorking:(UIView *)view string:(NSString *)string;
- (void)hideAllProgressIndicatorsFromView:(UIView *)view;
- (void)showFailure:(UIView *)view withString:(NSString *)string andBlock:(void(^)())complete;
- (BOOL)verifyEmail:(NSString *)email;


@end
