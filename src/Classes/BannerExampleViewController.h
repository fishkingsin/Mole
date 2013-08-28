//
//  BannerExampleViewController.h
//  Mole
//
//  Created by James Kong on 27/8/13.
//
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
@interface BannerExampleViewController : SPViewController<GADInterstitialDelegate>
{

    GADInterstitial *interstitial_;
}
@end
