//
//  SYMicroAddGoodsViewController.m
//  MicroShop
//
//  Created by siyue on 15/5/7.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYMicroAddGoodsViewController.h"
#import "SYMicroAddGoodsHeadTableViewCell.h"
#import "SYMicroAddGoodsTypeTableViewCell.h"
#import "IQKeyboardManager.h"
#import "SYMicroAddGoodsFootTableViewCell.h"
#import "CHDropView.h"
#import "SYGoodClassModel.h"
#import "CHLayout.h"
#import "SYGeneralHtmlViewController.h"
#import "SYGettingWebURLData.h"
#import "UIButton+WebCache.h"

#define CellHeight 130

@interface SYMicroAddGoodsViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)CHDropView *dropView;
@property (nonatomic,strong)MBProgressHUD *progressHUD;//加载图标

@property (assign,nonatomic)CGFloat scale;
@property (assign,nonatomic)NSInteger row;
@property (assign,nonatomic)NSInteger uploadingImgNum;
@property (assign,nonatomic)NSInteger readySubmitNum;//大于等于0表示满足提交条件

@property (strong,nonatomic)NSMutableArray *currentSpec;
@property (strong,nonatomic)NSMutableArray *classList;
@property (strong,nonatomic)NSMutableArray *imageList;
@property (strong,nonatomic)NSMutableArray *imageURLList;
@property (strong,nonatomic)SYGoodClassModel *currentClass;
@property (strong,nonatomic)SYWebURLModel *webURLModel;

@property (strong,nonatomic)SYMicroAddGoodsHeadTableViewCell *headCell;
@property (strong,nonatomic)SYMicroAddGoodsFootTableViewCell *footCell;
@end

@implementation SYMicroAddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type==0) {
        self.navigationItem.title = @"添加自营商品";
    }
    else if(self.type==1) {
        self.navigationItem.title = @"修改自营商品";
    }
    
    
    self.webURLModel = [[SYWebURLModel alloc] init];
    self.webURLModel = [[SYGettingWebURLData sharedManager] getWebURLData];
    
    self.currentClass = [[SYGoodClassModel alloc] init];
    self.currentSpec = [[NSMutableArray alloc] init];
    NSDictionary *spec = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"attr_name",@"",@"goods_storage",@"",@"goods_price", nil];
    [self.currentSpec addObject:spec];
    self.classList = [[NSMutableArray alloc] init];
    self.imageList = [[NSMutableArray alloc] initWithCapacity:8];
    self.imageURLList = [[NSMutableArray alloc] initWithCapacity:8];
    for (NSInteger i=0; i<8; i++) {
        UIImage *image = [[UIImage alloc] init];
        [self.imageList addObject:image];
    }
    
    self.uploadingImgNum = 0;
    self.readySubmitNum = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    if (self.subURL==nil) {
        self.subURL = Micro_Add_SelfGood;
    }
    
    if (self.type==1) {
        [self requestEditInfo];
    }
    
    [self initTableViewHead];
    [self initFootViewHead];
    [self initDropView];
    
    [self requestGoodClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableViewHead
{
    self.headCell = [[NSBundle mainBundle] loadNibNamed:@"SYMicroAddGoodsHeadTableViewCell" owner:nil options:nil].firstObject;
    
    [self.headCell.image1Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image2Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image3Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image4Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image5Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image6Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image7Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headCell.image8Btn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headCell.gooddescriptionLabel.delegate = self;
    CHLayout *layout = [CHLayout sharedManager];
    self.headCell.goodView.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
    self.headCell.goodView.layer.borderWidth = 1;
    [layout drawLineIn:self.headCell.goodTitleView withRect:CGRectMake(0, self.headCell.goodTitleView.frame.size.height-1, ScreenWidth-20, 1) withColor:[UIColor colorWithWhite:0.835 alpha:1.000]];
    
    UIView *headView = self.headCell.contentView;
    self.tableView.tableHeaderView = headView;
    
}

- (void)initFootViewHead
{
    self.footCell = [[NSBundle mainBundle] loadNibNamed:@"SYMicroAddGoodsFootTableViewCell" owner:nil options:nil].firstObject;
    UIView *footView = self.footCell.contentView;
    [self.footCell.addTypeBtn addTarget:self action:@selector(addGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footCell.goodClassBtn addTarget:self action:@selector(goodsClassClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footCell.submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footView;
}

- (void)initDropView
{
    self.dropView = [[CHDropView alloc] initWithFrame:CGRectMake(0, 60, 320, self.view.frame.size.height-60)];
    [self.view addSubview:self.dropView];
    __block SYMicroAddGoodsViewController *blockSelf = self;
    self.dropView.didSelect = ^(NSInteger topRow, NSInteger secRow) {
        blockSelf.currentClass = blockSelf.classList[topRow];
        blockSelf.footCell.goodClassTextField.text = blockSelf.currentClass.class_name;
    };
}

#pragma mark - net

- (void)requestGoodClass
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Micro_Goods_Class,key];
    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestGoodClass:result];
    } error:^(NSError *error) {
        
    }];
}

