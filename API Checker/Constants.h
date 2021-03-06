//
//  Constants.h
//  API Checker
//
//  Created by Jack Stenglein on 5/18/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

@interface Constants : NSObject
+(NSAttributedString *)descriptionForStatusCode:(int)statusCode;
+(NSString *)prettyPrintXML:(NSString *)xmlString;
+(NSAttributedString *)coloredJSON:(NSString *)rawString;
@end

#endif /* Constants_h */
