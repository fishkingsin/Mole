//
//  GameCore.h
//  Mole
//
//  Created by James Kong on 18/5/13.
//
//
#import <Foundation/Foundation.h>
#include <sys/utsname.h>
#import <Social/Social.h>

#define KEY_CONFIRM @"Confirm"
#define KEY_FACEBOOK @"Facebook"
#define KEY_SAVE @"Save"
#define KEY_CANCEL @"Cancel"


#define  NUM_MOLE 10
#define GAME_STATE_DRAGGING 0x10
#define GAME_STATE_CONFIRMED 0x11
#define GAME_STATE_END 0x12

#import "Scene.h"
#import "TouchSheet.h"
@interface GameCore : Scene
//-(void)setFaceFile : (NSString*)fileName;
@end
