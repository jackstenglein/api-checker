//
//  ResponseViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/20/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "ResponseViewController.h"

@interface ResponseViewController ()

@end

@implementation ResponseViewController {
    FooterType footerType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    } else {
        selectedButton = self.headersButton;
        unselectedButton = self.bodyButton;
        selectedLine = self.headersUnderline;
        unselectedLine = self.bodyUnderline;
    }
    
    [selectedButton.titleLabel setFont:[UIFont fontWithName:selectedButton.titleLabel.font.fontName size:15.0]];
    [unselectedButton.titleLabel setFont:[UIFont fontWithName:unselectedButton.titleLabel.font.fontName size:13.0]];
    selectedLine.hidden = NO;
    unselectedLine.hidden = YES;
}
@end
