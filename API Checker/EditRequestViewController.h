//
//  EditRequestViewController.h
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MethodType,
    Timeout
}SelectionTypes;

@interface EditRequestViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *methodTypeView;
- (IBAction)selectMethodType:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *requestStringView;
@property (strong, nonatomic) IBOutlet UIView *timeoutView;
@property (strong, nonatomic) IBOutlet UIView *requestNameView;
@property (strong, nonatomic) IBOutlet UIButton *bodyButton;
- (IBAction)selectFooterType:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic) IBOutlet UIButton *headersButton;
@property (strong, nonatomic) IBOutlet UIView *bodyLine;
@property (strong, nonatomic) IBOutlet UIView *authLine;
@property (strong, nonatomic) IBOutlet UIView *headersLine;
@property (strong, nonatomic) IBOutlet UIView *selectionView;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)selectTimeout:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *selectionLabel;

- (IBAction)closeSelectionView:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectionViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectionViewBottom;
@property (strong, nonatomic) IBOutlet UIButton *timeoutButton;
@property (strong, nonatomic) IBOutlet UIButton *methodTypeButton;

@end
