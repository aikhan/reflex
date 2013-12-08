//
//  GameScene.m
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "AboutScene.h"
#import "GameOverScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "BsButton.h"
#import "SNAdsManager.h"
#import "SettingsManager.h"
#import "MMHud.h"
#import "MMProgressHUD.h"
#import "Menu.h"
#import "PauseView.h"
#import "MKStoreManager.h"
#import "AppSpecificValues.h"

#import "RestoreIAPScene.h"

@implementation GameScene

@synthesize Blade1,Blade2,Box,TapLocationX,TapLocationY,Score,Highscore,prefs,boxes,highboxes,speed,RandomBoxCounter,greenBox,redBox;


+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        prefs = [NSUserDefaults standardUserDefaults];
        
        CCSprite *background=[CCSprite spriteWithFile:SHImageString(@"bg_game")];
        background.position=ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        [self addChild:background];
        
        Blade1=[CCSprite spriteWithFile:SHImageString(@"blade1")];
        Blade1.position=ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT-Blade1.contentSize.height/2);
        [self addChild:Blade1 z:2];
        
        Blade2=[CCSprite spriteWithFile:SHImageString(@"blade2")];
        Blade2.position=ccp(SCREEN_WIDTH/2, Blade2.contentSize.height/2);
        [self addChild:Blade2 z:2];
        
        Box=[CCSprite spriteWithFile:SHImageString(@"box")];
        Box.position=ccp(SCREEN_WIDTH -Box.contentSize.width/2 ,SCREEN_HEIGHT/2);
        [self addChild:Box z:1];
        
        
        greenBox=[CCSprite spriteWithFile:SHImageString(@"gBox")];
        greenBox.position=ccp(SCREEN_WIDTH +greenBox.contentSize.width/2,SCREEN_HEIGHT/2);
        [self addChild:greenBox z:1];
        
        redBox=[CCSprite spriteWithFile:SHImageString(@"rBox")];
        redBox.position=ccp(SCREEN_WIDTH +redBox.contentSize.width/2,SCREEN_HEIGHT/2);
        [self addChild:redBox z:1];
        
        RandomBoxCounter=0;
        
        speed=1.0;
        boxes=0;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
        Score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%d",@"Boxes: ",boxes] dimensions:CGSizeMake(150, 300) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:25.0];
            [Score setPosition: CGPointMake(100, -100)];
        }
        else
        {
            Score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%d",@"Boxes: ",boxes] dimensions:CGSizeMake(100, 300) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:18.0];
            [Score setPosition: CGPointMake(50, -100)];
        }
        
        Score.color=ccc3(255, 0, 0);
        [self addChild:Score z:3];
        
        highboxes=0;
        
        NSInteger myInt = [prefs integerForKey:@"integerKey"];
        if(myInt > highboxes)
        {
            highboxes=myInt;
        }
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            Highscore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%d",@"High Score: ",highboxes] dimensions:CGSizeMake(300, 300) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:25.0];
            [Highscore setPosition: CGPointMake(800, -100)];
        }
        else
        {
            Highscore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%d",@"High Score: ",highboxes] dimensions:CGSizeMake(150, 300) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:18.0];
            [Highscore setPosition: CGPointMake(400, -100)];
        }
        
        
        
        Highscore.color=ccc3(255, 0, 0);
        
        
        [self addChild:Highscore z:3];
        
        CCMenuItem *pauseGame;
        pauseGame = [CCMenuItemImage itemFromNormalImage:SHImageString(@"pause_n")
                                           selectedImage: SHImageString(@"pause_d")
                                                  target:self
                                                selector:@selector(actionPause:)];
        // pauseGame.tag = 1;
        
        mainMenu = [CCMenu menuWithItems: pauseGame, nil];
        mainMenu.position = ccp( pauseGame.contentSize.width*0.9, SCREEN_HEIGHT - pauseGame.contentSize.height*0.6);
        [self addChild:mainMenu z:10];
        [self createPauseView] ;

        
        id MoveBox=[CCMoveTo actionWithDuration:speed position:ccp(Box.contentSize.width/2,SCREEN_HEIGHT/2)];
        
        id MoveBoxFinished = [CCCallFuncN actionWithTarget:self 
                                                 selector:@selector(MoveBoxFinished)];
        
        id MoveBlade1=[CCMoveTo actionWithDuration:0.5 position:ccp(SCREEN_WIDTH/2,0.64*SCREEN_HEIGHT)];
        id MoveBlade1Finished=[CCCallFuncN actionWithTarget:self selector:@selector(MoveBlade1Finished)];
        
        id MoveBlade2=[CCMoveTo actionWithDuration:0.5 position:ccp(SCREEN_WIDTH/2,0.359*SCREEN_HEIGHT)];
        id MoveBlade2Finished=[CCCallFuncN actionWithTarget:self selector:@selector(MoveBlade2Finished)];
        
        [Box runAction:[CCSequence actions:MoveBox , MoveBoxFinished, nil]];
        
        [Blade1 runAction:[CCSequence actions:MoveBlade1, MoveBlade1Finished, nil]];
        
        [Blade2 runAction:[CCSequence actions:MoveBlade2, MoveBlade2Finished, nil]];
        
        [self schedule:@selector(CheckForSlice:) interval:0.08];
