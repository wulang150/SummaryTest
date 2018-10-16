//
//  LAFileManager.m
//  SummaryTest
//
//  Created by  Tmac on 2017/7/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "LAFileManager.h"

@implementation LAFileManager

//增加,创建文件夹
+ (NSString *)createFile:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0)
        return nil;
    
    char ss = [filePath characterAtIndex:filePath.length-1];
    if(ss=='/')
    {
        filePath = [filePath substringToIndex:filePath.length-1];
    }
    //取出文件路径
    NSRange range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.length<=0)
        return nil;
    NSString *folderPath = [filePath substringToIndex:range.location];
    
    if(folderPath==nil||folderPath.length==0)
        return nil;
    //文件夹不存在，就创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        NSLog(@"folderPath = %@",folderPath);
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!ret)
            return nil;
    }
    return filePath;
}

//去掉前后的'/'字符
+ (NSString *)filterStr:(NSString *)path
{
    char ss = [path characterAtIndex:0];
    if(ss=='/'&&path.length>1)
    {
        path = [path substringFromIndex:1];
    }
    ss = [path characterAtIndex:path.length-1];
    if(ss=='/')
    {
        path = [path substringToIndex:path.length-1];
    }
    
    return path;
}

+ (NSString *)getDefaultPath:(NSString *)defaultPath
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    char ss = [documentsDirectory characterAtIndex:0];
    if(ss=='/')
    {
        documentsDirectory = [documentsDirectory substringFromIndex:1];
    }
    
    if(defaultPath.length==0)
        return documentsDirectory;
    
    return [NSString stringWithFormat:@"%@/%@",documentsDirectory,[self filterStr:defaultPath]];
    
}

//对应特定的项目
+ (NSString *)getSavePath:(NSString *)subPath
{
    NSString *rootPath = [self getDefaultPath:@"mypro"];
    if(subPath.length<=0)
        return rootPath;
    return [NSString stringWithFormat:@"%@/%@",rootPath,[self filterStr:subPath]];
}
///////////增加
+ (BOOL)writeTextToDefaultPath:(NSString *)defaultPath text:(NSString *)text
{
    NSString *filePath = [self getSavePath:defaultPath];
    
    return [self writeTextToPath:filePath text:text];
}
+ (BOOL)appendTextToDefaultPath:(NSString *)defaultPath text:(NSString *)text
{
    NSString *filePath = [self getSavePath:defaultPath];
    return [self appendTextToPath:filePath text:text];
}
+ (BOOL)writeImageToDefaultPath:(NSString *)defaultPath image:(UIImage *)image
{
    NSString *filePath = [self getSavePath:defaultPath];
    return [self writeImageToPath:filePath image:image];
}
+ (BOOL)writeDataToDefaultPath:(NSString *)defaultPath data:(NSData *)data
{
    NSString *filePath = [self getSavePath:defaultPath];
    return [self writeDataToPath:filePath data:data];
}

//////////查询
+ (NSString *)getTextFromDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];
    return [self getTextFromPath:filePath];
}
+ (UIImage *)getImageFromDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];
    return [self getImageFromPath:filePath];
}
+ (NSData *)getDataFromDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];
    return [self getDataFromPath:filePath];
}

+ (NSData *)getDataFromDefaultRootPath:(NSString *)rootPath fileName:(NSString *)fileName
{
    NSString *filePath = [self getSavePath:rootPath];
    
    return [self getDataFromRootPath:filePath fileName:fileName];
}

//返回某个目录下的所有文件和文件夹
//rootPath需遍历的根目录  isIn是否深度遍历 hasDirectory是否包含文件夹
//containOrFilter 包含(YES)或过滤(NO) mstr:名称，包含(YES)或过滤(NO)的内容
+ (NSDictionary *)getAllFileFromDeFaultRootPath:(NSString *)rootPath isIn:(BOOL)isIn hasDirectory:(BOOL)hasDirectory containOrFilter:(BOOL)containOrFilter mstr:(NSString *)mstr
{
    NSString *filePath = [self getSavePath:rootPath];
    
    return [self getAllFileFromRootPath:filePath isIn:isIn hasDirectory:hasDirectory containOrFilter:hasDirectory mstr:mstr];
}

+ (float)getFileSizeWithDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];

    return [self getFileSizeWithPath:filePath];
    
}
//判断文件是否存在
+ (BOOL)fileIsExistWithDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];
    
    return [self fileIsExist:filePath];
}

/////////////删除

+ (BOOL)deleteFileWithDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];
    
    return [self deleteFileWithPath:filePath];
}

+ (BOOL)deleteAllWithDefaultPath:(NSString *)defaultPath
{
    NSString *filePath = [self getSavePath:defaultPath];
    
    return [self deleteAllWithPath:filePath];
}

