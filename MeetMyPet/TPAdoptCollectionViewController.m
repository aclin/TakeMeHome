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

static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface TPAdoptCollectionViewController ()

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
    
    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.albums = [NSMutableArray array];
    
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/johnny78716/TakeMeHome_Photos/master/pets/"];
	
    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < 12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        //album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];
        
        NSUInteger photoCount = 2; //arc4random()%4 + 2;
        for (NSInteger p = 0; p < photoCount; p++) {
            // there are up to 25 photos available to load from the code repository
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
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
        useProfile = TRUE;
        [self performSegueWithIdentifier:@"showAdoptForm" sender:self];
        //TPAdoptTableViewController *adoptFormViewController = [[TPAdoptTableViewController alloc] initWithNibName:@"TPAdoptTableViewController" bundle:nil set:TRUE];
        //[self.navigationController pushViewController:adoptFormViewController animated:YES];
    } else if (buttonIndex == 1) {
        // Report using new post
        useProfile = FALSE;
        [self performSegueWithIdentifier:@"showAdoptForm" sender:self];
        //        TPFoundFormViewController *foundFormViewController = [[TPFoundFormViewController alloc] init];
        //        [self.navigationController pushViewController:foundFormViewController animated:YES];
    } else {
        return;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showAdoptForm"]){
        TPAdoptTableViewController *adoptFormViewController = segue.destinationViewController;
        adoptFormViewController.usingProfile = &(useProfile);
    }
}


@end
