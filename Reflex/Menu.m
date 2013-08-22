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
        
       
        
        
        
     
        
        
       
        
        CCMenu *menu=[CCMenu menuWithItems:NewGame, Instructions, About, nil];
        
        [menu alignItemsVertically];
        menu.position = ccp(SCREEN_WIDTH*0.7,SCREEN_HEIGHT/2);
     //   NewGame.position=ccp(150,60);
     //   Instructions.position=ccp(150,0);
      //  About.position=ccp(150,-60);
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
