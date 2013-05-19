//
//  GameCore.m
//  Mole
//
//  Created by James Kong on 18/5/13.
//
//

#import "GameCore.h"
#import <Social/Social.h>
#define  NUM_MOLE 10
@interface GameCore ()
-(void) postFacebook;
- (void)onButtonTriggered:(SPEvent *)event;

@end
@implementation GameCore
{
    SPSprite *_contents;
    SPSprite *_face;
    SPSprite *_mole;

    SPButton *_confirmButton;
    SPButton *_fbButton;
    SPButton *_saveButton;
}
- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setup
{
    _contents = [SPSprite sprite];
    [self addChild:_contents];
    
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.jpg"];
    [_contents addChild:background];
    
    _face = [SPSprite sprite];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fileName = [defaults objectForKey:@"TargetFaceFile"];
    NSString *name = [defaults objectForKey:@"UserName"];
    
    
    SPImage * spImage = [[SPImage alloc] initWithContentsOfFile:fileName];
    
    spImage.x = 0;
    spImage.y = 0;
    [_face addChild:spImage];

    
    [_contents addChild:_face];
    NSLog(@"GameCore Init!!!");
//    [spImage addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    _mole = [SPSprite sprite];
    [_face addChild:_mole];
    // to find out how to react to touch events have a look at the TouchSheet class!
    // It's part of the demo.
    for(int i = 0 ; i< NUM_MOLE ; i++)
    {
        
        SPImage *sparrow = [SPImage imageWithContentsOfFile:@"mole01.png"];
        TouchSheet *sheet = [[TouchSheet alloc] initWithQuad:sparrow];
        sheet.x = Sparrow.stage.width-50;
        sheet.y = Sparrow.stage.height-(300)+(i*30);
    
        [_mole addChild:sheet];
    }
    
    _confirmButton = [self createButton:@"Confirm" :@"button_short.png"];
    _confirmButton.x = 20;
    _confirmButton.y = _confirmButton.height;
    [self addChild:_confirmButton];

    _fbButton = [self createButton:@"Facebook" :@"button_short.png"];
    _fbButton.x = 20;
    _fbButton.enabled = NO;
    _fbButton.y = _confirmButton.y + _fbButton.height;
    [self addChild:_fbButton];
    
    _saveButton = [self createButton:@"Save" :@"button_short.png"];
    _saveButton.x = 20;
    _saveButton.enabled = NO;
    _saveButton.y = _fbButton.y + _saveButton.height;
    [self addChild:_saveButton];
    
    [self addChild: [self childByName:@"back"]];
    

    SPTextField * _userNameTF = [SPTextField textFieldWithWidth:100 height:25
                                                           text:name];
    _userNameTF.x = 20;
    _userNameTF.y = 20;
    _userNameTF.hAlign = SPHAlignLeft;
    _userNameTF.vAlign = SPVAlignTop;
    _userNameTF.border = NO;
    _userNameTF.color = 0x000000;
    [self addChild:_userNameTF];
    
    [self updateLocations];
    
}

- (void)updateLocations
{
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    _contents.x = (int) (gameWidth  - _contents.width)  / 2;
    _contents.y = (int) (gameHeight - _contents.height) / 2;
}
// callback for CGDataProviderCreateWithData
void releaseData(void *info, const void *data, size_t dataSize) {
	//	NSLog(@"releaseData\n");
	free((void*)data);		// free the
}
- (UIImage *)screenshot :(SPRectangle*)rectangle{

    
    int width  = rectangle.width;
	int height = rectangle.height;
	
	NSInteger myDataLength = width * height * 4;
	GLubyte *buffer = (GLubyte *) malloc(myDataLength);
	GLubyte *bufferFlipped = (GLubyte *) malloc(myDataLength);
	glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	for(int y = 0; y <height; y++) {
		for(int x = 0; x <width * 4; x++) {
			bufferFlipped[((height - 1 - y) * width * 4 + x)] = buffer[(y * 4 * width + x)];
		}
	}
	free(buffer);	// free original buffer
	
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bufferFlipped, myDataLength, releaseData);
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);
	
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
    
    UIImage * image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    NSData * imageData = UIImagePNGRepresentation(image);
    UIImage * imageLossless = [UIImage imageWithData:imageData];
    return imageLossless;
    UIImageWriteToSavedPhotosAlbum(image, nil, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    [image release];
}
// callback for UIImageWriteToSavedPhotosAlbum
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	NSLog(@"Save finished");
    
}

- (void)postFacebook
{
//    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
//    if ([touches anyObject]) [Media playSound:@"sound.caf"];

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // Configure Compose View Controller
        [vc setInitialText:@"testing"];
        UIImage * img = [self screenshot:[[SPRectangle alloc] initWithX:
                                          0 y:0
                                          width:GAME_WIDTH height:GAME_HEIGHT]];
        [vc addImage: img];
        // Present Compose View Controller
        [Sparrow.currentController presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
-(SPButton*) createButton:(NSString*) _text : (NSString*)filePath
{
    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:filePath];
    
    SPButton *newButton = [[SPButton alloc] initWithUpState:buttonTexture text:_text];

    newButton.name = _text;
    newButton.enabled = YES;
    
    [newButton addEventListener:@selector(onButtonTriggered:) atObject:self
                        forType:SP_EVENT_TYPE_TRIGGERED];
    return newButton;
}
- (void)onButtonTriggered:(SPEvent *)event
{
    [Media playSound:@"sound.caf"];
    SPButton* button =  (SPButton*)event.target;
    if([button.name isEqualToString:@"Confirm"])
    {
        _fbButton.enabled = YES;
        _saveButton.enabled = YES;
        [self checkMolePosition];
        
    }else if([button.name isEqualToString:@"Facebook"])
    {
        _confirmButton.visible = NO;
        _fbButton.visible = NO;
        _saveButton.visible = NO;
        [self backButton].visible = NO;
        
        [self flatten];
                //refresh the screen when widget is invisable
        [self postFacebook];
        
        _confirmButton.visible = YES;
        _fbButton.visible = YES;
        _saveButton.visible = YES;
        [self backButton].visible = YES;
    }else if([button.name isEqualToString:@"Save"])
    {
        _confirmButton.visible = NO;
        _fbButton.visible = NO;
        _saveButton.visible = NO;
        [self backButton].visible = NO;
        
        //refresh the screen when widget is invisable
        [self flatten];
        
        UIImage * img = [self screenshot :[[SPRectangle alloc] initWithX:
                                           0 y:0
                                           width:GAME_WIDTH height:GAME_HEIGHT]];
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        
        _confirmButton.visible = YES;
        _fbButton.visible = YES;
        _saveButton.visible = YES;
        [self backButton].visible = YES;
    }
    
}

- (void)onSceneClosing:(SPEvent *)event
{
    [_confirmButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_fbButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_saveButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [super onSceneClosing:event];
}
-(void) checkMolePosition
{
    int numMole = [_mole numChildren];
    NSLog(@"checkMolePosition : %i",numMole);
    for( int i = 0 ; i < numMole ; i++)
    {
        TouchSheet *sheet = (TouchSheet *)[_mole childAtIndex:i];
        NSLog(@"TouchSheet : %i at %f %f",i,sheet.x,sheet.y);
    }
}
@end
