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
    
    float offSetX = (int) (gameWidth  - Sparrow.stage.width)  / 2;
    float offSetY = (int) (gameHeight - Sparrow.stage.height) / 2;
    
//    float offSetWidth = 0;
//    float offSetHeight = 0;
    
    baseView = [[UIView alloc] initWithFrame:CGRectMake(offSetX, offSetY+50, Sparrow.stage.width, Sparrow.stage.height - offSetY-50)];
    baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
//    UIScrollView* _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 0, Sparrow.stage.width-50, Sparrow.stage.height - 50)];
//    [_scroll setBackgroundColor:[UIColor clearColor]];

//    NSInteger numberOfViews = 3;
//    for (int i = 0; i < numberOfViews; i++) {
//        CGFloat yOrigin = i * (Sparrow.stage.height - offSetWidth);
//        UIView *awesomeView = [[UIView alloc    ] initWithFrame:CGRectMake(0, yOrigin, Sparrow.stage.width-offSetWidth, Sparrow.stage.height - offSetHeight)];
//        awesomeView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
//        [_scroll addSubview:awesomeView];
//
//    }
    
    UITextView *headerTV = [[UITextView alloc] initWithFrame:CGRectMake(0,10,
                                                                        baseView.frame.size.width,
                                                                        56)];
    [headerTV setBackgroundColor:[UIColor clearColor]];
    [headerTV setEditable:NO];
    [headerTV setTextColor:[UIColor whiteColor]];
    UIFont *headerTF = [UIFont fontWithName:@"Helvetica Neue Light" size:28.0];
    [headerTV setFont:headerTF];
    headerTV.text = NSLocalizedString(@"Credit", nil);
    headerTV.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:headerTV];
    
    CGRect textViewFrame = CGRectMake(0,headerTV.frame.origin.y+headerTV.frame.size.height,
                                      Sparrow.stage.width,Sparrow.stage.height - (headerTV.frame.origin.y+headerTV.frame.size.height));
//                                      _scroll.frame.size.width,
//                                      _scroll.frame.size.height);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setEditable:NO];
    [textView setTextColor:[UIColor whiteColor]];
    textView.textAlignment = NSTextAlignmentCenter;
    UIFont *textFont = [UIFont fontWithName:@"Helvetica Neue Light" size:14.0];
    [textView setFont:textFont];
    
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"credit" ofType:@"txt"];
    NSString *myText = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    
    textView.text = myText;

//    [_scroll addSubview:textView];
    
//    _scroll.contentSize = CGSizeMake(textView.frame.size.width,textView.frame.size.height*3);
    
//    _scroll.pagingEnabled = YES;
    

    [baseView addSubview:textView];
    [Sparrow.currentController.view addSubview:baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [baseView addGestureRecognizer:tap];
    
    
    
//    _button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,Sparrow.stage.width,Sparrow.stage.height)];
//    _button.backgroundColor = [UIColor clearColor];
//    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview: _button];
    
       [self addEventListener:@selector(onSceneClosing:) atObject:self
                   forType:EVENT_TYPE_CREDIT_CLOSING];
    
    baseView.frame = CGRectMake(0, -Sparrow.stage.height, Sparrow.stage.width, Sparrow.stage.height);
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
- (void)viewTapped:(UITapGestureRecognizer *)gr {
    CGRect easeOutFrame = baseView.frame;
    easeOutFrame.origin.y = -Sparrow.stage.height;
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
//- (void)buttonClick:(id)sender
//{
////    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
//    CGRect easeOutFrame = baseView.frame;
//    easeOutFrame.origin.y = -Sparrow.stage.height;
//    [UIView animateWithDuration:0.5
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         baseView.frame = easeOutFrame;
//                         
//                     }
//                     completion:^(BOOL finished){
//    [self dispatchEventWithType:EVENT_TYPE_CREDIT_CLOSING bubbles:YES];                         
//                     }];
//
//}
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
