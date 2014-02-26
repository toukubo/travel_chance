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
- (void)webView:(UIWebView *)theWebView didFailLoadWithError:(NSError *)error
{

}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    DLog(@"request url - %@", urlString);
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self executeJobWhileCookieChanged:theWebView];
    
    if ([self needOpenExternalSafari:urlString]) {
        [WebClient openSafari:urlString];
        return NO;
    } else if ([urlString isMatchedByRegex:@"/Login"] || [urlString isMatchedByRegex:@"/Registration"]) {
        if ([urlString isMatchedByRegex:@"device_token="]) {
            return NO;
        } else {
            // remove the trailing slash of request url
            if ([[urlString substringFromIndex:[urlString length] - 1] isEqualToString:@"/"]) {
                urlString = [urlString substringToIndex:[urlString length] - 1];
            }
            
            urlString = [NSString stringWithFormat:@"%@?device_token=%@", urlString, appDelegate.deviceHexToken];
            
            [self loadUrl:urlString];
        }
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [SVProgressHUD dismiss];
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
    [SVProgressHUD show];
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

#pragma mark - Cookie Helper
- (void)executeJobWhileCookieChanged:(UIWebView*)theWebView
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] save];
}
@end
