//
//  DataPair.h
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPair : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;

-(id)initWithKey:(NSString *)key andValue:(NSString *)value;

@end
