//
//  Splash.m
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Splash.h"
#import "Menu.h"


@implementation Splash

@synthesize splash;
@synthesize counter;

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Splash *layer = [Splash node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if((self=[super init])) {
        winsize = [[CCDirector sharedDirector] winSizeInPixels];
        ipScaleY=  320.0f/640.0f;//winsize.height / 2.0f;//320/640          0.5f
        ipScaleX =  960.0f/(winsize.width * 2.0f); ///960.0f/1136.0f;
        mainScreen = [UIScreen mainScreen];
        scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
        
        splash=[CCSprite spriteWithFile: SHImageString(@"splash")];
        splash.position=ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        
        NSLog(@"\nwidth: %f x Height: %f\n",winsize.width,winsize.height);
        NSLog(@"\nwidth: %f x Height: %f\n",SCREEN_WIDTH,SCREEN_HEIGHT);
        
       
        [self addChild:splash];
        
        counter=0.0;
        
        [self schedule:@selector(checkCounter:) interval:0.1];        
        
        self.isTouchEnabled = YES;
        
        
    }
    
    [[CCDirector sharedDirector] setDisplayFPS:NO];
    return self;
}

-(void)checkCounter:(ccTime)dt
{
    if(counter>=2.0)
    {
        [self unschedule:@selector(checkCounter:)];
        counter=0.0;
        [[CCDirector sharedDirector] replaceScene:[Menu scene]];
    }
    else
    {
        counter=counter+0.1;
    }
}

@end