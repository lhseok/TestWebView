//
//  ViewController.m
//  WebViewTest
//
//  Created by leehoseok on 2018. 3. 22..
//  Copyright © 2018년 leehoseok. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, retain) WKWebView *wkWebView;
@property (nonatomic, retain) UILabel *lblLog;
@property (nonatomic, retain) NSDate *date;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect;
    UIButton *btn;
    CGFloat f = [UIApplication sharedApplication].statusBarFrame.size.height;
    UIFont *font = [UIFont systemFontOfSize:11];
    UIColor *bgColor = [UIColor darkGrayColor];
    UIColor *textColor = [UIColor whiteColor];
    
    rect = CGRectMake(0, f + 40, self.view.frame.size.width, self.view.frame.size.height - (f + 40));
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.processPool = [[self class] processPool];
    WKWebView *wk = [[WKWebView alloc] initWithFrame:rect configuration:configuration];
    wk.UIDelegate = self;
    wk.navigationDelegate = self;
    wk.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:wk];
    self.wkWebView = wk;
    
    rect = CGRectMake(self.view.frame.size.width - 100, f, 90, 30);
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = bgColor;
    lbl.textColor = textColor;
    lbl.font = font;
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl];
    self.lblLog = lbl;
    
    rect = CGRectMake(10, f, 90, 30);
    btn = [[UIButton alloc] initWithFrame:rect];
    btn.backgroundColor = bgColor;
    btn.titleLabel.font = font;
    [btn setTitle:@"새창" forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    rect.origin.x += rect.size.width + 10;
    btn = [[UIButton alloc] initWithFrame:rect];
    btn.backgroundColor = bgColor;
    btn.titleLabel.font = font;
    [btn setTitle:@"load reqeust" forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)request
{
    _lblLog.text = @"로딩중..";
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSArray *arr = @[@"http://www.naver.com"];//, @"http://www.daum.net", @"http://apple.com"];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:arr[(arc4random() % arr.count)]]]];
}

- (void)didClickButton1:(UIButton *)button
{
    ViewController *vc = [[ViewController alloc] init];
    UIColor *color = [UIColor colorWithRed:(float)(arc4random() % 255)/255 green:(float)(arc4random() % 255)/255 blue:(float)(arc4random() % 255)/255 alpha:1];
    vc.view.backgroundColor = color;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    CGRect rect = vc.view.frame;
    CGRect rectFrom = rect;
    rectFrom.origin.x += rectFrom.size.width;
    vc.view.frame = rectFrom;
    
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.frame = rect;
    }];
}

- (void)didClickButton2:(UIButton *)button
{
    [self request];
}

+ (WKProcessPool *)processPool {
    static WKProcessPool *sharedProcessPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProcessPool = [[WKProcessPool alloc] init];
    });
    return sharedProcessPool;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    self.date = [NSDate date];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSTimeInterval n = [[NSDate date] timeIntervalSinceDate:_date];
    _lblLog.text = [NSString stringWithFormat:@"%.02fs", n];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
