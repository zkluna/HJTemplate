//
//  HJBaseRequest.m
//  HKProject
//
//  Created by rubick on 2018/7/24.
//  Copyright © 2018年 hjkl. All rights reserved.
//

#import "HJBaseRequest.h"
#import "HJNetworkAgent.h"
#import "HJNetworkPrivate.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

NSString *const HJRequestValidationErrorDomain = @"com.hjkl.request.validation";

@interface HJBaseRequest ()

@property (strong, nonatomic, readwrite) NSURLSessionTask *requestTask;
@property (strong, nonatomic, readwrite) NSData *responseData;
@property (strong, nonatomic, readwrite) id responseJSONObject;
@property (strong, nonatomic, readwrite) id responseObject;
@property (strong, nonatomic, readwrite) NSString *responseString;
@property (strong, nonatomic, readwrite) NSError *error;

@end

@implementation HJBaseRequest

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}
- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}
- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}
- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}
- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}
- (BOOL)isCacelled {
    if(!self.requestTask){
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}
- (BOOL)isExecuting {
    if(!self.requestTask){
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}
- (void)setCompletionBlockWithSuccess:(HJRequestCompletionBlock)success failure:(HJRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}
- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}
- (void)start {
    [[HJNetworkAgent shareAgent] addRequest:self];
}
- (void)stop {
    self.delegate = nil;
    [[HJNetworkAgent shareAgent] cancelRequest:self];
}
- (void)startWithCompletionBlockWithSuccess:(HJRequestCompletionBlock)success failure:(HJRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}
- (NSString *)requestUrl {
    return @"";
}
- (NSString *)cdnUrl {
    return @"";
}
- (NSString *)baseUrl {
    return @"";
}
- (NSTimeInterval)requestTimeoutInterval {
    return 75;
}
- (id)requestArgument {
    return nil;
}
- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}
- (HJRequestMethod)requestMethod {
    return HJRequestMethodGET;
}
- (HJRequestSerializer)requestSerializerType {
    return HJRequestSerializerHTTP;
}
- (HJResponseSerializer)responseSerializerType {
    return HJResponseSerializerJSON;
}
- (NSArray<NSString *> *)requestAuthorizationHeaderFieldArray {
    return nil;
}
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return nil;
}
- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}
- (BOOL)useCDN {
    return NO;
}
- (BOOL)allowsCellularAccess {
    return YES;
}
- (id)jsonValidator {
    return nil;
}
- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}

@end
