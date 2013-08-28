//
//  SettingScene.mm
//  towerGame
//
//  Created by KCU on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "Menu.h"
#import "AppDelegate.h"
#import "MKStoreManager.h"
#import "RestoreIAPScene.h"

//#import "AppSettings.h"
#import "AppSpecificValues.h"
#import "SettingsManager.h"
#import "RootViewController.h"
#import "MKStoreManager.h"
#import "MMProgressHUD.h"
#import "MMProgressHUDOverlayView.h"

//#define kTagMusicSlider 100
//#//define kTagSFXSlider	101
//#define __CLIPPING_SLIDERBAR   // Use clipping sliderbar
//#define __TOUCH_END_SLIDERBAR  // Use touch end callback sliderbar


@implementation RestoreIAPScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RestoreIAPScene *layer = [RestoreIAPScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) 
	{
        CCSprite *back = [CCSprite spriteWithFile:SHImageString(@"iappop")];  
        [back setPosition: ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
        [self addChild: back];
        
        CCMenuItemImage *yesButton;
        yesButton = [CCMenuItemImage itemFromNormalImage:SHImageString(@"yes") selectedImage:SHImageString(@"yes") target:self selector:@selector(restoreIAP:)];
        
        CCMenu* yesButtonMenu = [CCMenu menuWithItems: yesButton, nil];
        yesButtonMenu.position = ccp(SCREEN_WIDTH*0.35, SCREEN_HEIGHT/4);
        
        [self addChild:yesButtonMenu];
        
        CCMenuItemImage *noButton;
        noButton = [CCMenuItemImage itemFromNormalImage:SHImageString(@"no") selectedImage:SHImageString(@"no") target:self selector:@selector(cancelRestoreIAP:)];
        
        CCMenu* noButtonMenu = [CCMenu menuWithItems: noButton, nil];
        noButtonMenu.position = ccp(SCREEN_WIDTH*0.65, SCREEN_HEIGHT/4);
        
        [self addChild:noButtonMenu];
    }
	return self;
}



- (void) restoreIAP: (id) sender
{
    //Show LeaderBoard
    // AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [MKStoreManager sharedManager];
    
#ifdef FreeApp
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingRight];
    [MMProgressHUD showWithTitle:@"Restoring" status:@"Please Wait"];
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        
        if([MKStoreManager isFeaturePurchased: featureAIdVar] == NO) {
            [MMProgressHUD dismissWithError:@"This app does not appear to be purchased.\nPlease try again in a moment."];
           
            
        }
        else {
            [MMProgressHUD dismissWithSuccess:@"In app Purchase Remove Ads Restored!"];
            [SettingsManager sharedManager].hasInAppPurchaseBeenMade = YES;
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setBool:[SettingsManager sharedManager].hasInAppPurchaseBeenMade forKey:@"inapp"];
            [standardUserDefaults synchronize];
            
            NSLog(@"true");
            
            
        }
        
       // CCScene* back = [Menu node];
        [[CCDirector sharedDirector] replaceScene:[Menu scene]];
    } onError:^(NSError *A) {
        [MMProgressHUD dismissWithError:@"Unable to process your transaction.\nPlease try again in a moment." title:@"Error"];
        [[CCDirector sharedDirector] replaceScene:[Menu scene]];
    }];
#endif
    
    
    
    
	
}

- (void) cancelRestoreIAP: (id) sender
{
    //[self dealloc];
	CCScene* back = [Menu node];
	[[CCDirector sharedDirector] replaceScene:back];
}


- (void) dealloc
{
	[super dealloc];
}

@end