- (void)didRequestGoodClass:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            NSArray *class_list = result[@"class_list"];
            NSMutableArray *dropList = [[NSMutableArray alloc] init];
            for (NSDictionary *class in class_list) {
                SYGoodClassModel *goodClassModel = [[SYGoodClassModel alloc] init];
                goodClassModel.class_name = class[@"name"];
                goodClassModel.class_id = class[@"id"];
                [self.classList addObject:goodClassModel];
                
                CHDropModel *dropModel = [[CHDropModel alloc] init];
                dropModel.itemName = goodClassModel.class_name;
                [dropList addObject:dropModel];
            }
            self.dropView.dropModelList = dropList;

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

- (void)requestUploadImg:(UIImage *)image
{
    if (self.progressHUD==nil) {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.progressHUD.labelText = @"加载中";
        [self.progressHUD show:YES];
        [self.view addSubview:self.progressHUD];
    }

    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Micro_Upload_Img,key];
    
    [[NetworkInterface shareInstance] requestForMultiPost:url parms:nil formBlock:^(id<AFMultipartFormData> formData) {
        NSData *imgData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imgData name:@"img" fileName:@"image1.png" mimeType:@"image/jpeg"];
    } complete:^(NSDictionary *result) {
        [self didRequestUploadImg:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0.5];
        self.progressHUD = nil;
    }];
}

- (void)didRequestUploadImg:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            self.uploadingImgNum--;
            NSString *imageURL = [NSString stringWithFormat:@"%@",result[@"data"][@"image_url"]];
            [self.imageURLList addObject:imageURL];
            if (self.uploadingImgNum<=0) {//上传图片完成，开始上传数据
                [self requestAddGood];
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    [self.progressHUD hide:YES afterDelay:0.5];
    self.progressHUD = nil;
}

- (void)requestAddGood
{
    NSString *class_id;
    if (self.currentClass.class_id==nil) {
        class_id = self.currentClass.class_id;
    }
    else {
        SYGoodClassModel *goodClassModel = self.classList[0];
        class_id = goodClassModel.class_id;
    }
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *subURL = self.subURL;
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,subURL,key];
    NSString *goods_name = [NSString stringWithFormat:@"%@",self.headCell.goodtitleLabel.text];
    NSString *goods_description = [NSString stringWithFormat:@"%@",self.headCell.gooddescriptionLabel.text];
    NSString *shop_goods_class_id = [NSString stringWithFormat:@"%@",class_id];
    NSString *goods_freight = [NSString stringWithFormat:@"%@",self.footCell.postTextField.text];
    NSString *goods_id = [NSString stringWithFormat:@"%@",self.goodId];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:goods_name forKey:@"goods_name"];
    [params setObject:goods_description forKey:@"goods_description"];
    [params setObject:shop_goods_class_id forKey:@"shop_goods_class_id"];
    [params setObject:goods_freight forKey:@"goods_freight"];
    [params setObject:goods_id forKey:@"goods_id"];
    
    for (NSInteger i=0;i<self.imageURLList.count;i++) {
        NSString *key = [NSString stringWithFormat:@"goods_img[%li]",(long)i];
        [params setObject:self.imageURLList[i] forKey:key];
    }
    
    for (NSInteger i=0;i<self.currentSpec.count;i++) {
        NSDictionary *spec = self.currentSpec[i];
        NSString *attr_nameKey = [NSString stringWithFormat:@"goods_attribute[%li][attr_name]",(long)i];
        NSString *goods_priceKey = [NSString stringWithFormat:@"goods_attribute[%li][goods_price]",(long)i];
        NSString *goods_storageKey = [NSString stringWithFormat:@"goods_attribute[%li][goods_storage]",(long)i];
        NSString *attr_name = spec[@"attr_name"];
        NSString *goods_price = spec[@"goods_price"];
        NSString *goods_storage = spec[@"goods_storage"];
        
        [params setObject:attr_name forKey:attr_nameKey];
        [params setObject:goods_price forKey:goods_priceKey];
        [params setObject:goods_storage forKey:goods_storageKey];
    }
    
    [[NetworkInterface shareInstance] requestForPost:url parms:params complete:^(NSDictionary *result) {
        [self didRequestAddGood:result];
    } error:^(NSError *error) {
        [self.progressHUD hide:YES afterDelay:0.5];
        self.progressHUD = nil;
    }];
}

