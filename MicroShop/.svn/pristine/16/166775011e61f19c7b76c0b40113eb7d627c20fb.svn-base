//
//  UIViewController+Share.m
//  SYProject
//
//  Created by siyue on 14/12/6.
//  Copyright (c) 2014年 com.siyue.liuxn. All rights reserved.
//

#import "UIViewController+Share.h"
#import "AppDelegate.h"
#import "WXApi.h"

@implementation UIViewController (Share)

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
                                    [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"分享成功"];
                                    
                                    //分享次数统计
                                    NSString *authcode = [NSString stringWithFormat:@"&authcode=%@",UserToken];
                                    NSString *shareType = [NSString stringWithFormat:@"&type=%i",type];
                                    NSString *articleIdStr = [NSString stringWithFormat:@"&article_id=%@",articleId];
                                    NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@",HomeURL,Set_Share_Num,articleIdStr,shareType,authcode];
                                    if (articleId!=nil) {
                                        [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result) {
                                            
                                        } error:^(NSError *error) {
                                            
                                        }];
                                    }

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
    [[DialogUtil sharedInstance] showDlg:self.view textOnly:text];
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
