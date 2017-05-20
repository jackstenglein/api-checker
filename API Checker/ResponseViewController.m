//
//  ResponseViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/20/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "ResponseViewController.h"
#import "DictionaryTableViewCell.h"
#import "Constants.h"

#define UIColorFromHex(hexValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >>  8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:1.0]

@interface ResponseViewController ()

@end

@implementation ResponseViewController {
    FooterType footerType;
    NSArray *responseHeaderKeys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Request: %@", self.request);
    NSLog(@"Response: %@", self.response);
    
    [self setUpUI];
    responseHeaderKeys = [self.response[@"headers"] allKeys];
}

-(void)setUpUI {
    
    // change the title text
    NSString *requestName = self.request[@"requestName"];
    if(!(requestName == nil || [requestName isEqualToString:@""])) {
        self.titleLabel.text = requestName;
    } else {
        self.titleLabel.text = self.request[@"requestURL"];
    }
    
    // change the method type and url text
    self.methodTypeLabel.text = self.request[@"methodType"];
    self.urlLabel.text = self.request[@"requestURL"];
    
    // change the status text
    if(self.response[@"error"] != nil) {
        self.timeLabel.hidden = YES;
        self.statusLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Request Failed" attributes:@{ NSForegroundColorAttributeName: UIColorFromHex(0xE32636) }];
    } else {
        self.statusLabel.attributedText = [Constants descriptionForStatusCode:[self.response[@"statusCode"] intValue]];
        self.timeLabel.text = [NSString stringWithFormat:@"in %d ms", [self.response[@"responseTime"] intValue]];
    }
    
    // set the body text to a pretty-printed string
    NSError *error;
    NSObject *obj = [NSJSONSerialization JSONObjectWithData:self.response[@"responseBody"] options:kNilOptions error:&error];
    NSData *prettyPrintedData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:prettyPrintedData encoding:NSUTF8StringEncoding];
    self.bodyTextView.text = string;
    
    // format the headers table view
    self.headersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return responseHeaderKeys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headersCell" forIndexPath:indexPath];
    cell.keyTextField.text = responseHeaderKeys[indexPath.row];
    cell.valueTextField.text = self.response[@"headers"][responseHeaderKeys[indexPath.row]];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeFooterType:(UIButton *)sender {
    UIButton *selectedButton;
    UIButton *unselectedButton;
    UIView *selectedLine;
    UIView *unselectedLine;
    
    footerType = (FooterType)sender.tag;
    if(footerType == Body) {
        selectedButton = self.bodyButton;
        unselectedButton = self.headersButton;
        selectedLine = self.bodyUnderline;
        unselectedLine = self.headersUnderline;
        self.bodyFooterView.hidden = NO;
        self.headersFooterView.hidden = YES;
    } else {
        selectedButton = self.headersButton;
        unselectedButton = self.bodyButton;
        selectedLine = self.headersUnderline;
        unselectedLine = self.bodyUnderline;
        self.headersFooterView.hidden = NO;
        self.bodyFooterView.hidden = YES;
    }
    
    [selectedButton.titleLabel setFont:[UIFont fontWithName:selectedButton.titleLabel.font.fontName size:15.0]];
    [unselectedButton.titleLabel setFont:[UIFont fontWithName:unselectedButton.titleLabel.font.fontName size:13.0]];
    selectedLine.hidden = NO;
    unselectedLine.hidden = YES;
}
@end
