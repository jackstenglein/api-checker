//
//  EditRequestViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#define UIColorFromHex(hexValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((hexValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)(hexValue & 0x0000FF))/255.0 \
                alpha:1.0]

#import "EditRequestViewController.h"
#import "DataPair.h"
#import "DictionaryTableViewCell.h"

@interface EditRequestViewController ()

@end

@implementation EditRequestViewController {
    SelectionTypes selectionType;
    FooterTypes footerType;
    int selectedMethodType;
    int selectedTimeout;
    NSMutableArray<DataPair *> *bodyData;
    NSMutableArray<DataPair *> *headersData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    selectedTimeout = 5;
    bodyData = [[NSMutableArray alloc] init];
    headersData = [[NSMutableArray alloc] init];
    [headersData addObject:[[DataPair alloc] initWithKey:@"content-type" andValue:@"application/json"]];
    [headersData addObject:[[DataPair alloc] initWithKey:@"cache-control" andValue:@"no-cache"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (footerType) {
        case Body:
            return bodyData.count + 1;
        case Headers:
            return headersData.count + 1;
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DictionaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dictionaryTableViewCell" forIndexPath:indexPath];
    NSArray<DataPair *> *dataDict;
    switch(footerType) {
        case Body:
            dataDict = bodyData;
            break;
        case Headers:
            dataDict = headersData;
            break;
        case Authorization:
            dataDict = bodyData;
            break;
    }
    
    int row = (int)indexPath.row;
    if(row < dataDict.count) {
        cell.keyTextField.text = [dataDict objectAtIndex:row].key;
        cell.valueTextField.text = [dataDict objectAtIndex:row].value;
    } else {
        cell.keyTextField.text = @"";
        cell.valueTextField.text = @"";
    }
    cell.keyTextField.tag = row;
    cell.valueTextField.tag = row;
    
    return cell;
}



-(void)setUpUI {
    self.methodTypeView.layer.borderWidth = 1;
    _methodTypeView.layer.borderColor = UIColorFromHex(0xdcdcdc).CGColor;
    self.methodTypeView.layer.masksToBounds = YES;
    self.methodTypeView.layer.cornerRadius = 2;
    
    self.requestStringView.layer.borderWidth = 1;
    self.requestStringView.layer.borderColor = self.methodTypeView.layer.borderColor;
    self.requestStringView.layer.masksToBounds = YES;
    self.requestStringView.layer.cornerRadius = 2;
    
    self.timeoutView.layer.borderWidth = 1;
    self.timeoutView.layer.borderColor = self.methodTypeView.layer.borderColor;
    self.timeoutView.layer.masksToBounds = YES;
    self.timeoutView.layer.cornerRadius = 2;
    
    self.requestNameView.layer.borderWidth = 1;
    self.requestNameView.layer.borderColor = self.methodTypeView.layer.borderColor;
    self.requestNameView.layer.masksToBounds = YES;
    self.requestNameView.layer.cornerRadius = 2;
    
    [self.authButton.titleLabel setFont:[UIFont fontWithName:self.authButton.titleLabel.font.fontName size:13.0]];
    self.authLine.hidden = YES;
    [self.headersButton.titleLabel setFont:[UIFont fontWithName:self.headersButton.titleLabel.font.fontName size:13.0]];
    self.headersLine.hidden = YES;
    
    self.selectionViewBottom.constant = -self.selectionViewHeight.constant;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)showButton:(UIButton *)show hideButton:(UIButton *)hide1 andButton:(UIButton *)hide2 {
    [show.titleLabel setFont:[UIFont fontWithName:show.titleLabel.font.fontName size:15.0]];
    [hide1.titleLabel setFont:[UIFont fontWithName:hide1.titleLabel.font.fontName size:13.0]];
    [hide2.titleLabel setFont:[UIFont fontWithName:hide2.titleLabel.font.fontName size:13.0]];
}

-(void)showLine:(UIView *)show hideLine:(UIView *)hide1 andLine:(UIView *)hide2 {
    show.hidden = NO;
    hide1.hidden = YES;
    hide2.hidden = YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self closeSelectionView:nil];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag > -1) {
        DictionaryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        NSString *key = cell.keyTextField.text;
        NSString *value = cell.valueTextField.text;
        
        // we need to remove a row
        if([key isEqualToString:@""] && [value isEqualToString:@""]) {
            if(textField.tag < bodyData.count)
                [bodyData removeObjectAtIndex:textField.tag];
        } else {
            if(textField.tag == bodyData.count) {
                [bodyData addObject:[[DataPair alloc] initWithKey:key andValue:value]];
            } else {
                [bodyData replaceObjectAtIndex:textField.tag withObject:[[DataPair alloc] initWithKey:key andValue:value]];
            }
        }
        
        [self.tableView reloadData];
    }
    
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(selectionType == MethodType) {
        return 3;
    } else {
        return 12;
    }
}


-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;
    
    if(selectionType == MethodType) {
        switch(row) {
            case 0:
                title = @"GET";
                break;
            case 1:
                title = @"POST";
                break;
            case 2:
                title = @"PUT";
                break;
        }
    } else {
        title = [NSString stringWithFormat:@"%lu", (row+1)*10];
    }
    
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName: self.timeoutButton.titleLabel.font}];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(selectionType == MethodType) {
        selectedMethodType = (int)row;
        NSString *title;
        switch(selectedMethodType) {
            case 0:
                title = @"GET";
                break;
            case 1:
                title = @"POST";
                break;
            case 2:
                title = @"PUT";
                break;
        }
        [self.methodTypeButton setTitle:title forState:UIControlStateNormal];
    } else {
        selectedTimeout = (int)row;
        [self.timeoutButton setTitle:[NSString stringWithFormat:@"%ds", (selectedTimeout+1)*10] forState:UIControlStateNormal];
    }
}

