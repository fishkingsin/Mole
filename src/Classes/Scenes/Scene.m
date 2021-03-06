//
//  Scene.m
//  Mole
//
//  Created by James Kong on 17/5/13.
//
//

#import "Scene.h"
@interface Scene ()

@end
@implementation Scene
{
    SPButton *_backButton;
}
@synthesize backButton = _backButton;
//added backbutton sync
- (id)init
{
    if ((self = [super init]))
    {
        
        // create a button with the text "back" and display it at the bottom of the screen.
        SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:@"button_back.png"];
        
        _backButton = [[SPButton alloc] initWithUpState:buttonTexture text:NSLocalizedString(KEY_BACK, nil)];
        _backButton.x = 0;
        _backButton.y = Sparrow.stage.height - _backButton.height  - OFFSET_Y;
        _backButton.name = KEY_BACK;
        [_backButton addEventListener:@selector(onBackButtonTriggered:) atObject:self
                              forType:SPEventTypeTriggered];
        [self addChild:_backButton];
        [self addEventListener:@selector(onSceneClosing:) atObject:self
                       forType:EVENT_TYPE_SCENE_CLOSING];
        
    }
    return self;
}

- (void)onBackButtonTriggered:(SPEvent *)event
{
    
    [Media playSound:@"sound.caf"];
    [_backButton removeEventListenersAtObject:self forType:SPEventTypeTriggered];
    
    SPTween *tween = [SPTween tweenWithTarget:self time:0.5f transition:SP_TRANSITION_LINEAR];
    //Delay the tween for two seconds, so that we can see the
    //change in scenery.
    [tween fadeTo:0];
    [tween moveToX:Sparrow.stage.width y:0.0f];
    
    //Register the tween at the nearest juggler.
    //(We will come back to jugglers later.)
    [Sparrow.juggler addObject:tween];
    
    tween.onComplete = ^{
#ifdef DEBUG
        NSLog(@"Tween completed");
#endif
        [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];};
    
}

- (void)onSceneClosing:(SPEvent *)event
{
    [self removeEventListenersAtObject:self forType:EVENT_TYPE_SCENE_CLOSING];
}
@end