#ifdef FreeApp
        if (![SettingsManager sharedManager].hasInAppPurchaseBeenMade) {
            isbannerActive = false;
            [SNAdsManager sharedManager].delegate = self;
            [[SNAdsManager sharedManager] giveMeBannerAdAtTop];
            // [self createAdRemoveButton ];
            
        }
#endif
        
        [[CCDirector sharedDirector] setDisplayFPS:NO];
        
    }
    self.isTouchEnabled=YES;
    return self;
}

-(void)MoveBoxFinished
{
    id MoveBackBox=[CCMoveTo actionWithDuration:speed position:ccp(SCREEN_WIDTH-Box.contentSize.width/2,SCREEN_HEIGHT/2)];
    
    id MoveBackBoxFinished = [CCCallFuncN actionWithTarget:self 
                                              selector:@selector(MoveBackBoxFinished)];
    
    [Box runAction:[CCSequence actions:MoveBackBox , MoveBackBoxFinished, nil]];
 
}

-(void)MoveBlade1Finished
{
    id MoveBackBlade1=[CCMoveTo actionWithDuration:0.5 position:ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT-Blade1.contentSize.height/2)];
    
    id MoveBackBlade1Finished = [CCCallFuncN actionWithTarget:self 
                                                  selector:@selector(MoveBackBlade1Finished)];
    
    [Blade1 runAction:[CCSequence actions:MoveBackBlade1 , MoveBackBlade1Finished, nil]];
    
}

-(void)MoveBlade2Finished
{
    id MoveBackBlade2=[CCMoveTo actionWithDuration:0.5 position:ccp(SCREEN_WIDTH/2,Blade2.contentSize.height/2)];
    
    id MoveBackBlade2Finished = [CCCallFuncN actionWithTarget:self 
                                                     selector:@selector(MoveBackBlade2Finished)];
    
    [Blade2 runAction:[CCSequence actions:MoveBackBlade2 , MoveBackBlade2Finished, nil]];
    
}

-(void)MoveBackBoxFinished
{
    id MoveBox=[CCMoveTo actionWithDuration:speed position:ccp(Box.contentSize.width/2,SCREEN_HEIGHT/2)];
    
    id MoveBoxFinished = [CCCallFuncN actionWithTarget:self 
                                              selector:@selector(MoveBoxFinished)];
    
    [Box runAction:[CCSequence actions:MoveBox , MoveBoxFinished, nil]];

}

-(void)MoveBackBlade1Finished
{
    id MoveBlade1=[CCMoveTo actionWithDuration:0.5 position:ccp(SCREEN_WIDTH/2,0.64*SCREEN_HEIGHT)];
    
    id MoveBlade1Finished = [CCCallFuncN actionWithTarget:self 
                                              selector:@selector(MoveBlade1Finished)];
    
    [Blade1 runAction:[CCSequence actions:MoveBlade1 , MoveBlade1Finished, nil]];
    
}

