//
//  SqlService.h
//  sqlite
//
//  Created by siyue on 15/5/15.
//  Copyright (c) 2015年 siyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "SqlDataList.h"

#define kFilename  @"testdb.db"

@interface SqlService : NSObject


@property (nonatomic) sqlite3 *_database;
-(BOOL) createTestList:(sqlite3 *)db;//创建数据库
-(BOOL) insertTestList:(SqlDataList *)insertList;//插入数据
-(BOOL) updateTestList:(SqlDataList *)updateList;//更新数据
-(NSMutableArray*)getTestList;//获取全部数据
- (BOOL) deleteTestList:(SqlDataList *)deletList;//删除数据：
- (NSMutableArray*)searchTestList:(NSString*)searchString;//查询数据库，searchID为要查询数据的ID，返回数据为查询到的数据

@end
