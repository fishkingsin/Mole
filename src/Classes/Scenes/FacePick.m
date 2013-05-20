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
    _maleThumbnailImages = [NSArray arrayWithObjects:
                              @"ks_holy-tricky_male.png",
                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
                            @"ks_holy-tricky_male.png",
                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
                            @"ks_holy-tricky_male.png",
                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
                            @"ks_holy-tricky_male.png",
                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
                            @"ks_holy-tricky_male.png",
                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
                            @"ks_holy-tricky_male.png",
                            [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_male_thumb.png"],
                            nil];

    
    _femaleThumbnailImages = [NSArray arrayWithObjects:
                       @"tse_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
                       @"ks_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
                       @"tse_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
                       @"ks_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
                       @"tse_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
                       @"ks_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
                       @"tse_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
                       @"ks_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"],
                       @"tse_holy-tricky_female.png",
                       [SPTexture textureWithContentsOfFile:@"tse_holy-tricky_female_thumb.png"],
                       nil];
    
    /*
     it is going ot change it to Scroll View
     */
    int index = 0;
    int count = 0;
    float offSetX = (Sparrow.stage.width-315)*0.5;
    float offSetY = (Sparrow.stage.height-315)*0.5;
    while (index < _maleThumbnailImages.count)
    {
        NSString *faceName = _maleThumbnailImages[index++];
        SPTexture * image = _maleThumbnailImages[index++];

        
        SPButton *button = [SPButton buttonWithUpState: image];
        button.x = offSetX+(count % 3)*105;
        button.y = offSetY+(count / 3) * 105;
        button.name = faceName;
        
        
        [button addEventListener:@selector(onButtonTriggered:) atObject:self
                         forType:SP_EVENT_TYPE_TRIGGERED];
        // play a sound when the image is touched
        [button addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addChild:button];
        ++count;
    }
    
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
