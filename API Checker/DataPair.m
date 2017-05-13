//
//  DataPair.m
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "DataPair.h"

@implementation DataPair

-(id)initWithKey:(NSString *)key andValue:(NSString *)value {
    self = [super init];
    if(self != nil) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
