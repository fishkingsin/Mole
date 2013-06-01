//
//  CustomUIButton.m
//  singleViewRemote
//
//  Created by james KONG on 31/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomUIButton.h"

@implementation CustomUIButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGAffineTransform scale = CGAffineTransformMakeScale(1.0, 1.0);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(	0,0);
        
        oriTransform = CGAffineTransformConcat(scale,translate);
        
        CGAffineTransform  _scale = CGAffineTransformMakeScale(1.0, 1.0);
        CGAffineTransform _translate = CGAffineTransformMakeTranslation(0,0);
        
        tarTransform = CGAffineTransformConcat(_scale,_translate);
        self.transform = oriTransform;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)activeAnimation
{
   
        
        bToggle = YES;            
       
    [self setImage:[UIImage imageNamed:bToggle ? imageOn :imageOff] forState:UIControlStateNormal];    
//    CGRect startFrame = self.frame;    
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         
//                         bToggle = YES;            
//                         self.transform = tarTransform;
//                         
//                         
//                     } 
//                     completion:^(BOOL finished) {
//                         
//                     }];
    
}
- (void)deactiveAnimation
{
    
    bToggle = NO;
    
    [self setImage:[UIImage imageNamed:bToggle ? imageOn :imageOff] forState:UIControlStateNormal];
//    CGRect startFrame = self.frame;    
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         
//                         self.transform = oriTransform;
//                         bToggle = NO;
//                         
//                         
//                     } 
//                     completion:^(BOOL finished) {
//                         
//                     }];
    
}
- (void)toggleAnimation
{
    
//    CGRect startFrame = self.frame;    
    //[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear
    //                 animations:^{
                         if(bToggle ==NO)
                         {
                             
                             bToggle = YES;            
                             //self.transform = tarTransform;
                         }
                         else {
                             //self.transform = oriTransform;
                             bToggle = NO;
                         }
                         [self setImage:[UIImage imageNamed:bToggle ? imageOn :imageOff] forState:UIControlStateNormal];
    //                 } 
    //                 completion:^(BOOL finished) {
    //                     
    //                 }];
        
}
- (void)setMessage:(NSString *)_message
{
    message = [[NSString alloc] initWithFormat:_message];
}
- (void)setImageNamesOn:(NSString *)_message
{
    imageOn = [[NSString alloc] initWithFormat:_message];
}
- (void)setImageNamesOff:(NSString *)_message
{
    imageOff = [[NSString alloc] initWithFormat:_message];
}
- (NSString *)getMessage
{
    return message;
}

@end
