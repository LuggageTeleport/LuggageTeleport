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
#import "AccountUtilities.h"
#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>

#define DATE_MAXLENGTH              5
#define CVV_MAXLENGTH               3
#define AMEXCVV_MAXLEGNTH           4
#define ZIPCODE_MAXLENGTH           10
#define CARDNUMBER_MAXLENGTH        22
#define AMEXCARDNUMBER_MAXLENGTH    17
#define MASTERCARDNUMBER_MAXLENGTH  19

@interface AddCardViewController ()<UITextFieldDelegate>{
    BOOL isCardNumber, isExpDate, isCVV, isCountry, isZipCode;
    NSString        *previousTextFieldContent;
    UITextRange     *previousSelection;
    BOOL isAmex;
    BOOL isMaster;
}
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_cardNumber;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_expDate;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_cvv;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryFlag;
@property (weak, nonatomic) IBOutlet UIImageView *img_card;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _txt_cardNumber.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    _txt_expDate.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    _txt_cvv.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    _txt_zipCode.floatingLabelFont = [UIFont systemFontOfSize:12.f];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(yourTextViewDoneButtonPressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.txt_zipCode.inputAccessoryView = keyboardToolbar;
    
    isAmex = false;
    isMaster = false;
    [_txt_cardNumber addTarget:self
                      action:@selector(reformatAsCardNumber:)
            forControlEvents:UIControlEventEditingChanged];
}

-(void)yourTextViewDoneButtonPressed
{
    [self.txt_zipCode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
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

    }
}

#pragma mark - TextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)reformatAsCardNumber:(UITextField *)textField
{
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 19) {
        [textField setText:previousTextFieldContent];
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
                           toPosition:targetPosition]
     ];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangelength = range.length;
    
    NSUInteger newLength = oldLength - rangelength + replacementLength;
    
    BOOL returnKey = [string rangeOfString:@"\n"].location != NSNotFound;
    
    if(textField.tag == 0){
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        if(previousTextFieldContent.length < 2) {
            isAmex = false;
            isMaster = false;
            _img_card.image = [UIImage imageNamed:@"ic_credit_card.png"];
        }
        
        if([previousTextFieldContent isEqualToString:@"4"]){
            isAmex = false;
            isMaster = false;
            _img_card.image = [UIImage imageNamed:@"ic_visa_card.png"];
        }
        else if ([previousTextFieldContent isEqualToString:@"34"] || [previousTextFieldContent isEqualToString:@"37"]){
            isAmex = true;
            isMaster = false;
            _img_card.image = [UIImage imageNamed:@"amlex.png"];
        }
        else if ([previousTextFieldContent isEqualToString:@"50"] || [previousTextFieldContent isEqualToString:@"51"] || [previousTextFieldContent isEqualToString:@"52"] || [previousTextFieldContent isEqualToString:@"53"] || [previousTextFieldContent isEqualToString:@"54"] || [previousTextFieldContent isEqualToString:@"55"]){
            isAmex = false;
            isMaster = true;
            _img_card.image = [UIImage imageNamed:@"mastercard.png"];
        }
        if(isAmex){
            return newLength <= AMEXCARDNUMBER_MAXLENGTH || returnKey;
        }else{
            if(isMaster){
                return newLength <= MASTERCARDNUMBER_MAXLENGTH || returnKey;
            }
            else{
                return newLength <= CARDNUMBER_MAXLENGTH || returnKey;
            }
        }
    }
    else if(textField.tag == 1){
        if(newLength == 3){
            if ([string isEqualToString:@""]) {
                NSLog(@"Backspace");
            }else{
                NSMutableString *mu = [NSMutableString stringWithString:textField.text];
                [mu insertString:@"/" atIndex:2];
                textField.text = mu;
            }
        }
        return newLength <= DATE_MAXLENGTH || returnKey;
    }else if(textField.tag == 2){
        if(isAmex){
            return newLength <= AMEXCVV_MAXLEGNTH || returnKey;
        }else{
            return newLength <= CVV_MAXLENGTH || returnKey;
        }
        
    }else{
        return newLength <= ZIPCODE_MAXLENGTH || returnKey;
    }
    
}

- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string
                          andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if(isAmex){
            if(i < 18){
                if ((i>0) && ((i % 4) == 0) && (i < 6)) {
                    [stringWithAddedSpaces appendString:@" "];
                    if (i < cursorPositionInSpacelessString) {
                        (*cursorPosition)++;
                    }
                }
                else if ((i > 5 && ((i % 11) == 0))){
                    [stringWithAddedSpaces appendString:@" "];
                    if (i < cursorPositionInSpacelessString) {
                        (*cursorPosition)++;
                    }
                }
            }
        }else{
            if(i < 16){
                if ((i>0) && ((i % 4) == 0)) {
                    [stringWithAddedSpaces appendString:@" "];
                    if (i < cursorPositionInSpacelessString) {
                        (*cursorPosition)++;
                    }
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

#pragma mark - SaveButton Delegate

- (IBAction)clicked_save:(id)sender {
    [self checkInput];
    if(isCardNumber && isExpDate && isCVV && isCountry && isZipCode){
        [kACCOUNT_UTILS showWorking:self.view string:@"Creating Credit Card"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults stringForKey:KEY_TOKEN];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        NSDictionary *params = @{@"cardInfo": @{
                                         @"cardNumber": _txt_cardNumber.text,
                                         @"expDate": _txt_expDate.text,
                                         @"cvv": _txt_cvv.text,
                                         @"country": _countryLabel.text,
                                         @"zipCode": _txt_zipCode.text
                                         }};
        
        [manager POST:ADD_CARD_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success!");
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults stringForKey:KEY_TOKEN];
            
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
            NSDictionary *dict = @{@"":@""};
            [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"success!");
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Success Create Credit Card" dismiss:@"OK" sender:self];
                [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:nil forKey:KEY_CARDNUMBER];
                [defaults setValue:nil forKey:KEY_CVV];
                [defaults setValue:nil forKey:KEY_EXPDATE];
                NSArray *array = [[responseObject objectForKey:@"profile"] objectForKey:@"cards"];
                if(array.count > 0){
                    NSDictionary *dictionary = [array objectAtIndex:0];
                    NSString *cardNumber = [dictionary objectForKey:@"cardNumber"];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:cardNumber forKey:KEY_CARDNUMBER];
                    [defaults setValue:[dictionary objectForKey:@"cvv"] forKey:KEY_CVV];
                    [defaults setValue:[dictionary objectForKey:@"expDate"] forKey:KEY_EXPDATE];
                }
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
//                [self.navigationController pushViewController:mainVC animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error: %@", error);
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
            [kACCOUNT_UTILS showFailure:self.view withString:@"Failed Creadit Card" andBlock:nil];
            [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        }];
    }
}

- (void) checkInput{
    if(_txt_cardNumber.text.length == 0){
        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your Card Number" dismiss:@"OK" sender:self];
    }else{
        isCardNumber = true;
        if(_txt_expDate.text.length == 0){
            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your card expiration date" dismiss:@"OK" sender:self];
        }else{
            isExpDate = true;
            if(_txt_cvv.text.length == 0){
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your card CVV" dismiss:@"OK" sender:self];
            }else{
                isCVV = true;
                if(_countryLabel.text.length == 0){
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your country" dismiss:@"OK" sender:self];
                }else{
                    isCountry = true;
                    if(_txt_zipCode.text.length == 0){
                        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Please input your country zip code" dismiss:@"OK" sender:self];
                    }else{
                        isZipCode = true;
                    }
                }
            }
        }
    }
}


@end
