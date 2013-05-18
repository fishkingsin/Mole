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

    SPImage * spImage = [[SPImage alloc] initWithContentsOfFile:@"ks_holy-tricky_female_thumb.png"];

    spImage.x = 0;
    spImage.y = 0;

    [_contents addChild:spImage];
    NSLog(@"GameCore Init!!!");
    [spImage addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    [self updateLocations];
    
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
     SPImage * image = (SPImage*)event.target;
//    SPRectangle* rectangle = [SPRectangle rectangleWithX:image.x y:image.y width:image.width height:image.height];
//    [self saveRectangle:rectangle];
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        // Initialize Compose View Controller
//        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        // Configure Compose View Controller
//        [vc setInitialText:@"testing"];

        UIImage * img = [self screenshot: image];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
//        [vc addImage: img];
//        // Present Compose View Controller
//        [Sparrow.currentController presentViewController:vc animated:YES completion:nil];
//    } else {
//        NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
}
//-(void)saveRectangle:(SPRectangle*)rectangle{
//    int bufferLenght = (rectangle.width*(rectangle.height+30)*4);
//    
//    int myWidth = rectangle.width;
//    int myHeight = rectangle.height;
//    int myY = self.stage.height-rectangle.y-rectangle.height;
//    int myX = rectangle.x;
//    
//    unsigned char buffer[bufferLenght];
//    glReadPixels(myX, myY, myWidth, myHeight, GL_RGBA, GL_UNSIGNED_BYTE, &buffer);
//    
//    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, &buffer, bufferLenght, NULL);
//    CGImageRef iref = CGImageCreate(myWidth,myHeight,8,32,myWidth*4,CGColorSpaceCreateDeviceRGB(),
//                                    kCGBitmapByteOrderDefault,ref,NULL, true, kCGRenderingIntentDefault);
//    uint32_t* pixels = (uint32_t *)malloc(bufferLenght);
//    CGContextRef context = CGBitmapContextCreate(pixels, myWidth, myHeight, 8, myWidth*4, CGImageGetColorSpace(iref),
//                                                 kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
//    CGContextTranslateCTM(context, 0.0, myHeight);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextDrawImage(context, CGRectMake(0.0, 0.0, myWidth, myHeight), iref);
//    CGImageRef outputRef = CGBitmapContextCreateImage(context);
//    UIImage *image = [[UIImage alloc] initWithCGImage:outputRef];
//    free(pixels);
//    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
////    [image release];
//}
@end
