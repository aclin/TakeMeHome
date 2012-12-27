//
//  TPLostFoundCollectionViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/9.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPLostFoundCollectionViewController.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHAlbumTitleReusableView.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "TPLostPostTableViewController.h"
#import "TPFoundPostTableViewController.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface TPLostFoundCollectionViewController (){
    NSArray *feedEntries;
}

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, weak) BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation TPLostFoundCollectionViewController

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
    //[self loadFeeds];
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadFeeds];
    [self.collectionView reloadData];
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
            NSString *type = [entry objectForKey:@"Type"];
            //cell.data = entry;
            
            if([type isEqualToString:@"1"]){
                album.name = @"Lost";
            }else if([type isEqualToString:@"2"]){
                album.name = @"Found";
            }
            
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
    __weak TPLostFoundCollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell =
                (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                //cell.data = feedEntries[indexPath.item];
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
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"What Would You Like to Report?"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Report Lost", @"Report Found", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Report lost
        [self performSegueWithIdentifier:@"showLostForm" sender:self];
        //        TPLostFormViewController *lostFormViewController = [[TPLostFormViewController alloc] init];
        //        [self.navigationController pushViewController:lostFormViewController animated:YES];
    } else if (buttonIndex == 1) {
        // Report found
        [self performSegueWithIdentifier:@"showFoundForm" sender:self];
        //        TPFoundFormViewController *foundFormViewController = [[TPFoundFormViewController alloc] init];
        //        [self.navigationController pushViewController:foundFormViewController animated:YES];
    } else {
        return;
    }
}


- (void)loadFeeds{
    

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"1", @"typeID", //Lost
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //NSArray *index = [indexPath section];
    NSLog(@"ID: %d", indexPath.section);
    NSInteger item = [indexPath section];
    NSString *type = [feedEntries[item] objectForKey:@"Type"];
    
    if ([type isEqualToString:@"1"]){ //lost
        [self performSegueWithIdentifier:@"showUserLostPost" sender:cell];
    }else if ([type isEqualToString:@"2"]){ //found
        [self performSegueWithIdentifier:@"showUserFoundPost" sender:cell];
    }
        //NSLog(@"row %@ pressed", indexPath);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *index = [indexPaths lastObject];
    
//    if ([segue.identifier isEqualToString:@"showUserAdoptPost"]) {
//        
//        TPAdoptPostTableViewController *detailPage = segue.destinationViewController;
//        detailPage.data = feedEntries[index.section];
//    }
    
    if ([segue.identifier isEqualToString:@"showUserLostPost"]) {
        
        TPLostPostTableViewController *detailPage = segue.destinationViewController;
        detailPage.lostData = feedEntries[index.section];
    }
    
    if ([segue.identifier isEqualToString:@"showUserFoundPost"]) {
        
        TPFoundPostTableViewController *detailPage = segue.destinationViewController;
        detailPage.data = feedEntries[index.section];
    }

}

@end
