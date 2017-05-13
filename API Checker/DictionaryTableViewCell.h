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

@end
