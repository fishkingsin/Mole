//
//  Scene.h
//  Mole
//
//  Created by James Kong on 17/5/13.
//
//

#import "SPSprite.h"

#define EVENT_TYPE_SCENE_CLOSING @"closing"

// A scene is just a sprite with a back button that dispatches a "closing" event
// when that button was hit. All scenes inherit from this class.

@interface Scene : SPSprite
- (void)onBackButtonTriggered:(SPEvent *)event;
- (void)onSceneClosing:(SPEvent *)event;

//added backbutton sync
@property(nonatomic,strong)SPButton *backButton;
@end