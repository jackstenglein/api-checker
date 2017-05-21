//
//  ResponseViewController.h
//  API Checker
//
//  Created by Jack Stenglein on 5/20/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ResponseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSNumber *requestNumber;

@property (strong, nonatomic) NSDictionary *request;
@property (strong, nonatomic) NSDictionary *response;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (strong, nonatomic) IBOutlet UILabel *methodTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *bodyButton;
@property (strong, nonatomic) IBOutlet UIButton *headersButton;
@property (strong, nonatomic) IBOutlet UIView *bodyUnderline;
@property (strong, nonatomic) IBOutlet UIView *headersUnderline;

@property (strong, nonatomic) IBOutlet UIView *bodyFooterView;
@property (strong, nonatomic) IBOutlet UITextView *bodyTextView;

@property (strong, nonatomic) IBOutlet UIView *headersFooterView;
@property (strong, nonatomic) IBOutlet UITableView *headersTableView;
- (IBAction)changeFooterType:(UIButton *)sender;

- (IBAction)editRequest:(id)sender;
@end
