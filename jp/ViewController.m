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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kBaseUrl]];
    
    NSArray *storedCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookies = [NSHTTPCookie requestHeaderFieldsWithCookies:storedCookies];
    [request setAllHTTPHeaderFields:cookies];
    
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
    DLog(@"cookie - %@", request.allHTTPHeaderFields);
    
    [self executeJobWhileCookieChanged:theWebView];
    
    if (([[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] count] >= 3) &&       // cookie should have at least 3 fields, PHPSESSID, user, users_id
        IsEmpty(request.allHTTPHeaderFields[@"Cookie"])) {
        
        DLog(@"Empty cookie in request");
        [self loadUrl:urlString];
        
        return NO;
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self needOpenExternalSafari:urlString]) {
        [WebClient openSafari:urlString];
        return NO;
    } else if ([urlString isMatchedByRegex:kWSApiLogin] || [urlString isMatchedByRegex:kWSApiRegister]) {
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
    } else if ([urlString isMatchedByRegex:kWSApiLogout]) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *storedCookies = [cookieStorage cookies];
        for (NSHTTPCookie *cookie in storedCookies) {
            [cookieStorage deleteCookie:cookie];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSArray *storedCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookies = [NSHTTPCookie requestHeaderFieldsWithCookies:storedCookies];
    [request setAllHTTPHeaderFields:cookies];
    
    [self.webView loadRequest:request];
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
//    DLog(@"%@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] save];
}
@end
