//
//  CB_WebViewController.m
//  CityBao
//
//  Created by YueWen on 16/8/3.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import "RITL_WebViewController.h"

@interface RITL_WebViewController ()

//Data
@property (nonatomic, strong) id<WKNavigationDelegate> navigationDelegate;



@end

@implementation RITL_WebViewController

-(instancetype)initWithLoadUrl:(NSString *)url title:(nonnull NSString *)title navigationDelegate:(nullable id<WKNavigationDelegate>)navigationDelegate
{
    if (self = [super init])
    {
        _loadUrl = url;
        _navigatTitle = title;
        _navigationDelegate = navigationDelegate;
    }
    
    return self;
}

+(instancetype)webViewWithLoadUrl:(NSString *)url title:(nonnull NSString *)title navigationDelegate:(nullable id<WKNavigationDelegate>)navigationDelegate
{
    return [[self alloc] initWithLoadUrl:url title:title navigationDelegate:navigationDelegate];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view addSubview:self.webView];
    
    if (self.navigationController != nil)
    {
        self.navigationItem.title = _navigatTitle;
    }
    
    //开始加载
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]]];
 
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    _webView.navigationDelegate = nil;
    [self clearWebMemory];
//    DLog(@"RITL_WebViewController dealloc");

}


- (void)clearWebMemory
{
#ifdef __IPHONE_9_0
    
    if ([[UIDevice currentDevice].systemVersion compare:@"9.0"] != NSOrderedAscending)
    {
        //获得webView的数据kit
        WKWebsiteDataStore * webDataStore = [WKWebsiteDataStore defaultDataStore];
        
        //删除类型
        NSSet * set = [NSSet setWithArray:@[WKWebsiteDataTypeMemoryCache]];
        
        //当前时间
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:0];
        
        //清理缓存
        [webDataStore removeDataOfTypes:set modifiedSince:date completionHandler:^{
            
            NSLog(@"清理web");
            
        }];
    }
    
#endif
}




#pragma mark - Getter

-(WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:[[WKWebViewConfiguration alloc]init]];

        _webView.navigationDelegate = self.navigationDelegate;
    }
    
    return _webView;
}
@end
