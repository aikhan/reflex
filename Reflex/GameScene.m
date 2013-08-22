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
#import <iAd/ADBannerView.h>



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
        
        [[CCDirector sharedDirector] setDisplayFPS:NO];
        
       
        /*---------------iADs------------------*/
     /*   UIViewController *controller = [[UIViewController alloc] init];
        controller.view.frame = CGRectMake(0,0,480,32);
        
        //From the official iAd programming guide
        ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
        
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        
        [controller.view addSubview:adView];
        
        //Then I add the adView to the openglview of cocos2d
        [[[CCDirector sharedDirector] openGLView] addSubview:controller.view];*/
        /*---------------iADs------------------*/
        
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

-(void)terminate
{
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
