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
        
        _backButton = [[SPButton alloc] initWithUpState:buttonTexture text:@"back"];
        _backButton.x = CENTER_X - _backButton.width / 2.0f;
        _backButton.y = GAME_HEIGHT - _backButton.height + 1;
        _backButton.name = @"back";
        [_backButton addEventListener:@selector(onBackButtonTriggered:) atObject:self
                              forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:_backButton];
        [self addEventListener:@selector(onSceneClosing:) atObject:self
                       forType:EVENT_TYPE_SCENE_CLOSING];
    }
    return self;
}

- (void)onBackButtonTriggered:(SPEvent *)event
{
    
    [Media playSound:@"sound.caf"];
    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
}

- (void)onSceneClosing:(SPEvent *)event
{
    [self removeEventListenersAtObject:self forType:EVENT_TYPE_SCENE_CLOSING];
}
@end
