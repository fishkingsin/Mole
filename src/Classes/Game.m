//
//  Game.m
//  AppScaffold
//

#import "Game.h"
#import "Scene.h"
#import "NameInput.h"
#import "FacePick.h"
#import "GameCore.h"
#import "CreditPage.h"
//define scene array index
#define NAME_INPUT 0
#define FACE_PICK 1
#define GAME_CORE 2
// --- private interface ---------------------------------------------------------------------------

@interface Game ()

- (void)setup;
- (void)onImageTouched:(SPTouchEvent *)event;
- (void)onResize:(SPResizeEvent *)event;
- (void)onButtonTriggered:(SPEvent *)event;
- (void)onSceneClosing:(SPEvent *)event;
- (void)onCreditClosing:(SPEvent *)event;
@end


// --- class implementation ------------------------------------------------------------------------

@implementation Game
{
    Scene *_currentScene;
    CreditPage *_creditPage;
    SPSprite *_contents;
    SPSprite *_menu;
    NSArray *scenesToCreate;
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
    // release any resources here
    [Media releaseAtlas];
    [Media releaseSound];
}

- (void)setup
{
    // This is where the code of your game will start.
    // In this sample, we add just a few simple elements to get a feeling about how it's done.
    
    [SPAudioEngine start];  // starts up the sound engine
    
    
    // The Application contains a very handy "Media" class which loads your texture atlas
    // and all available sound files automatically. Extend this class as you need it --
    // that way, you will be able to access your textures and sounds throughout your
    // application, without duplicating any resources.
    
    [Media initAtlas];      // loads your texture atlas -> see Media.h/Media.m
    [Media initSound];      // loads all your sounds    -> see Media.h/Media.m
    
    
    // Create some placeholder content: a background image, the Sparrow logo, and a text field.
    // The positions are updated when the device is rotated. To make that easy, we put all objects
    // in one sprite (_contents): it will simply be rotated to be upright when the device rotates.
    
    _contents   = [SPSprite sprite];
    _menu       = [SPSprite sprite];
    [self addChild:_contents];
    [self addChild:_menu];
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.jpg"];
    [_contents addChild:background];
    
    
    scenesToCreate = @[[NameInput class],
                       [FacePick class],
                       [GameCore class],
                       [CreditPage class]];
    
    
    int targetIndex = NAME_INPUT;
    // create an instance of that class and add it to the display tree.
    _currentScene = [[[scenesToCreate[targetIndex] class] alloc] init];
    
    _currentScene.name = NSStringFromClass(scenesToCreate[targetIndex]);
    //    _contents.visible = NO;
    [_contents addChild:_currentScene];
    
    _creditPage = [[CreditPage alloc]init];
    [_contents addChild:_creditPage];
    
    [self addEventListener:@selector(onSceneClosing:) atObject:self
                   forType:EVENT_TYPE_SCENE_CLOSING];
    [self addEventListener:@selector( onCreditClosing:) atObject:self
                   forType:EVENT_TYPE_CREDIT_CLOSING];

    //    NSString *text = @"To find out how to create your own game out of this scaffold, "
    //                     @"have a look at the 'First Steps' section of the Sparrow website!";
    //
    //    SPTextField *textField = [[SPTextField alloc] initWithWidth:280 height:80 text:text];
    //    textField.x = (background.width - textField.width) / 2;
    //    textField.y = (background.height / 2) - 135;
    //    [_contents addChild:textField];
    //
    //    SPImage *image = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"sparrow"]];
    //    image.pivotX = (int)image.width  / 2;
    //    image.pivotY = (int)image.height / 2;
    //    image.x = background.width  / 2;
    //    image.y = background.height / 2 + 40;
    //    [_contents addChild:image];
    
    [self updateLocations];
    
    // play a sound when the image is touched
    //    [image addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    //
    //    // and animate it a little
    //    SPTween *tween = [SPTween tweenWithTarget:image time:1.5 transition:SP_TRANSITION_EASE_IN_OUT];
    //    [tween animateProperty:@"y" targetValue:image.y + 30];
    //    [tween animateProperty:@"rotation" targetValue:0.1];
    //    tween.repeatCount = 0; // repeat indefinitely
    //    tween.reverse = YES;
    //    [Sparrow.juggler addObject:tween];
    
    
    // The controller autorotates the game to all supported device orientations.
    // Choose the orienations you want to support in the Xcode Target Settings ("Summary"-tab).
    // To update the game content accordingly, listen to the "RESIZE" event; it is dispatched
    // to all game elements (just like an ENTER_FRAME event).
    //
    // To force the game to start up in landscape, add the key "Initial Interface Orientation"
    // to the "App-Info.plist" file and choose any landscape orientation.
    
    [self addEventListener:@selector(onResize:) atObject:self forType:SP_EVENT_TYPE_RESIZE];
    
    // Per default, this project compiles as a universal application. To change that, enter the
    // project info screen, and in the "Build"-tab, find the setting "Targeted device family".
    //
    // Now choose:
    //   * iPhone      -> iPhone only App
    //   * iPad        -> iPad only App
    //   * iPhone/iPad -> Universal App
    //
    // Sparrow's minimum deployment target is iOS 5.
}

