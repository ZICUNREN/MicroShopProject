//
//  SYEditUserInfoViewController.m
//  MicroShop
//
//  Created by siyue on 15/5/12.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYEditUserInfoViewController.h"
#import "SYUserInfoModel.h"
#import "SYGeneralHtmlViewController.h"
#import "CHLayout.h"

@interface SYEditUserInfoViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

- (IBAction)changeUserImgClick:(id)sender;
- (IBAction)nickNameEditClick:(id)sender;
- (IBAction)passWorkEditClick:(id)sender;

@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标
@property(strong,nonatomic)SYUserInfoModel *userInfoModel;
@property (assign,nonatomic)CGFloat scale;

//URL
@property(strong,nonatomic)NSString *nicknameEditURL;
@property(strong,nonatomic)NSString *passwordEditURL;

@end

@implementation SYEditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"账户编辑";
    self.userInfoModel = [[SYUserInfoModel alloc] init];

    [self initView];
    [self requestUserEditInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:self.userImgView withCornerRadius:3];
}

#pragma mark - net

- (void)requestUserEditInfo
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *app = [NSString stringWithFormat:@"&app=%@",@"ios"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,User_Info_Edit,key,app];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestUserEditInfo:result];
    } error:^(NSError *error) {
        
    }];
}

- (void)didRequestUserEditInfo:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        NSDictionary *data = result[@"data"];
        self.userInfoModel.imgURL = [NSString stringWithFormat:@"%@",data[@"avatar"]];
        self.userInfoModel.userName = [NSString stringWithFormat:@"%@",data[@"nickname"]];
        
        NSDictionary *href = data[@"href"];
        self.nicknameEditURL = [NSString stringWithFormat:@"%@",href[@"nickname"]];
        self.passwordEditURL = [NSString stringWithFormat:@"%@",href[@"passwordEdit"]];
        
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.imgURL] placeholderImage:[UIImage imageNamed:@"use"]];
        self.nickNameLabel.text = self.userInfoModel.userName;
    }
}

- (void)requestUploadImg:(UIImage *)image
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    [self.view addSubview:self.progressHUD];
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Micro_Upload_Img,key];
    
    [[NetworkInterface shareInstance] requestForMultiPost:url parms:nil formBlock:^(id<AFMultipartFormData> formData) {
        NSData *imgData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imgData name:@"img" fileName:@"image1.png" mimeType:@"image/jpeg"];
    } complete:^(NSDictionary *result) {
        [self didRequestUploadImg:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0.5];
    }];
}

- (void)didRequestUploadImg:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        NSString *avatarURL = [NSString stringWithFormat:@"%@",result[@"data"][@"image_url"]];
        [self requestEditImg:avatarURL];
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@",result[@"data"][@"message"]];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
        [self.progressHUD hide:YES afterDelay:0.5];
    }
}

- (void)requestEditImg:(NSString *)avatarURL
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *avatar = [NSString stringWithFormat:@"&avatar=%@",avatarURL];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,User_Avatar_Edit,key,avatar];
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestEditImg:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0.5];
    }];
    
}

- (void)didRequestEditImg:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"头像修改成功"];
        if (self.didEditImg!=nil) {
            self.didEditImg(self.userImgView.image);
        }
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@",result[@"data"][@"message"]];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
    [self.progressHUD hide:YES afterDelay:0];
}




//实现ImagePicker delegate 事件
#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     */
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGImageRef cgRef = image.CGImage;
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(0, (imageHeight-imageHeight*self.scale)/2, imageWidth, imageHeight*self.scale));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self requestUploadImg:self.userImgView.image];
    }];
    
    float kCompressionQuality = 0.3;
    NSData *photo = UIImageJPEGRepresentation(thumbScale, kCompressionQuality);//压缩图拼
    self.userImgView.image = [UIImage imageWithData:photo];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UIActionSheetDelegate


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                // 取消
                return;
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = (id)self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeUserImgClick:(id)sender {
    UIActionSheet *sheet;
    
    self.scale = 1;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];

}

- (IBAction)nickNameEditClick:(id)sender {
    if (self.nicknameEditURL!=nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
        SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
        NSString *url = self.nicknameEditURL;
        generalHtmlVC.url = url;
        generalHtmlVC.navTitle = @"修改呢称";
        generalHtmlVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:generalHtmlVC animated:YES];
    }
}

- (IBAction)passWorkEditClick:(id)sender {
    if (self.passwordEditURL!=nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
        SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
        NSString *url = self.passwordEditURL;
        generalHtmlVC.url = url;
        generalHtmlVC.navTitle = @"修改呢称";
        generalHtmlVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:generalHtmlVC animated:YES];
    }

}
@end
