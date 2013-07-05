//
//  FacebookShare.h
//  platformwatch
//
//  Created by Chung Tang on 17/4/13.
//  Copyright (c) 2013 Oregon Scientific Global Distribution Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookShare : NSObject

- (void) postStatusWithMessage:(NSString*)text withCompletionHandler:(void (^)(void))completion withErrorHandler:(void (^)(void))errorFunction;


- (void) postImage:(UIImage*)image withCaption:(NSString*)caption withCompletionHandler:(void (^)(void))completion withErrorHandler:(void (^)(void))errorFunction;

- (void)logout;

- (void)openActiveSession;

- (void)loginWithCompletionHandler:(void (^)(void)) action andErrorHander:(void (^)(void)) errorFunction;
@end
