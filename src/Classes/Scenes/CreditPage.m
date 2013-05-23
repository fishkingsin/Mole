//
//  CreaditPage.m
//  Mole
//
//  Created by James Kong on 5/23/13.
//
//

#import "CreditPage.h"

@interface CreditPage ()

@end
@implementation CreditPage
{
    UIScrollView *_scroll;
    SPButton *_backButton;
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
}

- (void)setup
{
    float offSetX = 20;
    float offSetY = 20;
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(offSetX, offSetY, Sparrow.stage.width-40, Sparrow.stage.height-40)];
    [_scroll setBackgroundColor:[UIColor darkGrayColor]];
    _scroll.alpha = 0.7f;
    NSInteger numberOfViews = 3;
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat yOrigin = i * (Sparrow.stage.height-40);
        UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, yOrigin, Sparrow.stage.width-40, Sparrow.stage.height-40)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        [_scroll addSubview:awesomeView];

    }
    _scroll.contentSize = CGSizeMake(Sparrow.stage.width-40, (Sparrow.stage.height-40)*3);
    
    _scroll.pagingEnabled = YES;

    
    [Sparrow.currentController.view addSubview:_scroll];
    
    // create a button with the text "back" and display it at the bottom of the screen.
    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:@"button_back.png"];
    
    _backButton = [[SPButton alloc] initWithUpState:buttonTexture text:@"back"];
    _backButton.x = Sparrow.stage.width*0.5 - _backButton.width / 2.0f;
    _backButton.y = Sparrow.stage.height - _backButton.height + 1;
    _backButton.name = @"back";
    [_backButton addEventListener:@selector(onBackButtonTriggered:) atObject:self
                          forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_backButton];
    [self addEventListener:@selector(onSceneClosing:) atObject:self
                   forType:EVENT_TYPE_CREDIT_CLOSING];
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
