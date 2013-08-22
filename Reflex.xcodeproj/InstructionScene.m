//
//  InstructionScene.m
//  Reflex
//
//  Created by Arslan Malik on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InstructionScene.h"
#import "Menu.h"


@implementation InstructionScene


+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InstructionScene *layer = [InstructionScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        CCSprite *background=[CCSprite spriteWithFile:SHImageString(@"instructions")];
        background.position=ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        [self addChild:background];
        
        CCMenuItemImage *MainMenu=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btn_back") selectedImage:SHImageString(@"btn_back_selected")
                                                                target:self
                                                              selector:@selector(MainMenu)];
        
        CCMenu *menu=[CCMenu menuWithItems:MainMenu, nil];
        
        [menu alignItemsVertically];
        menu.position=ccp(SCREEN_WIDTH*0.8,SCREEN_HEIGHT*0.1);
        
        [self addChild:menu];
        
        self.isTouchEnabled = YES;
        
        
    }
    
    [[CCDirector sharedDirector] setDisplayFPS:NO];
    return self;
}

-(void)MainMenu
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[Menu node]]];
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
