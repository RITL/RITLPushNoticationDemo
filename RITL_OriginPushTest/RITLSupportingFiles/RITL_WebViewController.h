//
//  CB_WebViewController.h
//  CityBao
//
//  Created by YueWen on 16/8/3.
//  Copyright © 2016年 wangpj. All rights reserved.
//  基于WKWebView进行的网络游览器

// ----- 备注 - Yue - 2016-08-04
//  若要拓展功能请使用类目或继承自该类
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN //简化版 2016-09-28

NS_CLASS_AVAILABLE_IOS(8_0) @interface RITL_WebViewController : UIViewController

/// @brief 导航的标题
@property (nullable ,nonatomic, readonly, copy) NSString * navigatTitle;

/// @brief 进行浏览的游览器
@property (nonatomic, strong)WKWebView * webView;

/// @brief 进行加载的url
@property (nonatomic, readonly, copy) NSString * loadUrl;


/// 便利初始化方法
- (instancetype)initWithLoadUrl:(NSString *)url title:(NSString *)title navigationDelegate:(nullable id <WKNavigationDelegate>) navigationDelegate;
+ (instancetype)webViewWithLoadUrl:(NSString *)url title:(NSString *)title navigationDelegate:(nullable id <WKNavigationDelegate>) navigationDelegate;

@end

NS_ASSUME_NONNULL_END