- (void)updateLocations
{
    int gameWidth  = Sparrow.stage.width;
    int gameHeight = Sparrow.stage.height;
    
    _contents.x = (int) (gameWidth  - _contents.width)  / 2;
    _contents.y = (int) (gameHeight - _contents.height) / 2;
}

- (void)onImageTouched:(SPTouchEvent *)event
{
    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
    if ([touches anyObject]) [Media playSound:@"sound.caf"];
}

- (void)onResize:(SPResizeEvent *)event
{
    NSLog(@"new size: %.0fx%.0f (%@)", event.width, event.height,
          event.isPortrait ? @"portrait" : @"landscape");
    
    [self updateLocations];
}

- (void)onButtonTriggered:(SPEvent *)event
{
    
    //    if (_currentScene) return;
    //
    //    // the class name of the scene is saved in the "name" property of the button.
    SPButton *button = (SPButton *)event.target;
    NSLog(@"onButtonTriggered %@", button.name);
    
    //    Class sceneClass = NSClassFromString(button.name);
    //
    //    // create an instance of that class and add it to the display tree.
    //    _currentScene = [[sceneClass alloc] init];
    //    _currentScene.y = _offsetY;
    //    _mainMenu.visible = NO;
    //    [_contents addChild:_currentScene];
}
- (void)onCreditClosing:(SPEvent *)event
{
    [_creditPage removeFromParent];
    _creditPage = nil;
}
- (void)onSceneClosing:(SPEvent *)event
{
    NSLog(@"onSceneClosing _currentScene.name : %@ , target : %@",_currentScene.name , event.target);
    if([_currentScene.name isEqualToString: NSStringFromClass(scenesToCreate[NAME_INPUT])])
    {
        
        
        [_currentScene removeFromParent];
        _currentScene = nil;
        _currentScene = [[[scenesToCreate[FACE_PICK] class] alloc] init];
        _currentScene.name = NSStringFromClass(scenesToCreate[FACE_PICK]);
        //        _contents.visible = NO;
        [_contents addChild:_currentScene];
        
        
    }
    else if([_currentScene.name isEqualToString:  NSStringFromClass(scenesToCreate[GAME_CORE])])
    {
        [_currentScene removeFromParent];
        _currentScene = nil;
        _currentScene = [[[scenesToCreate[FACE_PICK] class] alloc] init];
        _currentScene.name = NSStringFromClass(scenesToCreate[FACE_PICK]);
        
        
        [_contents addChild:_currentScene];
        
    }
    else if([_currentScene.name isEqualToString:  NSStringFromClass(scenesToCreate[FACE_PICK])])
    {
        
        FacePick *_scene = (FacePick*)_currentScene;
        if([_scene faceFile]==nil)
        {
            [_currentScene removeFromParent];
            _currentScene = nil;
            _currentScene = [[[scenesToCreate[NAME_INPUT] class] alloc] init];
            _currentScene.name = NSStringFromClass(scenesToCreate[NAME_INPUT]);
            [_contents addChild:_currentScene];
        }
        else{
            NSLog(@"FacePick target : %@",[_scene faceFile] );
            
            [_currentScene removeFromParent];
            _currentScene = nil;
            _currentScene = [[[scenesToCreate[GAME_CORE] class] alloc] init];
            _currentScene.name = NSStringFromClass(scenesToCreate[GAME_CORE]);
            //        _contents.visible = NO;
//            GameCore*gameCore =  (GameCore*)_currentScene;
//            [gameCore setFaceFile:[_scene faceFile]];
            
            
            [_contents addChild:_currentScene];
        }
    }
}

@end