-(void)raiseSelectionView {
    self.selectionViewBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)selectMethodType:(id)sender {
    selectionType = MethodType;
    [self.picker reloadComponent:0];
    [self.picker selectRow:selectedMethodType inComponent:0 animated:NO];
    self.selectionLabel.text = @"HTTP Method Type";
    if(self.selectionViewBottom.constant < 0) {
        self.selectionViewHeight.constant = 162;
    }
    [self raiseSelectionView];
}

- (IBAction)selectFooterType:(UIButton *)sender {
    footerType = (FooterTypes)sender.tag;
    switch(footerType) {
        case Body:
            [self showButton:self.bodyButton hideButton:self.authButton andButton:self.headersButton];
            [self showLine:self.bodyLine hideLine:self.authLine andLine:self.headersLine];
            break;
        case Authorization:
            [self showButton:self.authButton hideButton:self.bodyButton andButton:self.headersButton];
            [self showLine:self.authLine hideLine:self.bodyLine andLine:self.headersLine];
            break;
        case Headers:
            [self showButton:self.headersButton hideButton:self.bodyButton andButton:self.authButton];
            [self showLine:self.headersLine hideLine:self.bodyLine andLine:self.authLine];
            break;
    }
    
    [self.tableView reloadData];
}
- (IBAction)selectTimeout:(id)sender {
    selectionType = Timeout;
    [self.picker reloadComponent:0];
    [self.picker selectRow:selectedTimeout inComponent:0 animated:NO];
    self.selectionLabel.text = @"Request Timeout";
    self.selectionViewHeight.constant = 250;
    [self raiseSelectionView];
}
- (IBAction)closeSelectionView:(id)sender {
    self.selectionViewBottom.constant = -self.selectionViewHeight.constant;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)saveRequest:(id)sender {
    
    NSString *url = self.requestStringField.text;
    if([url isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please enter a URL" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:close];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if([url rangeOfString:@"http"].location != 0) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"savedRequests.plist"];
    
    NSMutableArray *plistArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    if(plistArray == nil) plistArray = [[NSMutableArray alloc] init];
    
    NSString *methodType;
    switch (selectedMethodType) {
        case 0:
            methodType = @"GET";
            break;
        case 1:
            methodType = @"POST";
            break;
        case 2:
            methodType = @"PUT";
            break;
    }
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < bodyData.count; i++) {
        DataPair *data = [bodyData objectAtIndex:i];
        [body setObject:data.value forKey:data.key];
    }
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < headers.count; i++) {
        DataPair *data = [headersData objectAtIndex:i];
        [headers setObject:data.value forKey:data.key];
    }
    
    NSNumber *timeout = [[NSNumber alloc] initWithInt:(selectedTimeout+1)*10];
    NSDictionary *requestDict = [[NSDictionary alloc] initWithObjects:@[methodType, timeout, url, self.requestNameField.text, body, headers] forKeys:@[@"methodType", @"timeout", @"requestURL", @"requestName", @"body", @"headers"]];
    [plistArray addObject:requestDict];
    
    BOOL saved = [plistArray writeToFile:plistPath atomically:YES];
    if(saved) NSLog(@"Saved!");
    else NSLog(@"Save failed");
    
    [self performSegueWithIdentifier:@"closeNewRequest" sender:nil];
}


@end
