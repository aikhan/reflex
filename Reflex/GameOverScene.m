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
#import "SettingsManager.h"
#import "SNAdsManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
//#import "FacebookScorer.h"

@implementation GameOverScene
@synthesize boxes;
//@synthesize fbButton,internetErrorAlert;

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
        
        appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        boxes=appDelegate.box;
        [self submitMyScore];
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
        m_btnFreeGames = [[BsButton buttonWithImage:SHImageString(@"btnfreegame")
                                           selected:SHImageString(@"btnfreegameselected")
                                             target:self
                                           selector:@selector(openRevmobLink)] retain];
        [m_btnFreeGames setPosition:ccp(SCREEN_WIDTH / 2, SCREEN_HEIGHT /6)];
        [self addChild: m_btnFreeGames];
        
#ifdef FreeApp
        
        if(![[SettingsManager sharedManager] hasInAppPurchaseBeenMade])
        {
            [[SNAdsManager sharedManager] hideBannerAd];
      //      [[SNAdsManager sharedManager] giveMeThirdGameOverAd];
        }
#endif
        appDelegate.PostedStatus = false;
        
        
        if(appDelegate.LoggedIn== true)
        {
              [[[[CCDirector sharedDirector] openGLView] viewWithTag:121] removeFromSuperview];        //self.buttonPostStatus.enabled = NO; 
            //[[[CCDirector sharedDirector] openGLView] addSubview:appDelegate.loginview];
        }
        
        [[CCDirector sharedDirector] setDisplayFPS:NO];
        
        
        //   fbAgent = [[FacebookAgent alloc] initWithApiKey:@"244574645593274"
        //                                        ApiSecret:@"f19ad533bd3f68a34da9ba43112a4a36"
        //                                        ApiProxy:nil];
        // fbAgent.delegate = self;
        
        
        self.isTouchEnabled=YES;
        
    }
    
    return self;
}

- (void) submitMyScore
{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app addOne:appDelegate.box];
}

-(void) openRevmobLink
{
    // [[SoundManager sharedManager] playMenuSound];
    [[SNAdsManager sharedManager] giveMeLinkAd];
    //[[AdManagerSS sharedManager] openRevmobLink];
}


/*FACEBOOK CONNECT*/


-(void)facebookTapped
{
    

    
    
    
    
    
    if(appDelegate.session!=NULL && appDelegate.LoggedIn == true)
    {
        //  BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom: self
        //                                                              initialText:message
        //                                                                  image:nil
        //                                                                     url:nil
        //                                                              handler:nil];
        // if (!displayedNativeDialog) {
        // [FBSession setActiveSession:appDelegate.session];
        
        
        //   if(!appDelegate.PostedStatus)
        ///  {
        message = @"Hey Check out This Cool Game. I Scored ";
        message = [message stringByAppendingFormat:@"%d",appDelegate.box];
        message = [message stringByAppendingString:@" with my speed. How fast are you?"];
        message = [message stringByAppendingFormat:@" You can download it at %@",appDelegate.myLink];
        
        if(!appDelegate.PostedStatus)
        {
            [self performPublishAction:^{
                // otherwise fall back on a request for permissions and a direct post
                [FBRequestConnection startForPostStatusUpdate:message
                                            completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                [self showAlert:message result:result error:error];
                                                //  self.buttonPostStatus.enabled = YES;
                                            }];
                
            }];
        }
        
    }
    
    
    /*  [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES
     completionHandler:^(FBSession *session,
     FBSessionState status,
     NSError *error) {
     // Respond to session state changes,
     // ex: updating the view
     if ([session isOpen]) {
     
     [self performPublishAction:^{
     // otherwise fall back on a request for permissions and a direct post
     [FBRequestConnection startForPostStatusUpdate:message
     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
     [self showAlert:message result:result error:error];
     //  self.buttonPostStatus.enabled = YES;
     }];
     
     //self.buttonPostStatus.enabled = NO;
     }];
     
     
     } else {
     // [appDelegate.loginview setTag:121];                                          // Session is closed
     //[[[CCDirector sharedDirector] openGLView] addSubview:appDelegate.loginview];
     }
     
     }];*/
    
    
    
    
    // Initialize a session object
    
    if(appDelegate.session==NULL || appDelegate.LoggedIn == false)
    {
        appDelegate.session = [[FBSession alloc] init];
        // Set the active session
        [FBSession setActiveSession:appDelegate.session];
        // Open the session
        [appDelegate.session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
                            completionHandler:^(FBSession *session,
                                                FBSessionState status,
                                                NSError *error) { }];
        
        
        
        
        
        
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceOnlyMe allowLoginUI:YES
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                                             // Respond to session state changes,
                                             // ex: updating the view
                                             if(!appDelegate.LoggedIn)
                                             {
                                                 appDelegate.loginview = [[FBLoginView alloc] initWithPublishPermissions:@[@"publish_actions"]
                                                                                                         defaultAudience:FBSessionDefaultAudienceOnlyMe];
                                                 
                                                 [appDelegate.loginview setTag:121];
                                                 appDelegate.loginview.frame = CGRectMake(-5, -5, 5, 5);
                                                 appDelegate.loginview.delegate = self;
                                                 
                                                 [[[CCDirector sharedDirector] openGLView] addSubview:appDelegate.loginview];
                                               //  appDelegate.LoggedIn = true;
                                             }
                                             /*  if(!appDelegate.PostedStatus && appDelegate.LoggedIn)
                                              {
                                              if ([session isOpen]) {
                                              
                                              [self performPublishAction:^{
                                              // otherwise fall back on a request for permissions and a direct post
                                              [FBRequestConnection startForPostStatusUpdate:message
                                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                              [self showAlert:message result:result error:error];
                                              //  self.buttonPostStatus.enabled = YES;
                                              }];
                                              appDelegate.PostedStatus = true;
                                              //self.buttonPostStatus.enabled = NO;
                                              }];
                                              }
                                              
                                              } else {
                                              // [appDelegate.loginview setTag:121];                                          // Session is closed
                                              //[[[CCDirector sharedDirector] openGLView] addSubview:appDelegate.loginview];
                                              }*/
                                             
                                         }];
        
        //  appDelegate.loginview = [[FBLoginView alloc] initWithPublishPermissions:@[@"publish_actions"]
        //                                     defaultAudience:FBSessionDefaultAudienceFriends];
        
        //  [appDelegate.loginview setTag:121];
        //  appDelegate.loginview.delegate = self;
        // [[[CCDirector sharedDirector] openGLView] addSubview:appDelegate.loginview];
        // }
        
        
    }
    
    //  appDelegate.loginview = [[FBLoginView alloc] initWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceEveryone];3
    
    
    
    
    
  
    
    
    
}