-(void)MoveBackBlade2Finished
{
    id MoveBlade2=[CCMoveTo actionWithDuration:0.5 position:ccp(SCREEN_WIDTH/2,0.359*SCREEN_HEIGHT)];
    
    id MoveBlade2Finished = [CCCallFuncN actionWithTarget:self 
                                                 selector:@selector(MoveBlade2Finished)];
    
    [Blade2 runAction:[CCSequence actions:MoveBlade2 , MoveBlade2Finished, nil]];
    
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [self convertTouchToNodeSpace: touch];
    TapLocationX=location.x;
    TapLocationY=location.y;
    //CHECK IF TAP IS INSIDE THE BOX. IF YES THEN INCREMENT.
    if((TapLocationY>(redBox.position.y-redBox.contentSize.height/2) && TapLocationY<(redBox.position.y+redBox.contentSize.height/2)) && (TapLocationX>(redBox.position.x-redBox.contentSize.width/2)&&TapLocationX<(redBox.position.x+redBox.contentSize.width/2)))
    {
        [Blade1 stopAllActions];
        [Blade2 stopAllActions];
        
        id MoveBlade1=[CCMoveTo actionWithDuration:0 position:ccp(SCREEN_WIDTH/2,0.64*SCREEN_HEIGHT)];
        id MoveBlade2=[CCMoveTo actionWithDuration:0 position:ccp(SCREEN_WIDTH/2,0.359*SCREEN_HEIGHT)];
        
        [Blade1 runAction:MoveBlade1];
        [Blade2 runAction:MoveBlade2];
        
        [self performSelector:@selector(MoveBlade1Finished) withObject:nil afterDelay:3];
        [self performSelector:@selector(MoveBlade2Finished) withObject:nil afterDelay:3];

        
    }
    else if((TapLocationY>(greenBox.position.y- greenBox.contentSize.height/2) && TapLocationY<(greenBox.position.y+ greenBox.contentSize.height/2)) && (TapLocationX>(greenBox.position.x- greenBox.contentSize.width/2)&&TapLocationX<(greenBox.position.x+greenBox.contentSize.width/2)))
    {
        [Blade1 stopAllActions];
        [Blade2 stopAllActions];
        
        id MoveBlade1=[CCMoveTo actionWithDuration:3 position:ccp(SCREEN_WIDTH/2,0.64*SCREEN_HEIGHT)];
        id MoveBlade1Finished=[CCCallFuncN actionWithTarget:self selector:@selector(MoveBlade1Finished)];
        
        id MoveBlade2=[CCMoveTo actionWithDuration:3 position:ccp(SCREEN_WIDTH/2,0.359*SCREEN_HEIGHT)];
        id MoveBlade2Finished=[CCCallFuncN actionWithTarget:self selector:@selector(MoveBlade2Finished)];
        
        [Blade1 runAction:[CCSequence actions:MoveBlade1, MoveBlade1Finished, nil]];
        
        [Blade2 runAction:[CCSequence actions:MoveBlade2, MoveBlade2Finished, nil]];
    }
    
    else if((TapLocationY>(Box.position.y-Box.contentSize.height/2) && TapLocationY<(Box.position.y+ Box.contentSize.height/2)) && (TapLocationX>(Box.position.x- Box.contentSize.width/2)&&TapLocationX<(Box.position.x+ Box.contentSize.width/2)))
    {
        speed=speed-0.01;
        boxes++;
        [Score setString:[NSString stringWithFormat:@"%@%d",@"Boxes: ",boxes]];
        if(boxes>highboxes)
        {
            highboxes=boxes;
            [Highscore setString:[NSString stringWithFormat:@"%@%d",@"High Score: ",highboxes]];
            [prefs setInteger:highboxes forKey:@"integerKey"];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"hit.mp3"];
        
        RandomBoxCounter++;
        if(RandomBoxCounter%10==0)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"speed.aiff"];
            if(arc4random()%2==0)
            {
                
                id moveGreenBox=[CCMoveTo actionWithDuration:1 position:ccp(-greenBox.contentSize.width/2,SCREEN_HEIGHT/2)];
            
                id GreenBoxFinished = [CCCallFuncN actionWithTarget:self 
                                                         selector:@selector(moveGreenBoxFinished)];
            
                [greenBox runAction:[CCSequence actions:moveGreenBox , GreenBoxFinished, nil]];
            }
            else
            {
                
                id moveRedBox=[CCMoveTo actionWithDuration:1 position:ccp(-redBox.contentSize.width/2,SCREEN_HEIGHT/2)];
            
                id RedBoxFinished = [CCCallFuncN actionWithTarget:self 
                                                       selector:@selector(moveRedBoxFinished)];
            
                [redBox runAction:[CCSequence actions:moveRedBox , RedBoxFinished, nil]];
                
            }
            
        }

    }
    else
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"miss.mp3"];
    }
    
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {

    TapLocationX=0;
    TapLocationY=0;
    
}

