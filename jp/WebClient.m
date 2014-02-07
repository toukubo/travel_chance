//
//  WebClient.m
//  travel_change
//
//  Created by Alsor Zhou on 1/29/14.
//  Copyright (c) 2014 ap-com. All rights reserved.
//

#import "WebClient.h"

@implementation WebClient

+ (void)openSafari:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url != nil && ![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

@end
