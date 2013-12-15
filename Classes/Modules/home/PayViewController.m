//
//  PayViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-11-26.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "PayViewController.h"
#import "AlixPayOrder.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "UPPayPlugin.h"
#import <QuartzCore/QuartzCore.h>


#define TF_X1   33
#define TF_Y1   55
@interface PayViewController ()

@end

@implementation PayViewController

@synthesize isYl = _isYl;
@synthesize isZf = _isZf;
@synthesize zfbutton = _zfbutton;
@synthesize ylbutton = _ylbutton;
@synthesize bookname = _bookname;
@synthesize price = _price;
@synthesize result = _result;
@synthesize bookId = _bookId;
@synthesize sure = _sure;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithNamePrice:(NSString *) bookName pprice:(float) price bookId:(NSString*)bookId shouldSure:(BOOL) sure
{
    if (self = [super init]) {
        _bookname = bookName;
        _price = price;
        _bookId = bookId;
        _sure = sure;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _result = @selector(paymentResult:);
    
    self.hasHomeButton = YES;
    self.hasSureButton = YES;
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]] ];
   
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        //titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"支付方式";
        self.navigationItem.titleView = titleLabel;
    }
    if (_sure) {
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureButton setFrame:CGRectMake(260, 7, 50, 30)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton.titleLabel setTextColor:[UIColor whiteColor]];
        [sureButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [sureButton setTag:1010];
        [sureButton setBackgroundImage:[UIImage imageNamed:@"rightcorner_n.png"] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(PayAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.visibleViewController.navigationController.navigationBar addSubview:sureButton];
    }
    
    float height = 480.0f;
    float height_2 = 0.0f;
    if(iPhone5){
        height =518.0f;
        height_2 = 20.0f;
    }
    UIImageView *myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,height)];
    [myView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg.png"]]];
    [myView setUserInteractionEnabled:YES];
    [self.view addSubview:myView];
    
    UILabel *lables = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 160, 30)];
    [lables setBackgroundColor:[UIColor clearColor]];
    [lables setFont:[UIFont boldSystemFontOfSize:20]];
    [lables setTextColor:[UIColor  blackColor]];
    [lables setText:@"请选择支付方式："];
    [myView addSubview:lables];
    
    UIImageView *payView = [[UIImageView alloc]initWithFrame:CGRectMake(10,70, 300,150)];
    payView.layer.borderWidth = 1;
    payView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    payView.layer.cornerRadius = 8.0;
    [myView addSubview:payView];
    
    _zfbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zfbutton setFrame:CGRectMake(TF_X1, 100+height_2, 17, 17)];
    _isZf = YES;
    _isYl = NO;
    if(_isZf){
        [_zfbutton setImage:[UIImage imageNamed:@"pay_s.png"] forState:UIControlStateNormal];
    }else{
        [_zfbutton setImage:[UIImage imageNamed:@"pay_n.png"] forState:UIControlStateNormal];
    }
    [_zfbutton addTarget:self action:@selector(zfbPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_zfbutton];
    
    UIImageView *zfimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zfb.png"]];
    [zfimg setFrame:CGRectMake(TF_X1+30,100+height_2, 103, 30)];
    [zfimg setUserInteractionEnabled:YES];
    [myView addSubview:zfimg];
    
    _ylbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ylbutton setFrame:CGRectMake(TF_X1, 160+height_2, 17, 17)];
    if(_isYl){
        [_ylbutton setImage:[UIImage imageNamed:@"pay_s.png"] forState:UIControlStateNormal];
    }else{
        [_ylbutton setImage:[UIImage imageNamed:@"pay_n.png"] forState:UIControlStateNormal];
    }
    [_ylbutton addTarget:self action:@selector(ylPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:_ylbutton];
    
    UIImageView *ylimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yinlan.png"]];
    [ylimg setFrame:CGRectMake(TF_X1+30,160+height_2, 103, 30)];
    [ylimg setUserInteractionEnabled:YES];
    [myView addSubview:ylimg];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
#if ! __has_feature(objc_arc)
    AlixPayResult* result = [[[AlixPayResult alloc] initWithString:resultd] autorelease];
#else
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
#endif
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
    
}



