#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"

@implementation RootViewController
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

#endif
#endif
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 
 return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
 }
 
 - (BOOL)shouldAutorotate {
 
 return YES;
 }
 
 - (NSUInteger)supportedInterfaceOrientations {
 
 return UIInterfaceOrientationLandscapeLeft;//UIInterfaceOrientationMaskLandscape;
 }
 
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
 
 return UIInterfaceOrientationLandscapeLeft;
 }
 
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 
 //
 // There are 2 ways to support auto-rotation:
 //  - The OpenGL / cocos2d way
 //     - Faster, but doesn't rotate the UIKit objects
 //  - The ViewController way
 //    - A bit slower, but the UiKit objects are placed in the right place
 //
 
 #if GAME_AUTOROTATION==kGameAutorotationNone
 //
 // EAGLView won't be autorotated.
 // Since this method should return YES in at least 1 orientation,
 // we return YES only in the Portrait orientation
 //
 return ( interfaceOrientation == UIInterfaceOrientationPortrait );
 
 #elif GAME_AUTOROTATION==kGameAutorotationCCDirector
 //
 // EAGLView will be rotated by cocos2d
 //
 // Sample: Autorotate only in landscape mode
 //
 if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
 [[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
 } else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
 [[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
 }
 
 // Since this method should return YES in at least 1 orientation,
 // we return YES only in the Portrait orientation
 return ( interfaceOrientation == UIInterfaceOrientationPortrait );
 
 #elif GAME_AUTOROTATION == kGameAutorotationUIViewController
 //
 // EAGLView will be rotated by the UIViewController
 //
 // Sample: Autorotate only in landscpe mode
 //
 // return YES for the supported orientations
 
 return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
 
 #else
 #error Unknown value in GAME_AUTOROTATION
 
 #endif // GAME_AUTOROTATION
 
 
 // Shold not happen
 return NO;
 }
 
 //
 // This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
 //
 #if GAME_AUTOROTATION == kGameAutorotationUIViewController
 -(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
 //
 // Assuming that the main window has the size of the screen
 // BUG: This won't work if the EAGLView is not fullscreen
 ///
 CGRect screenRect = [[UIScreen mainScreen] bounds];
 CGRect rect = CGRectZero;
 
 
 if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
 rect = screenRect;
 
 else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
 rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
 
 CCDirector *director = [CCDirector sharedDirector];
 EAGLView *glView = [director openGLView];
 //	float contentScaleFactor = [director contentScaleFactor];
 
 //	if( contentScaleFactor != 1 ) {
 ////		rect.size.width *= contentScaleFactor;
 //	rect.size.height *= contentScaleFactor;
 //}
 glView.frame = rect;
 }
 #endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
 
 
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 
 - (void)viewDidUnload {
 [super viewDidUnload];
 // Release any retained subviews of the main view.
 // e.g. self.myOutlet = nil;
 }
 
 
 
 
 - (void)dealloc {
 [super dealloc];
 }
 */

/*
 -(NSUInteger)supportedInterfaceOrientations{
 
 //Modify for supported orientations, put your masks here, trying to mimic behavior of shouldAutorotate..
 #if GAME_AUTOROTATION==kGameAutorotationNone
 return UIInterfaceOrientationMaskLandscape;
 #elif GAME_AUTOROTATION==kGameAutorotationCCDirector
 NSAssert(NO, @"RootviewController: kGameAutorotation isn't supported on iOS6");
 return UIInterfaceOrientationMaskLandscape;
 #elif GAME_AUTOROTATION == kGameAutorotationUIViewController
 return UIInterfaceOrientationMaskLandscape ;
 //for both landscape orientations return UIInterfaceOrientationLandscape
 #else
 #error Unknown value in GAME_AUTOROTATION
 
 #endif // GAME_AUTOROTATION
 }
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation,
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation,
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect;
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


/*
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
 {
 
 lastOrientation = self.interfaceOrientation;
 
 if(lastOrientation == UIInterfaceOrientationLandscapeLeft || lastOrientation== UIInterfaceOrientationLandscapeRight) return lastOrientation;
 
 // Choose your preferred default here as things get screwy with Game Centre Dialogs.
 return UIInterfaceOrientationLandscapeLeft;
 }
 
 #if GAME_AUTOROTATION==kGameAutorotationUIViewController
 - (BOOL)shouldAutorotate {
 return YES;
 }
 #else
 - (BOOL)shouldAutorotate {
 return NO;
 }
 #endif
 */
- (void)showLoadingView
{
    if (!self.loadingView)
    {
        
        self.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.loadingView.opaque = NO;
        self.loadingView.backgroundColor = [UIColor darkGrayColor];
        self.loadingView.alpha = 0.0;
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.spinnerView.color = [UIColor blueColor];
        [self.spinnerView setCenter:self.view.center];
        [self.loadingView addSubview:self.spinnerView];
        self.spinnerView.hidden = NO;
        [self.spinnerView startAnimating];
    }
    [UIView animateWithDuration:0.75
                     animations: ^{
                         self.loadingView.alpha = 0.7;
                         
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Do nothjing");
                         
                         
                     }];
    
    [self.spinnerView startAnimating];
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.spinnerView];
}
- (void)hideLoadingView
{
    [UIView animateWithDuration:0.75
                     animations: ^{
                         self.loadingView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.loadingView removeFromSuperview];
                     }];
    [self.spinnerView stopAnimating];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
/*
 -(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
 if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
 {
 lastOrientation=toInterfaceOrientation;
 }
 else lastOrientation=UIInterfaceOrientationLandscapeLeft;
 }
 */
@end
