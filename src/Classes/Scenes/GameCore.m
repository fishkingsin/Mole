//
//  GameCore.m
//  Mole
//
//  Created by James Kong on 18/5/13.
//
//

#import "GameCore.h"
#import <Social/Social.h>
@interface GameCore ()
- (void)onImageTouched:(SPTouchEvent *)event;
- (void)onButtonTriggered:(SPEvent *)event;
- (UIImage *)screenshot : (SPImage *) canvasImage;
@end
@implementation GameCore
{
    SPSprite *_contents;
    SPSprite *_face;

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
    
    [_contents addChild:_face];
    NSLog(@"GameCore Init!!!");
//    [spImage addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
   
    
    // to find out how to react to touch events have a look at the TouchSheet class!
    // It's part of the demo.
    for(int i = 0 ; i< 10 ; i++)
    {
        
     SPImage *sparrow = [SPImage imageWithContentsOfFile:@"mole01.png"];
        TouchSheet *sheet = [[TouchSheet alloc] initWithQuad:sparrow];
        sheet.x = Sparrow.stage.width-50;
        sheet.y = Sparrow.stage.height-(300)+(i*30);
    
        [self addChild:sheet];
    }
    
    _confirmButton = [self createButton:@"Confirm" :@"button_short.png"];
    _confirmButton.x = 20;
    _confirmButton.y = _confirmButton.height;
    [self addChild:_confirmButton];

    _fbButton = [self createButton:@"Facebook" :@"button_short.png"];
    _fbButton.x = 20;
    _fbButton.y = _confirmButton.y + _fbButton.height;
    [self addChild:_fbButton];
    
    _saveButton = [self createButton:@"Save" :@"button_short.png"];
    _saveButton.x = 20;
    _saveButton.y = _fbButton.y + _saveButton.height;
    [self addChild:_saveButton];
    
    [self addChild: [self childByName:@"back"]];
    
    [self updateLocations];
    
}
-(void)setFaceFile : (NSString*)fileName
{
    SPImage * spImage = [[SPImage alloc] initWithContentsOfFile:fileName];
    
    spImage.x = 0;
    spImage.y = 0;
    [_face addChild:spImage];
}
- (void)updateLocations
{
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    _contents.x = (int) (gameWidth  - _contents.width)  / 2;
    _contents.y = (int) (gameHeight - _contents.height) / 2;
}

- (UIImage *)screenshot : (SPImage *) canvasImage {
    int myWidth = canvasImage.width;
    int myHeight = canvasImage.height;
    int myX = canvasImage.x;
    int myY = Sparrow.stage.height-canvasImage.y-canvasImage.height;
    
    NSInteger myDataLength = myWidth * myHeight * 4;
    NSMutableData * buffer= [NSMutableData dataWithLength :myDataLength];
    
    glReadPixels(myX, myY, myWidth, myHeight, GL_RGBA, GL_UNSIGNED_BYTE, [buffer mutableBytes]);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, [buffer mutableBytes], myDataLength, NULL);
    CGImageRef iref = CGImageCreate(myWidth,myHeight,8,32,myWidth*4,CGColorSpaceCreateDeviceRGB(),
                                    kCGBitmapByteOrderDefault,ref,NULL, true, kCGRenderingIntentDefault);
    uint32_t* pixels = (uint32_t *)malloc(myDataLength);
    CGContextRef context = CGBitmapContextCreate(pixels, myWidth, myHeight, 8, myWidth*4, CGImageGetColorSpace(iref),
                                                 kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0.0, myHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, myWidth, myHeight), iref);
    CGImageRef outputRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:outputRef];
    
    free(pixels);
    return image;
//    [image release];  
}

- (void)onImageTouched:(SPTouchEvent *)event
{
    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
    if ([touches anyObject]) [Media playSound:@"sound.caf"];

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // Configure Compose View Controller
        [vc setInitialText:@"testing"];
        SPImage * image = (SPImage*)event.target;
        UIImage * img = [self screenshot: image];
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
    
}
@end
