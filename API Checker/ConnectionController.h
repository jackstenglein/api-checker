//
//  ConnectionController.h
//  API Checker
//
//  Created by Jack Stenglein on 5/17/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @protocol ConnectionControllerDelegate
 @brief Informs the delegate object of the connection's status.
 */
@protocol ConnectionControllerDelegate
@required

/*!
 @brief Called when the connection finishes successfully.
 @param connection The id of this ConnectionController object.
 @param response The response data from the request.
 */
-(void)connectionFinished:(id)connection response:(NSDictionary *)response;

@end

/*!
 @interface ConnectionController
 @brief Defines public properties and methods of the ConnectionController class.
 */
@interface ConnectionController : NSObject

/*!
 @brief The URL to make HTTP requests to.
 */
@property (strong, nonatomic) NSString *urlString;

/*!
 @brief The HTTP method type of the request.
 @discussion Eg: "POST" or "GET"
 */
@property (strong, nonatomic) NSString *methodType;

@property (strong, nonatomic) NSDictionary *headers;

@property (strong, nonatomic) NSDictionary *body;

/*!
 @brief The ConnectionController's delegate.
 @discussion This object is notified when the connection finishes successfully or when it fails.
 */
@property (strong, nonatomic) id<ConnectionControllerDelegate> delegate;

/*!
 @brief Creates a new ConnectionController object with the given URL and method type.
 @param url The url of the HTTP request.
 @param methodType The HTTP method type of the request ("POST", "GET", etc).
 @return The id of the new ConnectionController object.
 */
-(id)initWithURL:(NSString *)url methodType:(NSString *)methodType body:(NSDictionary *)body andHeaders:(NSDictionary *)headers;

/*!
 @brief Makes the HTTP request with the given body data.
 @discussion The HTTP request uses the URL and method type set earlier. Currently, this method requires bodyData to function, but in future versions, passing nil for a GET request will work.
 */
-(void)makeRequest;

@end
