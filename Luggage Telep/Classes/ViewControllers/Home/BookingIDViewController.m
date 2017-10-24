//
//  BookingIDViewController.m
//  Luggage Telep
//
//  Created by mac on 10/11/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "BookingIDViewController.h"
#import "Constant.h"

@interface BookingIDViewController ()
@property (weak, nonatomic) IBOutlet UIButton       *btn_leaveFeedback;
@property (weak, nonatomic) IBOutlet UIImageView    *img_star1;
@property (weak, nonatomic) IBOutlet UIImageView    *img_star2;
@property (weak, nonatomic) IBOutlet UIImageView    *img_star3;
@property (weak, nonatomic) IBOutlet UIImageView    *img_star4;
@property (weak, nonatomic) IBOutlet UIImageView    *img_star5;

@end

@implementation BookingIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn_leaveFeedback.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Clicked

- (IBAction)clicked_star1:(id)sender {
    [self setRatingValue:1];
}
- (IBAction)clicked_star2:(id)sender {
    [self setRatingValue:2];
}
- (IBAction)clicked_star3:(id)sender {
    [self setRatingValue:3];
}
- (IBAction)clicked_star4:(id)sender {
    [self setRatingValue:4];
}
- (IBAction)clicked_star5:(id)sender {
    [self setRatingValue:5];
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setRatingValue:(NSInteger)index{
    if(index == 1){
        _img_star1.image = IMAGE(@"ic_star_full.png");
        _img_star2.image = IMAGE(@"ic_star_empty.png");
        _img_star3.image = IMAGE(@"ic_star_empty.png");
        _img_star4.image = IMAGE(@"ic_star_empty.png");
        _img_star5.image = IMAGE(@"ic_star_empty.png");
    }else if (index == 2){
        _img_star1.image = IMAGE(@"ic_star_full.png");
        _img_star2.image = IMAGE(@"ic_star_full.png");
        _img_star3.image = IMAGE(@"ic_star_empty.png");
        _img_star4.image = IMAGE(@"ic_star_empty.png");
        _img_star5.image = IMAGE(@"ic_star_empty.png");
    }else if (index == 3){
        _img_star1.image = IMAGE(@"ic_star_full.png");
        _img_star2.image = IMAGE(@"ic_star_full.png");
        _img_star3.image = IMAGE(@"ic_star_full.png");
        _img_star4.image = IMAGE(@"ic_star_empty.png");
        _img_star5.image = IMAGE(@"ic_star_empty.png");
    }else if (index == 4){
        _img_star1.image = IMAGE(@"ic_star_full.png");
        _img_star2.image = IMAGE(@"ic_star_full.png");
        _img_star3.image = IMAGE(@"ic_star_full.png");
        _img_star4.image = IMAGE(@"ic_star_full.png");
        _img_star5.image = IMAGE(@"ic_star_empty.png");
    }else{
        _img_star1.image = IMAGE(@"ic_star_full.png");
        _img_star2.image = IMAGE(@"ic_star_full.png");
        _img_star3.image = IMAGE(@"ic_star_full.png");
        _img_star4.image = IMAGE(@"ic_star_full.png");
        _img_star5.image = IMAGE(@"ic_star_full.png");
    }
}

@end
