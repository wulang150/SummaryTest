//
//  NetWorkBase.m
//  AW600
//
//  Created by DONGWANG on 15/10/21.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import "NetWorkBase.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>

@implementation NetWorkBase


/**********************************************AF封装好的直接使用的借口*******************************************************/
#pragma mark 发起GET请求
/**
 *  发送GET请求
 *
 *  @param url       请求url
 *  @param params    请求参数
 */
- (void)startGet:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(receiveResponseBlock)block
{
    
    [self startRequest:url parameters:parameters httpMethod:@"GET" withBlock:^(id result, BOOL succ) {
        block(result,succ);
    }];
    
}

#pragma mark 发起POST请求
/**
 *  发送POST请求
 *
 *  @param url       请求url
 *  @param params    请求参数
 */
- (void)startPOST:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(receiveResponseBlock)block
{
    [self startRequest:url parameters:parameters httpMethod:@"POST" withBlock:^(id result, BOOL succ) {
        block(result,succ);
    }];
}

#pragma mark 上传文件到服务器
/**
 *  上传文件到服务器
 *
 *  @param url        请求url
 *  @param parameters 请求参数
 *  @param files      要上传的文件数组
 *  @param uploadType 上传的文件类型
 */
- (void)uploadFiles:(NSString *)url parameters:(NSDictionary *)parameters fileArray:(NSArray *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
{
    //初始化 AF
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self setGeneralPropertyForManager:manager];
    
    __block NSInteger count = 0;
    NSMutableDictionary *resultDic = [NSMutableDictionary new];
    __block BOOL ret = NO;
    
    __block NSInteger num = 0;
    for(NSString *filename in files)
    {
        NSURL *filePath = [NSURL fileURLWithPath:filename];
        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSLog(@"%@",filePath.path);
            NSError *error;
            
            BOOL formDataBool = YES;
            
            switch (uploadType)
            {
                case Image_Png:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"image/png" error:&error];
                }
                    
                    break;
                case Image_jpeg:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"image/jpeg" error:&error];
                }
                    
                    break;
                case File_Zip:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"application/octet-stream" error:&error];
                }
                    
                    break;
                case File_Other:
                {
                }
                    
                    break;
                case File_Xml:
                {
//                    NSString *filestr = parameters[[NSString stringWithFormat:@"file%zi",num++]];
//                    if(filestr.length<=0)
//                        filestr = [filePath lastPathComponent];
                    formDataBool = [formData appendPartWithFileURL:filePath name:@"file" fileName:[filePath lastPathComponent] mimeType:@"text/xml" error:&error];
                    break;
                }
                    
                default:
                    break;
            }
            
            if (formData == NO)
            {
                NSLog(@"Append part failed with error: %@", error);
            }
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            ret = YES;
            NSString *str = [self dealSuccResult:responseObject];
            NSString *value = [NSString stringWithFormat:@"%@:%d",str,1];
            NSString *filestr = files[count];
            [resultDic setObject:value forKey:filestr];
            if((++count)>=files.count)
            {
                block(resultDic,ret);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //有一个文件上传成功都算是成功
            NSString *value = [NSString stringWithFormat:@"%@:%d",error.description,0];
            NSString *filestr = files[count];
            [resultDic setObject:value forKey:filestr];
            if((++count)>=files.count)
            {
                block(resultDic,ret);
            }
            NSLog(@"Error: %@", error);
            
        }];
    }
}

