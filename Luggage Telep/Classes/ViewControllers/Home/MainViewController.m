//
//  MainViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // ----
    
    if(self.storyboard){
        
    }else{
        self.leftViewController = [LeftViewController new];
        self.leftViewWidth = 200.0;
        self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.95];
        self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    }
    
    // ----

//    UIColor *greenCoverColor = [UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:0.3];
//    UIBlurEffectStyle regularStyle;
//    if(UIDevice.currentDevice.systemVersion.floatValue >= 10.0){
//        regularStyle = UIBlurEffectStyleRegular;
//    }
//    else{
//        regularStyle = UIBlurEffectStyleLight;
//    }
//    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
//    self.rootViewCoverColorForLeftView = greenCoverColor;
//
//    // ----
}

- (void) leftViewWillLayoutSubviewsWithSize:(CGSize)size{
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if(!self.isLeftViewStatusBarHidden){
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height - 20.0);
    }
}

- (BOOL) isLeftViewStatusBarHidden {
    return super.isLeftViewStatusBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
