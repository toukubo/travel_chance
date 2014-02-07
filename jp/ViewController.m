//
//  ViewController.m
//  travel_change
//
//  Created by veiz on 14-1-25.
//  Copyright (c) 2014年 ap-com. All rights reserved.
//

#import "ViewController.h"
#import "WebClient.h"

@interface ViewController () <UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kBaseUrl]];
    
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    DLog(@"request url - %@", urlString);
    
    if ([self needOpenExternalSafari:urlString]) {
        [WebClient openSafari:urlString];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    DLog(@"");
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
    DLog(@"");
}

#pragma mark - Helper
- (void)loadUrl:(NSString*)url
{
    // check if url malform
    if (![self isUrlMalform:url]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
}

- (BOOL)isUrlMalform:(NSString*)url
{
    // http://stackoverflow.com/a/3819561
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}

- (BOOL)needOpenExternalSafari:(NSString*)url
{
    if ([url isMatchedByRegex:@"target=_blank"]) {
        return YES;
    }
    
    return NO;
}
@end