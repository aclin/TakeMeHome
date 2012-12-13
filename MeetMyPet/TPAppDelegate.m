//
//  TPAppDelegate.m
//  MeetMyPet
//
//  Created by Allan on 12/12/4.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPAppDelegate.h"
#import <FacebookSDK/FBSessionTokenCachingStrategy.h>

NSString *const FBSessionStateChangedNotification = @"tw.edu.ntu.MeetMyPet:FBSessionStateChangedNotification";

@interface TPAppDelegate()

@property (strong, nonatomic) NSURL *openedURL;

@end

@implementation TPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [FBPlacePickerViewController class];
    [FBFriendPickerViewController class];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

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


/*
 * A function to get the access token info and save
 * it in the cache, useful for deep linking support
 * in cases where the session is not open.
 */
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

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
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

/*
 * Closes the active Facebook session
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}


/*
 * Makes a request for user data and invokes a callback
 */
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
                 // Update menu user info
#warning  change here after profile set
                 //-->self.menu.profileID = user.id;
                 // Save the user data
                 self.user = user;
                 if (handler) {
                     handler(self, self.user);
                 }
             }
         }];
    }
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

@end
