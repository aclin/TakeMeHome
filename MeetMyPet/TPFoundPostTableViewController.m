//
//  TPFoundPostTableViewController.m
//  MeetMyPet
//
//  Created by Johnny Bee on 12/12/20.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPFoundPostTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

@interface TPFoundPostTableViewController (){

NSURLConnection *connect;
}

@end

@implementation TPFoundPostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
//    NSInteger typeID = 1;
//    NSString *post = [NSString stringWithFormat:@"typeID=%d",typeID];
//    NSLog(@"%@", post);
//    
//	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
////	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    
//    NSURL *url = [NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/"];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    
//    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
//    
////    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:typeID, @"typeID", nil];
//	NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
//                                                            path:@"http://secret-temple-2872.herokuapp.com/api/UserPost/"
//                                                      //parameters:@{@"typeID":[NSNumber numberWithInt:typeID]}];
//                                                      parameters: nil];
//    
////	[request setURL:[NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/api/FeedDownload/"]];
////	[request setHTTPMethod:@"POST"];
////	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
////	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
////    
////	[request setHTTPBody:postData];
////    
////    self.tempData = [NSMutableData alloc];
////	connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    [AFJSONRequestOperation addAcceptableContentTypes:@"text/plain"];
//    [AFJSONRequestOperation addAcceptableContentTypes:@"text/html"];
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"Found Post JSON: %@", JSON);
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"JSON content: %@", JSON);
//        NSLog(@"%@",[error localizedDescription]);
//    }];
//    [operation start];
    
    /*NSURL *url = [NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/api/FeedDownload/index.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Found Post JSON: %@", JSON);
    } failure:nil];
    [operation start];
     */
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{   //發生錯誤
	NSLog(@"發生錯誤");
}
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse {  //連線建立成功
    //取得狀態
    NSInteger status = (NSInteger)[(NSHTTPURLResponse *)aResponse statusCode];
    NSLog(@"%d", status);
}
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{   //收到封包，將收到的資料塞進緩衝中並修改進度條
	[self.tempData appendData:incomingData];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{   //檔案下載完成
    NSString *loadData = [[NSMutableString alloc] initWithData:self.tempData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", loadData);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
