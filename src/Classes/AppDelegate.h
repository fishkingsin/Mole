//
//  AppDelegate.h
//  AppScaffold
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate , GADInterstitialDelegate>
{
    NSTimer *currentTimer;
    GADInterstitial *splashInterstitial_;
}
@property(nonatomic, readonly) NSString *interstitialAdUnitID;
- (GADRequest *)createRequest;

@end
