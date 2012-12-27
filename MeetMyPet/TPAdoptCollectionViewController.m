//
//  TPAdoptCollectionViewController.m
//  MeetMyPet
//
//  Created by Evelyn on 12/17/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import "TPAdoptCollectionViewController.h"
#import "TPAdoptTableViewController.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHAlbumTitleReusableView.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "TPAdoptTableViewController.h"
#import "TPAdoptPostTableViewController.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface TPAdoptCollectionViewController (){
    NSArray *feedEntries;
}

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, weak) BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation TPAdoptCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Refresher
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor orangeColor];
    [refreshControl addTarget:self action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [self loadFeeds];
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

-(void)refresh:(UIRefreshControl*)sender{
    
    //reload feeds
    [self loadFeeds];
    [self.collectionView reloadData];
    [sender endRefreshing];
}

- (IBAction)loadImages:(id)sender{
    self.albums = [NSMutableArray array];
    
    NSURL *urlPrefix = [NSURL URLWithString:@"http://www.csie.ntu.edu.tw/~r00944044/mpptmh/tmhphotos/"];
	
    NSInteger photoIndex = 0;
    NSInteger entryCount = [feedEntries count];
    NSLog(@"Entry count: %d", entryCount);
    
    for (NSInteger a = 0; a < entryCount; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        
        NSDictionary *entry = feedEntries[a];
        
        NSUInteger photoCount = 2;
        for (NSInteger p = 0; p < photoCount; p++) {
            NSString *photoFilename = [NSString stringWithFormat:@"%@", [entry objectForKey:@"ImageName"]];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BHAlbum *album = self.albums[section];
    
    return album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                              forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    // load photo images in the background
    __weak TPAdoptCollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell =
                (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    
    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:AlbumTitleIdentifier
                                              forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}


- (IBAction)createReport:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"How Would You Like to Report?"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Use Existing Profile", @"Create New Post", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Report using existing profile
        useProfile = @"Yes";
        [self performSegueWithIdentifier:@"showAdoptForm" sender:self];
        //TPAdoptTableViewController *adoptFormViewController = [[TPAdoptTableViewController alloc] initWithNibName:@"TPAdoptTableViewController" bundle:nil set:TRUE];
        //[self.navigationController pushViewController:adoptFormViewController animated:YES];
    } else if (buttonIndex == 1) {
        // Report using new post
        useProfile = @"No";
        [self performSegueWithIdentifier:@"showAdoptForm" sender:self];
        //        TPFoundFormViewController *foundFormViewController = [[TPFoundFormViewController alloc] init];
        //        [self.navigationController pushViewController:foundFormViewController animated:YES];
    } else {
        return;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    NSLog(@"Data: %@", feedEntries[indexPath.section]);
    
    [self performSegueWithIdentifier:@"showUserAdoptPost" sender:cell];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *index = [indexPaths lastObject];
    
    if ([segue.identifier isEqualToString:@"showAdoptForm"]){
        TPAdoptTableViewController *adoptFormViewController = segue.destinationViewController;
        adoptFormViewController.usingProfile = *(&(useProfile));
    }
    
    if ([segue.identifier isEqualToString:@"showUserAdoptPost"]) {
        TPAdoptPostTableViewController *detailPage = segue.destinationViewController;
        detailPage.adoptPost = feedEntries[index.section];
    }

}

- (void)loadFeeds{
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"3", @"typeID", //Adopt
                           nil];
    NSURL *url = [NSURL URLWithString:@"https://secret-temple-2872.herokuapp.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/api/FeedDownload/"
                                                      parameters:param];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        // - Example Entry -
        //        City = Taipei;
        //        Country = Taipei;
        //        Date = "Dec 23, 2012";
        //        Email = "r2034kimo@hotmail.com";        //        ID = 221;
        //        ImageName = "c0da5941d13c788a674db1680c8beba8.jpg";
        //        Latitude = "5.90033";
        //        Longitude = "-2.39499";
        //        PetAge = 3;
        //        PetBreed = Mixed;
        //        PetChar = fat;
        //        PetChip = 1;
        //        PetGender = Female;
        //        PetName = Dot;
        //        PetNeuSpay = 1;
        //        PetVac = Rabies;
        //        PetinfoID = 41;
        //        PhotoID = 541;
        //        Type = 1;
        //        UserName = "<null>";
        //        petName = Dot;
        
        NSArray *entries = [NSArray arrayWithArray:JSON];
        feedEntries = entries;
        
        
        
        for(NSDictionary *entry in entries) {
            NSLog(@"Entry: %@", entry);
        }
        
        [self performSelector:@selector(loadImages:) withObject:self];
        
    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        NSLog(@"%@", [NSString stringWithFormat:@"%@", error]);}];
    [operation start];
    
}



@end