-(void)moveGreenBoxFinished
{
    greenBox.position=ccp(SCREEN_WIDTH +greenBox.contentSize.width/2,SCREEN_HEIGHT/2);
}

-(void)moveRedBoxFinished
{
    redBox.position=ccp(SCREEN_WIDTH +redBox.contentSize.width/2,SCREEN_HEIGHT/2);
}

-(void)CheckForSlice:(ccTime)dt
{
    //Check For Slicing
    if((TapLocationY>(Blade1.position.y-Blade1.contentSize.height/2) && TapLocationY<(Blade1.position.y+Blade1.contentSize.height/2)) || (TapLocationY>(Blade2.position.y-Blade2.contentSize.height/2)&&TapLocationY<(Blade2.position.y+Blade2.contentSize.height/2)))
    {
        [Blade1 stopAllActions];
        [Blade2 stopAllActions];
        [Box stopAllActions];
        [self unschedule:@selector(CheckForSlice:)];
        CCSprite *bloodstain=[CCSprite spriteWithFile:SHImageString(@"blood_stain")];
        bloodstain.position=ccp(TapLocationX,TapLocationY);
        [self addChild:bloodstain z:3];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Slice.mp3"];
        [self performSelector:@selector(terminate) withObject:nil afterDelay:2];
    }
}


