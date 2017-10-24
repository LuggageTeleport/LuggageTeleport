//
//  AccountUtilities.m
//  Luggage Telep
//
//  Created by mac on 10/9/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AccountUtilities.h"
#import "MBProgressHUD.h"


@interface AccountUtilities() <UIAlertViewDelegate> {
    MBProgressHUD *workingHud;
}
@end

@implementation AccountUtilities

+ (AccountUtilities *) sharedManager{
    static dispatch_once_t pred;
    static AccountUtilities *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[AccountUtilities alloc] init];
    });
    return shared;
}

- (void)showStandardAlertWithTitle:(NSString *)string body:(NSString *)body dismiss:(NSString *)cancel sender:(id)sender{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:string
                                                   message:body
                                                  delegate:sender
                                         cancelButtonTitle:cancel
                                         otherButtonTitles: nil];
    [alert show];
}

- (void) showWorking:(UIView *)view string:(NSString *)string{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = string;
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    workingHud = hud;
}
- (void)hideAllProgressIndicatorsFromView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
    });
}

- (void)showFailure:(UIView *)view withString:(NSString *)string andBlock:(void(^)())complete
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    MBProgressHUD *HUD;
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    image.contentMode = UIViewContentModeCenter;
    image.image = [UIImage imageNamed:@"theX@2x.png"];
    HUD.customView = image;
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.color = [UIColor colorWithRed:243.0/255.0 green:49.0/255.0 blue:62.0/255.0 alpha:1];
    
    //HUD.delegate = view;
    HUD.labelText = string;
    HUD.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    
    [HUD show:YES];
    
    double delayInSeconds = 1.8;
    [HUD hide:YES afterDelay:delayInSeconds];
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if (complete) {
            complete();
        }
        
    });
}

- (BOOL)verifyEmail:(NSString *)email
{
    // Email
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSRange range = [email rangeOfCharacterFromSet:cset];
    if (range.location == NSNotFound) {
        return NO;
    }
    
    NSCharacterSet *cset1 = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    NSRange range1 = [email rangeOfCharacterFromSet:cset1];
    if (range1.location == NSNotFound) {
        return NO;
    }
    
    
    return YES;
}

@end
