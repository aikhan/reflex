//
//  AppDelegate.h
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import <MessageUI/MessageUI.h>


@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,SA_OAuthTwitterControllerDelegate,MFMailComposeViewControllerDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    int box;
    SA_OAuthTwitterEngine	*_engine;
    NSUserDefaults *link;
    NSURLConnection *  connection;
    NSMutableData *data;
    NSString *linkToApp;
    NSString *myLink;

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic,readwrite) int box;
@property (nonatomic,retain) NSUserDefaults *link;
@property (nonatomic,retain) NSURLConnection *  connection;
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) NSString *linkToApp;
@property (nonatomic,retain) NSString *myLink;


- (void)twitterTapped;
- (void)sendMail;

@end
