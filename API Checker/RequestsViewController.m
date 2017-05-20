//
//  RequestsViewController.m
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//

#import "RequestsViewController.h"
#import "ResponseViewController.h"
#import "RequestTableViewCell.h"
#import "Constants.h"

#define UIColorFromHex(hexValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >>  8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:1.0]

@interface RequestsViewController ()

@end

@implementation RequestsViewController {
    NSMutableArray *savedRequests;
    NSMutableArray *receivedResponses;
    int currentRequest;
    NSString *plistPath;
    bool arbirtraryLoad;
    bool requesting;
    int selectedRequest;
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
    if(savedRequests == nil || savedRequests.count == 0) {
        savedRequests = [[NSMutableArray alloc] init];
        self.noRequestsLabel.hidden = NO;
    }
    
    [self startRequests];
    
}

-(void)startRequests {
    receivedResponses = [[NSMutableArray alloc] init];
    currentRequest = 0;
    requesting = YES;
    [self makeRequest];
}

-(void)makeRequest {
    if(currentRequest < savedRequests.count) {
        NSDictionary *request = [savedRequests objectAtIndex:currentRequest];
        ConnectionController *connection = [[ConnectionController alloc] initWithURL:[request objectForKey:@"requestURL"] methodType:[request objectForKey:@"methodType"] body:[request objectForKey:@"body"] andHeaders:[request objectForKey:@"headers"]];
        connection.delegate = self;
        [connection makeRequest];
    } else {
        requesting = NO;
    }
}

-(void)connectionFinished:(id)connection response:(NSDictionary *)response {
    //NSLog(@"JSON Response: %@", response);
    //NSLog(@"Status description: %@", [Constants descriptionForStatusCode:[response[@"statusCode"] intValue]]);
    [receivedResponses addObject:response];
    currentRequest++;
    [self makeRequest];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.requestsTableView reloadData];
    });
    
    ((ConnectionController *)connection).delegate = nil;
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
    
    // unconditional setup of the cell
    RequestTableViewCell *cell = [self.requestsTableView dequeueReusableCellWithIdentifier:@"requestTableViewCell" forIndexPath:indexPath];
    cell.waitingLabel.hidden = YES;
    cell.statusTitle.hidden = NO;
    cell.statusLabel.hidden = NO;
    
    // get the cell row and the current response
    int row = (int)indexPath.row;
    NSDictionary *response = receivedResponses[row];
    
    // do conditional setup of the cell
    if([[savedRequests[row] objectForKey:@"requestName"] isEqualToString:@""]) {
        cell.nameLabel.text = response[@"requestURL"];
    } else {
        cell.nameLabel.text = savedRequests[row][@"requestName"];
    }
    
    if(response[@"error"] != nil) {
        cell.timeLabel.hidden = YES;
        cell.statusLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Request Failed" attributes:@{ NSForegroundColorAttributeName: UIColorFromHex(0xE32636) }];
    } else {
        cell.timeLabel.hidden = NO;
        cell.statusLabel.attributedText = [Constants descriptionForStatusCode:[receivedResponses[row][@"statusCode"] intValue]];
        cell.timeLabel.text = [NSString stringWithFormat:@"in %d ms", [receivedResponses[row][@"responseTime"] intValue]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRequest = (int)indexPath.row;
    [self performSegueWithIdentifier:@"showResponse" sender:nil];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent swipe to delete
    if (tableView.isEditing) {
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
        
        if(savedRequests.count == 0) {
            self.noRequestsLabel.hidden = NO;
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"showResponse"]) {
        ResponseViewController *destVC = [segue destinationViewController];
        destVC.request = [savedRequests objectAtIndex:selectedRequest];
        destVC.response = [receivedResponses objectAtIndex:selectedRequest];
    }
}


-(IBAction)returnFromNewRequest:(UIStoryboardSegue *)segue {
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"File not found--rvm");
        plistPath = [[NSBundle mainBundle] pathForResource:@"savedRequests" ofType:@"plist"];
    }
    
    int oldCount = (int)savedRequests.count;
    savedRequests = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath] mutableCopy];
    if(savedRequests.count > oldCount) {
        // we have added a new request
        self.noRequestsLabel.hidden = YES;
        [self.requestsTableView reloadData];
        if(!requesting)
            [self makeRequest];
    }
}

- (IBAction)editRequests:(id)sender {
    if(currentRequest >= savedRequests.count) {
        [self.requestsTableView setEditing:!self.requestsTableView.isEditing animated:YES];
    
        if(self.requestsTableView.isEditing) {
            [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        } else {
            [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
            [savedRequests writeToFile:plistPath atomically:YES];
        }
    }
    
}
- (IBAction)addRequest:(id)sender {
    selectedRequest = -1;
    [self performSegueWithIdentifier:@"showEditRequest" sender:nil];
}
@end