- (void)didRequestAddGood:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            self.progressHUD.labelText = @"上传成功";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Html" bundle:nil];
            SYGeneralHtmlViewController *generalHtmlVC = [storyboard instantiateViewControllerWithIdentifier:@"generalHtmlVC"];
           
            if (self.type==0) {
                NSString *url = self.webURLModel.micro_mySelf_URL;
                generalHtmlVC.url = url;
                generalHtmlVC.navTitle = @"自营商品";
                generalHtmlVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:generalHtmlVC animated:YES];
                [[DialogUtil sharedInstance] showDlg:generalHtmlVC.view textOnly:@"上传成功"];
                [self.currentSpec removeAllObjects];
                NSDictionary *spec = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"attr_name",@"",@"goods_storage",@"",@"goods_price", nil];
                [self.currentSpec addObject:spec];
                [self.tableView reloadData];
                
                [self initTableViewHead];
                [self initFootViewHead];
            }
            else if (self.type==1) {
                [self.navigationController popViewControllerAnimated:YES];
                UIView *view = [self.navigationController.viewControllers.lastObject view];
                [[DialogUtil sharedInstance] showDlg:view textOnly:@"修改成功"];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@",result[@"data"][@"message"]];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
    [self.progressHUD hide:YES afterDelay:0.5];
    self.progressHUD = nil;
}

- (void)requestEditInfo
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *goodId = [NSString stringWithFormat:@"&goods_id=%@",self.goodId];
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Micro_Get_EditData,key,goodId];
   
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self didRequestEditInfo:result];
    } error:^(NSError *error) {
        
    }];
}

