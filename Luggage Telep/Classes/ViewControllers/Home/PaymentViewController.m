//
//  PaymentViewController.m
//  Luggage Telep
//
//  Created by mac on 10/8/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "PaymentViewController.h"
#import "AddPaymentViewController.h"
#import "Constant.h"
#import "PaymentTableViewCell.h"
#import "PaymentHeaderTableViewCell.h"
#import "AddPaymentViewController.h"
#import "PaymentVisaTableViewCell.h"
#import "EditCardViewController.h"
#import "AccountUtilities.h"
#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface PaymentViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    Boolean             isGiftView;
    NSMutableArray      *paymentList,  *promoList;
    NSString            *cardName;
    NSString            *promoID;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIView *lightBG;
@property (weak, nonatomic) IBOutlet UITextField *txt_promo;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *number = [defaults objectForKey:KEY_CARDNUMBER];
    if(number){
        cardName = [NSString stringWithFormat:@"****%@", [number substringWithRange:NSMakeRange(number.length-4, 4)]];
        paymentList = [[NSMutableArray alloc] init];
        [paymentList addObject:number];
    }
    
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    self.btn_cancel.layer.cornerRadius = self.btn_cancel.layer.frame.size.height/2;
    self.btn_add.layer.cornerRadius = self.btn_add.layer.frame.size.height/2;
    
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self downloadPromocode];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadPromocode {
    [kACCOUNT_UTILS showWorking:self.view string:@""];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:KEY_TOKEN];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"promoID": _txt_promo.text};
    
    [manager POST:PROMO_GET_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        [self.mTableView reloadData];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults stringForKey:KEY_TOKEN];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [kACCOUNT_UTILS showFailure:self.view withString:@"Failed Creadit Card" andBlock:nil];
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
    }];
}
#pragma mark - UIButton Delegate

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_canel:(id)sender {
    [self.txt_promo resignFirstResponder];
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
}

- (IBAction)clicked_add:(id)sender {
    promoList = [[NSMutableArray alloc] initWithObjects:_txt_promo.text, nil];
    [self.mTableView reloadData];
    [self addPromo];
    
    [self.txt_promo resignFirstResponder];
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
}

#pragma mark - TextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 240) animated:true];
    }
}

#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.row == 2){
        return  60;
    }
    else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [paymentList count] + [promoList count] + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || indexPath.row == (2 + paymentList.count)){
        PaymentHeaderTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentHeaderTableViewCell"];
        if(!paymentCell)
        {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentHeaderTableViewCell" owner:self options:nil];
            paymentCell = [nib objectAtIndex:0];
        }
        if(indexPath.row == 0){
            paymentCell.payment_list_header.text = @"Payment Methods";
        }else{
            paymentCell.payment_list_header.text = @"Promotions";
        }
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
    }
    else if(indexPath.row == (1 + paymentList.count)){
        PaymentTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCell"];
        if(!paymentCell)
        {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTableViewCell" owner:self options:nil];
            paymentCell = [nib objectAtIndex:0];
        }
        paymentCell.payment_list_header.text = @"Add Payment Method";
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
    }
    else if(indexPath.row == (3 + paymentList.count + promoList.count)){
        PaymentTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCell"];
        if(!paymentCell)
        {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTableViewCell" owner:self options:nil];
            paymentCell = [nib objectAtIndex:0];
        }
        paymentCell.payment_list_header.text = @"Add Promo/Gift Code";
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
    }
    else if(indexPath.row == (2 + paymentList.count + promoList.count)){
        PaymentTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCell"];
        if(!paymentCell)
        {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTableViewCell" owner:self options:nil];
            paymentCell = [nib objectAtIndex:0];
        }
        paymentCell.payment_list_header.text = [promoList objectAtIndex:0];
        paymentCell.payment_list_header.textColor = [UIColor blackColor];
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
    }
    else{
        PaymentVisaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentVisaTableViewCell"];
        if(!cell)
        {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentVisaTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString *str_card = [paymentList objectAtIndex:0];
        cell.lbl_visaNumber.text = [NSString stringWithFormat:@"****%@", [str_card substringWithRange:NSMakeRange(str_card.length-4, 4)]];
        NSString *str_header = [str_card substringWithRange:NSMakeRange(0,2)];
        NSString *str_header1 = [str_card substringWithRange:NSMakeRange(0,1)];
        
        if([str_header1 isEqualToString:@"4"]){
            cell.img_card.image = [UIImage imageNamed:@"ic_visa_card.png"];
        }
        if ([str_header isEqualToString:@"34"] || [str_header isEqualToString:@"37"]){
            cell.img_card.image = [UIImage imageNamed:@"amlex.png"];
        }
        else if ([str_header isEqualToString:@"50"] || [str_header isEqualToString:@"51"] || [str_header isEqualToString:@"52"] || [str_header isEqualToString:@"53"] || [str_header isEqualToString:@"54"] || [str_header isEqualToString:@"55"]){
            cell.img_card.image = [UIImage imageNamed:@"mastercard.png"];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == (1 + paymentList.count)) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddPaymentViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"AddPaymentViewController"];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
    else if(indexPath.row > 0 && indexPath.row < (1 + paymentList.count)){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditCardViewController *editCardVC = [story instantiateViewControllerWithIdentifier:@"EditCardViewController"];
        [self.navigationController pushViewController:editCardVC animated:YES];
    }
    else if(indexPath.row == (3 + paymentList.count + promoList.count)){
        
        isGiftView = true;
        _giftView.hidden = NO;
        _lightBG.hidden = NO;
        _txt_promo.text = @"";
        [_txt_promo resignFirstResponder];
    }
}

- (void) addPromo {
    [kACCOUNT_UTILS showWorking:self.view string:@"Creating Promo Code"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:KEY_TOKEN];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *params = @{@"promoCode": _txt_promo.text};
    
    [manager POST:PROMO_ADD_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        if([[responseObject objectForKey:@"success"] intValue] == 1){
            promoID = [[responseObject objectForKey:@"promoCode"] objectForKey:@"_id"];
            [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
            [self.mTableView reloadData];
        }else{
            [kACCOUNT_UTILS showFailure:self.view withString:@"Failed Promo Code" andBlock:nil];
            [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

@end
