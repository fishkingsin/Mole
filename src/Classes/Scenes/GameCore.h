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
#define SQ(x) ((x)*(x))



#define  NUM_MOLE 10
#define GAME_STATE_DRAGGING 0x10
#define GAME_STATE_CONFIRMED 0x11
#define GAME_STATE_TOUCHMOLE 0x12
#define GAME_STATE_SHOWDESCRITPION 0x13
#define GAME_STATE_END 0x14
#define DEBUG
#import "Scene.h"
#import "TouchSheet.h"
@interface GameCore : Scene
//-(void)setFaceFile : (NSString*)fileName;
@end
