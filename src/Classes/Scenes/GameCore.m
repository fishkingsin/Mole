//
//  GameCore.m
//  Mole
//
//  Created by James Kong on 18/5/13.
//
//

#import "GameCore.h"
#import "MoleDescription.h"
#import "FacebookShare.h"
#define KEY_BACK @"Back"
#define KEY_EXPLAIN @"Explain"
#define KEY_SAVE_COMPLETE @"Save Complete"

@interface GameCore ()
-(void) postFacebook;
- (void)onButtonTriggered:(SPEvent *)event;

@end
@implementation GameCore
{
    //    SPSprite *_contents;
    SPSprite *_face;
    SPSprite *_mole;
    
    SPSprite *_moleMenu;
    
    SPButton *_confirmButton;
    SPButton *_fbButton;
    SPButton *_saveButton;
    SPButton *_cancelButton;
    SPButton *_addButton;
    SPButton *_minuButton;
    BOOL _canCapScreen;
    BOOL _canPostFB;
    BOOL _isConfirm;
    int state;
    NSString *currentDescription;
    
    SPTextField * _userDescTF;
    SPSprite *textFieldContainer;
    
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
    //    int numMole = [_mole numChildren];
    //    for( int i = 0 ; i < numMole ; i++)
    for (TouchSheet *sheet in _mole)
    {
        //        TouchSheet *sheet = (TouchSheet *)[_mole childAtIndex:i];
        sheet.enabled = YES;
        [sheet removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
    if(_confirmButton!=nil)
    {
        [_confirmButton removeFromParent];
        [_confirmButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
    if(_fbButton!=nil)
    {
        [_fbButton removeFromParent];
        [_fbButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
    if(_confirmButton!=nil)
    {
        [_saveButton removeFromParent];
        [_saveButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
    if(_face!=nil)
    {
        [_face removeFromParent];
        
    }
    if(_mole!=nil)
    {
        [_mole removeFromParent];
    }
    if(_cancelButton!=nil)
    {
        [_cancelButton removeFromParent];
        [_cancelButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
    if(_addButton!=nil)
    {
        [_addButton removeFromParent];
        [_addButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
    if(_minuButton!=nil)
    {
        [_minuButton removeFromParent];
        [_minuButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    }
}

- (void)setup
{
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"alpha_background.png"];
    [self addChild:background];
    [self addChild:[super backButton]];
    self.x = GAME_WIDTH*0.5;
    self.alpha = 0;
    SPTween *tween = [SPTween tweenWithTarget:self time:0.5f transition:SP_TRANSITION_LINEAR];
    [tween fadeTo:1.0f];
    [tween moveToX:0 y:0.0f];
    [Sparrow.juggler addObject:tween];
    
    currentDescription = @"";
    state = GAME_STATE_DRAGGING;
    
    _face = [SPSprite sprite];
    _moleMenu = [SPSprite sprite];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fileName = [defaults objectForKey:@"TargetFaceFile"];
    //    NSString *name = [defaults objectForKey:@"UserName"];
    
    /*
     * _moleMenu add button
     * minusbtn
     * scroll
     *
     *
     */
    
    SPImage * spImage = [[SPImage alloc] initWithContentsOfFile:fileName];
    
    spImage.x = 0;
    spImage.y = 0;
    [_face addChild:spImage];
    
    
    [self addChild:_face];
    [self addChild:_moleMenu];
    _mole = [SPSprite sprite];
    [_face addChild:_mole];
    // to find out how to react to touch events have a look at the TouchSheet class!
    // It's part of the demo.
    //    for(int i = 0 ; i< NUM_MOLE ; i++)
    //    {
    //
    //        SPImage *sparrow = [SPImage imageWithContentsOfFile:@"mole01.png"];
    //        TouchSheet *sheet = [[TouchSheet alloc] initWithQuad:sparrow];
    //        sheet.x = (i*30)+30;
    //        sheet.y = GAME_HEIGHT-80;
    //
    //        [_mole addChild:sheet];
    //    }
    _confirmButton = [self createButton:NSLocalizedString(KEY_CONFIRM, nil) :@"button_short.png"];
    _confirmButton.x = 64;
    _confirmButton.y = GAME_HEIGHT-_confirmButton.height;
    _confirmButton.enabled = NO;
    [self addChild:_confirmButton];
    _addButton = [self createButton:NSLocalizedString(@"+", nil) :@"button_short.png"];
    _addButton.x = _confirmButton.x+_confirmButton.width;
    _addButton.y = GAME_HEIGHT-_addButton.height;
    [self addChild:_addButton];
    _minuButton = [self createButton:NSLocalizedString(@"-", nil) :@"button_short.png"];
    _minuButton.x = _addButton.x+_addButton.width;
    _minuButton.y = GAME_HEIGHT-_minuButton.height;
    _minuButton.enabled = NO;
    [self addChild:_minuButton];
    
    
    
    
    
    [self addChild:[self backButton]];
    
    textFieldContainer = [SPSprite sprite];
    textFieldContainer.x = 0;
    textFieldContainer.y = 0;
    SPImage *textFieldBkgImage = [SPImage imageWithContentsOfFile:@"textfieldBackground.png"];
    
    [textFieldContainer addChild:textFieldBkgImage];
    
    SPTextField *TF = [SPTextField textFieldWithWidth:textFieldContainer.width height:30 text:NSLocalizedString(KEY_EXPLAIN, nil)];
    TF.fontSize = 24;
    TF.hAlign = SPHAlignCenter ;
    TF.vAlign = SPVAlignCenter ;
    
    TF.border = NO;
    TF.color = 0xFFFFFF;
    
    _userDescTF = [SPTextField textFieldWithWidth:textFieldContainer.width-50 height:textFieldContainer.height-50 text:@""];
    
    _userDescTF.hAlign = SPHAlignLeft ;
    _userDescTF.vAlign = SPVAlignTop ;
    _userDescTF.x = 25;
    _userDescTF.y = TF.y+TF.height;
    _userDescTF.border = NO;
    _userDescTF.fontSize = 11;
    _userDescTF.color = 0xFFFFFF;
    [textFieldContainer addChild:TF];
    [textFieldContainer addChild:_userDescTF];
    
    
    _fbButton = [self createButton:NSLocalizedString(KEY_FACEBOOK, nil) :@"button_short.png"];
    _fbButton.x = _fbButton.width;
    _fbButton.visible = YES;
    _fbButton.y = textFieldContainer.height - _fbButton.height;
    
    
    [textFieldContainer addChild:_fbButton];
    
    
    
    _saveButton = [self createButton:NSLocalizedString(KEY_SAVE, nil) :@"button_short.png"];
    _saveButton.x = _fbButton.x+_fbButton.width;
    _saveButton.visible = YES;
    _saveButton.y =textFieldContainer.height - _saveButton.height;
    [textFieldContainer addChild:_saveButton];
    
    _cancelButton = [self createButton:NSLocalizedString(KEY_CANCEL, nil) :@"button_short.png"];
    _cancelButton.x = _saveButton.x+_saveButton.width;
    _cancelButton.visible = YES;
    _cancelButton.y = textFieldContainer.height - _saveButton.height;
    [textFieldContainer addChild:_cancelButton];
    
    
    _isConfirm = _canCapScreen = _canPostFB = NO;
    
    [self loadDescription];
    
    
    
}

// callback for CGDataProviderCreateWithData
void releaseData(void *info, const void *data, size_t dataSize) {
	//	NSLog(@"releaseData\n");
	free((void*)data);		// free the
}
- (UIImage *)screenshot :(SPRectangle*)rectangle{
#ifdef DEBUG
    NSLog(@"Screenshot %@",[self platformString]);
#endif
	int myWidth = 640;
	int myHeight = 960;
    int myX = 0;
    int myY = 0;
    if ([[self platformString] isEqualToString:@"iPhone 3G"] ||
        [[self platformString] isEqualToString:@"iPhone 3GS"])
    {
        myWidth = 320;
        myHeight = 480;
    }
    else if ([[self platformString] isEqualToString:@"iPhone 4"] ||
             [[self platformString] isEqualToString:@"Verizon iPhone 4"] ||
             [[self platformString] isEqualToString:@"iPhone 4S"])
    {
        myWidth = 640;
        myHeight = 960;
    }
    else if ([[self platformString] isEqualToString:@"iPhone 5 (GSM)"] ||
             [[self platformString] isEqualToString:@"iPhone 5 (GSM+CDMA)"])
    {
        myWidth = 640;
        myHeight = 960;
        myX = 0;
        myY = (1136-960)/2;
    }
    else{
        myWidth = 640;
        myHeight = 960;
    }
    
    
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
    CGImageRelease(outputRef);
    CGImageRelease(iref);
    CGContextRelease(context);
	free(pixels);
	return image;
    //    [image release];
}

// callback for UIImageWriteToSavedPhotosAlbum
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
#ifdef DEBUG
	NSLog(@"Save finished");
#endif
}

- (void)postFacebook
{
    //    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
    //    if ([touches anyObject]) [Media playSound:@"sound.caf"];
    //    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"6.0" options: NSNumericSearch];
    //    if (order == NSOrderedSame || order == NSOrderedDescending) {
    //        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    //            // Initialize Compose View Controller
    //            SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //            // Configure Compose View Controller
    //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //            NSString *name = [defaults objectForKey:@"UserName"];
    //            NSString *content = [[NSString alloc] initWithFormat:@"%@ : %@",name,currentDescription];
    //            [vc setInitialText:content];
    //            UIImage * img = [self screenshot:[[SPRectangle alloc] initWithX:
    //                                              0 y:0
    //                                                                      width:GAME_WIDTH height:GAME_HEIGHT]];
    //            [vc addImage: img];
    //            //        [name release];
    //            // Present Compose View Controller
    //            UIView *base = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GAME_WIDTH, GAME_HEIGHT)];
    //            [base setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    //            UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //            ai.center = Sparrow.currentController.view.center;
    //            [ai startAnimating];
    //            [base addSubview:ai];
    //
    //            [Sparrow.currentController presentViewController:vc animated:YES completion:
    //             ^{
    //                 [ai removeFromSuperview];
    //                 [base removeFromSuperview];
    //             }];
    //            [Sparrow.currentController.view addSubview:base];
    //
    //        } else {
    //            NSString *message = @"It seems that we cannot talk to Facebook at the moment or you have not yet added your Facebook account to this device. Go to the Settings application to add your Facebook account to this device.";
    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //            [alertView show];
    //        }
    //
    //    } else {
    // OS version < 6.0
    FacebookShare *fbShare = [[FacebookShare alloc] init];
    //    [fbShare loginWithCompletionHandler:^{
    UIImage * img = [self screenshot:[[SPRectangle alloc] initWithX:
                                      0 y:0
                                                              width:GAME_WIDTH height:GAME_HEIGHT]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"UserName"];
    NSString *content = [[NSString alloc] initWithFormat:@"%@ : %@",name,currentDescription];
    
    [fbShare postImage:img withCaption:content withCompletionHandler:^{
        [fbShare logout];
    }
      withErrorHandler:^
     {
         
         NSLog(@"Facebook upload failed");
     }];
    //    } andErrorHander:^{
    //             NSLog(@"Facebook login failed");
    //    } ];
    
    
    
    //}
    
}
-(SPButton*) createButton:(NSString*) _text : (NSString*)filePath
{
    SPTexture *buttonTexture = [SPTexture textureWithContentsOfFile:filePath];
    
    SPButton *newButton = [[SPButton alloc] initWithUpState:buttonTexture text:_text];
    
    newButton.name = _text;
    newButton.visible = YES;
    
    [newButton addEventListener:@selector(onButtonTriggered:) atObject:self
                        forType:SP_EVENT_TYPE_TRIGGERED];
    return newButton;
}
- (void)onButtonTriggered:(SPEvent *)event
{
    [Media playSound:@"sound.caf"];
    SPButton* button =  (SPButton*)event.target;
    if([button.name isEqualToString:NSLocalizedString(KEY_CONFIRM,nil)])
    {
        if([_mole numChildren] >0)
        {
            state = GAME_STATE_CONFIRMED;
            
            _confirmButton.enabled = NO;
            _addButton.enabled = NO;
            _minuButton.enabled = NO;
            [self checkMolePosition];
        }
    }
    else if([button.name isEqualToString:NSLocalizedString(@"+", nil)])
    {
        
        if([_mole numChildren] < NUM_MOLE)
        {
            SPImage *sparrow = [SPImage imageWithContentsOfFile:@"mole01.png"];
            TouchSheet *sheet = [[TouchSheet alloc] initWithQuad:sparrow];
            sheet.x = CENTER_X;
            sheet.y = GAME_HEIGHT;
            
            SPTween *tween = [SPTween tweenWithTarget:sheet time:0.5f transition:SP_TRANSITION_LINEAR];
            
            [tween moveToX:CENTER_X y:CENTER_Y];
            [Sparrow.juggler addObject:tween];
            
            [_mole addChild:sheet];
        }
        if([_mole numChildren] == NUM_MOLE)
        {
            button.enabled = NO;
        }
        if([_mole numChildren] >0)
        {
            _confirmButton.enabled = YES;
            _minuButton.enabled=YES;
        }
        
    }
    else if([button.name isEqualToString:NSLocalizedString(@"-", nil)])
    {
        
        if([_mole numChildren] > 0 )
        {
            
            [_mole removeChildAtIndex:[_mole numChildren]-1];
            
        }
        if([_mole numChildren] == 0)
        {
            
            _minuButton.enabled = NO;
            
            
            _confirmButton.enabled = NO;
        }
        
        if([_mole numChildren] < NUM_MOLE)
        {
            _addButton.enabled = YES;
        }
    }
    else if([button.name isEqualToString:NSLocalizedString(KEY_CANCEL,nil)])
    {
        //        _fbButton.visible = NO;
        //        _saveButton.visible = NO;
        //        _cancelButton.visible = NO;
        _confirmButton.enabled = YES;
        _addButton.enabled = YES;
        _minuButton.enabled = YES;
        
        //        int numMole = [_mole numChildren];
        //        for( int i = 0 ; i < numMole ; i++)
        //        {
        //            TouchSheet *sheet = (TouchSheet *)[_mole childAtIndex:i];
        for (TouchSheet *sheet in _mole)
        {
            //        TouchSheet *sheet = (TouchSheet *)[_mole childAtIndex:i];
            sheet.enabled = YES;
            [sheet removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        }
        //        int numChildren = [_moleMenu numChildren];
        //        for( int j = 0 ; j < numChildren ; j++)
        //        {
        //            MoleDescription *description = (MoleDescription*)[_moleMenu childAtIndex:j];
        //            description.visible = NO;
        //        }
        SPTween *tween = [SPTween tweenWithTarget:textFieldContainer time:0.5f transition:SP_TRANSITION_LINEAR];
        
        [tween scaleTo:0];
        [tween moveToX:CENTER_X y:CENTER_Y];
        tween.onComplete = ^{ [self removeChild:textFieldContainer]; };
        [Sparrow.juggler addObject:tween];
        
        
        state = GAME_STATE_DRAGGING;
    }else if([button.name isEqualToString:NSLocalizedString(KEY_FACEBOOK,nil)])
    {
        [self removeChild: _confirmButton];
        //        [self removeChild: _fbButton];
        //        [self removeChild: _saveButton];
        //        [self removeChild: _cancelButton];
        [self removeChild: [self backButton]];
        [self removeChild: _addButton];
        [self removeChild: _minuButton];
        [self removeChild:textFieldContainer];
        [self flatten];
        //allow render loop do scapscreeen function
        _canPostFB = YES;
    }else if([button.name isEqualToString:NSLocalizedString(KEY_SAVE,nil)])
    {
        [self removeChild: _confirmButton];
        //        [self removeChild: _fbButton];
        //        [self removeChild: _saveButton];
        [self removeChild: [self backButton]];
        //        [self removeChild: _cancelButton];
        [self removeChild: _addButton];
        [self removeChild: _minuButton];
        [self removeChild:textFieldContainer];
        
        [self flatten];
        //allow render loop do scapscreeen function
        _canCapScreen = YES;
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
    //    int numMole = [_mole numChildren];
    //#ifdef DEBUG
    //    NSLog(@"checkMolePosition : %i",numMole);
    //#endif
    NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"descriptions" ofType:@"plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    
    //load config.plist
	NSArray *appPropertyList = (NSArray *)[NSPropertyListSerialization
                                           propertyListFromData:plistXML
                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                           format:&format errorDescription:&errorDesc];
    
    if (!appPropertyList) {
		NSLog(@"%@",errorDesc);
        //		[errorDesc release];
        
	}
    //retrieve items properties from plist which is array of Dictionary
    
    //    load plist descriptions
    //    load plist by facename
    
    
    NSArray *data = [[NSArray alloc] initWithArray: [appPropertyList valueForKey:@"items"]];
    currentDescription = @"";
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *name =  [defaults objectForKey:@"UserName"];
    //    currentDescription = [currentDescription stringByAppendingString:name];
    //    currentDescription = [currentDescription stringByAppendingString:@"\n"];
    
    int numTargetHit = 0;
    //    for( int i = 0 ; i < numMole ; i++)
    //    {
    //        TouchSheet *sheet = (TouchSheet *)[_mole childAtIndex:i];
    for (TouchSheet *sheet in _mole)
    {
        //        TouchSheet *sheet = (TouchSheet *)[_mole childAtIndex:i];
        sheet.enabled = NO;
        //        int numChildren = [_moleMenu numChildren];
        float shortest = 9999;
        int index = -1;
        NSString * _id;
        //        for( int j = 0 ; j < numChildren ; j++)
        int j = 0;
        SPRectangle *bounds2 = [[SPRectangle alloc] init];
        for (MoleDescription *description in _moleMenu)
        {
            j++;
            //            MoleDescription *description = (MoleDescription*)[_moleMenu childAtIndex:j];
            SPRectangle *bounds1 = sheet.bounds;
            int x = description.bounds.x;
            int y = description.bounds.y;
            int w = description.bounds.width;
            int h = description.bounds.height;
            
            [bounds2 setX:x-w*0.5 y:y-h*0.5 width:w height:h];
            if ([bounds1 intersectsRectangle:bounds2])
            {
                
                SPPoint *p1 = [SPPoint pointWithX:sheet.x y:sheet.y];
                SPPoint *p2 = [SPPoint pointWithX:description.x y:description.y];
                
                float distance = [SPPoint distanceFromPoint:p1 toPoint:p2];
                if(abs(distance)<shortest)
                {
                    shortest = distance;
                    index = j ;
                    _id = description.name;
                    
                }
            }
            
        }
        if(index!=-1)
        {
            
            numTargetHit++;
            
            NSString * _description = nil;
            for(NSDictionary *dic in data)
            {
                
                if([_id isEqualToString:[dic valueForKey:@"name"]])
                {
                    _description = [dic valueForKey:@"description"];
                }
            }
#ifdef DEBUG
            MoleDescription *description = (MoleDescription*)[_moleMenu childAtIndex:index];
            
            description.visible = YES;
            
            NSLog(@"id %@ %i %@",_id , index,_description);
#endif
            if(_description!=nil)
            {
                NSRange range = [currentDescription rangeOfString : _description];
                
                if (range.location == NSNotFound) {
                    currentDescription = [currentDescription stringByAppendingString:@">"];
                    currentDescription = [currentDescription stringByAppendingString:_description];
                    currentDescription = [currentDescription stringByAppendingString:@"\n"];
                    
                }
            }
            
            
        }
        
    }
    
    [_userDescTF setText:currentDescription];
    
    SPTween *tween = [SPTween tweenWithTarget:textFieldContainer time:0.5f transition:SP_TRANSITION_LINEAR];
    textFieldContainer.scaleX = textFieldContainer.scaleY = 0;
    textFieldContainer.x = CENTER_X;
    textFieldContainer.y = CENTER_Y;
    [tween scaleTo:1];
    [tween moveToX:0 y:0];
    [Sparrow.juggler addObject:tween];
    
    [self addChild:textFieldContainer];
#ifdef DEBUG
    NSLog(@"currentDescription :\n%@",currentDescription);
#endif
    
    
}
- (void)render:(SPRenderSupport*)support
{
    //should do super render before the cap screen
    [super render:support];
    if (_canCapScreen || _canPostFB) {
        if(_canPostFB)
        {
            //            NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"6.0" options: NSNumericSearch];
            //            if (order == NSOrderedSame || order == NSOrderedDescending) {
            [self postFacebook];
            //            } else {
            // OS version < 6.0
            //            }
            
        }else{
            UIImage * img = [self screenshot :[[SPRectangle alloc] initWithX:
                                               0 y:0 width:GAME_WIDTH height:GAME_HEIGHT]];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(KEY_SAVE_COMPLETE, nil) message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            
        }
        _canCapScreen = NO;
        _canPostFB = NO;
        [self addChild: _confirmButton];
        //        [self addChild: _fbButton];
        //        [self addChild: _saveButton];
        [self addChild: [self backButton]];
        //        [self addChild: _cancelButton];
        [self addChild:_addButton];
        [self addChild:_minuButton];
        [self addChild:textFieldContainer];
        
        //should use unflatten here
        //dont know why
        [self unflatten];
    }
    
}
- (NSString *) platformString{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* platform =  [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //    NSLog(@"Current Devie Model %@",_platform);//[[UIDevice currentDevice] localizedModel]);
    //    NSString *platform = [Sparrow.currentController.parentViewController _platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

-(void) loadDescription
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fileName = [defaults objectForKey:@"TargetFaceFile"];
    
    NSString *errorDesc = nil;
	NSPropertyListFormat format;
    NSString *plistPath;
    if(fileName!=nil)
    {
#ifdef DEBUG
        NSLog(@"%@ ",fileName);
#endif
        plistPath = [[NSBundle mainBundle] pathForResource: [fileName substringWithRange:NSMakeRange(0, [fileName length] - 4)] ofType:@"plist"];
#ifdef DEBUG
        NSLog(@"pListPath %@",plistPath);
#endif
    }
    else
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"deafult_description" ofType:@"plist"];
    }
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    
    //load config.plist
	NSArray *appPropertyList = (NSArray *)[NSPropertyListSerialization
                                           propertyListFromData:plistXML
                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                           format:&format errorDescription:&errorDesc];
    
    if (!appPropertyList) {
		NSLog(@"%@",errorDesc);
        //		[errorDesc release];
        
	}
    NSArray *data = [[NSArray alloc] initWithArray: [appPropertyList valueForKey:@"items"]];
    //retrieve items properties from plist which is array of Dictionary
    for(int i=0;i<[data count];i++){
        NSString *name = [[data objectAtIndex:i] valueForKey:@"name"];
        //        NSString *description = [[data objectAtIndex:i] valueForKey:@"description"];
        NSDictionary *position = [[data objectAtIndex:i] valueForKey:@"position"];
        //        CGRect rect = CGRectMake([[position valueForKey:@"x"] integerValue],[[position valueForKey:@"y"] integerValue], 100,100);
#ifdef DEBUG
        NSLog(@"name : %@ \nposition : %@ ",name,position);
#endif
        MoleDescription *myDescription = [[MoleDescription alloc ]initWithName:name ];//description:description];
        myDescription.x = [[position valueForKey:@"x"] integerValue];
        myDescription.y = [[position valueForKey:@"y"] integerValue];
#ifdef DEBUG
        myDescription.visible = YES;
#else
        myDescription.visible = NO;
#endif
        [_moleMenu addChild:myDescription];
        
    }
    
}
@end
