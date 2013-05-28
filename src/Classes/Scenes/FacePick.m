//
//  FacePick.m
//  Mole
//
//  Created by James Kong on 17/5/13.
//
//

#import "FacePick.h"

#define SCROLL_SIZE 310

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
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.jpg"];
    [self addChild:background];
    [self addChild:[super backButton]];
    self.x = GAME_WIDTH;
    SPTween *tween = [SPTween tweenWithTarget:self time:1.0f transition:SP_TRANSITION_LINEAR];
    //Delay the tween for two seconds, so that we can see the
    //change in scenery.
    
    [tween moveToX:0 y:0.0f];
    
    //Register the tween at the nearest juggler.
    //(We will come back to jugglers later.)
    [Sparrow.juggler addObject:tween];
    
    
    _faceFile = nil;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *name = [defaults objectForKey:@"UserName"];
//    SPTextField * _userNameTF = [SPTextField textFieldWithWidth:100 height:25
//                                                           text:name];
//    _userNameTF.x = (GAME_WIDTH*0.5)-(_userNameTF.width*0.5);
//    _userNameTF.y = 50;
//    _userNameTF.hAlign = SPHAlignCenter ;
//    _userNameTF.vAlign = SPVAlignCenter ;
//    _userNameTF.border = NO;
//    _userNameTF.color = 0x000000;
//    [self addChild:_userNameTF];
    
    
    _maleButton = [self createButton:NSLocalizedString(KEY_MALE, nil) :@"button_short.png"];
    _maleButton.x = (GAME_WIDTH-( _maleButton.width*2))*0.5;
    _maleButton.y = 0;
    _maleButton.enabled = YES;
    [_maleButton addEventListener:@selector(onMaleTriggered:) atObject:self
                         forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_maleButton];
    
    _femaleButton = [self createButton:NSLocalizedString(KEY_FEMALE, nil) :@"button_short.png" ];
    _femaleButton.x = (GAME_WIDTH-( _maleButton.width*2))*0.5+_maleButton.width;
    _femaleButton.y = 0;
    _femaleButton.enabled = NO;
    [_femaleButton addEventListener:@selector(onFemaleTriggered:) atObject:self
                           forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_femaleButton];
    
    _maleThumbnailImages = [NSArray arrayWithObjects:
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"lbt_holy-tricky_male.png",
                            @"lbt_holy-tricky_male_thumb.png",
                            @"peter_holy-tricky_male.png",
                            @"peter_holy-tricky_male_thumb.png",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"blank_face.png",
                            @"",
                            @"blank_face.png",
                            nil];

    _femaleThumbnailImages = [NSArray arrayWithObjects:
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              @"ks_holy-tricky_female.png",
                              @"ks_holy-tricky_female_thumb.png",
                              @"lbt_holy-tricky_female.png",
                              @"lbt_holy-tricky_female_thumb.png",
                              @"peter_holy-tricky_female.png",
                              @"peter_holy-tricky_female_thumb.png",
                              @"",
                              @"blank_face.png",
                              @"",
                              @"blank_face.png",
                              @"",
                              @"blank_face.png",
                              @"",
                              @"blank_face.png",
                              @"",
                              @"blank_face.png",
                              nil];
    
    
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    
    float offSetX = (GAME_WIDTH-SCROLL_SIZE)*0.5+(int) (gameWidth  - GAME_WIDTH)  / 2;
    float offSetY = (GAME_HEIGHT-SCROLL_SIZE)*0.5+(int) (gameHeight - GAME_HEIGHT) / 2;
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(GAME_WIDTH, offSetY, SCROLL_SIZE, SCROLL_SIZE)];
    _scroll.pagingEnabled = YES;
    [self createScrollView:_femaleThumbnailImages];
    
    CGRect easeInFrame = _scroll.frame;
    easeInFrame.origin.x = offSetX;
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scroll.frame = easeInFrame;
                         
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
    
    
    
    
    if(array.count%2==0)
    {
        while (index < array.count)
        {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(onFaceClicked:)
             forControlEvents:UIControlEventTouchDown];
            button.frame = CGRectMake((count % 3)*105, (count / 3) * 105, 100, 100);
            
            
            NSString *faceName = array[index++];
            [button setTitle:faceName forState:UIControlStateNormal];
            [button addSubview:
             [[UIImageView alloc]initWithImage:
              [UIImage imageNamed:array[index++]]]];
            
            [_scroll addSubview:button];
            ++count;
        }
        _scroll.contentSize = CGSizeMake(SCROLL_SIZE, 105*(array.count/3));
    }
    else{
        NSLog(@"Error : Array is not even number length please check the array content");
    }
    
}
- (void) onFaceClicked: (id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Button image value %@",[button titleForState:UIControlStateNormal ]);
    [Media playSound:@"sound.caf"];
    
    _faceFile=[button titleForState:UIControlStateNormal ];
    NSString* faceFile = [button titleForState:UIControlStateNormal ];
    if(![faceFile isEqualToString:@""])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:faceFile forKey:@"TargetFaceFile"];
        [defaults synchronize];
        
        
        SPTween *tween = [SPTween tweenWithTarget:self time:1.0f transition:SP_TRANSITION_LINEAR];
        //Delay the tween for two seconds, so that we can see the
        //change in scenery.
        
        [tween moveToX:-GAME_HEIGHT y:0.0f];
        
        //Register the tween at the nearest juggler.
        //(We will come back to jugglers later.)
        [Sparrow.juggler addObject:tween];
        
        CGRect easeOutFrame = _scroll.frame;
        easeOutFrame.origin.x = -_scroll.frame.size.width;
        [UIView animateWithDuration:1
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _scroll.frame = easeOutFrame;
                             
                         }
                         completion:^(BOOL finished){
                             [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
//                             [_textField removeFromSuperview];
                         }];
//        [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
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
    _maleButton.enabled = NO;
    _femaleButton.enabled = YES;
    [self createScrollView:_maleThumbnailImages];
}
- (void)onFemaleTriggered:(SPEvent *)event
{
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
- (void)onSceneClosing:(SPEvent *)event
{
    
    [_femaleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_maleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    
    
    [super onSceneClosing:event];
}
@end
