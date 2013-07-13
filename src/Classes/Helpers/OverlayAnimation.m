//
//  OverlayAnimation.m
//  Mole
//
//  Created by James Kong on 28/5/13.
//
//

#import "OverlayAnimation.h"


@interface OverlayAnimation ()

@end
@implementation OverlayAnimation
{
    
}
- (id)init
{
    if ((self = [super init]))
    {
        
        SPTextField *_userDescTF = [SPTextField textFieldWithWidth:Sparrow.stage.width height:Sparrow.stage.height text:@"fjkgnqeklrb\nfjkgnqeklrb\nfjkgnqeklrb\nfjkgnqeklrb\nfjkgnqeklrb\n"];
        
        _userDescTF.hAlign = SPHAlignLeft ;
        _userDescTF.vAlign = SPVAlignCenter ;
        _userDescTF.border = NO;
        _userDescTF.color = 0xFFFFFF;
        [self addChild:_userDescTF];
    }
    return self;
}
- (void)render:(SPRenderSupport*)support
{
#ifdef DEBUG
    NSLog(@"OverlayAnimation rendering");
#endif
    //should do super render before the cap screen
    [super render:support];
}
@end