- (void)uploadFiless:(NSString *)url parameters:(NSDictionary *)parameters fileArray:(NSArray *)files withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
{
    //初始化 AF
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self setGeneralPropertyForManager:manager];
    
    __block NSInteger count = 0;
    NSMutableDictionary *resultDic = [NSMutableDictionary new];
    __block BOOL ret = NO;
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error;
        
        BOOL formDataBool = YES;
        
        int num = 0;
        for(NSString *filename in files)
        {
            NSURL *filePath = [NSURL fileURLWithPath:filename];
            NSString *fileStr = [NSString stringWithFormat:@"file%d",num++];
            switch (uploadType)
            {
                case Image_Png:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:fileStr fileName:[filePath lastPathComponent] mimeType:@"image/png" error:&error];
                }
                    
                    break;
                case Image_jpeg:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:fileStr fileName:[filePath lastPathComponent] mimeType:@"image/jpeg" error:&error];
                }
                    
                    break;
                case File_Zip:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:fileStr fileName:[filePath lastPathComponent] mimeType:@"application/octet-stream" error:&error];
                }
                    
                    break;
                case File_Other:
                {
                }
                    
                    break;
                case File_Xml:
                {
                    formDataBool = [formData appendPartWithFileURL:filePath name:fileStr fileName:[filePath lastPathComponent] mimeType:@"text/xml" error:&error];
                    break;
                }
                    
                default:
                    break;
            }
            
            if (formData == NO)
            {
                NSLog(@"Append part failed with error: %@", error);
            }
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    
        NSString *value = [self dealSuccResult:responseObject];
        
        block(value,YES);
        
        NSLog(@"result：%@",value);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //有一个文件上传成功都算是成功
        NSString *value = [NSString stringWithFormat:@"%@",error.description];

        block(value,NO);
        
        NSLog(@"Error: %@", value);
        
    }];
}

- (void)uploadFile:(NSString *)url parameters:(NSDictionary *)parameters filePath:(NSString *)filePath withType:(UploadType)uploadType withBlock:(receiveResponseBlock)block
{
    NSArray *arr = @[filePath];
    
    [self uploadFiless:url parameters:parameters fileArray:arr withType:uploadType withBlock:^(id result, BOOL succ) {
        
//        NSDictionary *dic = RDic(result);
        
        if(block)
            block(result,succ);
        
    }];
}
#pragma mark 上传图片到服务器
/**
 *  开始调用POST方法上传图片
 *
 *  @param url    URL
 *  @param params 参数描述
 *  @param files  image文件
 *  @param key    Key值
 */
- (void)startUpLoadImage:(NSString *)url parameters:(NSDictionary *)parameters files:(NSArray *)files withBlock:(receiveResponseBlock)block
{
    
    //图片处理
    NSMutableArray *fileArray;
    if (files && files.count>0)
    {
        fileArray = [NSMutableArray array];
        for (int i = 0; i<files.count; i++)
        {
            NSDictionary *dic = files[i];
            //上传的图片命名为image
            UIImage *image = dic[@"image"];
            
            NSData *data;
            if (UIImagePNGRepresentation(image) == nil)
            {
                //0.6为压缩系数
                data = UIImageJPEGRepresentation(image, 0.6);
            }
            else
            {
                data = UIImagePNGRepresentation(image);
            }
            
            //图片重命名
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [paths objectAtIndex:0];
            NSString *filePath = [cachePath stringByAppendingFormat:@"/showImage-%d.png",i];
            
            //图片保存路径
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:filePath contents:data attributes:nil];
            
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newDic setObject:filePath forKey:@"path"];
            [fileArray addObject:newDic];
            
        }
    }
    [self uploadFiles:url parameters:parameters fileArray:files withType:Image_Png withBlock:^(id result, BOOL succ) {
        block(result,succ);
    }];
}


#pragma mark 下载文件
/**
 *  去服务器下载文件
 *
 *  @param downloadUrl 下载的请求地址
 *  @param block (文件路径，成功与否)
 */
- (void)downloadFilewithURL:(NSString *)downloadUrl withBlock:(receiveResponseBlock)block
{
    
    [self reachNetWorkWithBlock:^(BOOL blean) {
        if (blean)
        {//有网络
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *urlString = [downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //请求时间为5秒，超过5秒为超时
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:12.0f];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                // 指定下载文件保存的路径
                NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
                
                return [NSURL fileURLWithPath:path];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                
                NSLog(@"下载成功，文件保存在%@",[filePath path]);
                
                block([filePath path],YES);
                
            }];
            
            [downloadTask resume];//启动下载任务
            
            //下载写入进度，test
            [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                // 设置进度条的百分比
                CGFloat precent = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
                
                if (precent == 1.0)
                {
                    
                }
                NSLog(@"----precent-->>>>>>>>%f", precent);
            }];
            
        }
        else
        {
            block(@"网络不佳",NO);
            
        }
    }];
}

