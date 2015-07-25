//
//  SqliteMageger.m
//  MicroShop
//
//  Created by siyue on 15/7/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SqliteMageger.h"
#import "SqlService.h"
#import "CHFileManager.h"

@interface SqliteMageger()

@property (strong,nonatomic)SqlService *sqlService;

@end


@implementation SqliteMageger

+ (instancetype)shareInstance {
    static SqliteMageger * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SqliteMageger alloc] init];
        
    });
    return shareInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.sqlService = [[SqlService alloc] init];
    }
    return self;
}


- (void)saveString:(NSString *)str forKey:(NSString *)key
{
    NSString *urlMd5 = key;
    SqlDataList *sqlDataList = [[SqlDataList alloc] init];
    sqlDataList.sqlID = 0;
    sqlDataList.sqlname = urlMd5;
    sqlDataList.sqlText = str;
    NSArray *list = [self.sqlService searchTestList:sqlDataList.sqlname];
    for (SqlDataList *data in list) {
        [self.sqlService deleteTestList:data];
    }
    [self.sqlService insertTestList:sqlDataList];
}

- (NSString *)getStringFromKey:(NSString *)key
{
    NSString *urlMd5 = key;
    NSArray *list = [self.sqlService searchTestList:urlMd5];
    SqlDataList *sqlDataList;
    if (list.count>0) {
        sqlDataList = list[0];
        return sqlDataList.sqlText;
    }
    return @"";
}

@end
