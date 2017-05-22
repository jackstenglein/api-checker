//
//  ResponseViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/20/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "ResponseViewController.h"
#import "DictionaryTableViewCell.h"
#import "EditRequestViewController.h"
#import "JSONSyntaxHighlight.h"
#import "Constants.h"

#define UIColorFromHex(hexValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((hexValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)(hexValue & 0x0000FF))/255.0 \
    alpha:1.0]

@interface ResponseViewController ()

@end

@implementation ResponseViewController {
    FooterTypes footerType;
    NSArray *responseHeaderKeys;
    NSMutableArray<NSNumber *> *displayTruncatedMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Request: %@", self.request);
    NSLog(@"Response: %@", self.response);
    
    [self setUpUI];
    responseHeaderKeys = [self.response[@"headers"] allKeys];
    displayTruncatedMode = [[NSMutableArray alloc] initWithCapacity:responseHeaderKeys.count];
    for(int i = 0; i < responseHeaderKeys.count; i++) {
        [displayTruncatedMode addObject:@(NO)];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    NSLog(@"Scroll view gesture recognizers: %lu", scrollView.gestureRecognizers.count);
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
    if(self.response[@"responseBody"]){
        NSString *string;
        NSError *error;
        NSObject *obj = [NSJSONSerialization JSONObjectWithData:self.response[@"responseBody"] options:kNilOptions error:&error];
        if(obj == nil) {
            string = [[NSString alloc] initWithData:self.response[@"responseBody"] encoding:NSUTF8StringEncoding];
            if(string == nil)
                string = [[NSString alloc] initWithData:self.response[@"responseBody"] encoding:NSASCIIStringEncoding];
            
            self.bodyTextView.text = string;
        } else {
            JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:obj];
            jsh.nonStringAttributes = @{NSForegroundColorAttributeName: UIColorFromHex(0x00008b)};
            jsh.stringAttributes = @{NSForegroundColorAttributeName: UIColorFromHex(0x2a00ff)};
            jsh.keyAttributes = @{NSForegroundColorAttributeName: UIColorFromHex(0xE32636)};
            NSAttributedString *test = [jsh highlightJSON];
            self.bodyTextView.attributedText = test;
        }
    }
    
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
    if(displayTruncatedMode[indexPath.row].boolValue) {
        cell.longValueScrollView.hidden = NO;
        cell.longValueScrollView.delegate = self;
        cell.longValueLabel.text = self.response[@"headers"][responseHeaderKeys[indexPath.row]];
        
        if(cell.longValueScrollView.gestureRecognizers.count == 2) {
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            singleTapGestureRecognizer.cancelsTouchesInView = NO;
            [cell.longValueScrollView addGestureRecognizer:singleTapGestureRecognizer];
        }
        
        cell.keyTextField.hidden = YES;
        cell.valueTextField.hidden = YES;
        cell.colonLabel.hidden = YES;
    } else {
        cell.longValueScrollView.hidden = YES;
        
        cell.keyTextField.text = responseHeaderKeys[indexPath.row];
        cell.valueTextField.text = self.response[@"headers"][responseHeaderKeys[indexPath.row]];
        //[cell.longValueScrollView setContentSize:CGSizeMake(cell.longValueLabel.bounds.size.width, cell.longValueLabel.bounds.size.height)];
        
        
        [cell.keyTextFieldTrailing setActive:YES];
        cell.keyTextField.hidden = NO;
        cell.valueTextField.hidden = NO;
        cell.colonLabel.hidden = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DictionaryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGSize textSize = [cell.valueTextField.text sizeWithFont:cell.valueTextField.font];
    if(textSize.width > cell.valueTextField.bounds.size.width || displayTruncatedMode[indexPath.row].boolValue) {
        [displayTruncatedMode replaceObjectAtIndex:indexPath.row withObject:@(!displayTruncatedMode[indexPath.row].boolValue)];
        [tableView reloadData];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    for(int i = 0; i < displayTruncatedMode.count; i++) {
        if(displayTruncatedMode[i].boolValue) {
            DictionaryTableViewCell *cell = [self.headersTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if([cell.longValueScrollView.gestureRecognizers containsObject:gesture]) {
                [displayTruncatedMode replaceObjectAtIndex:i withObject:@(NO)];
                [self.headersTableView reloadData];
            }
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"showEditRequest"]) {
        EditRequestViewController *destVC = [segue destinationViewController];
        destVC.request = self.request;
        destVC.requestNumber = self.requestNumber;
    }
}


- (IBAction)changeFooterType:(UIButton *)sender {
    UIButton *selectedButton;
    UIButton *unselectedButton;
    UIView *selectedLine;
    UIView *unselectedLine;
    
    footerType = (FooterTypes)sender.tag;
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

- (IBAction)editRequest:(id)sender {
    [self performSegueWithIdentifier:@"showEditRequest" sender:nil];
}

-(IBAction)returnFromEditRequest:(UIStoryboardSegue *)sender {
}

@end
