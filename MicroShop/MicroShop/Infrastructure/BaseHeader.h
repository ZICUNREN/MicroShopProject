//
//  BaseHeader.h
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#ifndef MicroShop_BaseHeader_h
#define MicroShop_BaseHeader_h

/**************************主地址******************************/
#define Text   //是否为测试版

#ifdef Text

#define HomeURL @"http://test.gx.com/index.php?g=app&access=mk1502oy3x&secret=z0223x01zj2w120kzh5wzx323zk2i4i1m54wy4j3"
#define AliasType @"text"
#define Share_URL @"http://test.gx.com/user/user/register/inviter/"

#else

#define HomeURL @"http://weidian.gx.com/index.php?g=app&access=mk1502oy3x&secret=z0223x01zj2w120kzh5wzx323zk2i4i1m54wy4j3"
#define AliasType @"weidian"
#define Share_URL @"http://weidian.gx.com/user/user/register/inviter/"

#endif


#define MTVersion [[[UIDevice currentDevice] systemVersion] floatValue] //版本
#define ScreenHeight     [UIScreen mainScreen].bounds.size.height //设备高
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width   //设备宽

//颜色封装
#define COLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
//系统颜色
#define SytemColor COLOR(244.0, 244.0, 244.0, 1)

//保存邀请码
#define SetInvite(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"Invite"];[[NSUserDefaults standardUserDefaults] synchronize];
//获取邀请码
#define UserInvite [[NSUserDefaults standardUserDefaults] objectForKey:@"Invite"]
//保存用户key
#define SetUserToken(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"token"];[[NSUserDefaults standardUserDefaults] synchronize];
//获取用户key
#define UserToken [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
//删除保存的key
#define RemoveUserToken [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];[[NSUserDefaults standardUserDefaults] synchronize];

//保存邀请码
#define SetMemberId(obj) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"member_id"];[[NSUserDefaults standardUserDefaults] synchronize];
//获取邀请码
#define MemberId [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"]


#define LogoutCode 999
#define Micro_Tab 0
#define Defualt_Tab 2
#define Study_Tab 3

/**************************用户登录******************************/
#define User_Login @"&m=member&a=login"
#define Weixin_Login @"&&m=member&a=weixinLogin"
#define User_Info_URL @"&m=MemberEdit&a=index" //用户信息
#define User_Info_Edit @"&m=MemberEdit&a=edit" //个人资料修改
#define User_Avatar_Edit @"&m=MemberEdit&a=edit_avatar" //用户头像修改
#define Register_Send_MSM @"&m=member&a=sendmsm" //发送短信验证码
#define Register_New_User @"&m=member&a=register" //注册
#define User_Feedback @"&m=member&a=feedback"//用户反馈
/**************************微店首页******************************/
#define Micro_Index @"&m=index&a=getHomeData"
#define Micro_Store_Detail @"&m=shop&a=getMemberShopInfo" //店铺详细信息
#define Micro_Store_Edit @"&m=shop&a=editShop" //店铺编辑
#define Micro_Goods_Class @"&m=self&a=addSelf" //商品分类
#define Micro_Upload_Img @"&m=public&a=uploadImgFrom" //上传图片
#define Micro_Add_SelfGood @"&m=self&a=addSelfGoods" //添加自营商品
#define Micro_Get_EditData @"&m=self&a=editSelfGoods&goods_id=1"//获得要编辑的商品的内容
#define Micro_Edit_SelfGood @"&m=self&a=editSelfGoods"//编辑自营商品
/**************************首页******************************/
#define Home_Index @"&m=index&a=getIndexData"
/**************************货源xxx******************************/
#define Supply_URL @"&m=GoodSource&a=index"
#define Supply_Goods_URL @"&m=GoodSource&a=goods"
/**************************微店学习******************************/

#define Study_List @"&m=study&a=index"
#define Study_Article_Content @"&m=study&a=show" //文章内容－推广

#define Study_List_Index @"&m=study&a=s_index"
#define Study_Article_Content_Index @"&m=study&a=s_show" //文章内容－学习


#define Study_Add_Comment @"&m=study&a=add_comment" //添加评论
#define Study_Comment_List @"&m=study&a=comment_list" //评论列表
/**************************推广列表******************************/
#define Dynamic_List @"&m=Spread&a=index"
#define Spread_Add_Sell @"&m=GoodSell&a=addSell"

#define Set_Share_Num @"&m=Study&a=share_num" //统计分享次数

/**************************活动活动******************************/
#define Award_List_URL @"&m=activity&a=getList" //获取活动列表
#define Award_Detail_URL @"&m=activity&a=lotteryInfo"//抽奖页面详情
#define Award_Submit_URL @"&m=activity&a=lottery"//立即抽奖
#define Award_Record_List @"&m=activity&a=getRecord"//中奖记录(列表)
#define Award_Win_Detail @"&m=activity&a=prize"//领奖页面数据获取
#define Award_Share_CallBack @"&m=activity&a=shareCallBack"//分享成功后回调 针对活动页面
#define Award_Done_Detail @"&m=activity&a=getaward"//领奖详情
#define Award_Add_Price @"&m=activity&a=add_prize"//点击领取奖品
#pragma mark - WEB

#define Web_Main_URL @"http://test.gx.com"

/**************************找回密码******************************/
#define Send_Password_Message @"&m=member&a=sendFindPassword"//发送短信验证码
#define Check_Verify_Message @"&m=member&a=checkVerify"//验证短信验证码
#define Change_Password_URL @"&m=member&a=passwordFindOkUpdate" //修改密码

/**************************商品列表******************************/
#define MySelf_Good_List @"&m=self&a=mySelf" //自营商品列表

#pragma mark - 消息中心

#define Notification_ReloadAllView @"Notification_ReloadAllView"

#endif
