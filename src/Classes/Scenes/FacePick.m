//
//  FacePick.m
//  Mole
//
//  Created by James Kong on 17/5/13.
//
//
#import "CustomUIButton.h"
#import "FacePick.h"
#import <QuartzCore/QuartzCore.h>


@interface FacePick ()
- (void)onImageTouched:(SPTouchEvent *)event;
//- (void)onButtonTriggered:(SPEvent *)event;
- (void)onMaleTriggered:(SPEvent *)event;
- (void)onFemaleTriggered:(SPEvent *)event;
-(SPButton*) createButton:(NSString*) _text : (NSString*)filePath;
@end
@implementation FacePick
{
    //    SPSprite *self;
    NSArray *_femaleThumbnailImages;
    NSArray *_maleThumbnailImages;
    float _offsetY;
    NSString *_faceFile;
    SPButton *_conifirmButton;
    SPButton *_maleButton;
    SPButton *  _femaleButton;
    UIScrollView *_scroll;
    
}
@synthesize faceFile = _faceFile;

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
    if(_conifirmButton!=nil)
    {
        [_conifirmButton removeFromParent];
    }
    if(_maleButton!=nil)
    {
        [_maleButton removeFromParent];
        [_maleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
    }
    if(_femaleButton!=nil)
    {
        [_femaleButton removeFromParent];
        [_femaleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
}

- (void)setup
{
    int gameWidth  = Sparrow.stage.width;
    //int gameHeight = Sparrow.stage.height;
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"alpha_background.png"];
    [self addChild:background];
    [self addChild:[super backButton]];
    self.x = Sparrow.stage.width*0.5;
    self.alpha = 0;
    SPTween *tween = [SPTween tweenWithTarget:self time:0.5f transition:SP_TRANSITION_LINEAR];
    [tween fadeTo:1.0f];
    [tween moveToX:0 y:0.0f];
    [Sparrow.juggler addObject:tween];
    
    _faceFile = nil;

    float offSetX = (Sparrow.stage.width-SCROLL_SIZE)*0.5+(int) (gameWidth  - Sparrow.stage.width)  / 2;
    float offSetY = (Sparrow.stage.height*0.5)  - SCROLL_SIZE*0.33333f;

    
    _maleButton = [self createButton:NSLocalizedString(KEY_MALE, nil) :@"button_short.png"];
    _maleButton.x = (Sparrow.stage.width-( _maleButton.width*2))*0.5;
    _maleButton.y = offSetY -  10 - _maleButton.height;
    _maleButton.enabled = YES;
    [_maleButton addEventListener:@selector(onMaleTriggered:) atObject:self
                          forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_maleButton];
    
    _femaleButton = [self createButton:NSLocalizedString(KEY_FEMALE, nil) :@"button_short.png" ];
    _femaleButton.x = (Sparrow.stage.width-( _maleButton.width*2))*0.5+_maleButton.width;
    _femaleButton.y = offSetY - 10 - _maleButton.height;
    _femaleButton.enabled = NO;
    [_femaleButton addEventListener:@selector(onFemaleTriggered:) atObject:self
                            forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_femaleButton];
    
    _maleThumbnailImages = [NSArray arrayWithObjects:
                            @"tse_holy-tricky_male.png",
                            @"tse_holy-tricky_male_thumb.png",
                            @"謝曬皮",
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"KS",
                            @"lbt_holy-tricky_male.png",
                            @"lbt_holy-tricky_male_thumb.png",
                            @"路邊攤",
                            @"peter_holy-tricky_male.png",
                            @"peter_holy-tricky_male_thumb.png",
                            @"Peter Ng",
                            @"donald_holy-tricky_male.png",
                            @"donald_holy-tricky_male_thumb.png",
                            @"Donald",
                            @"sh_holy-tricky_male.png",
                            @"sh_holy-tricky_male_thumb.png",
                            @"小克",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"",
                            @"blank_face.png",
                            @"",
                            nil];
    
    _femaleThumbnailImages = [NSArray arrayWithObjects:
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              @"謝曬皮",
                              @"ks_holy-tricky_female.png",
                              @"ks_holy-tricky_female_thumb.png",
                              @"KS",
                              @"lbt_holy-tricky_female.png",
                              @"lbt_holy-tricky_female_thumb.png",
                              @"路邊攤",
                              @"peter_holy-tricky_female.png",
                              @"peter_holy-tricky_female_thumb.png",
                              @"Peter Ng",
                              @"donald_holy-tricky_female.png",
                              @"donald_holy-tricky_female_thumb.png",
                              @"Donald",
                              @"sh_holy-tricky_female.png",
                              @"sh_holy-tricky_female_thumb.png",
                              @"小克",
                              @"littlethunder_holy-tricky_female.png",
                              @"littlethunder_holy-tricky_female_thumb.png",
                              @"門小雷",
                              @"",
                              @"blank_face.png",
                              @"",
                              @"",
                              @"blank_face.png",
                              @"",
                              nil];
    
    
    
    
    
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(Sparrow.stage.width, offSetY, SCROLL_SIZE, SCROLL_SIZE)];
    _scroll.pagingEnabled = YES;
    [self createScrollView:_femaleThumbnailImages];
    
    CGRect easeInFrame = _scroll.frame;
    easeInFrame.origin.x = offSetX;
    _scroll.alpha = 0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scroll.frame = easeInFrame;
                         _scroll.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    [Sparrow.currentController.view addSubview:_scroll];
    //    [scroll release];
    
}
-(void) createScrollView :(NSArray*)array
{
    for (UIView *view in _scroll.subviews) {
        [view removeFromSuperview];
    }
    int index = 0;
    int count = 0;
    
    
    
    int row = 0;
    if(array.count%3==0)
    {
        while (index < array.count)
        {
            CustomUIButton *new_button = [CustomUIButton buttonWithType:UIButtonTypeCustom];
            [new_button addTarget:self
                           action:@selector(onFaceClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
            NSString *faceName = array[index++];
            
            [new_button setMessage:faceName];
            UIImage *image1 = [UIImage imageNamed:array[index++]];
            NSString *authorName = array[index++];
            //[[UIImageView alloc]initWithImage:[UIImage imageNamed:array[index++]]];
            [new_button setFrame:CGRectMake((count % 3)*105, (count / 3) * 105, 100, 100)];
            [new_button setBackgroundImage: image1 forState:UIControlStateNormal];
            [new_button setBackgroundImage: image1 forState:UIControlStateSelected];
            [new_button setTitle:authorName forState:UIControlStateNormal];
            [new_button setTitle:authorName forState:UIControlStateSelected];
            [new_button setBackgroundColor:[UIColor clearColor]];
            [new_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [new_button setTitleEdgeInsets:UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f)];
            
            
            //            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //            [button addTarget:self
            //                       action:@selector(onFaceClicked:)
            //             forControlEvents:UIControlEventTouchDown];
            //            button.frame = CGRectMake((count % 3)*105, (count / 3) * 105, 100, 100);
            if(count%3==0)
            {
                row++;
            }
            
            //            NSString *faceName = array[index++];
            //            [button setTitle:faceName forState:UIControlStateNormal];
            //            [button addSubview:
            //             [[UIImageView alloc]initWithImage:
            //              [UIImage imageNamed:array[index++]]]];
            //
            //            [_scroll addSubview:button];
            [_scroll addSubview:new_button];
            ++count;
        }
        _scroll.contentSize = CGSizeMake(SCROLL_SIZE, 105*(row));
    }
    else{
        NSLog(@"Error : Array is not even number length please check the array content");
    }
}
- (void) onFaceClicked: (id)sender
{
    //    UIButton *button = (UIButton *)sender;
    CustomUIButton* theButton = (CustomUIButton*) sender;
    //    NSLog(@"Button image value %@",[button titleForState:UIControlStateNormal ]);
    [Media playSound:@"sound.caf"];
    
    _faceFile=[theButton getMessage];
#ifdef DEBUG
    NSLog(@"Button image value %@",theButton);
#endif
    //    _faceFile=[button titleForState:UIControlStateNormal ];
    //    NSString* faceFile = [button titleForState:UIControlStateNormal ];
    if(![_faceFile isEqualToString:@""])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_faceFile forKey:@"TargetFaceFile"];
        [defaults synchronize];
        
        
        SPTween *tween = [SPTween tweenWithTarget:self time:0.5f transition:SP_TRANSITION_LINEAR];
        //Delay the tween for two seconds, so that we can see the
        //change in scenery.
        [tween fadeTo:0.0f];
        
        [tween moveToX:-Sparrow.stage.height y:0.0f];
        
        //Register the tween at the nearest juggler.
        //(We will come back to jugglers later.)
        [Sparrow.juggler addObject:tween];
        
        CGRect easeOutFrame = _scroll.frame;
        easeOutFrame.origin.x = -_scroll.frame.size.width;
        [UIView animateWithDuration:0.5
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _scroll.frame = easeOutFrame;
                             _scroll.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
                             //                             [_textField removeFromSuperview];
                         }];
        //        [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert Title"
                                                                                    ,nil)
                                                          message:NSLocalizedString(@"Alert Body",nil)
                                                         delegate:nil
                                                cancelButtonTitle: NSLocalizedString(KEY_CONFIRM,nil)
                                                otherButtonTitles:nil];
        [message show];
    }
}
- (void)onImageTouched:(SPTouchEvent *)event
{
    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
    if ([touches anyObject]) [Media playSound:@"sound.caf"];
}