- (void)bannerAdDidLoad{
    [self createAdRemoveButton];
    isbannerActive = true;;
}
- (void) showIAPNOADS :(id)sender {
    //[self terminate];
#ifdef FreeApp
    if (![SettingsManager sharedManager].hasInAppPurchaseBeenMade) {
        [[SNAdsManager sharedManager] hideBannerAd];
    }
#endif
    [[CCDirector sharedDirector] replaceScene:[RestoreIAPScene scene]];
       /*
#ifdef FreeApp
    if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO) {
        
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
        [MMProgressHUD showWithTitle:@"Purchasing" status:@"Please Wait"];
        [[MKStoreManager sharedManager] buyFeature:featureAIdVar
                                        onComplete:^(NSString* purchasedFeature,
                                                     NSData* purchasedReceipt,
                                                     NSArray* availableDownloads)
         {
             
             //   AppDelegate *mainDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             
             // mainDelegate.m_no_ads = NO;
             
         //    [[SettingsManager sharedManager].rootViewController hideLoadingView];
             NSLog(@"Purchased: %@", purchasedFeature);
             
             
             [SettingsManager sharedManager].hasInAppPurchaseBeenMade = YES;
             NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
             [standardUserDefaults setBool:[SettingsManager sharedManager].hasInAppPurchaseBeenMade forKey:@"inapp"];
             [standardUserDefaults synchronize];
             [[SNAdsManager sharedManager] hideBannerAd];
             [MMProgressHUD dismissWithSuccess:@"Ads removed and Wallpapers unlocked"];
             
             [self removeChildByTag:1000 cleanup:YES];
             
             //  [self createAd];
             // remembering this purchase is taken care of by MKStoreKit.
         }
                                       onCancelled:^
         {
             NSLog(@"Something went wrong");
             // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             //  [alert show];
             // [alert release];
             [MMProgressHUD dismissWithError:@"Unable to process your Request.\nPlease try again in a moment." title:@"Error"];
           //  [[SettingsManager sharedManager].rootViewController hideLoadingView];
             // User cancels the transaction, you can log this using any analytics software like Flurry.
         }];
        
        
    }
#endif
    [[CCDirector sharedDirector] startAnimation];
       */
}
-(void)createAdRemoveButton
{
    
    
    CCSprite* sprite1 = [CCSprite spriteWithFile:SHImageString(@"redCloseButton")];
    
    removeAdButton = [BsButton buttonWithImage:SHImageString(@"redCloseButton")
                                      selected:SHImageString(@"redCloseButton")
                                        target:self
                                      selector:@selector(showIAPNOADS:)];
    removeAdButton.tag = 1000;
    if (!UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        [removeAdButton setPosition:ccp( SCREEN_WIDTH-sprite1.contentSize.width-10,SCREEN_HEIGHT- sprite1.contentSize.height)];//+ 17 * (ipxbutton(2.2))
    }else{
        [removeAdButton setPosition:ccp( SCREEN_WIDTH-sprite1.contentSize.width-20,SCREEN_HEIGHT- sprite1.contentSize.height)];
    }
    [self addChild: removeAdButton z:10];

    
    
    
}
- (void) actionPause:(id)sender{
#ifdef FreeApp
    if (![SettingsManager sharedManager].hasInAppPurchaseBeenMade) {
        if(isbannerActive==true)
        {
        [[SNAdsManager sharedManager] hideBannerAd];
            isbannerActive = false;
        }
    }
#endif
  //  [[SoundManager sharedSoundManager] stopBackgroundMusic];
    mainMenu.visible = NO;
	removeAdButton.visible = false;
    [[CCDirector sharedDirector] pause];
	[m_pauseView setVisible:TRUE];
	
}
- (void) createPauseView
{
    
	CGPoint	pos = ccp(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
	m_pauseView = [[[PauseView alloc] initWithFrame:pos delegate:self] retain];
	[self addChild:m_pauseView z:1000];
	[m_pauseView setVisible:NO];
}
- (void)actionQuitfromPause:(id)sender {

    CCScene *scene = [Menu scene];
    [[CCDirector sharedDirector] resume];
    CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:0.6f scene:scene withColor:ccBLACK];
    
	[[CCDirector sharedDirector] replaceScene:ts];
}
- (void)actionQuit:(id)sender {
   // [[SoundManager sharedSoundManager] playBackgroundMusic:0];
    [self terminate];
	//CCScene *scene = [Menu scene];
  //  [[CCDirector sharedDirector] resume];
//	CCTransitionScene *ts = [CCTransitionFade transitionWithDuration:0.6f scene:scene withColor:ccBLACK];
    
	//[[CCDirector sharedDirector] replaceScene:ts];
}

- (void)actionResume:(id)sender {
    
#ifdef FreeApp
    if (![SettingsManager sharedManager].hasInAppPurchaseBeenMade) {
        [[SNAdsManager sharedManager] giveMeBannerAdAtTop];
    }
#endif
//    [[SoundManager sharedSoundManager] playBackgroundMusic:1];
    mainMenu.visible = YES;
    self.isAccelerometerEnabled = YES;
	[m_pauseView setVisible:FALSE];
    [[CCDirector sharedDirector] resume];
}


-(void)terminate
{
#ifdef FreeApp
    if (![SettingsManager sharedManager].hasInAppPurchaseBeenMade) {
        if(isbannerActive==true)
        {
            [[SNAdsManager sharedManager] hideBannerAd];
            isbannerActive = false;
        }
    }
#endif
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.box = boxes;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOverScene node]]];
}


- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
        
    // don't forget to call "super dealloc"
    [super dealloc];
}

@end
