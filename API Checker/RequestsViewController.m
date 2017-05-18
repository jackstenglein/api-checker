//
//  RequestsViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "RequestsViewController.h"
#import "RequestTableViewCell.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController {
    NSArray *savedRequests;
    NSMutableArray *receivedResponses;
    int currentRequest;
}

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
    
    savedRequests = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if(savedRequests == nil) {
        savedRequests = [[NSArray alloc] init];
    }
    
    [self makeRequests];
}

-(void)makeRequests {
    
    receivedResponses = [[NSMutableArray alloc] init];
    currentRequest = 0;
    
    NSDictionary *request = [savedRequests objectAtIndex:currentRequest];
    ConnectionController *connection = [[ConnectionController alloc] initWithURL:[request objectForKey:@"requestURL"] methodType:[request objectForKey:@"methodType"] body:[request objectForKey:@"body"] andHeaders:[request objectForKey:@"headers"]];
    connection.delegate = self;
    [connection makeRequest];
}

-(void)connectionFailed:(id)connection error:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Error description: %@", error.localizedDescription);
}

-(void)connectionFinished:(id)connection response:(NSDictionary *)response {
    NSLog(@"Response: %@", response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return savedRequests.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestTableViewCell" forIndexPath:indexPath];
    
    if ([[[savedRequests objectAtIndex:indexPath.row] objectForKey:@"requestName"] isEqualToString:@""]) {
        cell.nameLabel.text = [[savedRequests objectAtIndex:indexPath.row] objectForKey:@"requestURL"];
    } else {
        cell.nameLabel.text = [[savedRequests objectAtIndex:indexPath.row] objectForKey:@"requestName"];
    }
    
    
    
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

- (IBAction)editRequests:(id)sender {
    [self.requestsTableView setEditing:YES animated:YES];
}
@end
