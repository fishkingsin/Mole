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
    UIScrollView *_scroll;
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
    for (UIView *view in _scroll.subviews) {
        [view removeFromSuperview];
    }
    if(_scroll!=nil)[_scroll removeFromSuperview];
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
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(offSetX, offSetY, GAME_WIDTH-offSetWidth, GAME_HEIGHT-offSetHeight)];
    [_scroll setBackgroundColor:[UIColor darkGrayColor]];
    _scroll.alpha = 0.7f;
    NSInteger numberOfViews = 3;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat yOrigin = i * (GAME_HEIGHT-offSetWidth);
        UIView *awesomeView = [[UIView alloc    ] initWithFrame:CGRectMake(0, yOrigin, GAME_WIDTH-offSetWidth, GAME_HEIGHT-offSetHeight)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        [_scroll addSubview:awesomeView];

    }
    _scroll.contentSize = CGSizeMake(GAME_WIDTH-offSetWidth, (GAME_HEIGHT-offSetHeight)*3);
    
    _scroll.pagingEnabled = YES;

    
    [Sparrow.currentController.view addSubview:_scroll];
    
    
    
    CGRect textViewFrame = CGRectMake(_scroll.frame.origin.x,
                                      _scroll.frame.origin.y,
                                      _scroll.contentSize.width,
                                      _scroll.contentSize.height-50);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setEditable:NO];

    textView.text = @"asfqwegjhwqilfhqliuwefghuil\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\nwbhefliu\n";
//    textView.returnKeyType = UIReturnKeyDone;
    [_scroll addSubview:textView];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(GAME_WIDTH-offSetWidth-50, offSetY, 50, 50)];
    _button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [Sparrow.currentController.view addSubview: _button];
    
       [self addEventListener:@selector(onSceneClosing:) atObject:self
                   forType:EVENT_TYPE_CREDIT_CLOSING];
    
    _scroll.frame = CGRectMake(0, -GAME_HEIGHT, gameWidth, gameHeight);
    CGRect easeInFrame = _scroll.frame;
    easeInFrame.origin.y = offSetY;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scroll.frame = easeInFrame;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];

}
- (void)buttonClick:(id)sender
{
//    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self dispatchEventWithType:EVENT_TYPE_CREDIT_CLOSING bubbles:YES];
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
