//
//  CreaditPage.m
//  Mole
//
//  Created by James Kong on 5/23/13.
//
//

#import "CreditPage.h"

@interface CreditPage ()

-(void)buttonClick:(id)sender;

@end
@implementation CreditPage
{
    UIView *baseView;
//    UIScrollView *_scroll;
    SPButton *_backButton;
    UIButton* _button;
}
- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{

    for (UIView *view in baseView.subviews) {
        [view removeFromSuperview];
    }
    if(baseView!=nil)[ baseView removeFromSuperview];
    
    if(_button!=nil){
        [_button removeFromSuperview];
    }
}

- (void)setup
{
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    float offSetX = (int) (gameWidth  - GAME_WIDTH)  / 2;
    float offSetY = (int) (gameHeight - GAME_HEIGHT) / 2;
    
    float offSetWidth = 0;
    float offSetHeight = 0;
    
    baseView = [[UIView alloc] initWithFrame:CGRectMake(offSetX, offSetY+50, GAME_WIDTH, GAME_HEIGHT-offSetY-50)];
    baseView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    
    UIScrollView* _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, GAME_WIDTH-offSetWidth, GAME_HEIGHT)];
    [_scroll setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7]];

//    NSInteger numberOfViews = 3;
//    for (int i = 0; i < numberOfViews; i++) {
//        CGFloat yOrigin = i * (GAME_HEIGHT-offSetWidth);
//        UIView *awesomeView = [[UIView alloc    ] initWithFrame:CGRectMake(0, yOrigin, GAME_WIDTH-offSetWidth, GAME_HEIGHT-offSetHeight)];
//        awesomeView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
//        [_scroll addSubview:awesomeView];
//
//    }
    CGRect textViewFrame = CGRectMake(baseView.frame.origin.x,
                                      baseView.frame.origin.y,
                                      baseView.frame.size.width,
                                      baseView.frame.size.height);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setEditable:NO];
    [textView setTextColor:[UIColor whiteColor]];
    UIFont *textFont = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    [textView setFont:textFont];
    textView.text = @"App設計構思: 細So, 朱薰, C君, 毫子, 家媛\nApp名設計: Timmy Chu\nApp製作: James Kong fishkingsin.com\n面相圖互動設計: Jason Lam mb09.com\n資料提供：麥玲玲師父\n面相圖提供：門小雷, KS, 小克, Peter Ng, 路邊攤, Donald@903, 謝曬皮\n特別鳴謝：謝茜嘉@903, Mike@CRi, Ryan@CRi\nApp名全力支持：Lilian Chung, Horlick Ho Lai Chu, Kathy Fok, Keith Wong, Lam Wing Chi, Chung Sing Ping, Ng ShekLun Jeff, Gab Tang, KG Thekanson, Ben Leung, Wing Chow, Candy Chau, Mitsuki Leung, Brian Leung, Betty Fung, YanChing Sin, Travis Chan, Martin Choi, Mcchihou, SzeWah, Felix Leung, Tobias Ma, Ka Ying Ngai, 塵穎移, Timmy Chu, Eric Wong, Angel Wong, yangusTayori, Chip Chengminmin, Jacob Lau Ka Ho, Jess Chung, martin Wong, Ip Cy, Carol Cheung, Nicole Chan, Wilson Perry, Dickson Lam Tik Sang, Emily Minnie Wong, molly Tai, Angela Tse, ZumiQian, Vivian Ho, Ting Yip, FatfatKwong, Joe Yuen, Sherry Chan, Ivyivy Ng, Jenny Law, Matthew Wong, Edmond Chan, Deniece Yuen, Sqquare Fong, Elaine yuen, Robert Fung, My Beauty Art, Melanie Wong, Wing Wing, VB Tai, Eric Leung Yin, Leung Ka Yee Helen, ChichuenIp, Koby Wong, Matty Wong, Freda Cheng, Anshun Wong, Esther Liang Shi Wei, Wong Melody, Wong Kan, Cody Cheung, Carrie Yuen Lok Ting, Abby Lam, Alfredo So, Chow Wun Yan, C Wai Yu, Leo Chan, Ting Lap, Kowk Dada, Mini Cheng Wing Sze, Larry Law, Anna M. Chan, Tobey Shum, Frank Chin, Kit Yin Chung, Edwin Chow, David Karl";
    //    textView.returnKeyType = UIReturnKeyDone;
    [_scroll addSubview:textView];
    
    _scroll.contentSize = CGSizeMake(textViewFrame.size.width,textViewFrame.size.height);
    
    _scroll.pagingEnabled = YES;

    [baseView addSubview:_scroll];
    [Sparrow.currentController.view addSubview:baseView];
    
    
    
    
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(GAME_WIDTH-offSetWidth-50, 0, 50, 50)];
    _button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview: _button];
    
       [self addEventListener:@selector(onSceneClosing:) atObject:self
                   forType:EVENT_TYPE_CREDIT_CLOSING];
    
    baseView.frame = CGRectMake(0, -GAME_HEIGHT, GAME_WIDTH, GAME_HEIGHT);
    CGRect easeInFrame = baseView.frame;
    easeInFrame.origin.y = offSetY;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         baseView.frame = easeInFrame;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];

}
- (void)buttonClick:(id)sender
{
//    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    CGRect easeOutFrame = baseView.frame;
    easeOutFrame.origin.y = -GAME_HEIGHT;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         baseView.frame = easeOutFrame;
                         
                     }
                     completion:^(BOOL finished){
    [self dispatchEventWithType:EVENT_TYPE_CREDIT_CLOSING bubbles:YES];                         
                     }];

}
- (void)onBackButtonTriggered:(SPEvent *)event
{
    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self dispatchEventWithType:EVENT_TYPE_CREDIT_CLOSING bubbles:YES];
}
- (void)onSceneClosing:(SPEvent *)event
{
    [self removeEventListenersAtObject:self forType:EVENT_TYPE_CREDIT_CLOSING];
}

@end