#pragma mark - FBLoginView delegate




- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
    message = @"Hey Check out This Cool Game. I Scored ";
    message = [message stringByAppendingFormat:@"%d",appDelegate.box];
    message = [message stringByAppendingString:@" with my speed. How fast are you?"];
    message = [message stringByAppendingFormat:@" You can download it at %@",appDelegate.myLink];
    
    
    
    
    appDelegate.LoggedIn=true;
    
    // if it is available to us, we will post using the native dialog
    /*  BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom: self
     initialText:message
     image:nil
     url:nil
     */                                                        //      handler:nil];
    // if (!displayedNativeDialog) {
    
    [self performPublishAction:^{
        // otherwise fall back on a request for permissions and a direct post
        [FBRequestConnection startForPostStatusUpdate:message
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        [self showAlert:message result:result error:error];
                                        appDelegate.PostedStatus = true;
                                        //  self.buttonPostStatus.enabled = YES;
                                    }];
       
    }];
    //}
    
    
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    
    NSString *alertMessage, *alertTitle;
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Facebook Error";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures since they can happen
        // outside of the app. You can inspect the error for more context
        // but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        appDelegate.LoggedIn= false;
        //BOOL canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    BOOL canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
    appDelegate.LoggedIn=false;
    //[[FBSession activeSession] closeAndClearTokenInformation];
    // [FBSession.activeSession closeAndClearTokenInformation];
   // appDelegate.LoggedIn=false;
    // [[[[CCDirector sharedDirector] openGLView] viewWithTag:121] removeFromSuperview];
}
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        alertMsg = [NSString stringWithFormat:@"Successfully posted."];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}

/*
 -(void)facebookTapped1
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
 */
/*FACEBOOK CONNECT ENDS*/

#pragma mark - twitter

-(void)twitterTapped
{
    NSLog(@"Twitter Tapped");
    [appDelegate twitterTapped];
}//

-(void)mailTapped
{
    NSLog(@"Mail Tapped");
    [appDelegate sendMail];
}

-(void)TryAgain
{
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:121] removeFromSuperview];
    // [appDelegate.loginview setHidden:YES];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameScene node]]];
}

-(void)MainMenu
{
    //[loginview setHidden:YES];
    [[[[CCDirector sharedDirector] openGLView] viewWithTag:121] removeFromSuperview];
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
