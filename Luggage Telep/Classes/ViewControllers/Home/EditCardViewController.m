//
//  EditCardViewController.m
//  Luggage Telep
//
//  Created by mac on 11/4/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "EditCardViewController.h"
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

@interface EditCardViewController ()<UITextFieldDelegate, UIAlertViewDelegate>{
    BOOL isCardNumber, isExpDate, isCVV, isCountry, isZipCode;
    NSString        *cardIndex;
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

@implementation EditCardViewController

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
    
    [self downloadCardInfo];
    
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

- (void) downloadCardInfo {
    [kACCOUNT_UTILS showWorking:self.view string:@"Downloading Card Info.."];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:KEY_TOKEN];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{@"":@""};
    [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        NSArray *array = [[responseObject objectForKey:@"profile"] objectForKey:@"cards"];
        if(array.count > 0){
            NSDictionary *dictionary = [array objectAtIndex:0];
            cardIndex = [dictionary objectForKey:@"id"];
            _txt_cardNumber.text = [dictionary objectForKey:@"cardNumber"];
            
            NSString *str_card = [dictionary objectForKey:@"cardNumber"];
            NSString *str_header = [str_card substringWithRange:NSMakeRange(0,2)];
            NSString *str_header1 = [str_card substringWithRange:NSMakeRange(0,1)];
            
            if([str_header1 isEqualToString:@"4"]){
                _img_card.image = [UIImage imageNamed:@"ic_visa_card.png"];
            }
            if ([str_header isEqualToString:@"34"] || [str_header isEqualToString:@"37"]){
                _img_card.image = [UIImage imageNamed:@"amlex.png"];
            }
            else if ([str_header isEqualToString:@"50"] || [str_header isEqualToString:@"51"] || [str_header isEqualToString:@"52"] || [str_header isEqualToString:@"53"] || [str_header isEqualToString:@"54"] || [str_header isEqualToString:@"55"]){
                _img_card.image = [UIImage imageNamed:@"mastercard.png"];
            }

            _txt_expDate.text = [dictionary objectForKey:@"expDate"];
            _txt_cvv.text = [dictionary objectForKey:@"cvv"];
            _countryLabel.text = [dictionary objectForKey:@"country"];
            _txt_zipCode.text = [dictionary objectForKey:@"zipCode"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
    }];
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
        [kACCOUNT_UTILS showWorking:self.view string:@"Updating Credit Card"];
        
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
                                         },
                                 @"cardIndex" : cardIndex
                                 };
        
        [manager POST:UPDATE_CARD_URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([[responseObject objectForKey:@"success"] intValue] == 1){
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [defaults stringForKey:KEY_TOKEN];
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                NSDictionary *dict = @{@"":@""};
                [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"success!");
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Your credit card has been updated." dismiss:@"OK" sender:self];
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
//                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
//                    [self.navigationController pushViewController:mainVC animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error: %@", error);
                    [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                }];

            }
            else{
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Failed Update Credit Card" dismiss:@"OK" sender:self];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
            [kACCOUNT_UTILS showFailure:self.view withString:@"Failed Creadit Card" andBlock:nil];
            [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        }];
    }
}
- (IBAction)clicked_delete:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Luggage Teleport"
                                                    message:@"Confirm to delete this card?"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
    
    

}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [kACCOUNT_UTILS showWorking:self.view string:@"Deleting Credit Card"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults stringForKey:KEY_TOKEN];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        NSDictionary *dict = @{@"cardIndex":cardIndex};
        [manager POST:DELETE_CARD_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success!");
            [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
            if([[responseObject objectForKey:@"success"] intValue] == 1){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [defaults stringForKey:KEY_TOKEN];
                AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                NSDictionary *dict = @{@"":@""};
                [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"success!");
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Success delete Credit Card" dismiss:@"OK" sender:self];
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
//                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
//                    [self.navigationController pushViewController:mainVC animated:YES];
                      [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error: %@", error);
                    [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                }];
            }
            else{
                [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Failed Update Credit Card" dismiss:@"OK" sender:self];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
        }];
        
    }else{
        NSLog(@"cancel");
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
