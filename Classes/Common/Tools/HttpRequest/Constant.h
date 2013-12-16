//
//  Constant.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-17.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "DeviceSystemUtil.h"
//宏定义，方便调用
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define kVERSION                        @"3" // 当前程序的版本号，以此值与服务器进行比对，确定版本更新

#define kREMEBERPWD                     @"remeberPWD"
#define kAUTOLOGIN                      @"autoLogin"
#define KUSERNAME                       @"userName"
#define kPASSWORD                       @"password" // 保存用户输入的密码

#define kCOUNT_HOME                     @"count_HOME"
#define kCOUNT_SECH                     @"count_SECH"
#define kCOUNT_GRZX                     @"count_GRZX"
#define kCOUNT_BCAR                     @"count_BCAR"
#define kCOUNT_MORE                     @"count_MORE"
#define kURL                            @"http://220.231.55.105" //下载地址


//支付宝信息
// 合作身份者ID，以2088开头由16位纯数字组成的字符串
#define PartnerID @"2088111062893317"
// 商户签约支付宝账号
#define SellerID  @"2088111062893317"
//安全校验码（MD5）密钥  用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取
#define MD5_KEY @"kvbf3asuniafn6467dmzjl3a853ka60h"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALileI1YdFOxbWthiuTV2DV7+D75Siw78yj38y7hhaBvkHNqObzcnUIyIYDU5ZHW814kwnPSZy8SonO67hUY18XV1fmslyP8nK3LqzTfG4ECnHhzLG9+HY/E7PWfQUj3EjNb1VXJKIAMjx+1xwLF642KgSrBRAizGjFzi4WEAxizAgMBAAECgYA2o3ht0wvxLCKl0OJp3sGw6fNGpzwEpOTKbby/VarWE81Z6cgWE+5RBUaWuekI4+N2K0iDP3KbIleCCYGkKorGlfbwTAxUfcwEZokLTQyK/Z3VST8dANa8Gw/4yQMNZ3s2fcymFd2Zq/wbVbjtI0G5Aa+mdt8GSWpWZ9qkRz4esQJBAOreH46rfLmIkjDjYesrNtn0LDdk0Rj7A2EBS6NCH3RSNqjUS1ZehoDE5OVH7K+tySOoKFe4IjZK3Ol2IDuPEXkCQQDJQpBuW2Bfd2aCzWWY+Z88HhM+zCSsLys/3lwZzlB1cuHtnPEfblryIy9EIW35bRaH3fUqSFZez05ipxN+TnyLAkARvybzSNHr0v3447WKZ4GFhoWwydVi5dSjh82HUH+/8lZe+2uV4x6WrEn/aSfhPmhsYVBrEGbFY3K90UcuOOlBAkBhkd+rYKlMHvqXlzQWAY5s+rehzh5JS2TQReCoshjXl6ZoJ5nN/xYgJWaYxQwny/cMT1K3+PHGbQI3WYBdz3cZAkEAnucvJHCcs/m0mHHw9J1zHjKtmEu/SntwijLLTDtKHT9RQKzqliRxd+itWXQSYlCGOvkEtXxWaEfAYtjjoQiWGA=="

//支付宝公钥，用签约支付宝账号登录ms.alipay.com后获取。
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDXCvIyzEUi0xJVAB8d+HPxQKBjvhU0x2IwoSu3UQ9ZBbAKVL/r863MHnp5pNdwNkS+DMEPQROOuBSUA4eU7wHr8fG1XxHRv9WcN6uIab3WjjpIRMunARnUjrvNlzZ3hmV8JV86GKGt/N5w2G23W36KnMpbzUePdrxUFB7HGda14QIDAQAB"

//银联信息

#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kMode             @"00"
#define kConfigTnUrl      @"http://222.66.233.198:8080/sim/app.jsp?user=%@"
#define kNormalTnUrl      @"http://222.66.233.198:8080/sim/gettn"
//#define kNormalTnUrl      @"http://220.231.55.105/zjzfWebApp/buylog.action?m=frontTransNumber"


// 注意此值并不是真正的联网地址，真正的地址在登录成功后返回，存于 kREALHOST 中
#define DEFAULTHOST                     @"http://220.231.55.105"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define STRETCH                                5

#define IS_IOS_7 (DeviceSystemMajorVersion() >= 7)

#define kCollectTableName  @"CollectTable"  //收藏表名
#define kDataBaseName      @"zjzfDB"        //数据库文件夹

@interface Constant : NSObject

@end
