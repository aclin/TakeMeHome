//
//  AppDelegate.m
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import "TPAppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

NSString *const FBSessionStateChangedNotification =
@"tw.edu.ntu.THProfile:FBSessionStateChangedNotification";

@interface TPAppDelegate ()

@property (strong, nonatomic) NSURL *openedURL;

@end


@implementation TPAppDelegate

@synthesize window = _window;
@synthesize openedURL = _openedURL;
@synthesize user = _user;

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ([kv count] > 1) {
            NSString *val = [[kv objectAtIndex:1]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}

- (void) handleOpenURLPre:(NSURL *) url
{
    // Parse the URL
    NSString *query = [url fragment];
    if (!query) {
        query = [self.openedURL query];
    }
    NSDictionary *params = [self parseURLParams:query];
    // Look for a valid access token
    if ([params objectForKey:@"access_token"]) {
        NSString *accessToken = [params objectForKey:@"access_token"];
        NSString *expires_in = [params objectForKey:@"expires_in"];
        // Determine the expiration data
        NSDate *expirationDate = nil;
        if (expires_in != nil) {
            int expValue = [expires_in intValue];
            if (expValue != 0) {
                expirationDate = [NSDate dateWithTimeIntervalSinceNow:expValue];
            }
        }
        if (!expirationDate) {
            expirationDate = [NSDate distantFuture];
        }
        NSDate *nowDate = [NSDate date];
        // Check expiration date later than now
        if (NSOrderedDescending == [expirationDate compare:nowDate]) {
            // Cache the token
            NSDictionary *tokenInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       accessToken, FBTokenInformationTokenKey,
                                       expirationDate, FBTokenInformationExpirationDateKey,
                                       nowDate, FBTokenInformationRefreshDateKey,
                                       nil];
            FBSessionTokenCachingStrategy *tokenCachingStrategy = [FBSessionTokenCachingStrategy defaultInstance];
            [tokenCachingStrategy cacheTokenInformation:tokenInfo];
            // Now open the session and the cached token should
            // be picked up, open with nil permissions because
            // what you send is checked against any cached permissions
            // to determine token validity.
            [FBSession openActiveSessionWithReadPermissions:nil
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session,
                                                              FBSessionState state,
                                                              NSError *error) {
                                              [self sessionStateChanged:session
                                                                  state:state
                                                                  error:error];
                                          }];
        }
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
            self.user = nil;
            break;
        case FBSessionStateClosedLoginFailed:
            self.user = nil;
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    // Ask for permissions for getting info about uploaded
    // custom photos.
    NSArray *permissions = [NSArray arrayWithObjects:
                            @"user_photos",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}


- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}


- (void)requestUserData:(UserDataLoadedHandler)handler
{
    // If there is saved data, return this.
    if (nil != self.user) {
        if (handler) {
            handler(self, self.user);
        }
    } else if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 // Save the user data
                 self.user = user;
                 if (handler) {
                     handler(self, self.user);
                 }
             }
         }];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeiPhoneTheme];
    [FBProfilePictureView class];
    [FBPlacePickerViewController class];
    [FBFriendPickerViewController class];
    // Override point for customization after application launch.
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Save the incoming URL to test deep links later.
    self.openedURL = url;
    
    // Work around for app link from FB with valid info. If the
    // session is closed, set the valid info (if any) in the cache
    if ((FBSession.activeSession.state == FBSessionStateCreated) ||
        (FBSession.activeSession.state == FBSessionStateClosed)){
        [self handleOpenURLPre:url];
    }
    // We need to handle URLs by passing them to FBSession in order for SSO authentication
    // to work.
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}


-(void)customizeiPhoneTheme
{
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"menubar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-active.png"]];

    

    
}




@end
