//
//  AddCardViewController.m
//  Luggage Telep
//
//  Created by mac on 10/22/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "AddCardViewController.h"
#import "JVFloatLabeledTextField.h"
#import "EMCCountryPickerController.h"
#import "UIImage+UIImage_EMCImageResize.h"
#import "EMCCountryManager.h"


#define DATE_MAXLENGTH  4
#define CVV_MAXLENGTH   3
#define ZIPCODE_MAXLENGTH   10
@interface AddCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_cardNumber;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_expDate;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_cvv;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlag;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _txt_cardNumber.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    _txt_expDate.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    _txt_cvv.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    _txt_zipCode.floatingLabelFont = [UIFont systemFontOfSize:12.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
//    if (self)
//    {
//        [self loadDefaults];
//    }
    
    return self;
}

- (void)countryController:(id)sender didSelectCountry:(EMCCountry *)chosenCity
{
    self.countryLabel.text = chosenCity.countryName;
    
    NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", chosenCity.countryCode];
    UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:EMCCountryPickerController.class] compatibleWithTraitCollection:nil];
    self.countryFlag.image = [image fitInSize:CGSizeMake(33, 33)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openCountryPicker"])
    {
        EMCCountryPickerController *countryPicker = segue.destinationViewController;
        
        // default values
        countryPicker.showFlags = true;
        countryPicker.countryDelegate = self;
        countryPicker.drawFlagBorder = true;
        countryPicker.flagBorderColor = [UIColor grayColor];
        countryPicker.flagBorderWidth = 0.5f;

        countryPicker.flagSize = 50;

        
//        if (![self.allCountriesSwitch isOn])
//        {
//            countryPicker.availableCountryCodes = [NSSet setWithObjects:@"IT", @"ES", @"US", @"FR", nil];
//        }
    }
}

#pragma mark - TextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangelength = range.length;
    
    NSUInteger newLength = oldLength - rangelength + replacementLength;
    
    BOOL returnKey = [string rangeOfString:@"\n"].location != NSNotFound;
    
    if(textField.tag == 1){
        return newLength <= DATE_MAXLENGTH || returnKey;
    }else if(textField.tag == 2){
        return newLength <= CVV_MAXLENGTH || returnKey;
    }else{
        return newLength <= ZIPCODE_MAXLENGTH || returnKey;
    }
    
}


@end
