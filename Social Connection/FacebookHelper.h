//
//  FacebookHelper.h
//  Reflex
//
//  Created by Semantic Notion on 8/27/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define kAppName        @"Reflex"
#define kCustomMessage  @"Hey Check out This Cool Game. I Scored %d  with my speed. How fast are you?\nYou can download it at: %@"
#define kServerLink     @"http://semanticdevlab.com/reflex/link.php"
#define kImageSrc       @""
#define kAppId @"244574645593274"
/*

message = @"Hey Check out This Cool Game. I Scored ";
message = [message stringByAppendingFormat:@"%d",appDelegate.box];
message = [message stringByAppendingString:@" with my speed. How fast are you?"];
message = [message stringByAppendingFormat:@" You can download it at %@",appDelegate.myLink];*/
@interface FacebookHelper : NSObject  {
    FBSession* _facebook;
    NSArray* _permissions;
}

@property(readonly) FBSession *facebook;

+ (FacebookHelper *) sharedInstance;


// Public methods here.
-(void) login;
-(void) logout;
-(void) postToWallWithDialogNewHighscore:(int)highscore;

@end
