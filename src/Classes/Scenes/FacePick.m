//
//  FacePick.m
//  Mole
//
//  Created by James Kong on 17/5/13.
//
//

#import "FacePick.h"
@interface FacePick ()
- (void)onImageTouched:(SPTouchEvent *)event;
- (void)onButtonTriggered:(SPEvent *)event;
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
    SPButton *conifirmButton;
    SPButton *maleButton;
    SPButton *femaleButton;
    UIScrollView *scroll;

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
    for (UIView *view in scroll.subviews) {
        [view removeFromSuperview];
    }
    if(scroll!=nil)[scroll removeFromSuperview];
}

- (void)setup
{

    
    _faceFile = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"UserName"];
    SPTextField * _userNameTF = [SPTextField textFieldWithWidth:100 height:25
                                                     text:name];
    _userNameTF.x = 10;
    _userNameTF.y = 10;
    _userNameTF.hAlign = SPHAlignLeft;
    _userNameTF.vAlign = SPVAlignTop;
    _userNameTF.border = NO;
    _userNameTF.color = 0x000000;
    [self addChild:_userNameTF];
    
    
    maleButton = [self createButton:@"Male" :@"button_short.png"];
    maleButton.x = (Sparrow.stage.width-( maleButton.width*2))*0.5;
    maleButton.y = 0;
    maleButton.enabled = NO;
    [maleButton addEventListener:@selector(onMaleTriggered:) atObject:self
                        forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:maleButton];
    
    femaleButton = [self createButton:@"Female" :@"button_short.png" ];
    femaleButton.x = (Sparrow.stage.width-( maleButton.width*2))*0.5+maleButton.width;
    femaleButton.y = 0;
    femaleButton.enabled = YES;
    [femaleButton addEventListener:@selector(onFemaleTriggered:) atObject:self
                         forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:femaleButton];
    
//    [maleButton addEventListener:@selector(onMaleTriggered::) atObject:self
//                        forType:SP_EVENT_TYPE_TRIGGERED];
//    _maleThumbnailImages = [NSArray arrayWithObjects:
//                              @"ks_holy-tricky_male.png",
//                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
//                            @"ks_holy-tricky_male.png",
//                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
//                            @"ks_holy-tricky_male.png",
//                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
//                            @"ks_holy-tricky_male.png",
//                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
//                            @"ks_holy-tricky_male.png",
//                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
//                            @"ks_holy-tricky_male.png",
//                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
//                            nil];

    _maleThumbnailImages = [NSArray arrayWithObjects:
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            @"ks_holy-tricky_male.png",
                            @"ks_holy-tricky_male_thumb.png",
                            nil];
//    _femaleThumbnailImages = [NSArray arrayWithObjects:
//                       @"tse_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
//                       @"ks_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
//                       @"tse_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
//                       @"ks_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
//                       @"tse_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
//                       @"ks_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
//                       @"tse_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
//                       @"ks_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
//                       @"tse_holy-tricky_female.png",
//                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
//                       nil];
    _femaleThumbnailImages = [NSArray arrayWithObjects:
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              @"ks_holy-tricky_female.png",
                              @"ks_holy-tricky_female_thumb.png",
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              @"ks_holy-tricky_female.png",
                              @"ks_holy-tricky_female_thumb.png",
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              @"ks_holy-tricky_female.png",
                              @"ks_holy-tricky_female_thumb.png",
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              @"ks_holy-tricky_female.png",
                              @"ks_holy-tricky_female_thumb.png",
                              @"tse_holy-tricky_female.png",
                              @"tse_holy-tricky_female_thumb.png",
                              nil];

    
    /*
     it is going ot change it to Scroll View
     */
    int index = 0;
    int count = 0;
    float offSetX = (Sparrow.stage.width-310)*0.5;
    float offSetY = (Sparrow.stage.height-310)*0.5;
//    while (index < _maleThumbnailImages.count)
//    {
//        NSString *faceName = _maleThumbnailImages[index++];
//        SPTexture * image = _maleThumbnailImages[index++];
//
//        
//        SPButton *button = [SPButton buttonWithUpState: image];
//        button.x = offSetX+(count % 3)*105;
//        button.y = offSetY+(count / 3) * 105;
//        button.name = faceName;
//        
//        
//        [button addEventListener:@selector(onButtonTriggered:) atObject:self
//                         forType:SP_EVENT_TYPE_TRIGGERED];
//        // play a sound when the image is touched
//        [button addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
//        
//        [self addChild:button];
//        ++count;
//    }
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(offSetX, offSetY, 310, 310)];
    scroll.pagingEnabled = YES;
    NSInteger numberOfViews = 3;
//    for (int i = 0; i < _maleThumbnailImages.count; i++) {
    while (index < _femaleThumbnailImages.count)
    {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(onFaceClicked:)
         forControlEvents:UIControlEventTouchDown];
//        [button setTitle:@"Show View" forState:UIControlStateNormal];
        button.frame = CGRectMake((count % 3)*105, (count / 3) * 105, 100, 100);
        

        NSString *faceName = _femaleThumbnailImages[index++];
        [button setTitle:faceName forState:UIControlStateNormal];
        [button addSubview:
         [[UIImageView alloc]initWithImage:
          [UIImage imageNamed:_femaleThumbnailImages[index++]]]];
        
        [scroll addSubview:button];
        ++count;
//        CGFloat yOrigin = i * Sparrow.currentController.view.frame.size.width;
//        UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, yOrigin, Sparrow.currentController.view.frame.size.width, Sparrow.currentController.view.frame.size.height)];
//        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
//        [scroll addSubview:awesomeView];
//        [awesomeView release];
    }

    scroll.contentSize = CGSizeMake(310, 105*(_maleThumbnailImages.count/3));
    [Sparrow.currentController.view addSubview:scroll];
//    [scroll release];
    
}

- (void) onFaceClicked: (id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"Button image value %@",[button titleForState:UIControlStateNormal ]);
    [Media playSound:@"sound.caf"];
    
//    SPButton *button = (SPButton *)event.target;
//    NSLog(@"onButtonTriggered %@", button.name);
    _faceFile=[button titleForState:UIControlStateNormal ];
    NSString* faceFile = [button titleForState:UIControlStateNormal ];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:faceFile forKey:@"TargetFaceFile"];
    [defaults synchronize];
    
    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
}
- (void)onImageTouched:(SPTouchEvent *)event
{
    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
    if ([touches anyObject]) [Media playSound:@"sound.caf"];
}

- (void)onButtonTriggered:(SPEvent *)event
{
    
    SPButton *button = (SPButton *)event.target;
    NSLog(@"onButtonTriggered %@", button.name);
    _faceFile=button.name;
    NSString* faceFile = button.name;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:faceFile forKey:@"TargetFaceFile"];
    [defaults synchronize];

    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
}
- (NSString*) getTargetFace
{
    return _faceFile;
}

- (void)onMaleTriggered:(SPEvent *)event
{
    maleButton.enabled = NO;
    femaleButton.enabled = YES;
}
- (void)onFemaleTriggered:(SPEvent *)event
{
    maleButton.enabled = YES;
    femaleButton.enabled = NO;
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
    
    [femaleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [maleButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
     [super onSceneClosing:event];
}
@end
