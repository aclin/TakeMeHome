//
//  TPAppDelegate.h
//  MeetMyPet
//
//  Created by Allan on 12/12/4.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;

typedef void(^UserDataLoadedHandler)(id sender, id<FBGraphUser> user);

@interface TPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<FBGraphUser> user;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;
- (void)requestUserData:(UserDataLoadedHandler)handler;

@end
