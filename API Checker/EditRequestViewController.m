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

@interface EditRequestViewController ()

@end

@implementation EditRequestViewController {
    SelectionTypes selectionType;
    int selectedMethodType;
    int selectedTimeout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    selectedTimeout = 5;
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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(selectionType == MethodType) {
        switch(row) {
            case 0:
                return @"GET";
            case 1:
                return @"POST";
            case 2:
                return @"PUT";
        }
    }
    
    return [NSString stringWithFormat:@"%lu", (row+1)*10];
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
    switch(sender.tag) {
        case 0:
            [self showButton:self.bodyButton hideButton:self.authButton andButton:self.headersButton];
            [self showLine:self.bodyLine hideLine:self.authLine andLine:self.headersLine];
            break;
        case 1:
            [self showButton:self.authButton hideButton:self.bodyButton andButton:self.headersButton];
            [self showLine:self.authLine hideLine:self.bodyLine andLine:self.headersLine];
            break;
        case 2:
            [self showButton:self.headersButton hideButton:self.bodyButton andButton:self.authButton];
            [self showLine:self.headersLine hideLine:self.bodyLine andLine:self.authLine];
            break;
    }
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
@end
