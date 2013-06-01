//
//  CustomUIButton.h
//  singleViewRemote
//
//  Created by james KONG on 31/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBShapedButton.h"
@interface CustomUIButton : UIButton//OBShapedButton

{
    NSString *message;
    CGAffineTransform oriTransform;
    CGAffineTransform tarTransform;
    BOOL bToggle;
    NSString *imageOn;
    NSString *imageOff;
}
- (void)activeAnimation;
- (void)deactiveAnimation;

- (void)toggleAnimation;
- (void)setMessage:(NSString *)_message;
- (void)setImageNamesOn:(NSString *)_message;
- (void)setImageNamesOff:(NSString *)_message;
- (NSString *)getMessage;
@end
