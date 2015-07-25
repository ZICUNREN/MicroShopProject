//
//  SYMcroEditStoreViewController.m
//  MicroShop
//
//  Created by siyue on 15/5/4.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYMcroEditStoreViewController.h"
#import "SYMcroShopViewController.h"
#import "SYShopInfoModel.h"
#import "CHLayout.h"
#import "SYGeneralHtmlViewController.h"
#import "SYGettingWebURLData.h"

#define BigIconScale (280.0/600.0)
#define IconScale 1

@interface SYMcroEditStoreViewController () <UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bigIconImgView;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
- (IBAction)iconClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *storeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *storeDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *bigIconBtn;
- (IBAction)bigIconClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *weiXinTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
- (IBAction)previewClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *weixinImgView;
@property (weak, nonatomic) IBOutlet UIImageView *qqImgView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigIconImgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigIconViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigIconBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;

@property (strong,nonatomic)SYShopInfoModel *mcroShopModel;
@property (strong,nonatomic)UIImage *image;
@property (assign,nonatomic)CGFloat scale;
@property (strong,nonatomic)SYWebURLModel *webURLModel;

@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@end

@implementation SYMcroEditStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"店铺编辑";
    
    self.mcroShopModel = [[SYShopInfoModel alloc] init];
    self.webURLModel = [[SYWebURLModel alloc] init];
    self.webURLModel = [[SYGettingWebURLData sharedManager] getWebURLData];
    
    [self requestMicroStore];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    CHLayout *layout = [CHLayout sharedManager];
    [layout setView:self.iconImgView withCornerRadius:3];
    [layout setView:self.bigIconImgView withCornerRadius:3];
    
    [layout setView:self.weixinImgView withCornerRadius:3];
    [layout setView:self.qqImgView withCornerRadius:3];
    [layout setView:self.phoneImgView withCornerRadius:3];
    [layout setView:self.saveBtn withCornerRadius:3];
    [layout setView:self.previewBtn withCornerRadius:3];
    
    self.bigIconBtnHeightConstraint.constant = (ScreenWidth-20)*280/600;
    self.bigIconViewHeightConstraint.constant = (ScreenWidth-20)*280/600+80;
    self.bigIconImgViewHeightConstraint.constant = (ScreenWidth-20)*280/600;
    self.scrollViewHeightConstraint.constant = 620+(ScreenWidth-20)*280/600;
}

#pragma mark - net

- (void)requestMicroStore
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *shopId = [NSString stringWithFormat:@"&shop_id%@",self.store_id];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Micro_Store_Detail,key,shopId];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestMicroStore:result];
        //[self endRefresh];
    } error:^(NSError *error) {
        //[self endRefresh];
    }];
}

- (void)didRequestMicroStore:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            self.mcroShopModel.iconURL = [NSString stringWithFormat:@"%@",result[@"data"][@"store_label"]];
            self.mcroShopModel.storeName = [NSString stringWithFormat:@"%@",result[@"data"][@"store_name"]];
            self.mcroShopModel.storeDetail = [NSString stringWithFormat:@"%@",result[@"data"][@"store_description"]];
            self.mcroShopModel.bigIconURL = [NSString stringWithFormat:@"%@",result[@"data"][@"store_banner"]];
            self.mcroShopModel.store_weixin = [NSString stringWithFormat:@"%@",result[@"data"][@"store_weixin"]];
            self.mcroShopModel.store_qq = [NSString stringWithFormat:@"%@",result[@"data"][@"store_qq"]];
            self.mcroShopModel.store_tel = [NSString stringWithFormat:@"%@",result[@"data"][@"store_tel"]];
            
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:self.mcroShopModel.iconURL] placeholderImage:[UIImage imageNamed:@"use"]];
            self.storeNameLabel.text = self.mcroShopModel.storeName;
            self.storeDetailLabel.text = self.mcroShopModel.storeDetail;
            [self.bigIconImgView sd_setImageWithURL:[NSURL URLWithString:self.mcroShopModel.bigIconURL] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
            self.weiXinTextField.text = self.mcroShopModel.store_weixin;
            self.qqTextField.text = self.mcroShopModel.store_qq;
            self.phoneTextField.text = self.mcroShopModel.store_tel;

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

#pragma mark - net

- (void)requestMicroEditStore
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"加载中";
    [self.progressHUD show:YES];
    [self.view addSubview:self.progressHUD];
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Micro_Store_Edit,key];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
 
    NSString *storeName = self.storeNameLabel.text;
    NSString *store_description = self.storeDetailLabel.text;
    NSString *store_weixin = self.weiXinTextField.text;
    NSString *store_qq = self.qqTextField.text;
    NSString *store_tel = self.phoneTextField.text;
    
    NSData *iconData=UIImageJPEGRepresentation(self.iconImgView.image, 0.5);
    NSString *iconBase64Encode = [iconData base64EncodedStringWithOptions:0];
    NSData *bigIconData=UIImageJPEGRepresentation(self.bigIconImgView.image, 0.5);
    NSString *bigIconBase64Encode = [bigIconData base64EncodedStringWithOptions:0];
    
    [params setObject:storeName forKey:@"store_name"];
    [params setObject:store_description forKey:@"store_description"];
    [params setObject:store_weixin forKey:@"store_weixin"];
    [params setObject:store_qq forKey:@"store_qq"];
    [params setObject:store_tel forKey:@"store_tel"];
    if (iconBase64Encode!=nil) {
        [params setObject:iconBase64Encode forKey:@"store_label"];
    }
    if (bigIconBase64Encode!=nil) {
        [params setObject:bigIconBase64Encode forKey:@"store_banner"];
    }
    
    [[NetworkInterface shareInstance] requestForPost:url parms:params complete:^(NSDictionary *result) {
        [self didRequestMicroEditStore:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0.5];
    }];
}

- (void)didRequestMicroEditStore:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSString *message = [NSString stringWithFormat:@"%@",result[@"message"]];
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@",result[@"message"]];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
    [self.progressHUD hide:YES afterDelay:0];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    self.image = image;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGImageRef cgRef = image.CGImage;
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(0, (imageHeight-imageHeight*self.scale)/2, imageWidth, imageHeight*self.scale));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    float kCompressionQuality = 0.3;
    NSData *photo = UIImageJPEGRepresentation(thumbScale, kCompressionQuality);//压缩图拼
    thumbScale = [UIImage imageWithData:photo];
    
    if (self.scale == IconScale) {
        self.iconImgView.image = thumbScale;
    }
    else {
        self.bigIconImgView.image = thumbScale;
    }
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

#pragma mark - Click

- (IBAction)bigIconClick:(id)sender {
    UIActionSheet *sheet;
    self.scale = BigIconScale;
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

- (IBAction)saveClick:(id)sender {//修改店铺
    [self requestMicroEditStore];
}

- (IBAction)previewClick:(id)sender {//店铺预览
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
    SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
    NSString *url = [NSString stringWithFormat:@"%@&shop_id=%@",self.webURLModel.micro_shopIndex_URL,self.store_id];
    generalHtmlVC.url = url;
    generalHtmlVC.navTitle = @"店铺详情";
    generalHtmlVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:generalHtmlVC animated:YES];

}

- (IBAction)iconClick:(id)sender {
    UIActionSheet *sheet;
    
    self.scale = IconScale;
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

@end