///////////////修改
/**
 *  修改或移动文件或文件夹
 *
 *  @param srcFilePath 源路径
 *  @param decDefaultPath 目标路径
 *
 *  @return BOOL
 */
+ (BOOL)alterFileWithDefaultPath:(NSString *)srcFilePath decDefaultPath:(NSString *)decDefaultPath
{
    NSString *src = [self getSavePath:srcFilePath];
    NSString *dec = [self getSavePath:decDefaultPath];
    
    return [self alterFileWithPath:src decFilePath:dec];
}

//拷贝
+ (BOOL)copyFileWithDefaultPath:(NSString *)srcFilePath decDefaultPath:(NSString *)decDefaultPath
{
    NSString *src = [self getSavePath:srcFilePath];
    NSString *dec = [self getSavePath:decDefaultPath];
    
    return [self copyFileWithDefaultPath:src decDefaultPath:dec];
}


/////直接操作路径的，需要传入绝对路径
///////////增加
+ (BOOL)writeTextToPath:(NSString *)filePath text:(NSString *)text
{
    filePath = [self createFile:filePath];
    if(filePath==nil)
        return NO;
    
    return [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (BOOL)appendTextToPath:(NSString *)filePath text:(NSString *)text
{
    filePath = [self createFile:filePath];
    if(filePath==nil)
        return NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath])
    {
        NSLog(@"filePath = %@",filePath);
        return [fm createFileAtPath:filePath contents:[text dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(!outFile)
        return NO;
    [outFile seekToEndOfFile];
    [outFile writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    [outFile closeFile];
    return YES;
}
+ (BOOL)writeImageToPath:(NSString *)filePath image:(UIImage *)image
{
    filePath = [self createFile:filePath];
    if(filePath==nil)
        return NO;
    NSData* UIImagePNGRepresentation(UIImage *image);
    NSData* UIImageJPEGRepresentation (UIImage *image, CGFloat compressionQuality);
    NSData* imageData = UIImagePNGRepresentation(image);
    
    NSLog(@"saveImg：%@",filePath);
    return [imageData writeToFile:filePath atomically:YES];
}
+ (BOOL)writeDataToPath:(NSString *)filePath data:(NSData *)data
{
    filePath = [self createFile:filePath];
    if(filePath==nil)
        return NO;
    if(data==nil)
        return NO;
    if(![data isKindOfClass:[NSData class]])
        return NO;
    //如果为YES则保证文件的写入原子性,就是说会先创建一个临时文件,直到文件内容写入成功再导入到目标文件里
    return [data writeToFile:filePath atomically:YES];
}

//////////查询
+ (NSString *)getTextFromPath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0)
        return nil;
    NSData *myData = [[NSData alloc] initWithContentsOfFile:filePath];
    if(myData==nil)
        return nil;
    NSString *myString = [[NSString alloc]
                          initWithBytes:[myData bytes]
                          length:[myData length]
                          encoding:NSUTF8StringEncoding];
    
    return myString;
}
+ (UIImage *)getImageFromPath:(NSString *)filePath
{
    UIImage* image = nil;
    if([[self class] fileIsExist:filePath])
    {
        image = [[UIImage alloc] initWithContentsOfFile:filePath];
    }
    return image;
}
+ (NSData *)getDataFromPath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0)
        return nil;
    
    return [[NSData alloc] initWithContentsOfFile:filePath];
}
+ (NSString *)findFile:(NSString *)rootPath fileName:(NSString *)fileName
{
    if(rootPath==nil||rootPath.length==0||fileName==nil||fileName.length==0)
        return nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:rootPath error:nil];
    int j = 0;
    for(j=0;j<[array count];j++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"%@",array[j]];
        NSString *tmpPath = [[NSString alloc] initWithFormat:@"%@/%@",rootPath,name];
        NSDictionary *attri = [fileManager attributesOfItemAtPath:tmpPath error:nil];
        //文件
        if(![[attri fileType] isEqualToString:NSFileTypeDirectory])
        {
            if([name isEqualToString:fileName])
            {
                return tmpPath;
            }
        }
    }
    for(j=0;j<[array count];j++)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"%@",array[j]];
        NSString *tmpPath = [[NSString alloc] initWithFormat:@"%@/%@",rootPath,name];
        NSDictionary *attri = [fileManager attributesOfItemAtPath:rootPath error:nil];
        NSString *type = [attri fileType];
        //文件夹
        if([type isEqualToString:NSFileTypeDirectory])
        {
            NSString *ret = [[self class] findFile:tmpPath fileName:fileName];
            if(ret!=nil)
                return ret;
        }
    }
    
    return nil;
}

