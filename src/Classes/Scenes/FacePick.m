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

@end
@implementation FacePick
{
    SPSprite *_contents;
    NSArray *_thumbnailImages;
    float _offsetY;
        NSString *_faceFile;
    SPButton *conifirmButton;

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
    _contents = [SPSprite sprite];
    [self addChild:_contents];
    
    _faceFile = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"UserName"];
    SPTextField * _userNameTF = [SPTextField textFieldWithWidth:100 height:25
                                                     text:name];
    _userNameTF.x = 20;
    _userNameTF.y = 20;
    _userNameTF.hAlign = SPHAlignLeft;
    _userNameTF.vAlign = SPVAlignTop;
    _userNameTF.border = NO;
    _userNameTF.color = 0x000000;
    [self addChild:_userNameTF];
    
    _thumbnailImages = [NSArray arrayWithObjects:
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
    int index = 0;
    int count = 0;

    while (index < _thumbnailImages.count)
    {
        NSString *faceName = _thumbnailImages[index++];
        SPTexture * image = _thumbnailImages[index++];

        
        SPButton *button = [SPButton buttonWithUpState: image];
        button.x = (count % 3)*105;
        button.y = (count / 3) * 105;
        button.name = faceName;
        
        
        [button addEventListener:@selector(onButtonTriggered:) atObject:self
                         forType:SP_EVENT_TYPE_TRIGGERED];
        // play a sound when the image is touched
        [button addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [_contents addChild:button];
        ++count;
    }
    

    
    
    [self updateLocations];
    
}
- (void)updateLocations
{
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    _contents.x = (int) (gameWidth  - _contents.width)  / 2;
    _contents.y = (int) (gameHeight - _contents.height) / 2;
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
@end
