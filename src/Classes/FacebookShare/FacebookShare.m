//
//  FacebookShare.m
//  platformwatch
//
//  Created by Chung Tang on 17/4/13.
//  Copyright (c) 2013 Oregon Scientific Global Distribution Ltd. All rights reserved.
//

#import "FacebookShare.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookShare () {
    int counter;
}

@end
@implementation FacebookShare

- (void) performPublishAction:(void (^)(void)) action andErrorHander:(void (^)(void)) errorFunction {
    //Check if the permission is permitted
    if (!FBSession.activeSession.isOpen) {
        if (FBSession.activeSession.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            FBSession.activeSession = [[FBSession alloc] init];
            
            NSLog(@"FBSessionState Not Created");
            NSLog(@"<-------------------------->");
        }
        [FBSession.activeSession openWithCompletionHandler: ^(FBSession *session, FBSessionState status, NSError *error)
         {
             counter++;
             NSLog(@"COUNTER = %d", counter);
             if (counter == 1){
//                 switch (status) {
//                     case FBSessionStateOpen:
//                         NSLog(@"FBSessionStateOpen");
//                         break;
//                         
//                     case FBSessionStateClosed:
//                         NSLog(@"FBSessionStateClosed");
//                         break;
//                         
//                     case FBSessionStateClosedLoginFailed:
//                         NSLog(@"FBSessionStateClosedLoginFailed");
//                         break;
//                         
//                     case FBSessionStateCreated:
//                         NSLog(@"FBSessionStateCreated");
//                         break;
//                         
//                     case FBSessionStateCreatedOpening:
//                         NSLog(@"FBSessionStateCreatedOpening");
//                         break;
//                         
//                     case FBSessionStateCreatedTokenLoaded:
//                         NSLog(@"FBSessionStateCreatedTokenLoaded");
//                         break;
//                         
//                     case FBSessionStateOpenTokenExtended:
//                         NSLog(@"FBSessionStateOpenTokenExtended");
//                         break;
//                         
//                     default:
//                         break;
//                 }
                 if (status == FBSessionStateOpen || status == FBSessionStateOpenTokenExtended){
                     if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                         // if no permission, then we request it now
                         [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                                               defaultAudience:FBSessionDefaultAudienceFriends
                                                             completionHandler:^(FBSession *session, NSError *error) {
                                                                 if (!error) {
                                                                     NSLog(@"FBSessionStateOpen with No Error");
                                                                     NSLog(@"<-------------------------->");
                                                                     action();
                                                                 }
                                                                 else {
                                                                     NSLog(@"FBSessionStateOpen with Error");
                                                                     NSLog(@"<-------------------------->");
                                                                     NSLog(@"%@", error);
                                                                     errorFunction();
                                                                 }
                                                             }];
                     } else {
                         action();
                     }
                 }
                 else {
                     NSLog(@"FBSessionState Not Open");
                     NSLog(@"<-------------------------->");
                     errorFunction();
                 }
             }
         }];
    }
    else {
        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
            // if no permission, then we request it now
            [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                                  defaultAudience:FBSessionDefaultAudienceFriends
                                                completionHandler:^(FBSession *session, NSError *error) {
                                                    if (!error) {
                                                        NSLog(@"FBSessionStateOpen with No Error");
                                                        NSLog(@"<-------------------------->");
                                                        action();
                                                    }
                                                    else {
                                                        NSLog(@"FBSessionStateOpen with Error");
                                                        NSLog(@"<-------------------------->");
                                                        NSLog(@"%@", error);
                                                        errorFunction();
                                                        //[FBSession setActiveSession:session];
                                                    }
                                                }];
        } else {
            NSLog(@"Smooth");
            NSLog(@"<-------------------------->");
            action();
        }
    }

    
}

- (void) postStatusWithMessage:(NSString*)text withCompletionHandler:(void (^)(void))completion withErrorHandler:(void (^)(void))errorFunction
{
    [self performPublishAction:^{
        [FBRequestConnection startForPostStatusUpdate:text
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        if (!error) {
                                            completion();
                                        }
                                        else {
                                            NSLog(@"%@", error);
                                            errorFunction();
                                            
                                        }
                                    }];
        
    } andErrorHander:^(void){
        errorFunction();
    }];
}

- (void)postImage:(UIImage*)image withCaption:(NSString*)caption withCompletionHandler:(void (^)(void))completion withErrorHandler:(void (^)(void))errorFunction
{
    counter = 0;
    NSLog(@"Post Image");
    NSLog(@"<-------------------------->");
    [self performPublishAction:^{
        NSData* imageData = UIImageJPEGRepresentation(image, 100);
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        caption, @"message",
                                        imageData, @"source",
                                        nil];
        
        [FBRequestConnection startWithGraphPath:@"me/photos"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      completion();
                                  }
                                  else {
                                      NSLog(@"%@", error);
                                      errorFunction();
                                  }
                              }];
    } andErrorHander:^(void){
        errorFunction();
    }];
}

- (void)logout {
    [FBSession.activeSession closeAndClearTokenInformation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenInformationKey"];
    
    //Remove facebook Cookies:
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([cookie.domain isEqualToString:@".facebook.com"] || [cookie.domain isEqualToString:@"facebook.com"]) {
            [storage deleteCookie:cookie];
//            NSLog(@"Delete facebook cookie: %@",cookie);
        }
    }
    [defaults synchronize];
}

- (void)loginWithCompletionHandler:(void (^)(void)) action andErrorHander:(void (^)(void)) errorFunction {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // Even though we had a cached token, we need to login to make the session usable:
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error){
                errorFunction();
            }
            else {
                action();
            }
            return;
        }];
    }
    
    if (!FBSession.activeSession.isOpen) {
        if (FBSession.activeSession.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            FBSession.activeSession = [[FBSession alloc] init];
        }
        [FBSession.activeSession openWithCompletionHandler: ^(FBSession *session, FBSessionState status, NSError *error)
         {
             if (error){
                 errorFunction();
             }
             else {
                 action();
             }
             return;
         }];
    }
}

- (void)openActiveSession {
    [FBSession openActiveSessionWithAllowLoginUI: NO];
}
@end
