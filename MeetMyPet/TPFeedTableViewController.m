//
//  TPFeedTableViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/5.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPFeedTableViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "TPFeedTableCell.h"
#import "UIImageView+AFNetworking.h"
#import "TPAdoptPostTableViewController.h"
#import "TPLostPostTableViewController.h"
#import "TPFoundPostTableViewController.h"


// Dictionary Keys
NSString *const FeedDictKeyCity = @"City";
NSString *const FeedDictKeyCountry = @"Country";
NSString *const FeedDictKeyEmail = @"Email";
NSString *const FeedDictKeyDate = @"Date";
NSString *const FeedDictKeyPostID = @"ID";
NSString *const FeedDictKeyImageName = @"ImageName";
NSString *const FeedDictKeyPetAge = @"PetAge";
NSString *const FeedDictKeyPetBreed = @"PetBreed";
NSString *const FeedDictKeyPetChar = @"PetChar";
NSString *const FeedDictKeyPetChip = @"PetChip";
NSString *const FeedDictKeyPetGender = @"PetGender";
NSString *const FeedDictKeyPetName = @"PetName";
NSString *const FeedDictKeyPetNeuSpay = @"PetNeuSpay";
NSString *const FeedDictKeyPetVac = @"PetVac";
NSString *const FeedDictKeyPetinfoID = @"PetinfoID";
NSString *const FeedDictKeyPhotoID = @"PhotoID";
NSString *const FeedDictKeyTypeID = @"Type";
NSString *const FeedDictKeyType = @"TypeName";
NSString *const FeedDictKeyUserName = @"UserName";

//Map Dictionary Keys
NSString *const FeedDictKeyLongitude=@"Longitude";
NSString *const FeedDictKeyLatitude=@"Latitude";

@interface TPFeedTableViewController ()

@end

@implementation TPFeedTableViewController


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

    NSArray *plistPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistDocumentsDirectory = [plistPaths objectAtIndex:0];
    
    NSString *plistPath = [plistDocumentsDirectory stringByAppendingPathComponent:@"local_profile.plist"];
    NSFileManager *plistFileMgr = [NSFileManager defaultManager];
    if ([plistFileMgr fileExistsAtPath:plistPath]) {
        NSMutableDictionary *savedPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        _petID = [savedPlist valueForKey:@"petID"];
        NSLog(@"PetID: %@",_petID);
    } else {
        NSLog(@"local_profile.plist does not exist");
    }
    
    [self loadPosts];
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPosts{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           _petID, @"petID", //Lost
                           nil];
    NSURL *url = [NSURL URLWithString:@"https://secret-temple-2872.herokuapp.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/api/UserPost/"
                                                      parameters:param];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *entries = [NSArray arrayWithArray:JSON];
        _myPosts = entries;
        NSLog(@"Entry count: %d", _myPosts.count);
        
        for(NSDictionary *entry in entries) {
            NSLog(@"Entry: %@", entry);
        }
        
        [self performSelector:@selector(reloadTable:) withObject:self];
        
    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        NSLog(@"%@", [NSString stringWithFormat:@"%@", error]);}];
    [operation start];

    [self.tableView reloadData];
}

-(void)reloadTable:(id)sender
{
    [self.tableView reloadData];
}

-(IBAction)reload:(id)sender
{
    [self loadPosts];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Entry count for row creation: %d", _myPosts.count);
    return [_myPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    
    _date= [ _myPosts[row] valueForKeyPath:FeedDictKeyDate];
    _type = [ _myPosts[row] valueForKeyPath:FeedDictKeyType];
    _imageName = [ _myPosts[row] valueForKeyPath:FeedDictKeyImageName];
    
    TPFeedTableCell *feedCell = (TPFeedTableCell *)cell;
    feedCell.dateOfPosts.text = _date;
    feedCell.typeOfPosts.text = _type;
    NSString *imageURL = [NSString stringWithFormat:@"http://www.csie.ntu.edu.tw/~r00944044/mpptmh/tmhphotos/%@" ,  _imageName];
    [feedCell.feedImage setImageWithURL:[NSURL URLWithString:imageURL]];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = indexPath.row;
    
    NSDictionary *entry = _myPosts[row];
    _type = [entry objectForKey:FeedDictKeyType];
    NSLog(@" TYPE1: %@", _type);
    
    if ([_type isEqualToString:@"Lost"])
        [self performSegueWithIdentifier:@"showUserLostPost" sender:self];
    else if ([_type isEqualToString:@"Found"])
        [self performSegueWithIdentifier:@"showUserFoundPost" sender:self];
    else if ([_type isEqualToString:@"Adopt"])
        [self performSegueWithIdentifier:@"showUserAdoptPost" sender:self];
    
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSUInteger row = indexPath.row;
    
    NSDictionary *entry = _myPosts[row];
    _type = [entry objectForKey:FeedDictKeyType];
    NSLog(@" TYPE2: %@", _type);
    if ([segue.identifier isEqualToString:@"showUserAdoptPost"]) {
        
        TPAdoptPostTableViewController *detailPage = segue.destinationViewController;
        detailPage.adoptPost = _myPosts[row];
    }
    
    if ([segue.identifier isEqualToString:@"showUserLostPost"]) {
        
        TPLostPostTableViewController *detailPage = segue.destinationViewController;
        detailPage.lostData = _myPosts[row];
    }
    
    if ([segue.identifier isEqualToString:@"showUserFoundPost"]) {
        
        TPFoundPostTableViewController *detailPage = segue.destinationViewController;
        detailPage.data = _myPosts[row];
    }
    
    
}


@end
