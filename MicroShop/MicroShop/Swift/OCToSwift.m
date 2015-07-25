//
//  OCToSwift.m
//  MicroShop
//
//  Created by abc on 15/6/23.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "OCToSwift.h"
#import "SYShareModel.h"
#import "UIViewController+Share.h"
#import "AppDelegate.h"

@implementation OCToSwift

+(id)sharedManager
{
    static OCToSwift *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[OCToSwift alloc] init];
    });
    return sharedManager;
}

- (NSString *)userToken
{
    return UserToken;
}

- (void)requestAddSell:(NSString *)good_id_str
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *good_id = [NSString stringWithFormat:@"&goods_id=%@",good_id_str];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@",HomeURL,Spread_Add_Sell,key,good_id];
    

    
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        
        [self didRequestAddSell:result];
    } error:^(NSError *error) {

    }];
}

- (void)didRequestAddSell:(NSDictionary *)result {
    if ([result[@"code"] integerValue]==1) {
        @try {
            
            SYShareModel *shareModel = [[SYShareModel alloc] init];
            NSDictionary *share = result[@"data"][@"share"];
            shareModel.article_content = [NSString stringWithFormat:@"%@",share[@"share_desc"]];
            shareModel.article_image = [NSString stringWithFormat:@"%@",share[@"share_pic"]];
            shareModel.article_title = [NSString stringWithFormat:@"%@",share[@"share_title"]];
            shareModel.article_url = [NSString stringWithFormat:@"%@",share[@"share_url"]];
            shareModel.article_id = [NSString stringWithFormat:@"%@",share[@"id"]];
            
            id<ISSCAttachment>shareImage = [ShareSDK imageWithUrl:shareModel.article_image];
            // NSString *content = [NSString stringWithFormat:@"%@\n%@",self.shareModel.article_title,self.shareModel.article_content];
            //[self shareAllButtonClickHandler:content url:self.shareModel.article_url image:shareImage];
            NSString *content = [NSString stringWithFormat:@"%@",shareModel.article_content];
            NSString *titleStr = [NSString stringWithFormat:@"%@",shareModel.article_title];
            [self shareAllButtonClickHandler:content withTitle:titleStr url:shareModel.article_url image:shareImage withId:shareModel.article_id];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        
    }
    
}

- (void) shareAllButtonClickHandler:(NSString *) content withTitle:(NSString *)title url:(NSString *) urlStr image:(id<ISSCAttachment>)image withId:(NSString *)articleId
{
    [self shareAllButtonClickHandler:content withTitle:title url:urlStr image:image withId:articleId isActive:NO];
}

- (void) shareAllButtonClickHandler:(NSString *) content withTitle:(NSString *)title url:(NSString *) urlStr image:(id<ISSCAttachment>)image withId:(NSString *)articleId isActive:(BOOL)isActive
{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:urlStr
                                                image:image
                                                title:title
                                                  url:urlStr
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeNews];
    
    NSArray *shareList = [ShareSDK getShareListWithType: ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSMS, nil];
    
    AppDelegate *_appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:_appDelegate.viewDelegate
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    //[[DialogUtil sharedInstance] showDlg:self.view textOnly:@"分享成功"];
                                    
                                    //分享次数统计
                                    NSString *authcode = [NSString stringWithFormat:@"&authcode=%@",UserToken];
                                    NSString *shareType = [NSString stringWithFormat:@"&type=%i",type];
                                    NSString *articleIdStr = [NSString stringWithFormat:@"&article_id=%@",articleId];
                                    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,Set_Share_Num,articleIdStr,shareType,authcode];
                                    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
                                        
                                    } error:^(NSError *error) {
                                        
                                    }];
                                    
                                    if (isActive) {//活动
                                        [self requestHaveShare];
                                    }
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self performSelector:@selector(showDlgtext:) withObject:(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]) afterDelay:0.5];
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
}

- (void)requestHaveShare
{
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,Award_Share_CallBack,key];
    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
        [self refreshWeb];
    } error:^(NSError *error) {
        
    }];
    
}

- (void)refreshWeb
{
    
}

- (void)showDlgtext:(NSString *)text
{
    //[[DialogUtil sharedInstance] showDlg:self.view textOnly:text];
}


- (void)shareLoginWithType:(ShareType)type result:(void(^)(NSDictionary *result))resultBlock
{
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if(result){
            NSDictionary *dic = [userInfo sourceData];
            resultBlock(dic);
        }else{
            //[DialogUtil showDlgAlert:@"尚未安装微信" cancelButtonTitle:@"确定" title:@"" delegate:nil];
            return ;
        }
    }];
    
}

- (void)shareCancelAuthWithType:(ShareType)type
{
    [ShareSDK cancelAuthWithType:type];
    
}



@end