+ (NSData *)getDataFromRootPath:(NSString *)rootPath fileName:(NSString *)fileName
{
    NSString *path = [[self class] findFile:rootPath fileName:fileName];
    if(path==nil)
        return nil;
    NSLog(@"find：%@",path);
    return [[NSData alloc] initWithContentsOfFile:path];
}

//返回某个目录下的所有文件和文件夹
//rootPath需遍历的根目录  isIn是否深度遍历 hasDirectory是否包含文件夹
//containOrFilter 包含(YES)或过滤(NO) mstr:名称，包含(YES)或过滤(NO)的内容
+ (NSDictionary *)getAllFileFromRootPath:(NSString *)rootPath isIn:(BOOL)isIn hasDirectory:(BOOL)hasDirectory containOrFilter:(BOOL)containOrFilter mstr:(NSString *)mstr
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *fileDic = [NSMutableDictionary new];
    
    NSMutableArray *mulArr = [NSMutableArray new];
    if(isIn)
    {
        //遍历这个目录的第一种方法：（深度遍历，会递归枚举它的内容）
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:rootPath];
        
        NSString *filename;
        while ((filename = [dirEnum nextObject]) != nil)
        {
            [mulArr addObject:filename];
            
        }
    }
    else
    {
        //遍历目录的另一种方法：（不递归枚举文件夹种的内容）
        mulArr = [[fm directoryContentsAtPath:rootPath] mutableCopy];
    }
    
    for(NSString *filename in mulArr)
    {
        BOOL flag;
        
        NSString *key = [NSString stringWithFormat:@"%@/%@",rootPath,filename];
        if(hasDirectory) //过滤掉文件夹
        {
            [fm fileExistsAtPath:key isDirectory:&flag];
            if(flag)
                continue;
        }
        
        if(mstr.length>0)
        {
            //过滤文件
            BOOL ret = containOrFilter?![filename containsString:mstr]:[filename containsString:mstr];
            if(ret)
                continue;
        }
        
        NSArray *nameArr = [filename componentsSeparatedByString:@"/"];
        NSString *value = [nameArr lastObject];
        if(value)
        {
            [fileDic setObject:value forKey:key];
        }
        
    }
    
    return fileDic;
}
/**
 *  获取文件大小
 *
 *  @param filePath 绝对路径
 *
 *  @return 文件大小，单位kb
 */
+ (float)getFileSizeWithPath:(NSString *)filePath
{
    float fileSize=0.0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:filePath];
    
    if(success)
    {
        NSDictionary *fileAttributes=[fileManager attributesOfItemAtPath:filePath error:nil];
        
        if (fileAttributes!=nil) {
            
            fileSize = [fileAttributes fileSize]/(1024.0);
        }
    }
    NSLog(@"文件的大小=%f k",fileSize);
    
    return fileSize;
}
//判断文件是否存在
+ (BOOL)fileIsExist:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0)
        return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

/////////////删除
/**
 *  删除文件或文件夹
 *
 *  @param filePath 绝对路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteFileWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:filePath];
    if(!success)
    {
        return FALSE;
    }
    else
    {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
}
/**
 *  删除文件夹目录下说有的东西（但不删除此文件夹）
 *
 *  @param filePath 绝对路径
 *
 *  @return BOOL
 */
+ (BOOL)deleteAllWithPath:(NSString *)filePath
{
    if(filePath==nil||filePath.length==0)
        return NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:filePath];
    if(!success)
        return FALSE;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    //NSLog(@"%@",[fileManager contentsOfDirectoryAtPath:filePath error:nil]);
    for (int j=0; j<[array count]; j++) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",filePath,[array objectAtIndex:j]] error:nil];
    }
    
    
    return YES;
}

///////////////修改
/**
 *  修改或移动文件或文件夹
 *
 *  @param srcFilePath 源路径
 *  @param decFilePath 目标路径
 *
 *  @return BOOL
 */
+ (BOOL)alterFileWithPath:(NSString *)srcFilePath decFilePath:(NSString *)decFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:srcFilePath];
    if(!success)
    {
        return NO;
    }
    decFilePath = [self createFile:decFilePath];
    if(decFilePath==nil)
        return NO;
    NSError *error;
    BOOL ret = [fileManager moveItemAtPath:srcFilePath toPath:decFilePath error:&error];
    if(!ret)
    {
        NSLog(@"error = %@",error);
    }
    return ret;
}

//拷贝
+ (BOOL)copyFileWithPath:(NSString *)srcFilePath decFilePath:(NSString *)decFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:srcFilePath];
    if(!success)
    {
        return NO;
    }
    
    decFilePath = [self createFile:decFilePath];
    if(decFilePath==nil)
        return NO;
    NSError *error;
    BOOL ret = [fileManager copyItemAtPath:srcFilePath toPath:decFilePath error:&error];
    if(!ret)
    {
        NSLog(@"error = %@",error);
    }
    return ret;
}
@end
