//
//  RequestsViewController.h
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionController.h"

@interface RequestsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ConnectionControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *requestsTableView;
- (IBAction)editRequests:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)addRequest:(id)sender;

@end
