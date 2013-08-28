//
//  BannerExampleViewController.m
//  Mole
//
//  Created by James Kong on 27/8/13.
//
//

#import "BannerExampleViewController.h"

@interface BannerExampleViewController ()

@end

@implementation BannerExampleViewController

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
	//@"a1521c629207880";
    
    interstitial_ = [[GADInterstitial alloc] init] ;
    interstitial_.delegate = self;
    
    // Note: Edit InterstitialExampleAppDelegate.m to update
    // INTERSTITIAL_AD_UNIT_ID with your interstitial ad unit id.
    
    interstitial_.adUnitID = @"a1521c629207880";
    
    [interstitial_ loadRequest: [self createRequest]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    // Alert the error.
    UIAlertView *alert = [[UIAlertView alloc]
                           initWithTitle:@"GADRequestError"
                           message:[error localizedDescription]
                           delegate:nil cancelButtonTitle:@"Drat"
                           otherButtonTitles:nil] ;
    [alert show];
    
 
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
 
}

#pragma mark GADRequest generation

// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
//    request.testDevices = [NSArray arrayWithObjects:@"a65bcdc085aebcbd4e5f04cfe8f7e23c", nil];
    return request;
}

@end
