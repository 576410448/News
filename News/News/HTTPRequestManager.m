//
//  HTTPRequestManager.m
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "HTTPRequestManager.h"

@interface HTTPRequest : NSObject<NSURLConnectionDelegate>

@property (nonatomic ,copy) NSString *urlStr;

@property (nonatomic ,copy) void(^callback)(BOOL success,NSData *data);

-(void)startRequest;

@end

@implementation HTTPRequest
{
    NSMutableData *_data;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)startRequest{
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]] delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _data.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    _callback(YES,_data);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _callback(NO,nil);
}

@end

@implementation HTTPRequestManager
{
    HTTPRequest *_request;
}
+(id)manager{
    static HTTPRequestManager *_h = nil;
    if (!_h) {
        _h = [[HTTPRequestManager alloc] init];
    }
    return _h;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _request = [[HTTPRequest alloc] init];
    }
    return self;
}

-(void)GET:(NSString *)urlStr complete:(void(^)(BOOL success ,NSData *data))callback{
    _request.urlStr = urlStr;
    _request.callback = callback;
    [_request startRequest];
    
}

-(void)GET:(NSString *)urlStr complete:(void (^)(BOOL success, NSData *))callback isCache:(BOOL)chche{
    
}


























@end
