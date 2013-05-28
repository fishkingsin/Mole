//
//  NameInput.m
//  Mole
//
//  Created by James Kong on 18/5/13.
//
//

#import "NameInput.h"
@interface NameInput ()<UITextFieldDelegate>

@end

@implementation NameInput
{
    UITextField *_textField;
    SPButton *_okButton;
    //    NSString *_yourName;
    float startX;
    float startY;
}

@synthesize textField = _textField ;
//@synthesize yourName = _yourName;

- (id)init
{
    if ((self = [super init]))
    {
        [self removeAllChildren];
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    if(_textField!=nil)
    {
        [_textField removeFromSuperview];
    }
    if(_okButton!=nil)
    {
        [_okButton removeFromParent];
        [_okButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
}

- (void)setup
{
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.jpg"];
    [self addChild:background];
    self.x = GAME_WIDTH;
    SPTween *tween = [SPTween tweenWithTarget:self time:0.5f transition:SP_TRANSITION_LINEAR];
    [tween moveToX:0 y:0.0f];
    [Sparrow.juggler addObject:tween];
    
    startY = CENTER_Y-CENTER_Y*0.3;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(GAME_WIDTH,startY-12.5, 160, 25)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.delegate = self;
    //read the last save user name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"UserName"];
    [_textField setText:name];
    [Sparrow.currentController.view addSubview:_textField];
    
    
    CGRect easeInFrame = _textField.frame;
    easeInFrame.origin.x = CENTER_X-80;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _textField.frame = easeInFrame;
                         
                     }
                     completion:^(BOOL finished){
                        
                     }];
    
    
    
    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:@"button_normal.png"];
    
    _okButton = [[SPButton alloc] initWithUpState:buttonTexture text:NSLocalizedString(KEY_OK, nil)];
    _okButton.x = CENTER_X - _okButton.width / 2.0f;
    _okButton.y = startY - _okButton.height / 2.0f+30;
    _okButton.name = NSLocalizedString(KEY_OK, nil);
    if([_textField.text isEqualToString:@""])
    {
        _okButton.enabled = NO;
    }
    [_okButton addEventListener:@selector(onOkButtonTriggered:) atObject:self
                        forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_okButton];
    
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button
{
    textField.text =@"";
    _okButton.enabled = NO;
    return YES;
}

//implement UITextfield Mothod
- (BOOL)textFieldShouldReturn:(UITextField *)textField
// A delegate method called by the URL text field when the user taps the Return
// key.  We just dismiss the keyboard.
{
#pragma unused(textField)
    assert( (textField == _textField ) );
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn %@",[textField text]);
    //    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
    if(![textField.text isEqualToString:@""])
    {
        _okButton.enabled = YES;
    }
    return NO;
}
- (void)onOkButtonTriggered:(SPEvent *)event
{
    [Media playSound:@"sound.caf"];
    NSString* name = _textField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"UserName"];
    [defaults synchronize];
    NSLog(@"Data saved");
    
    SPTween *tween = [SPTween tweenWithTarget:self time:0.5f transition:SP_TRANSITION_LINEAR];
    //Delay the tween for two seconds, so that we can see the
    //change in scenery.
    
    [tween moveToX:-GAME_HEIGHT y:0.0f];
    
    //Register the tween at the nearest juggler.
    //(We will come back to jugglers later.)
    [Sparrow.juggler addObject:tween];
    
    CGRect easeOutFrame = _textField.frame;
    easeOutFrame.origin.x = 0-_textField.frame.size.width;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _textField.frame = easeOutFrame;
                         
                     }
                     completion:^(BOOL finished){
                         [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
                         [_textField removeFromSuperview];
                     }];
    
}
- (void)onBackButtonTriggered:(SPEvent *)event
{
    CGRect easeOutFrame = _textField.frame;
    easeOutFrame.origin.x = 0-_textField.frame.size.width;
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _textField.frame = easeOutFrame;
                         
                     }
                     completion:^(BOOL finished){
                         [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
                         [_textField removeFromSuperview];
                     }];
    [super onBackButtonTriggered:event];
    //    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];

    
}
- (void)onSceneClosing:(SPEvent *)event
{
    
    [_okButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    
    [super onSceneClosing:event];
}

@end