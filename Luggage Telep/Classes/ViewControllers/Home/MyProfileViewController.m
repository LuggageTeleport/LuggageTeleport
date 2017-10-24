//
//  MyProfileViewController.m
//  Luggage Telep
//
//  Created by MacOS on 10/2/17.
//  Copyright © 2017 MacOS. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Constant.h"
#import "AccountUtilities.h"
#import "UIImageView+AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyProfileViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    UIImagePickerController *_imagePicker;
    UIActionSheet *_actionSheet; //show Photo Menu
    UIImage *_image;
    NSString    *filePath;
    NSString    *token;
    NSString    *userName;
    NSString    *userImagePath;
    NSData      *userImageData;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txt_firstName;
@property (weak, nonatomic) IBOutlet UITextField *txt_lastName;
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *img_userProfile;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downLoadProfileInfo];
    _editBtn.layer.cornerRadius = _editBtn.layer.frame.size.height/2;
    _saveBtn.layer.cornerRadius = _saveBtn.layer.frame.size.height/2;
    _img_userProfile.layer.cornerRadius = _img_userProfile.frame.size.height/2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downLoadProfileInfo {
    
    [kACCOUNT_UTILS showWorking:self.view string:@"Downloading Profile.."];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults stringForKey:@"TOKEN"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{@"":@""};
    [manager POST:DOWNLOAD_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
        _txt_email.text = [[responseObject objectForKey:@"profile"] objectForKey:@"email"];
        _txt_firstName.text = [[responseObject objectForKey:@"profile"] objectForKey:@"firstname"];
        _txt_lastName.text = [[responseObject objectForKey:@"profile"] objectForKey:@"lastname"];
        _txt_phone.text = [[responseObject objectForKey:@"profile"] objectForKey:@"phoneNumber"];
        userName = [[responseObject objectForKey:@"profile"] objectForKey:@"username"];
        userImagePath = [NSString stringWithFormat:@"https://infinite-garden-74421.herokuapp.com/%@", [[responseObject objectForKey:@"profile"] objectForKey:@"avatar"]];
        [_img_userProfile sd_setImageWithURL:[NSURL URLWithString:userImagePath]
                     placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]
                              options:SDWebImageRefreshCached];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
    }];
    
}

- (IBAction)clicked_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)takePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
        _actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        _actionSheet.destructiveButtonIndex = 1;
        [_actionSheet showInView:self.view];
        
    } else {

        [self SelectPhotoFromLibrary];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self TakePhotoWithCamera];
    }
    else if (buttonIndex == 1)
    {
        [self SelectPhotoFromLibrary];
    }
    
    else if (buttonIndex == 2)
    {
        NSLog(@"cancel");
    }
}

- (void)TakePhotoWithCamera
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)SelectPhotoFromLibrary
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.img_userProfile.image = chosenImage;
    userImageData = UIImagePNGRepresentation(chosenImage);
    filePath = [info objectForKey:@"UIImagePickerControllerImageURL"];
    NSLog(@"%@", filePath);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)clicked_saveProfile:(id)sender {
    [kACCOUNT_UTILS showWorking:self.view string:@"Updating Profile.."];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    token = [defaults stringForKey:@"TOKEN"];
    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//    NSDictionary *dict = @{@"firstname":_txt_firstName.text,
//                           @"lastname": _txt_lastName.text,
//                           @"username": _txt_firstName.text,
//                           @"email": _txt_email.text,
//                           @"password": _txt_password.text,
//                           };
//    [manager POST:UPDATE_PROFILE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success!");
//        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
//        NSNumber *number = [responseObject objectForKey:@"success"];
//        if( [number intValue] == 1){
//            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Profile Updating Success" dismiss:@"OK" sender:self];
//        }else{
//            [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Profile Updating Failed" dismiss:@"OK" sender:self];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error: %@", error);
//        [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
//    }];
    
    [self uploadImage];
}

- (void) uploadImage{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:UPDATE_PROFILE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:userImageData name:@"avatar" fileName:@"123" mimeType:@"image/jpeg"];
        [formData appendPartWithFormData:[_txt_password.text dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        [formData appendPartWithFormData:[_txt_email.text dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
        [formData appendPartWithFormData:[userName dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
        [formData appendPartWithFormData:[_txt_phone.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phoneNumber"];
        [formData appendPartWithFormData:[_txt_firstName.text dataUsingEncoding:NSUTF8StringEncoding] name:@"firstname"];
        [formData appendPartWithFormData:[_txt_lastName.text dataUsingEncoding:NSUTF8StringEncoding] name:@"lastname"];
    } error:nil];

    [request setValue:token forHTTPHeaderField:@"Authorization"];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
//                          [progressView setProgress:uploadProgress.fractionCompleted];
                          NSLog(@"*****====");
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      [kACCOUNT_UTILS hideAllProgressIndicatorsFromView:self.view];
                      if (error) {
                          NSLog(@"Error: %@", error);
                          [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Profile Updating Failed" dismiss:@"OK" sender:self];
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          [kACCOUNT_UTILS showStandardAlertWithTitle:@"Luggage Teleport" body:@"Profile Updating Success" dismiss:@"OK" sender:self];
                      }
                  }];
    
    [uploadTask resume];
    
    
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    if (nextTag == 6) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    
    if (textField == self.txt_firstName) {
        [self.txt_lastName becomeFirstResponder];
    }else if(textField == self.txt_lastName) {
        [self.txt_phone becomeFirstResponder];
    }else if(textField == self.txt_phone) {
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
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    else if (textField.tag == 2) {
        [self.mScrollView setContentOffset:CGPointMake(0, -20) animated:true];
    }
    else if (textField.tag == 3) {
        [self.mScrollView setContentOffset:CGPointMake(0, 30) animated:true];
    }
    else if (textField.tag == 4) {
        [self.mScrollView setContentOffset:CGPointMake(0, 70) animated:true];
    }
    else {
        [self.mScrollView setContentOffset:CGPointMake(0, 110) animated:true];
    }
}


@end
