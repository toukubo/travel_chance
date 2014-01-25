//
//  DLog.h
//  TaoBaobei
//
//  Created by Alsor Zhou on 12-4-7.
//  Copyright (c) 2012年 EIJUS. All rights reserved.
//

#ifndef EIJUS_DLog_h
#define EIJUS_DLog_h

#ifdef DEBUG
#define FLog() NSLog(@"%s", __PRETTY_FUNCTION__)
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define DLine DLog(@"------------------------------")
//#define DLog(...) TFLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#define DLine do { } while (0)
//#define DLog(...) TFLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define FLog() do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)

#endif
