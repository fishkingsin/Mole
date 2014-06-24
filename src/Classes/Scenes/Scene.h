//
//  Scene.h
//  Mole
//
//  Created by James Kong on 17/5/13.
//
//

#import "Sparrow.h"
#define KEY_BACK @"Back"
#define KEY_CONFIRM @"Confirm"
#define KEY_FACEBOOK @"Facebook"
#define KEY_SAVE @"Save"
#define KEY_CANCEL @"Cancel"
#define EVENT_TYPE_SCENE_CLOSING @"closing"
#define KEY_POST_COMPLETE @"Post Complete"
#define KEY_POST_ERROR @"Post Error"
#define KEY_SWITCH_USER @"Switch User"

#define SCROLL_SIZE 310
// A scene is just a sprite with a back button that dispatches a "closing" event
// when that button was hit. All scenes inherit from this class.
#define BANNER_HEIGHT 50
@interface Scene : SPSprite
- (void)onBackButtonTriggered:(SPEvent *)event;
- (void)onSceneClosing:(SPEvent *)event;

//added backbutton sync
@property(nonatomic,strong)SPButton *backButton;
@end