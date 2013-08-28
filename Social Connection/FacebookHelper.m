//
//  FacebookHelper.m
//  Reflex
//
//  Created by Semantic Notion on 8/27/13.
//
//

#import "FacebookHelper.h"
#import "AppDelegate.h"
@implementation FacebookHelper

static FacebookHelper *singletonDelegate = nil;


+ (FacebookHelper *)sharedInstance {
    @synchronized(self) {
        if (singletonDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return singletonDelegate;
}
- (id)init {
    if (!kAppId) {
        NSLog("missing app id!");
        exit(1);
        return nil;
    }
    
    if ((self = [super init])) {
        _permissions =  [[NSArray arrayWithObjects: @"read_stream&", @"publish_stream", @"offline_access",nil] retain];
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonDelegate == nil) {
            singletonDelegate = [super allocWithZone:zone];
            // assignment and return on first allocation
            return singletonDelegate;
        }
    }
    // on subsequent allocation attempts return nil
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


-(NSMutableDictionary*) buildPostParamsWithHighscore:(int)highscore {
    AppDelegate* appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * message = @"Hey Check out This Cool Game. I Scored ";
    message = [message stringByAppendingFormat:@"%d",appDelegate.box];
    message = [message stringByAppendingString:@" with my speed. How fast are you?"];
    message = [message stringByAppendingFormat:@" You can download it at %@",appDelegate.myLink];
 //   NSString *customMessage = [NSString stringWithFormat:@"%@ %d %a ",kCustomMessage, highscore, kAppName];
//    NSString *postName = kAppName;
   // NSString *serverLink = [NSString stringWithFormat:kServerLink];
  //  NSString *imageSrc = kImageSrc;
    
    // Final params build.
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   //@&quot;message&quot;, @&quot;message&quot;,
                                  // imageSrc, @&quot;picture&quot;,
                                   message, @"Message", nil];
    
    return params;
}

-(void) login {
    // Check if there is a valid session.
    _facebook = [[FBSession alloc] initWithAppId:kAppId];
    _facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
    _facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
    if (![_facebook isSessionValid]) {
        [_facebook authorize:_permissions delegate:self];
    }
    else {
        [_facebook requestWithGraphPath:@"me"; andDelegate:self];
    }
}

-(void) logout {
    [_facebook logout:self];
}

-(void) postToWallWithDialogNewHighscore:(int)highscore {
    NSMutableDictionary* params = [self buildPostParamsWithHighscore:highscore];
    
    // Post on Facebook.
    [_facebook dialog:@"feed" andParams:params andDelegate:self];
}

@end