- (void)downloadFilewithURL:(NSString *)downloadUrl filePath:(NSString *)_filePath withResult:(void(^)(BOOL succ,NSData *data,CGFloat percent))isSuccess
{
    
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    
    //请求时间为5秒，超过5秒为超时
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    
    NSURLSessionDownloadTask *_task=[session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        //NSLog(@"%f",downloadProgress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(isSuccess)
                isSuccess(YES,nil,downloadProgress.fractionCompleted);
        });
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //下载到哪个文件夹
        NSString *cachePath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *fileName=[cachePath stringByAppendingPathComponent:response.suggestedFilename];
        if(_filePath!=nil)
            fileName = _filePath;
        return [NSURL fileURLWithPath:fileName];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(!error)
        {
            //下载完成了
            NSLog(@"下载完成 %@",filePath);
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            if(isSuccess)
                isSuccess(YES,data,1.0);
        }
        else
            if(isSuccess)
                isSuccess(NO,nil,1.0);
        
    }];
    
    [_task resume];
}




#pragma mark POST与GET请求通用
/**
 *  核心请求 POST与GET请求通用
 *
 *  @param url        请求url
 *  @param parameters 请求参数
 *  @param method     GET @“GET” POST @“POST”
 */
- (void)startRequest:(NSString *)url parameters:(NSDictionary *)parameters httpMethod:(NSString *)method withBlock:(receiveResponseBlock)block
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setGeneralPropertyForManager:manager];
    
    if ([method isEqualToString:@"GET"])
    {
        [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            block([self dealSuccResult:responseObject],YES);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(error.description,NO);
        }];
    }
    else if ([method isEqualToString:@"POST"])
    {
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            block([self dealSuccResult:responseObject],YES);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            block(error.description,NO);
            
        }];
    }
    
}
#pragma mark AFN请求成功做的处理
- (id)dealSuccResult:(id)responseObject
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
    if (jsonObject)
    {
        return jsonObject;
    }
    else
    {
        if ([responseObject isKindOfClass:[NSData class]])
        {
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"非JsonObject:%@",str);
        }
        
        return responseObject;
    }
}

#pragma mark 设置AFHTTPSessionManager一些通用的属性
- (void)setGeneralPropertyForManager:(AFHTTPSessionManager *)manager
{
    AFNetworkReachabilityManager *netStateManager = [AFNetworkReachabilityManager sharedManager];
    [netStateManager startMonitoring];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    if (self.needAppendRequestHeader && self.httpHeaderFields)
    {
        //该属性设置会把你传的字典转化成JSON字符串，这个有待查看是否得设置
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        for (NSString *key in [self.httpHeaderFields allKeys])
        {
            [manager.requestSerializer setValue:[self.httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    AFSecurityPolicy* policy = [AFSecurityPolicy defaultPolicy];  //使用默认的设置
    
    [policy setAllowInvalidCertificates:YES];
    [policy setValidatesDomainName:NO];
    manager.securityPolicy = policy;
    
    
    //网络状态检查
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [netStateManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
        
    }];
    
}

#pragma mark - 使用AFN检测网络连接
- (void)reachNetWorkWithBlock:(void (^)(BOOL blean))block;
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         BOOL isconnect = NO;
         if ( status > 0 )
         {
             isconnect = YES;
         }
         block(isconnect);
     }];
}




/**********************************************系统封装接口***********************************************/

/**
 *  设置get Request的特性
 *
 *  @param urlString URL
 *  @param paras Request 的参数
 *
 *  @return 返回设置好的Request
 */
-(NSMutableURLRequest *)getPostRequest:(NSString *)urlString paras:(NSString *)paras
{
    
    NSString *post =[paras stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setURL:url];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

/**
 *  设置get request的特性
 *
 *  @param url URL
 *
 *  @return 返回设置好的Request
 */
-(NSMutableURLRequest *)getRequest:(NSString *)url
{
    url=[NSString stringWithFormat:@"%@",url];
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"get url=%@",url);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:12];
    [request setHTTPMethod:@"GET"];
    
    return request;
}

/**
 *  设置REquest的特性
 *
 *  @param urlString URL
 *  @param ParaDic   参数字典
 *  @param img       png图片
 *  @param imageName png图片的名称
 *
 *  @return 返回设置好的Request
 */
