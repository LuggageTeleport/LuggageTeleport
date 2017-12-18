//
//  RegisterViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/6/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"
#import "SigninViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constant.h"
#import "AccountUtilities.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface RegisterViewController ()<UITextFieldDelegate, UIAlertViewDelegate>{
    Boolean isuserName;
    Boolean isEmail;
    Boolean isPassword;
    Boolean isPhone;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_country;
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *countryView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isuserName = false;
    isEmail = false;
    isPassword = false;
    isPhone = false;
    self.registerBtn.layer.cornerRadius = self.registerBtn.layer.frame.size.height/2;
    self.nameView.layer.cornerRadius = self.nameView.layer.frame.size.height/2;
    self.emailView.layer.cornerRadius = self.emailView.layer.frame.size.height/2;
    self.passwordView.layer.cornerRadius = self.passwordView.layer.frame.size.height/2;
    self.countryView.layer.cornerRadius = self.countryView.layer.frame.size.height/2;
    self.phoneView.layer.cornerRadius = self.phoneView.layer.frame.size.height/2;
    
    [self setDefaultCountryCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getCountryCode {
    CTTelephonyNetworkInfo *network_Info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = network_Info.subscriberCellularProvider;
    
    NSLog(@"country code is: %@", carrier.mobileCountryCode);
    
    NSLog(@"ISO country code is: %@", carrier.isoCountryCode);
}

-(void)setDefaultCountryCode{
    NSString *countryIdentifier = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSString *prefix_number = [[self getCountryCodeDictionary] objectForKey:countryIdentifier];
//    _txt_country.text = [NSString stringWithFormat:@"+%@",[[self getCountryCodeDictionary] objectForKey:countryIdentifier]];
    NSLog(@"%@",[NSString stringWithFormat:@"+%@",[[self getCountryCodeDictionary] objectForKey:countryIdentifier]]);
}

- (NSDictionary *)getCountryCodeDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
            @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
            @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
            @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
            @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
            @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
            @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
            @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
            @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
            @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
            @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
            @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
            @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
            @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
            @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
            @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
            @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
            @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
            @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
            @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
            @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
            @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
            @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
            @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
            @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
            @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
            @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
            @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
            @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
            @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
            @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
            @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
            @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
            @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
            @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
            @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
            @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
            @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
            @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
            @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
            @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
            @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
            @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
            @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
            @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
            @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
            @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
            @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
            @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
            @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
            @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
            @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
            @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
            @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
            @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
            @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
            @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
            @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
            @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
            @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
            @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clicked_Register:(id)sender {
    [self checkInputs];
    if(isuserName && isEmail && isPassword && isPhone){
        
        [kACCOUNT_UTILS showWorking:self.view string:@"Creating Account"];

        NSDictionary *params = @{@"username"    : _txt_name.text,
                                 @"email"       : _txt_email.text,
                                 @"password"    : _txt_password.text,
                                 @"phoneNumber" : [NSString stringWithFormat:@"%@", _txt_phone.text],
                                 @"countryCode"     : _txt_country.text,
                                 };

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:REGISTER_URL parameters:params error:nil];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:(request) completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
                [kACCOUNT_UTILS showFailure:self.view withString:@"Failed" andBlock:nil];
            } else {
                NSNumber *number = [responseObject objectForKey:@"success"];
                if( [number intValue] == 1){
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:_txt_phone.text forKey:KEY_PHONENUMBER];
                    [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:[responseObject objectForKey:@"msg"] dismiss:@"OK" sender:self];
                    
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    [defaults setValue:[responseObject objectForKey:@"token"] forKey:KEY_TOKEN];
//                    [defaults setValue:_txt_password.text forKey:KEY_PASSWORD];
//                    [defaults setValue:_txt_phone.text forKey:KEY_PHONENUMBER];
//                    [defaults synchronize];
//                    NSString *token = [responseObject objectForKey:@"token"];
//
//                    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//                    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//                    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//                    NSDictionary *dict = @{@"":@""};
//                    [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                        NSLog(@"success!");
//                        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
//
//                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                        [defaults setValue:nil forKey:KEY_CARDNUMBER];
//                        [defaults setValue:nil forKey:KEY_CVV];
//                        [defaults setValue:nil forKey:KEY_EXPDATE];
//                        NSArray *array = [[responseObject objectForKey:@"profile"] objectForKey:@"cards"];
//                        if(array.count > 0){
//                            NSDictionary *dictionary = [array objectAtIndex:0];
//                            NSString *cardNumber = [dictionary objectForKey:@"cardNumber"];
//                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                            [defaults setValue:cardNumber forKey:KEY_CARDNUMBER];
//                            [defaults setValue:[dictionary objectForKey:@"cvv"] forKey:KEY_CVV];
//                            [defaults setValue:[dictionary objectForKey:@"expDate"] forKey:KEY_EXPDATE];
//                        }
//                        [defaults setValue:_txt_name.text forKey:KEY_USERNAME];
//                        [defaults setValue:_txt_email.text forKey:KEY_EMAIL];
//                        [defaults synchronize];
//
//                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        MainViewController *mainVC = [story instantiateViewControllerWithIdentifier:@"MainViewController"];
//                        [self.navigationController pushViewController:mainVC animated:YES];
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        NSLog(@"error: %@", error);
//                    }];
                }else{
//                    NSString *str = [responseObject objectForKey:@"type"];
//                    if([str isEqualToString:@"duplicated"]){
//                        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Same User already exists" dismiss:@"OK" sender:self];
//                    }else{
//                        [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Internet or Wi-fi issue." dismiss:@"OK" sender:self];
//                    }
                    [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                    [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:[responseObject objectForKey:@"msg"] dismiss:@"OK" sender:self];
                    
                }
            }
        }];
        [dataTask resume];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SigninViewController *signVC = [story instantiateViewControllerWithIdentifier:@"SigninViewController"];
    [self.navigationController pushViewController:signVC animated:YES];
}

- (void) checkInputs{
    if(_txt_name.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                 message:@"Please input your username"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        isuserName = true;
        if(_txt_email.text.length == 0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                     message:@"Please input your last name"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            if([self validateEmailWithString:_txt_email.text]){
                isEmail = true;
                if(_txt_password.text.length == 0){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                             message:@"Please input your password"
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else{
                    if(_txt_password.text.length < 6){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                                 message:@"Password must be at least 6 characters"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:nil];
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }else{
                        isPassword = true;
                        if (_txt_phone.text.length == 0) {
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                                     message:@"Please input your phone"
                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:nil];
                            [alertController addAction:actionOk];
                            [self presentViewController:alertController animated:YES completion:nil];
                        }
                        else{
                            isPhone = true;
                        }
                    }
                }
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Luggage Teleport"
                                                                                         message:@"Not valid email address"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
    
}



#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 4 || textField.tag == 0) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_name) {
        [self.txt_email becomeFirstResponder];
    }else if(textField == self.txt_email) {
        [self.txt_password becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, 10) animated:true];
    }
    else{
        [self.mScrollView setContentOffset:CGPointMake(0, 90) animated:true];
    }
}


#pragma mark - Utility Handler -
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