- (void)didRequestEditInfo:(NSDictionary *)result
{
    if ([result[@"code"] integerValue]==1) {
        NSDictionary *goods_info = result[@"data"][@"goods_info"];
        NSArray *goods_img = goods_info[@"goods_img"];
        for (NSInteger i=0; i<goods_img.count; i++) {
            NSString *imgURL = goods_img[i];
            if (i==0) {
                [self.headCell.image1Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
            else if(i==1) {
                [self.headCell.image2Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                    
                }];
            }
            else if(i==2) {
                [self.headCell.image3Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
            else if(i==3) {
                [self.headCell.image4Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
            else if(i==4) {
                [self.headCell.image5Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
            else if(i==5) {
                [self.headCell.image6Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
            else if(i==6) {
                [self.headCell.image7Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
            else if(i==7) {
                [self.headCell.image8Btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image!=nil) {
                        [self.imageList replaceObjectAtIndex:i withObject:image];
                    }
                }];
            }
        }
        
        NSString *goods_name = [NSString stringWithFormat:@"%@",goods_info[@"goods_name"]];
        NSString *goods_description = [NSString stringWithFormat:@"%@",goods_info[@"goods_description"]];
        self.headCell.goodtitleLabel.text = goods_name;
        self.headCell.gooddescriptionLabel.text = goods_description;
        if ([self.headCell.gooddescriptionLabel.text isEqualToString:@""]) {
            self.headCell.descriptionBackWordTextField.hidden = NO;
        }
        else {
            self.headCell.descriptionBackWordTextField.hidden = YES;
        }

        NSArray *attr = goods_info[@"attr"];
        self.currentSpec = [NSMutableArray arrayWithArray:attr];
        [self.tableView reloadData];
        
        NSString *className = [NSString stringWithFormat:@"%@",goods_info[@"shop_goods_class_name"]];
        NSString *goods_freight = [NSString stringWithFormat:@"%@",goods_info[@"goods_freight"]];
        self.footCell.goodClassTextField.text = className;
        self.footCell.postTextField.text = goods_freight;
    }
    else {
        NSString *message = [NSString stringWithFormat:@"%@",result[@"data"][@"message"]];
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:message];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentSpec count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"tableViewCellIdentify";
    SYMicroAddGoodsTypeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SYMicroAddGoodsTypeTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    NSDictionary *spec = self.currentSpec[row];
    cell.typeLabel.delegate = self;
    cell.goodsNumLabel.delegate = self;
    cell.priceLabel.delegate = self;
    cell.typeLabel.tag = row;
    cell.goodsNumLabel.tag = row;
    cell.priceLabel.tag = row;
    cell.typeLabel.restorationIdentifier = @"type";
    
    NSString *type = [NSString stringWithFormat:@"%@",spec[@"attr_name"]];
    NSString *goodsNum = [NSString stringWithFormat:@"%@",spec[@"goods_storage"]];
    NSString *price = [NSString stringWithFormat:@"%@",spec[@"goods_price"]];
    
    cell.typeLabel.text = type;
    cell.goodsNumLabel.text = goodsNum;
    cell.priceLabel.text = price;
    
    CHLayout *layout = [[CHLayout sharedManager] init];
    cell.cellView.layer.borderColor = [UIColor colorWithWhite:0.835 alpha:1.000].CGColor;
    cell.cellView.layer.borderWidth = 1;
    [layout drawLineIn:cell.stockView withRect:CGRectMake(0, 0, ScreenWidth-70, 1) withColor:[UIColor colorWithWhite:0.835 alpha:1.000]];
    [layout drawLineIn:cell.priceView withRect:CGRectMake(0, 0, ScreenWidth-70, 1) withColor:[UIColor colorWithWhite:0.835 alpha:1.000]];
    
    if (row==0) {
        cell.deleteBtn.hidden = YES;
    }
    else {
        cell.deleteBtn.tag = row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - text delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag;
    NSMutableDictionary *spec = [[NSMutableDictionary alloc] initWithDictionary:self.currentSpec[row]];
    NSString *key;
    if ([textField.placeholder isEqual:@"颜色、尺寸等规格"]) {
        key = @"attr_name";
    }
    else if ([textField.placeholder isEqual:@"填写商品数量"]) {
        key = @"goods_storage";
    }
    
    else if ([textField.placeholder isEqual:@"填写商品价格"]) {
        key = @"goods_price";
    }
    
    [spec setObject:textField.text forKey:key];
    [self.currentSpec replaceObjectAtIndex:row withObject:spec];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.headCell.descriptionBackWordTextField.hidden = NO;
    }
    else {
        self.headCell.descriptionBackWordTextField.hidden = YES;
    }
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
        
    }];
    
    float kCompressionQuality = 0.3;
    NSData *photo = UIImageJPEGRepresentation(thumbScale, kCompressionQuality);//压缩图拼
    thumbScale = [UIImage imageWithData:photo];
    
    if (self.row==1) {
        [self.headCell.image1Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==2) {
        [self.headCell.image2Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==3) {
        [self.headCell.image3Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==4) {
        [self.headCell.image4Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==5) {
        [self.headCell.image5Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==6) {
        [self.headCell.image6Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==7) {
        [self.headCell.image7Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    else if (self.row==8) {
        [self.headCell.image8Btn setBackgroundImage:thumbScale forState:UIControlStateNormal];
    }
    [self.imageList replaceObjectAtIndex:self.row-1 withObject:thumbScale];
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

- (void)imageClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    self.row = button.tag;
    
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

- (void)addGoodsClick:(id)sender
{//添加自营商品
    NSDictionary *spec = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"attr_name",@"",@"goods_storage",@"",@"goods_price", nil];
    [self.currentSpec addObject:spec];
    [self.tableView reloadData];
}

- (void)goodsClassClick:(id)sender
{//商品分类选择
    self.dropView.hidden = !self.dropView.hidden;
}

- (void)submitClick:(id)sender
{//提交
    [self.view endEditing:YES];
    
    if (![self isReadySubmit]) {//是否填写内容完整
        return;
    }
    
    for (UIImage *image in self.imageList) {
        if (image.size.width!=0) {
            [self requestUploadImg:image];
            self.uploadingImgNum++;
        }
    }
}
    
- (void)deleteBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    [self.currentSpec removeObjectAtIndex:row];
    [self.tableView reloadData];
}

#pragma mark - other

- (BOOL)isReadySubmit
{
    BOOL isHaveImage = NO;
    for (UIImage *image in self.imageList) {
        if (image.size.width!=0) {
            isHaveImage = YES;
        }
    }
    if (!isHaveImage) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"请选择图片"];
        return NO;
    }
    
    if ([self.headCell.goodtitleLabel.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"商品标题不能为空"];
        return NO;
    }
    
    if ([self.headCell.gooddescriptionLabel.text isEqualToString:@""]) {
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"商品描述不能为空"];
        return NO;
    }
    
    for (NSDictionary *spec in self.currentSpec) {
        NSString *attr_name = spec[@"attr_name"];
        NSString *goods_storage = spec[@"goods_storage"];
        NSString *goods_price = spec[@"goods_price"];
        if ([attr_name isEqualToString:@""]) {
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"型号不能为空"];
            return NO;
        }
        if ([goods_storage isEqualToString:@""]) {
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"库存不能为空"];
            return NO;
        }
        if ([goods_price isEqualToString:@""]) {
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"价格不能为空"];
            return NO;
        }
    }
    
    return YES;
}

@end
