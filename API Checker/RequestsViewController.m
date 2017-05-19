//
//  RequestsViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "RequestsViewController.h"
#import "RequestTableViewCell.h"
#import "Constants.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController {
    NSMutableArray *savedRequests;
    NSMutableArray *receivedResponses;
    int currentRequest;
    NSString *plistPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.requestsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    plistPath = [documentsPath stringByAppendingPathComponent:@"savedRequests.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"File not found--rvm");
        plistPath = [[NSBundle mainBundle] pathForResource:@"savedRequests" ofType:@"plist"];
    }
    
    savedRequests = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    if(savedRequests == nil) {
        savedRequests = [[NSMutableArray alloc] init];
    }
    
    [self makeRequests];
    
}

-(void)makeRequests {
    
    receivedResponses = [[NSMutableArray alloc] init];
    currentRequest = 0;
    
    if(savedRequests.count > 0) {
        NSDictionary *request = [savedRequests objectAtIndex:currentRequest];
        ConnectionController *connection = [[ConnectionController alloc] initWithURL:[request objectForKey:@"requestURL"] methodType:[request objectForKey:@"methodType"] body:[request objectForKey:@"body"] andHeaders:[request objectForKey:@"headers"]];
        connection.delegate = self;
        [connection makeRequest];
    }
}

-(void)connectionFailed:(id)connection error:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Error description: %@", error.localizedDescription);
    [receivedResponses addObject:error];
    currentRequest++;
    if(currentRequest < savedRequests.count) {
        NSDictionary *request = [savedRequests objectAtIndex:currentRequest];
        ConnectionController *connection = [[ConnectionController alloc] initWithURL:[request objectForKey:@"requestURL"] methodType:[request objectForKey:@"methodType"] body:[request objectForKey:@"body"] andHeaders:[request objectForKey:@"headers"]];
        connection.delegate = self;
        [connection makeRequest];
    }
}

-(void)connectionFinished:(id)connection response:(NSDictionary *)response {
    NSLog(@"JSON Response: %@", response);
    NSLog(@"Status description: %@", [Constants descriptionForStatusCode:[response[@"statusCode"] intValue]]);
    [receivedResponses addObject:response];
    currentRequest++;
    if(currentRequest < savedRequests.count) {
        NSDictionary *request = [savedRequests objectAtIndex:currentRequest];
        ConnectionController *connection = [[ConnectionController alloc] initWithURL:[request objectForKey:@"requestURL"] methodType:[request objectForKey:@"methodType"] body:[request objectForKey:@"body"] andHeaders:[request objectForKey:@"headers"]];
        connection.delegate = self;
        [connection makeRequest];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.requestsTableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return savedRequests.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row < currentRequest) {
        return [self cellForReceivedResponseAtRow: indexPath];
    } else {
        RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestTableViewCell" forIndexPath:indexPath];
        
        if ([[[savedRequests objectAtIndex:indexPath.row] objectForKey:@"requestName"] isEqualToString:@""]) {
            cell.nameLabel.text = [[savedRequests objectAtIndex:indexPath.row] objectForKey:@"requestURL"];
        } else {
            cell.nameLabel.text = [[savedRequests objectAtIndex:indexPath.row] objectForKey:@"requestName"];
        }
        
        cell.timeLabel.hidden = YES;
        cell.statusLabel.hidden = YES;
        cell.statusTitle.hidden = YES;
        cell.waitingLabel.hidden = NO;
        
        return cell;
    }
}

-(RequestTableViewCell *)cellForReceivedResponseAtRow:(NSIndexPath *)indexPath {
    RequestTableViewCell *cell = [self.requestsTableView dequeueReusableCellWithIdentifier:@"requestTableViewCell" forIndexPath:indexPath];
    
    int row = (int)indexPath.row;
    if([[savedRequests[row] objectForKey:@"requestName"] isEqualToString:@""]) {
        cell.nameLabel.text = receivedResponses[row][@"requestURL"];
    } else {
        cell.nameLabel.text = savedRequests[row][@"requestName"];
    }
    
    cell.waitingLabel.hidden = YES;
    cell.timeLabel.hidden = NO;
    cell.statusTitle.hidden = NO;
    cell.statusLabel.hidden = NO;
    cell.statusLabel.attributedText = [Constants descriptionForStatusCode:[receivedResponses[row][@"statusCode"] intValue]];
    cell.timeLabel.text = [NSString stringWithFormat:@"in %d ms", [receivedResponses[row][@"responseTime"] intValue]];
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent swipe to delete
    if (tableView.isEditing) {
        NSLog(@"Tableview is editing");
        return UITableViewCellEditingStyleDelete;
    }
    
    NSLog(@"Tableview not editing");
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSDictionary *request = [savedRequests objectAtIndex:sourceIndexPath.row];
    [savedRequests removeObjectAtIndex:sourceIndexPath.row];
    [savedRequests insertObject:request atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [savedRequests removeObjectAtIndex:indexPath.row];
        [tableView endUpdates];
    }
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
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"File not found--rvm");
        plistPath = [[NSBundle mainBundle] pathForResource:@"savedRequests" ofType:@"plist"];
    }
    
    NSMutableArray *plistArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    NSLog(@"Plist array: %@", plistArray);
}

- (IBAction)editRequests:(id)sender {
    
    [self.requestsTableView setEditing:!self.requestsTableView.isEditing animated:YES];
    
    if(self.requestsTableView.isEditing) {
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [savedRequests writeToFile:plistPath atomically:YES];
    }
    
    
}
- (IBAction)addRequest:(id)sender {
    [self performSegueWithIdentifier:@"showEditRequest" sender:nil];
}
@end
