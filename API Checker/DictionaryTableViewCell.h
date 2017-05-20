//
//  DictionaryTableViewCell.h
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictionaryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *keyTextField;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UILabel *colonLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyTextFieldTrailing;

@property (strong, nonatomic) IBOutlet UIScrollView *longValueScrollView;
@property (strong, nonatomic) IBOutlet UILabel *longValueLabel;

@end
