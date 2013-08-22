//
//  GameOverScene.m
//  Reflex
//
//  Created by Arslan Malik on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "Menu.h"
#import "AppDelegate.h"

@implementation GameOverScene
@synthesize boxes;
@synthesize fbButton,internetErrorAlert;

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        boxes=appDelegate.box;
        
        CCSprite *background=[CCSprite spriteWithFile:SHImageString(@"bg_game")];
        background.position=ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
        [self addChild:background];
        
        CCMenuItemImage *TryAgain=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btn_tryagain") selectedImage:SHImageString(@"btn_tryagain_selected")
                                                               target:self
                                                             selector:@selector(TryAgain)];
        
        CCMenuItemImage *MainMenu=[CCMenuItemImage itemFromNormalImage:SHImageString(@"btn_main_menu") selectedImage:SHImageString(@"btn_main_menu_selected")
                                                                    target:self
                                                                  selector:@selector(MainMenu)];
        
        CCMenu *menu=[CCMenu menuWithItems:TryAgain, MainMenu, nil];
        
        [menu alignItemsHorizontally];
        menu.position=ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.6);
       // TryAgain.position=ccp(0,80);
       // MainMenu.position=ccp(0,20);
        
        [self addChild:menu];
        
        //FACEBOOK, TWITTER, MAIL BUTTONS
        
        CCMenuItemImage *facebook=[CCMenuItemImage itemFromNormalImage:SHImageString(@"facebook_pressed") selectedImage:SHImageString(@"facebook") target:self selector:@selector(facebookTapped)];
        CCMenuItemImage *twitter=[CCMenuItemImage itemFromNormalImage:SHImageString(@"twitter_pressed") selectedImage:SHImageString(@"twitter") target:self selector:@selector(twitterTapped)];
        CCMenuItemImage *mail=[CCMenuItemImage itemFromNormalImage:SHImageString(@"mail_pressed") selectedImage:SHImageString(@"mail") target:self selector:@selector(mailTapped)];
        
        CCMenu *connectivity_buttons=[CCMenu menuWithItems:facebook, twitter, mail, nil];
        
        [connectivity_buttons alignItemsHorizontally];
        connectivity_buttons.position = ccp(SCREEN_WIDTH/2,SCREEN_HEIGHT/3);
        [self addChild:connectivity_buttons];
        CCLabelTTF *GameOverText;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        GameOverText=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%d%@",@"You Collected: ",boxes,@" boxes"] dimensions:CGSizeMake(300, 300) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:25.0];
            GameOverText.position = ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.7);
        }
        else
        {
        GameOverText=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%d%@",@"You Collected: ",boxes,@" boxes"] dimensions:CGSizeMake(300, 300) alignment:NSTextAlignmentCenter fontName:@"Arial" fontSize:18.0];
            GameOverText.position = ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.5);
        }
        
        //[GameOverText setPosition: CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.7)];
        GameOverText.color=ccc3(255, 255, 255);
        
        [self addChild:GameOverText];

        
        [[CCDirector sharedDirector] setDisplayFPS:NO];
        
        
        fbAgent = [[FacebookAgent alloc] initWithApiKey:@"244574645593274" 
                                              ApiSecret:@"f19ad533bd3f68a34da9ba43112a4a36" 
                                               ApiProxy:nil];
        fbAgent.delegate = self;
        
        
        self.isTouchEnabled=YES;
        
    }
    
    return self;
}

/*FACEBOOK CONNECT*/

-(void)facebookTapped
{
    NSLog(@"Facebook Tapped");
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.facebook.com"] encoding:NSUTF8StringEncoding error:nil];
    if(URLString == NULL)
    {
        self.internetErrorAlert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable To Reach Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.internetErrorAlert show];
        return;
    }
    NSString * update = @"Hey Check out This Cool Game. I Scored ";
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    update = [update stringByAppendingFormat:@"%d",appDelegate.box];
    update = [update stringByAppendingString:@" with my speed. How fast are you?"];
    update = [update stringByAppendingFormat:@" You can download it at %@",appDelegate.myLink];
    [fbAgent setStatus:update];
}
- (void) facebookAgent:(FacebookAgent*)agent requestFaild:(NSString*) message{
    fbAgent.shouldResumeSession = NO;
}
- (void) facebookAgent:(FacebookAgent*)agent statusChanged:(BOOL) success{
    NSLog(@"status changed");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"Your score has been successfully updated" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void) facebookAgent:(FacebookAgent*)agent loginStatus:(BOOL) loggedIn{
}
- (void) facebookAgent:(FacebookAgent*)agent dialog:(FBDialog*)dialog didFailWithError:(NSError*)error{
    NSLog(@"status change failed");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error posting score to your profile please try back in a while" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
    NSLog(@"Error : %@", [error description]);
}

/*FACEBOOK CONNECT ENDS*/

-(void)twitterTapped
{
    NSLog(@"Twitter Tapped");
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate twitterTapped];
}

-(void)mailTapped
{
    NSLog(@"Mail Tapped");
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate sendMail];
}

-(void)TryAgain
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameScene node]]];
}

-(void)MainMenu
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[Menu node]]];
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
