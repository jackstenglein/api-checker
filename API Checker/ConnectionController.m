//
//  ConnectionController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/17/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "ConnectionController.h"

@implementation ConnectionController {
    NSTimeInterval start;
}

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
    
    start = 0;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:self.methodType];
    [request setAllHTTPHeaderFields:self.headers];
    
    if(self.body.count > 0) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:self.body options:0 error:nil];
        [request setHTTPBody:postData];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        int time = (int)(([NSDate timeIntervalSinceReferenceDate] - start) * 1000);
        NSNumber *responseTime = [[NSNumber alloc] initWithInt:time];
        NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
        [res setObject:self.urlString forKey:@"requestURL"];
        
        if(error != nil) {
            [res setObject:error forKey:@"error"];
        } else {
            [res setObject:[[NSNumber alloc] initWithInteger:((NSHTTPURLResponse *)response).statusCode] forKey:@"statusCode"];
            [res setObject:responseTime forKey:@"responseTime"];
            
            NSDictionary *body = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if(body != nil) {
                [res setObject:body forKey:@"responseBody"];
            }
        }
        
        [self.delegate connectionFinished:self response:res];

    }];
    
    start = [NSDate timeIntervalSinceReferenceDate];
    [dataTask resume];
}

@end
