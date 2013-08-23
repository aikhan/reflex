//
//  PauseView.m
//  LoolyFly
//
//  Created by user on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseView.h"
#import "AppDelegate.h"
#import "SNAdsManager.h"
//#import "SoundManager.h"
//#import "AdManagerSS.h"

@implementation PauseView
- (id)initWithFrame:(CGPoint)point delegate:(id)delegate {
	if( (self=[super init]) ) {
		self.isTouchEnabled = YES;
		m_delegate = delegate;
		
        
		m_background = [[CCSprite spriteWithFile:SHImageString(@"bg")] retain];
		[m_background setPosition:ccp(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)];
		[self addChild:m_background];
		
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [CCDirector sharedDirector].winSize.height > 500)
        {
      //      m_background.scale = (double)568/480;
        }
        
				
		m_btnResume = [[BsButton buttonWithImage:SHImageString(@"btnresume")
									  selected:SHImageString(@"btnresumeSelected")
										target:self
									  selector:@selector(actionResume:)] retain];
		[m_btnResume setPosition:ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
		[self addChild: m_btnResume];

		m_btnQuit = [[BsButton buttonWithImage:SHImageString(@"btn_main_menu")
										  selected:SHImageString(@"btn_main_menu_selected")
											target:self
										  selector:@selector(actionQuit:)] retain];
		[m_btnQuit setPosition:ccp(SCREEN_WIDTH/2, SCREEN_HEIGHT* 3/8)];
		[self addChild: m_btnQuit];
        
        m_btnFreeGames = [[BsButton buttonWithImage:SHImageString(@"btnfreegame")
                                           selected:SHImageString(@"btnfreegameselected")
                                             target:self
                                           selector:@selector(openRevmobLink)] retain];
        [m_btnFreeGames setPosition:ccp(SCREEN_WIDTH / 2, SCREEN_HEIGHT /4)];
        [self addChild: m_btnFreeGames];
	}
	return self;
}

-(void) openRevmobLink
{
   // [[SoundManager sharedManager] playMenuSound];
    [[SNAdsManager sharedManager] giveMeLinkAd];
    //[[AdManagerSS sharedManager] openRevmobLink];
}

- (void) setVisible:(BOOL)isVisible
{
	[super setVisible:isVisible];
	[m_msgPause setVisible:isVisible];
	[m_btnResume setVisible:isVisible];
	[m_btnResume setEnable:isVisible];
	[m_btnQuit setVisible:isVisible];
	[m_btnQuit setEnable:isVisible];
    [m_btnFreeGames setVisible:isVisible];
	[m_btnFreeGames setEnable:isVisible];
}

- (void) dealloc {
	[m_background    release];
    [m_msgPause      release];
	[m_btnResume     release];
	[m_btnQuit       release];
    [m_btnFreeGames release];
	
	[super dealloc];
}

- (void)actionQuit:(id)sender {
     
   // AppDelegate *mainDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
     //   mainDelegate.m_showhint = 1;
   // [[SoundManager sharedSoundManager] playMenuSound];
    
	[m_delegate actionQuit:sender];
}

- (void)actionResume:(id)sender {
   // [[SoundManager sharedManager] playMenuSound];
    
	[m_delegate actionResume:sender];
}
@end
