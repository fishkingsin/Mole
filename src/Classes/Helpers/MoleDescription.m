//
//  MoleDescription.m
//  Mole
//
//  Created by James Kong on 5/25/13.
//
//

#import "MoleDescription.h"
@interface MoleDescription ()


@end
@implementation MoleDescription
{
    NSString* _name;
//    NSString* _myText;
}

@synthesize name = _name;
//@synthesize myText = _myText;
- (id)init
{
    // the designated initializer of the base class should always be overridden -- we do that here.
//    SPQuad *quad = [[SPQuad alloc] init];
//    return [self initWithQuad:quad];
    return [super init];
}
- (id)initWithName:(NSString*)name //description:(NSString*)description
{
    if ((self = [super init]))
    {
        _name = name;
//        _myText = description;
        SPTextField *colorTF = [SPTextField textFieldWithWidth:30 height:20
                                                          text:_name];
        colorTF.x = 0;
        colorTF.y = 0;
        colorTF.border = YES;
        colorTF.color = 0x333399;
        [self addChild:colorTF];
    }
    return self;
}
@end