//- (void)onButtonTriggered:(SPEvent *)event
//{
//
//    SPButton *button = (SPButton *)event.target;
//    NSLog(@"onButtonTriggered %@", button.name);
//    _faceFile=button.name;
//    NSString* faceFile = button.name;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:faceFile forKey:@"TargetFaceFile"];
//    [defaults synchronize];
//
//    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
//}
- (NSString*) getTargetFace
{
    return _faceFile;
}

- (void)onMaleTriggered:(SPEvent *)event
{
    [Media playSound:@"sound.caf"];
    _maleButton.enabled = NO;
    _femaleButton.enabled = YES;
    
    
    [self createScrollView:_maleThumbnailImages];
}
- (void)onFemaleTriggered:(SPEvent *)event
{
    [Media playSound:@"sound.caf"];
    _maleButton.enabled = YES;
    _femaleButton.enabled = NO;
    [self createScrollView:_femaleThumbnailImages];
}
-(SPButton*) createButton:(NSString*) _text : (NSString*)filePath
{
    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:filePath];
    
    SPButton *newButton = [[SPButton alloc] initWithUpState:buttonTexture text:_text];
    
    newButton.name = _text;
    newButton.enabled = YES;
    
    
    return newButton;
}

- (void)onBackButtonTriggered:(SPEvent *)event
{
    CGRect easeInFrame = _scroll.frame;
    easeInFrame.origin.x = Sparrow.stage.width;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scroll.frame = easeInFrame;
                         _scroll.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    [super onBackButtonTriggered:event];
}
- (void)onSceneClosing:(SPEvent *)event
{
    
    [_femaleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_maleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [super onSceneClosing:event];
}
@end
