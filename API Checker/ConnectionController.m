//
//  ConnectionController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/17/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "ConnectionController.h"

@implementation ConnectionController

-(id)init {
    return [self initWithURL:nil methodType: nil body:nil andHeaders:nil];
}

-(id)initWithURL:(NSString *)url methodType:(NSString *)methodType body:(NSDictionary *)body andHeaders:(NSDictionary *)headers {
    self = [super init];
    if(self != nil) {
        self.urlString = url;
        self.methodType = methodType;
        self.body = body;
        self.headers = headers;
    }
    
    return self;
}

-(void)makeRequest {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:self.methodType];
    [request setAllHTTPHeaderFields:self.headers];
    
    if(self.body.count > 0) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:self.body options:0 error:nil];
        [request setHTTPBody:postData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self.delegate connectionFailed:self error:error];
        } else {
            NSLog(@"URL response: %@", response);
            [self.delegate connectionFinished:self response:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
        }
    }];
    
    [dataTask resume];
}

@end