-(NSMutableURLRequest *)getRequestPostImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName
{
    NSLog(@"postToUrl:%@ Form:%@ imageKey:%@",urlString,ParaDic,imageName);
    NSString *boundary = @"iOS_fenda_zhuzhuxian_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", imageName,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(img)]];
    
    
    
    for (NSString*key in [ParaDic allKeys])
    {
        NSLog(@"%@ - %@",key,[ParaDic objectForKey:key]);
        NSString *value = [ParaDic objectForKey:key];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    //Now all we need to do is make a connection to the server and send the request:
    [request setHTTPBody:body];
    return request;//[NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

/**
 *  发送POST请求
 *
 *  @param Path    URL路径
 *  @param ParaDic 传入的参数
 */

-(void)postToPath:(NSString *)Path ParaDic:(NSDictionary *)ParaDic
{
    
    NSString *ParaString = nil;
    
    for (int i = 0; i <[ParaDic allKeys].count; i++)
    {
        NSString *key = [ParaDic allKeys][i];
        if (i == 0)
        {
            ParaString = [NSString stringWithFormat:@"%@=%@",key,ParaDic[key]];
        }
        else
        {
            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,ParaDic[key]];
        }
    }
    
    
    NSMutableURLRequest *request=[self getPostRequest:Path paras:ParaString];
    
    NSLog(@"url=%@",Path);
    NSLog(@"paras=%@",ParaString);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"responseCode=%ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            
            NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
            
            NSLog(@"responseData: %@",responseString);
            
            if (self.receiveResponseBlock)
            {
                self.receiveResponseBlock(data,YES);
            }
        }
        else
        {
            NSLog(@"error=%@",error.description);
            
            if (self.receiveResponseBlock)
            {
                self.receiveResponseBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
        
    }];
}

/**
 *  GET请求
 *
 *  @param Path    URL
 *  @param ParaDic 传入的参数
 */

-(void)getWithPath:(NSString *)Path  ParaDic:(NSDictionary *)ParaDic
{
    
    NSString *ParaString = nil;
    
    for (int i = 0; i <[ParaDic allKeys].count; i++)
    {
        NSString *key = [ParaDic allKeys][i];
        if (i == 0)
        {
            ParaString = [NSString stringWithFormat:@"%@=%@",key,ParaDic[key]];
        }
        else
        {
            ParaString= [NSString stringWithFormat:@"%@&%@=%@",ParaString,key,ParaDic[key]];
        }
    }
    
    NSMutableURLRequest *request=[self getRequest:[NSString stringWithFormat:@"%@?%@",Path,ParaString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!error && responseCode == 200) //根据返回值来确定返回结果
        {
            
            //NSString *responseString=[NSString stringWithUTF8String:[data bytes]];
            //NSLog(@"responseData: %@",responseString);
            if (self.receiveResponseBlock)
            {
                self.receiveResponseBlock(data,YES);
            }
        }
        else
        {
            if (self.receiveResponseBlock)
            {
                self.receiveResponseBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
    }];
    
}

/**
 *  更新IMG图片
 *
 *  @param urlString URL
 *  @param ParaDic   URL参数
 *  @param img       Image图片
 *  @param imageName Image名称
 */

-(void)uploadImageToUrl:(NSString *)urlString ParaDic:(NSDictionary*)ParaDic andImage:(UIImage*)img imageName:(NSString*)imageName
{
    
    NSMutableURLRequest *request=[self getRequestPostImageToUrl:urlString ParaDic:ParaDic andImage:img imageName:imageName];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"responseCode = %ld",(long)responseCode);
        if (!error && responseCode == 200)
        {
            NSLog(@"responseData: %@",[NSString stringWithUTF8String:[data bytes]]);
            
            if (self.receiveResponseBlock)
            {
                self.receiveResponseBlock(data,YES);
            }
        }
        else
        {
            NSLog(@"error=%@",error.description);
            
            if (self.receiveResponseBlock)
            {
                self.receiveResponseBlock([@"" dataUsingEncoding:NSUTF8StringEncoding],NO);
            }
        }
        
    }];
}


- (NSString*)dicToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (BOOL)isReachable {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return  [[AFNetworkReachabilityManager sharedManager] isReachable];
}

@end
