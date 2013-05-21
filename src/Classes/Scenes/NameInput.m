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
    }
}

- (void)setup
{
    startY = CENTER_Y-CENTER_Y*0.3;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(CENTER_X-80,startY-12.5, 160, 25)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.delegate = self;
    //read the last save user name
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"UserName"];
    [_textField setText:name];
    
    [Sparrow.currentController.view addSubview:_textField];
    
    
    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:@"button_normal.png"];
    
    _okButton = [[SPButton alloc] initWithUpState:buttonTexture text:@"OK"];
    _okButton.x = CENTER_X - _okButton.width / 2.0f;
    _okButton.y = startY - _okButton.height / 2.0f+30;
    _okButton.name = @"ok";
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
    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
}
- (void)onBackButtonTriggered:(SPEvent *)event
{
    [super onBackButtonTriggered:event];
//    [_backButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
}
- (void)onSceneClosing:(SPEvent *)event
{
    [_okButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [super onSceneClosing:event];
}

@end