//
//  GameScene.h
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BsButton.h"
#import "PauseView.h"
#import "SNAdsManager.h"

@interface GameScene : CCLayerColor <UIAlertViewDelegate, SNAdsManagerDelegate> {
    
    CCSprite *Blade1;
    CCSprite *Blade2;
    CCSprite *Box;
    float TapLocationX;
    float TapLocationY;
    
    CCLabelTTF *Score;
    CCLabelTTF *Highscore;
    NSUserDefaults *prefs;
    int boxes;
    int highscore;
    float speed;
    bool isbannerActive;
    
    CCSprite *greenBox;
    CCSprite *redBox;
    int RandomBoxCounter;
    
    float counter;
    float ipScaleY;
    float ipScaleX;
    CGSize winsize;
    UIScreen *mainScreen;
    CGFloat scale;
    CGFloat pixelHeight;
    
    CCMenu *            mainMenu;
    BsButton *          removeAdButton;
    PauseView *			m_pauseView;
    
}

@property(nonatomic,retain) CCSprite *Blade1;
@property(nonatomic,retain) CCSprite *Blade2;
@property(nonatomic,retain) CCSprite *Box;
@property(nonatomic,readwrite) float TapLocationX;
@property(nonatomic,readwrite) float TapLocationY;
@property(nonatomic,retain) CCLabelTTF *Score;
@property(nonatomic,retain) CCLabelTTF *Highscore;
@property(nonatomic,retain) NSUserDefaults *prefs;
@property(nonatomic,readwrite) int boxes;
@property(nonatomic,readwrite) int highboxes;
@property(nonatomic,readwrite) float speed;

@property(nonatomic,retain) CCSprite *greenBox;
@property(nonatomic,retain) CCSprite *redBox;
@property(nonatomic,readwrite) int RandomBoxCounter;


+(CCScene *) scene;

-(void)MoveBoxFinished;
-(void)MoveBackBoxFinished;
-(void)moveGreenBoxFinished;
-(void)moveRedBoxFinished;
-(void)CheckForSlice:(ccTime)dt;
-(void)terminate;

@end
