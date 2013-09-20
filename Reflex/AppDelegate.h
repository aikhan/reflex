//
//  AppDelegate.h
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>
//#import "SA_OAuthTwitterEngine.h"
//#import "SA_OAuthTwitterController.h"
#import <KiipSDK/KiipSDK.h>
#import "GameCenterManager.h"
#import <MessageUI/MessageUI.h>
#import "GCViewController.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate, MFMailComposeViewControllerDelegate,KiipDelegate> {//SA_OAuthTwitterControllerDelegate,
	UIWindow			*window;
	RootViewController	*viewController;
    int box;
    GCViewController *viewController2;
    GameCenterManager* gameCenterManager;
    NSString* currentLeaderBoard;
  //  SA_OAuthTwitterEngine	*_engine;
  //  MGTwitterEngine *twitterEngine;
	UIAlertView *objAlertView;
	//OAToken *token;
    NSUserDefaults *link;
    NSURLConnection *  connection;
    NSMutableData *data;
    NSString *linkToApp;
    NSString *myLink;
    FBLoginView *loginview;
    BOOL LoggedIn;
    BOOL PostedStatus;
    

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic,readwrite) int box;
@property (nonatomic, assign) NSInteger appStartupCount;
@property (nonatomic,retain) NSUserDefaults *link;
@property (nonatomic,retain) NSURLConnection *  connection;
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) NSString *linkToApp;
@property (nonatomic, retain) RootViewController	*viewController;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) FBLoginView *loginview;
@property (nonatomic,readwrite) BOOL LoggedIn;
@property (nonatomic,readwrite) BOOL PostedStatus;
@property (nonatomic,retain) NSString *myLink;

- (void) addOne:(int)score;
- (void)twitterTapped;
- (void)sendMail;

@end
