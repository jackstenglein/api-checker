//
//  RequestsViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"savedRequests.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"File not found--rvm");
        plistPath = [[NSBundle mainBundle] pathForResource:@"savedRequests" ofType:@"plist"];
    }
    
    NSMutableArray *plistArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    NSLog(@"Plist array: %@", plistArray);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)returnFromNewRequest:(UIStoryboardSegue *)segue {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"savedRequests.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"File not found--rvm");
        plistPath = [[NSBundle mainBundle] pathForResource:@"savedRequests" ofType:@"plist"];
    }
    
    NSMutableArray *plistArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    NSLog(@"Plist array: %@", plistArray);
}

@end