#pragma mark-
#pragma mark--按钮点击事件
/**
 *  选择支付宝方式
 *
 *  @param sender
 */
-(void)zfbPayAction:(id)sender
{
    _isZf = !_isZf;
    if(_isZf){
        [_zfbutton setImage:[UIImage imageNamed:@"pay_s.png"] forState:UIControlStateNormal];
    }else{
        [_zfbutton setImage:[UIImage imageNamed:@"pay_n.png"] forState:UIControlStateNormal];
    }
    _isYl = !_isZf;
    if(_isYl){
        [_ylbutton setImage:[UIImage imageNamed:@"pay_s.png"] forState:UIControlStateNormal];
    }else{
        [_ylbutton setImage:[UIImage imageNamed:@"pay_n.png"] forState:UIControlStateNormal];
    }
}

/**
 *  选择银联方式
 *
 *  @param sender
 */
-(void)ylPayAction:(id)sender
{
    _isYl = !_isYl;
    if(_isYl){
        [_ylbutton setImage:[UIImage imageNamed:@"pay_s.png"] forState:UIControlStateNormal];
    }else{
        [_ylbutton setImage:[UIImage imageNamed:@"pay_n.png"] forState:UIControlStateNormal];
    }
    _isZf = !_isYl;
    if(_isZf){
        [_zfbutton setImage:[UIImage imageNamed:@"pay_s.png"] forState:UIControlStateNormal];
    }else{
        [_zfbutton setImage:[UIImage imageNamed:@"pay_n.png"] forState:UIControlStateNormal];
    }
}

/**
 *  确认支付
 *
 *  @param sender
 */
-(void)PayAction:(id)sender
{
    if(_isYl){//银联支付
        NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:[UserDefaults objectForKey:KUSERNAME],@"userName",[_bookname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"goodsName",[NSString stringWithFormat:@"%.2f",_price],@"goodsPrice",_bookId,@"bookId", nil];
        AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                             sendRequestWithRequestDic:requestDic
                                             requesId:YLLS
                                             messId:nil
                                             success:^(id obj) {
                                                 mData = [obj objectForKey:@"tn"];
                                                 if([[obj objectForKey:@"rs"]intValue] == 1){
                                                     if (mData != nil && mData.length > 0)
                                                     {
                                                         [UPPayPlugin startPay:mData mode:kMode viewController:self.navigationController delegate:self];
                                                     }
                                                     
                                                 }else if([[obj objectForKey:@"rs"]intValue] == 0){
                                                     [SVProgressHUD showErrorWithStatus:@"失败！"];
                                                 }
                                             } failure:^(NSString *errMsg) {
                                                 
                                             }];
        [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在连接..." completeBlock:^(NSArray *operations) {
            
        }];
       
    }
    if(_isZf){//支付宝支付
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法
         */
        
        NSString *appScheme = @"ZFManual4iphone";
        /*
         *生成订单信息及签名
         *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法
         */
        AlixPayOrder *order = [[AlixPayOrder alloc] init];
        order.partner = PartnerID;
        order.seller = SellerID;
        
        order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
        order.productName = _bookname; //商品标题
        order.productDescription = [NSString stringWithFormat:@"%@andby%@",_bookname,[UserDefaults objectForKey:KUSERNAME]]; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",_price]; //商品价格
        order.notifyURL =  @"http://220.231.55.105/zjzfWebApp/notify_url.jsp"; //回调URL
        
        NSString *orderInfo = [order description];
        NSString* signedStr = [self doRsa:orderInfo];
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:_result target:self];
    }
}

#pragma mark-
#pragma mari--支付回调
- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

// 银联支付返回结果
- (void)UPPayPluginResult:(NSString *)result
{
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-70)];

    NSLog(@"UPPay Result : %@", result);
}




@end
