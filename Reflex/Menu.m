//
//  Menu.m
//  Reflex
//
//  Created by Arslan Malik on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import "GameScene.h"
#import "InstructionScene.h"
#import "AboutScene.h"
#import "SettingsManager.h"
#import "AppDelegate.h"
#import "MKStoreManager.h"
#import "MMProgressHUD.h"
#import "MMProgressHUDOverlayView.h"
#import "RestoreIAPScene.h"
#import "AppSpecificValues.h"
#import "SNAdsManager.h"

@implementation Menu

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Menu *layer = [Menu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        
              
       CCSprite *background=[CCSprite spriteWithFile:SHImageString(@"bg")];
        background.position=ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        CCMenuItemImage *NewGame=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btn_play") selectedImage:SHImageString(@"btn_play_selected")
                                                               target:self
                                                             selector:@selector(Startgame)];
        
        CCMenuItemImage *Instructions=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btn_instructions") selectedImage:SHImageString(@"btn_instructions_selected")
                                                                    target:self
                                                                  selector:@selector(ShowInstructions)];
        
        CCMenuItemImage *About=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btn_about") selectedImage:SHImageString(@"btn_about_selected") target:self selector:@selector(ShowAbout)];
        
       CCMenuItemImage *highscore=[CCMenuItemImage itemFromNormalImage:SHImageString(@"highscore") selectedImage:SHImageString(@"highscoreSelected") target:self selector:@selector(leaderboard)];
        CCMenuItemImage *getafreegame =[CCMenuItemImage itemFromNormalImage:SHImageString(@"btnfreegame") selectedImage:SHImageString(@"btnfreegame") target:self selector:@selector(getaFreeGame)];
        
         CCMenuItemImage *restore=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btnrestore") selectedImage:SHImageString(@"btnrestore") target:self selector:@selector(restoreIAP)];
        
      CCMenuItemImage *removeads=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btnremoveAds") selectedImage:SHImageString(@"btnremoveAds") target:self selector:@selector(removeAds)];
        removeads.tag = 20;
        restore.tag=21;
        CCMenu *menu;
#ifdef FreeApp
        if(![[SettingsManager sharedManager] hasInAppPurchaseBeenMade])
            // if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO)
        {
             menu=[CCMenu menuWithItems: NewGame, Instructions,  highscore, removeads,restore, getafreegame,nil];
           // mainMenu = [CCMenu menuWithItems: startGame, highScore,store, instructions, removeads,restoreads, nil];
        }
        else
            
            menu=[CCMenu menuWithItems: NewGame, Instructions,highscore, getafreegame, nil];
          
        
#endif
        
#ifdef PaidApp
        menu=[CCMenu menuWithItems: NewGame, Instructions, highscore,getafreegame, nil];
       
#endif
        
        
        
        [menu alignItemsVertically];
        menu.position = ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT*0.41);
        [self addChild:background];
        [self addChild:menu];
        
        self.isTouchEnabled = YES;
        
        
    }
    
    [[CCDirector sharedDirector] setDisplayFPS:NO];
    return self;
}

-(void)Startgame
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameScene node]]];
}

-(void)ShowInstructions
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[InstructionScene node]]];
}

-(void)ShowAbout
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[AboutScene node]]];
}
-(void) leaderboard
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] abrirLDB];
}
- (void) restoreIAP
{
     [[CCDirector sharedDirector] replaceScene:[RestoreIAPScene scene]];
    
	//[super dealloc];
}
-(void) getaFreeGame
{
    [[SNAdsManager sharedManager] giveMeMoreAppsAd];
}

- (void)removeAds{
    
#ifdef FreeApp
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showWithTitle:@"Purchasing" status:@"Please Wait"];
    
    [[MKStoreManager sharedManager] buyFeature:featureAIdVar
                                    onComplete:^(NSString* purchasedFeature,
                                                 NSData* purchasedReceipt,
                                                 NSArray* availableDownloads)
     {
         
         
         //[[SettingsManager sharedManager].rootViewController hideLoadingView];
         NSLog(@"Purchased: %@", purchasedFeature);
         [SettingsManager sharedManager].hasInAppPurchaseBeenMade = YES;
         NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
         [standardUserDefaults setBool:[SettingsManager sharedManager].hasInAppPurchaseBeenMade forKey:@"inapp"];
         [standardUserDefaults synchronize];
         //[[SNAdsManager sharedManager] hideBannerAd];
         [MMProgressHUD dismissWithSuccess:@"Game Purchased and Ads removed"];
         
         [self removeChildByTag:21 cleanup:YES];
         [self removeChildByTag:20 cleanup:YES];
     }
                                   onCancelled:^
     {
         NSLog(@"Something went wrong");
         
         [MMProgressHUD dismissWithError:@"Unable to process your transaction.\nPlease try again in a moment." title:@"Error"];
         
     }];
    
    
    
    
#endif
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
