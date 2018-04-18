//
//  DY_AliUploadManager.m
//  SanCai
//
//  Created by SongChang on 2018/4/18.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_AliUploadManager.h"
#import <AliyunOSSiOS/OSSService.h>


static NSString *_endpoint = @"https://oss-cn-beijing.aliyuncs.com";

static NSString *_bucketName = @"scimagespace";

static NSString *_imageKey = @"userImage";

@implementation DY_AliUploadManager


+(OSSClient *)manager
{
    static OSSClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"AccessKeyId" secretKeyId:@"AccessKeySecret" securityToken:@"SecurityToken"];
        _client = [[OSSClient alloc] initWithEndpoint:_endpoint credentialProvider:credential];

    });
    return _client;
}

+(void)uploadImage:(UIImage *)image
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = _bucketName;
    put.objectKey = _imageKey;
    put.uploadingData = UIImagePNGRepresentation(image); // 直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [[self manager] putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

@end
