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

@interface PaymentViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    Boolean             isGiftView;
    NSMutableArray      *paymentList,  *promoList;
    NSString            *cardName;
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
        [paymentList addObject:cardName];
    }
    
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    self.btn_cancel.layer.cornerRadius = self.btn_cancel.layer.frame.size.height/2;
    self.btn_add.layer.cornerRadius = self.btn_add.layer.frame.size.height/2;
    
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    promoList = [[NSMutableArray alloc] initWithObjects:@"Add Payment Method", @"Add Promo/Git Code",  nil];
//    promoList = [@[@"Promotions"] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Delegate

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_add_promo:(id)sender {
    isGiftView = true;
    _giftView.hidden = NO;
    _lightBG.hidden = NO;
}
- (IBAction)clicked_canel:(id)sender {
    [self.txt_promo resignFirstResponder];
    [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    isGiftView = false;
    _giftView.hidden = YES;
    _lightBG.hidden = YES;
}

- (IBAction)clicked_add:(id)sender {
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
    else if(indexPath.row == (3 + paymentList.count)){
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
    else{
        PaymentVisaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentVisaTableViewCell"];
        if(!cell)
        {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentVisaTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lbl_visaNumber.text = [paymentList objectAtIndex:0];
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
    else if(indexPath.row == (3 + paymentList.count)){
        isGiftView = true;
        _giftView.hidden = NO;
        _lightBG.hidden = NO;
    }
    
}


@end
