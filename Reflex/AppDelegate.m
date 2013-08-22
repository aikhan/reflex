//
//  AppDelegate.m
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"
#import "GameScene.h"
#import "Splash.h"
#import "SimpleAudioEngine.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define kOAuthConsumerKey		@"gtDQDzuhURxiHEsw7I9Iwg"
#define kOAuthConsumerSecret	@"tN3LeIO1n6EUiSvUj2ARnrxLnMuIR2YLQeAjh1xVkc"


@implementation AppDelegate

@synthesize window,box;

@synthesize link;
@synthesize connection;
@synthesize data;
@synthesize linkToApp;
@synthesize myLink;



- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Slice.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"miss.mp3"];
    
    
    link = [NSUserDefaults standardUserDefaults];
    myLink = [link stringForKey:@"stringKey"];
    if(myLink==nil)
    {
        NSURLRequest *linkRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://semanticdevlab.com/reflex/link.php"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        self.connection = [[NSURLConnection alloc] initWithRequest:linkRequest delegate:self];
    }
    
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        [director setDeviceOrientation:kCCDeviceOrientationPortrait];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
    }
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
    [window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [Splash scene]];
}

- (void)connection:(NSURLConnection *)theConnection 
    didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    self.linkToApp=[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [link setObject:self.linkToApp forKey:@"stringKey"];
    NSLog(@"string returned: %@", self.linkToApp);
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

/*TWITTER CONNECT*/

#pragma mark -
#pragma mark Twitter 


- (void)twitterTapped{
    
    //if (_engine) return;
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
    _engine.consumerKey = kOAuthConsumerKey;
    _engine.consumerSecret = kOAuthConsumerSecret;
    
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
    
    if (controller)
    {
        [viewController presentModalViewController: controller animated: YES];
        controller = nil;
        [controller release];
    }
    
    else {
        NSString * update = @"Hey Check out This Cool Game. I Scored ";
        update = [update stringByAppendingFormat:@"%d",box];
        update = [update stringByAppendingString:@" with my speed. How fast are you?"];
        update = [update stringByAppendingFormat:@" You can download it at %@",myLink];
        [_engine sendUpdate:update];
        //TODO: Change this behaviour create a seprate Catch Object & set its properties
    }
}


#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    NSString * update = @"Hey Check out This Cool Game. I Scored ";
    update = [update stringByAppendingFormat:@"%d",box];
    update = [update stringByAppendingString:@" with my speed. How fast are you?"];
    update = [update stringByAppendingFormat:@" You can download it at %@",myLink];
    
	[_engine sendUpdate:update];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"Your score has been successfully updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

/*TWITTER CONNECT ENDS HERE*/



/*Mail Button*/


-(void)sendMail {
	
	MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease] ;
	mailComposer.mailComposeDelegate = self;
	
	if ([MFMailComposeViewController canSendMail]) {
		
        NSString * update = @"Hey Check out This Cool Game. I Scored ";
        update = [update stringByAppendingFormat:@"%d",box];
        update = [update stringByAppendingString:@" with my speed. How fast are you?"];
        update = [update stringByAppendingFormat:@" You can download it at %@",myLink];
        
		[mailComposer setToRecipients:nil];
		[mailComposer setSubject:nil];
		[mailComposer setMessageBody:update isHTML:NO];
		
		[viewController presentModalViewController:mailComposer animated:YES];
		
	}
	
	
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	
	[controller dismissModalViewControllerAnimated:YES];
    
	NSString * strMessage = nil;
	switch(result)
	{
		case MFMailComposeResultSent:
			strMessage = @"Your email was sent.";
			break;
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultFailed:
			strMessage = @"Failed to send en email, please check your email settings";
			break;
		case MFMailComposeResultSaved:
			strMessage = @"LSEmailSaved", @"Email has been saved to your draft";
			break;
		default:
			break;
	}
	
	if (strMessage != nil)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[viewController dismissModalViewControllerAnimated:YES];;
}

/*Mail Button Ends Here*/

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
