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
	// Do any additional setup after loading the view.
    // 在畫面下方建立標準廣告大小的畫面。
    bannerView_ = [[GADBannerView alloc]
                   initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    bannerView_.adUnitID = @"a1521c629207880";
    
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    

    [bannerView_ loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
