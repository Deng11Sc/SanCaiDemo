//
//  DYLeanCloudNet.m
//  NearbyTask
//
//  Created by SongChang on 2018/4/4.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYLeanCloudNet.h"
#import <objc/runtime.h>


@implementation DYLeanCloudNet

-(void)_initOSCloudServers
{
    [AVOSCloud setApplicationId:@"7YEy5Uoc3UG8xRifE6gRVKp7-gzGzoHsz" clientKey:@"Mc5uwS1LjXgpJkMOXr0Ke4No"];
    [AVOSCloud setAllLogsEnabled:NO];
    
}


/*
 method:获取列表数据
 model:传继承于AVObject的model，继承于AVObject的写法和普通model并没什么不同
 orderby:排序，传nil为默认orderByDescending的创建时间排序，其他请自行参照leanCloud官网进行修改
 limit:获取个数，传0则默认为20个
 */
-(void)getList:(id)model
       orderby:(NSString *)orderby
         limit:(NSInteger)limit
       success:(successful)successful
       failure:(failure)faliure
{
    AVQuery *query = (AVQuery *)[model query];
    
    if (orderby) {
        [query orderByDescending:orderby];
    } else {
        [query orderByDescending:@"createdAt"];
    }
    
    if (limit > 0) {
        query.limit = limit;
    } else {
        query.limit = 20;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject *avObj in objects) {
                NSDictionary *dic = [avObj objectForKey:@"localData"];
                if (successful) {
                    successful(dic);
                }
            }
        } else {
            if (faliure) {
                faliure(DYLeanCloudErrorDefault);
            }
        }
    }];

}

/*
 method:查询自己的数据。条件查询
 步骤:
 1,创建AVQuey --- AVQuery *query = [AVQuery queryWithClassName:表明，相当于url]
 2,设置查询条件 --- [query whereKey:@"userId" equalTo:用户userId具体值]
 */
-(void)findObjectWithQuery:(AVQuery *)query
                   success:(successful)successful
                   failure:(failure)faliure
{
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (AVObject *avObj in objects) {
                NSDictionary *dic = [avObj objectForKey:@"localData"];
                if (successful) {
                    successful(dic);
                }
            }
        } else {
            if (faliure) {
                faliure(DYLeanCloudErrorDefault);
            }
        }
    }];
}


/*
 method:修改数据
 model:需要保存的数据，model形式
 objectId:数据唯一id，注意，如果传了objectId并且数据库内有对应的objectId，则只会修改对应数据；如果不传，则生成一条新的数据
 className:需要保存在哪个表中，和常规情况下的url差不多的概念
 relationId:关联Id,一般我默认为关联用户的userId，用处自行探索
 */
-(void)saveObject:(id)model
         objectId:(NSString *)objectId
        className:(NSString *)className
       relationId:(NSString *)relationId
          success:(successful)successful
          failure:(failure)faliure

{
    AVObject *todoFolder;
    if (!objectId) {
        todoFolder = [[AVObject alloc] initWithClassName:className];// 构建对象

    } else {
        todoFolder = [AVObject objectWithClassName:className objectId:objectId];// 构建对象
    }
    
    if (relationId) {
        [todoFolder setObject:relationId forKey:@"relationId"];// 设置关联id
    }
    [todoFolder setObject:@1 forKey:@"priority"];// 设置优先级
    
    //
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([model class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        // 获取key
        NSString *key = [self getKeyWithIvar:ivar];
        
        id value = [model valueForKey:key];
        [todoFolder setObject:value forKey:key];
    }
    free(ivarList);

    [todoFolder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            // 存储成功
            NSLog(@"%@",todoFolder.objectId);// 保存成功之后，objectId 会自动从云端加载到本地
            
            if (successful) {
                successful(nil);
            }
            
        } else {
            // 失败的话，请检查网络环境以及 SDK 配置是否正确
            if (faliure) {
                faliure(DYLeanCloudErrorDefault);
            }
        }
    }];

}

//获取model的其中一个key
-(NSString *)getKeyWithIvar:(Ivar)ivar {
    
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 获取key
    NSString *key = nil;
    if ([[ivarName substringToIndex:1] isEqualToString:@"_"]) {
        key = [ivarName substringFromIndex:1];
    } else {
        key = ivarName;
    }
    return key;
}




@end
