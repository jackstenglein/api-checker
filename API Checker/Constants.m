//
//  Constants.m
//  API Checker
//
//  Created by Jack Stenglein on 5/18/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libxml/tree.h>
#import "Constants.h"
#import "GDataXMLNode.h"

#define UIColorFromHex(hexValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >>  8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:1.0]

@implementation Constants

+(NSAttributedString *)descriptionForStatusCode:(int)statusCode {
    NSDictionary *attributes;
    NSString *string;
    if(statusCode >= 400) {
        attributes = @{ NSForegroundColorAttributeName: UIColorFromHex(0xE32636) };
    } else {
        attributes = @{ NSForegroundColorAttributeName: UIColorFromHex(0x25A20B) };
    }
    
    NSArray *array;
    switch(statusCode/100) {
        case 1:
            array = @[@"Continue", @"Switching Protocols", @"Processing"];
            break;
        case 2:
            array = @[@"OK", @"Created", @"Accepted", @"Non-Authoritative Information", @"No Content", @"Reset Content", @"Partial Content", @"Multi-Status", @"Already Reported", @"IM Used"];
            break;
        case 3:
            array = @[@"Multiple Choices", @"Moved Permanently", @"Found", @"See Other", @"Not Modified", @"Use Proxy", @"Switch Proxy", @"Temporary Redirect", @"Permanent Redirect"];
            break;
        case 4:
            array = @[@"Bad Request", @"Unauthorized", @"Payment Required", @"Forbidden", @"Not Found", @"Method Not Allowed", @"Not Acceptable", @"Proxy Authentication Required", @"Request Timeout", @"Conflict", @"Gone", @"Length Required", @"Precondition Failed", @"Payload Too Large", @"URI Too Long", @"Unsupported Media Type", @"Range Not Satisfiable", @"Expectation Failed", @"I'm a teapot", @"", @"", @"Misdirected Request", @"Unprocessable Entity", @"Locked", @"Failed Dependency", @"Upgrade Required", @"", @"Precondition Required", @"Too Many Requests", @"", @"Request Header Fields Too Large", @"Unavailable For Legal Reasons"];
            break;
        case 5:
            array = @[@"Internal Server Error", @"Not Implemented", @"Bad Gateway", @"Service Unavailable", @"Gateway Timeout", @"HTTP Version Not Supported", @"Variant Also Negotiates", @"Insufficient Storage", @"Loop Detected", @"", @"Not Extended", @"Network Authentication Required"];
            break;
        default:
            array = @[@""];
    }

    if((statusCode % 100) >= array.count ) {
        string = [array lastObject];
    } else {
        string = array[statusCode % 100];
    }
    
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d %@", statusCode, string] attributes:attributes];
}

+(NSAttributedString *)coloredJSON:(NSString *)rawString {
    return nil;
}

@end
