//
//  AppDelegate.m
//  AppScaffold
//

#import "AppDelegate.h"
#import "Game.h"
//#define USE_BANNER
#ifdef USE_BANNER
#import "BannerExampleViewController.h"
#endif
#import <FacebookSDK/FacebookSDK.h>
// --- c functions ---

void onUncaughtException(NSException *exception)
{
    NSLog(@"uncaught exception: %@", exception.description);
}

// ---

@implementation AppDelegate
{
#ifndef USE_BANNER
    SPViewController *_viewController;
#else
    BannerExampleViewController *_viewController;    
#endif
    

    UIWindow *_window;
//    BannerExampleViewController * banner;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _window = [[UIWindow alloc] initWithFrame:screenBounds];
    
    [SPAudioEngine start];
    
    _viewController = [[SPViewController alloc] init];
    _viewController.multitouchEnabled = YES;
    [_viewController startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:YES];
    
    [_window setRootViewController:_viewController];
    [_window makeKeyAndVisible];
    
    // What follows is a very simple approach to support the iPad:
    // we just center the stage on the screen!
    //
    // (Beware: to support autorotation, this would need a little more work.)
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _viewController.view.frame = CGRectMake(64, 32, 640, 960);
        _viewController.stage.width = 320;
        _viewController.stage.height = 568;
    }

    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
    //killing timer
    
    if(currentTimer!=nil)
    {
        if([currentTimer isValid]){
            NSLog(@"kill timer");
            [currentTimer invalidate];
            currentTimer = nil;
        }
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Start Timer");
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(theActionMethod) userInfo:nil repeats:NO];
}
- (void)theActionMethod {
	NSLog(@"5mins pass exit app");
    exit(0);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


@end
