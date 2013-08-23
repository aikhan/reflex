//
//  GameOverScene.h
//  Reflex
//
//  Created by Arslan Malik on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookAgent.h"
#import "FBConnect.h"
#import "cocos2d.h"
#import "BsButton.h"

@interface GameOverScene : CCLayerColor <FBDialogDelegate,FBSessionDelegate,FBRequestDelegate,FacebookAgentDelegate,UIAlertViewDelegate>{
    int boxes;
    FBLoginButton			*fbButton;
	FacebookAgent			*fbAgent;
    UIAlertView *internetErrorAlert;
    
    float counter;
    float ipScaleY;
    float ipScaleX;
    CGSize winsize;
    UIScreen *mainScreen;
    CGFloat scale;
    CGFloat pixelHeight;
    BsButton    *m_btnFreeGames;

}

@property(nonatomic,readwrite) int boxes;
@property (nonatomic, retain) FBLoginButton *fbButton;
@property (nonatomic, retain) UIAlertView *internetErrorAlert;

+(CCScene *) scene;

-(void)TryAgain;
-(void)MainMenu;
-(void)facebookTapped;
-(void)twitterTapped;
-(void)mailTapped;

@end
