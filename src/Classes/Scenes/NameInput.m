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
}

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
}

- (void)setup
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 160, 25)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.delegate = self;
    [Sparrow.currentController.view addSubview:_textField];
    

}


//implement UITextfield Mothod
- (BOOL)textFieldShouldReturn:(UITextField *)textField
// A delegate method called by the URL text field when the user taps the Return
// key.  We just dismiss the keyboard.
{
#pragma unused(textField)
    assert( (textField == _textField ) );
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn");
    [self dispatchEventWithType:EVENT_TYPE_SCENE_CLOSING bubbles:YES];
    return NO;
}


@end