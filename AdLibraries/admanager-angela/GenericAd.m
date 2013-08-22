//
//  GenericAd.m
//  Alien Tower
//
//  Created by Asad Khan on 05/02/2013.
//
//

#import "GenericAd.h"
#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"

#import "SNAdsManager.h"
#import <RevMobAds/RevMobBanner.h>
#import "ALInterstitialAd.h"
#import "ALSdk.h"
static int count = 0;

@interface GenericAd()

@property (nonatomic, retain) NSTimer *playHavenTimer;
@property (nonatomic, assign)BOOL hasPlayHavenAdLoaded;
@end


@implementation GenericAd

/**
Chartboost AdNetwork calls the didFailToLoadInterstitial: delegate method even when it tries and fails to load the cache which results in 2 callbacks. The Problem with our admanager than is it loads two lower priority ads. To mitigate this we will be using nstimer to distinguish between 2 consecutive calls. If the time difference between the calls is less than a specified limit we will ignore the second call.
 For this we will be declaring a static float variable to store first intial failure time and than we will compare it with every second call we wll recieve.

 Another option is to wait a predefined number of seconds before calling another ad network. This option is NOT currently implemented in this code.
*/

static double firstCallBackTime;
static int callBackCount;

/**
 Sometimes RevMob fails to notify that loading ad has been failed so as a back we're adding fail time for RevMob FullScreen and Banner both
 */


@synthesize adNetworkType = _adNetworkType;
@synthesize adType = _adType;
@synthesize isTestAd = _isTestAd;
@synthesize adPriority = _adPriority;
@synthesize adView;
//@synthesize adStarted;
@synthesize revMobFullScreenAd = _revMobFullScreenAd;
@synthesize delegate = _delegate;

@synthesize revMobBannerAdView = _revMobBannerAdView;
@synthesize adLink = _adLink;
@synthesize revMobFullScreenAdTimer = _revMobFullScreenAdTimer;
@synthesize isRevMobFullScreenAlreadyShown = _isRevMobFullScreenAlreadyShown;
@synthesize playHavenTimer = _playHavenTimer;
//@synthesize isTopBannerAd = _isTopBannerAd;


- (id) initWithAdNetworkType:(NSUInteger)adNetworkType andAdType:(NSUInteger)adType{
	self = [super init];
	if(self !=nil){
        _adType = adType;
        _adNetworkType = adNetworkType;
        switch (adNetworkType) {
            case kAppLovin:
                if (_adType == kBannerAd){
                    adView = [[ALAdView alloc] initBannerAd];
                    adView.adDisplayDelegate = self;
                    adView.adLoadDelegate = self;
                    _adPriority = kAppLovinBannerAdPriority;
                }
                else if (adType == kFullScreenAd){
                    [ALInterstitialAd shared].adDisplayDelegate = self;
                    [ALInterstitialAd shared].adLoadDelegate = self;
                    _adPriority = kAppLovinFullScreenAdPriority;
                }
                break;
            case kChartBoost:
                if (adType == kFullScreenAd){
                    _adPriority = kChartBoostFullScreeAdPriority;
                    self.chartBoost = [SNAdsManager sharedManager].chartBoost;
                    self.chartBoost.delegate = self;
                }
                else if (adType == kMoreAppsAd)
                    _adPriority = kChartBoostMoreAppsAd;
                break;
            case kPlayHaven:
                if (adType == kFullScreenAd) {
                    _adPriority = kPlayHavenFullScreenAdPriority;
                    [[PHPublisherContentRequest requestForApp:kPlayHavenAppToken secret:kPlayHavenSecret placement:kPlayHavenPlacement delegate:self] preload];
                }
                break;
            case kRevMob:
                if(adType == kBannerAd){
                    _adPriority = kRevMobBannerAdPriority;
                    _revMobBannerAdView.delegate = self;
                }
                else if (adType == kFullScreenAd){
                    _adPriority = kRevMobFullScreenAdPriority;
                    _revMobFullScreenAd = [[RevMobAds session] fullscreen];
                    [_revMobFullScreenAd retain];
                    //_revMobFullScreenAd.delegate = self;
                    [_revMobFullScreenAd loadWithSuccessHandler:nil andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error){
                          //  [self.delegate revMobFullScreenDidFailToLoad:self];
                    }];   
                }
                else if (adType == kButtonAd)
                    _adPriority = kRevMobButtonAdPriority;
                else if (adType == kLinkAd){
                    _adPriority = kRevMobLinkAdPriority;
                    self.adLink = [[RevMobAds session] adLinkWithPlacementId:nil]; // you must retain this object
                    [self.adLink retain];
                    self.adLink.delegate = self;
                    [self.adLink loadAd];
                }
                else if (adType == kPopUpAd)
                    _adPriority = kRevMobPopAdPriority;
                else if (adType == kLocalNotificationAd)
                    _adPriority = kRevMobLocalNotificationAdPriority;
                else
                    [NSException raise:@"Invalid Ad Type" format:@"Ad Type is invalid"];
                break;
            default:
               // NSAssert(!adNetworkType == kUndefined, @"Value for Ad Network cannot be Undefined");
                [NSException raise:@"Undefined Ad Network" format:@"Ad Network is unknown cannot continue"];
                break;
        }
	}
	return self;
}

- (id) initWithAdType:(NSUInteger)adType{
    self = [super init];
	if(self !=nil){
        _adType = adType;   
    }
    return self;
}

-(void)showBannerAdAtTop{
    switch(self.adNetworkType){
        case kRevMob:{
            @try {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSUInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;
//                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                        self.revMobBannerAdView.frame = CGRectMake(0, 0, screenWidth, 114);
//                    } else {
//                        self.revMobBannerAdView.frame = CGRectMake(0, 0, screenWidth, 50);
//                    }
//                        [[SNAdsManager getRootViewController].view addSubview:self.revMobBannerAdView];
//                });
                    self.revMobBannerAdView = [[RevMobAds session] bannerView];
                    [self.revMobBannerAdView retain];
                    self.revMobBannerAdView.delegate = self;
                    [self.revMobBannerAdView loadAd];
                    CGSize size = [GenericAd currentSize];
//                    NSUInteger screenHeight = size.height;
//                    NSUInteger screenWidth = size.width;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            self.revMobBannerAdView.frame = CGRectMake(250, 0, 640, 114);
                    } else {
                            self.revMobBannerAdView.frame = CGRectMake(100, 0, 320, 50);
                    }
                    self.revMobBannerAdView.hidden = NO;
                    [[SNAdsManager getRootViewController].view addSubview:self.revMobBannerAdView];
                    [[SNAdsManager getRootViewController].view bringSubviewToFront:self.revMobBannerAdView];
                });
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
            @finally {
                //
            }
        }
            break;
        case kAppLovin:
            dispatch_async(dispatch_get_main_queue(), ^{
                [[SNAdsManager getRootViewController].view addSubview: adView];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    self.adView.frame = CGRectMake(250, 0, 640, adView.frame.size.height);
                } else {
                    self.adView.frame = CGRectMake(100, 0, 320, adView.frame.size.height);
                }
                [adView loadNextAd];
                });
            break;
        default:
            [NSException raise:@"Undefined Ad Network" format:@"Ad Network is unknown or does not have a banner Ad."];
            break;
    }
}

-(void)showBannerAd{
    switch(self.adNetworkType){
        case kRevMob:{
            @try {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.revMobBannerAdView = [[RevMobAds session] bannerView];
                    [self.revMobBannerAdView retain];
                    self.revMobBannerAdView.delegate = self;
                    [self.revMobBannerAdView loadAd];
                    CGSize size = [GenericAd currentSize];
                    NSUInteger screenHeight = size.height;
                    NSUInteger screenWidth = size.width;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        self.revMobBannerAdView.frame = CGRectMake(0, screenHeight-114, screenWidth, 114);
                    } else {
                        self.revMobBannerAdView.frame = CGRectMake(0, screenHeight-50, screenWidth, 50);
                    }
                    self.revMobBannerAdView.hidden = NO;
                    [[SNAdsManager getRootViewController].view addSubview:self.revMobBannerAdView];
                    [[SNAdsManager getRootViewController].view bringSubviewToFront:self.revMobBannerAdView];
               });
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
            @finally {
                //
            }
        }
            break;
    case kAppLovin:
            dispatch_async(dispatch_get_main_queue(), ^{
            adView.frame = CGRectMake( 0,
                                      [SNAdsManager getRootViewController].view.frame.size.height - adView.frame.size.height,
                                      adView.frame.size.width,
                                      adView.frame.size.height );
             
            [[SNAdsManager getRootViewController].view addSubview: adView];
            [adView loadNextAd];
            });
        break;
    default:
            [NSException raise:@"Undefined Ad Network" format:@"Ad Network is unknown or does not have a banner Ad."];
        break;
    }
}


-(void)showFullScreenAd{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch(self.adNetworkType){
        case kRevMob:
        {
            @try {
                if ([self.revMobFullScreenAd respondsToSelector:@selector(showAd)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.revMobFullScreenAd.delegate = self;
                        [self.revMobFullScreenAd showAd];
                    });
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
        }
            break;
        case kAppLovin:{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", [[ALSdk shared] description]);
                [ALInterstitialAd showOver:[UIApplication sharedApplication].keyWindow];
                [ALInterstitialAd shared].adLoadDelegate = self;
                [ALInterstitialAd shared].adDisplayDelegate = self;
                
            }); 
        }
            break;
        case kChartBoost:{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.chartBoost.delegate = self;
                [self.chartBoost showInterstitial];
            });
        }
            break;
        case kPlayHaven:{
            count++;
            NSLog(@"COunt for play HAVEN %d", count);
          //  dispatch_async(dispatch_get_main_queue(), ^{
                [self showPlayHavenFullScreenAd];
          //  });
            
        }
            break;
        default:
            [NSException raise:@"Undefined Ad Network" format:@"Ad Network is unknown or does not have a banner Ad."];
            break;
    }
}
-(void)showLinkButtonAd{
    [self.adLink openLink];
}
+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}
+(CGSize) currentSize
{
    return [GenericAd sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}
-(void)hideBannerAd{
    
    self.revMobBannerAdView.hidden = YES;
    [self.revMobBannerAdView removeFromSuperview];
    self.revMobBannerAdView = nil;
   
}

- (void)showPlayHavenFullScreenAd{
    DebugLog(@"%s", __PRETTY_FUNCTION__);
    DebugLog(@"YAAY PLAY HAVEN");
    dispatch_async(dispatch_get_main_queue(), ^{
        PHPublisherContentRequest * request = [PHPublisherContentRequest requestForApp:kPlayHavenAppToken secret:kPlayHavenSecret placement:kPlayHavenPlacement delegate:self];
        [request setShowsOverlayImmediately:YES];
        [request setAnimated:YES];
        [request send];
    });
   
}



//TODO: This is not a good way to do this from what I can tell, but until 
- (void)revmobAdDidFailWithError:(NSError *)error{
    NSLog(@" Hey hey hey %s", __PRETTY_FUNCTION__);
    if (self.adType == kBannerAd) {
        NSLog(@"REVMOB BANNER FAILED");
        
            [self.delegate revMobBannerDidFailToLoad:self];
            [self.revMobBannerAdView removeFromSuperview];
//            [self.revMobBannerAdTimer invalidate];
//            self.revMobBannerAdTimer = nil;
        
    }else if (self.adType == kFullScreenAd){
        NSLog(@"REVMOB FULLSCREEN FAILED");
            [self.delegate revMobFullScreenDidFailToLoad:self];
//            [self.revMobFullScreenAdTimer invalidate];
//            self.revMobFullScreenAdTimer = nil;
    }
}
- (void)revmobAdDisplayed{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.adType == kBannerAd) {
        [self.delegate revMobBannerDidLoadAd:self];

    }else if (self.adType == kFullScreenAd){

        [self.delegate revMobFullScreenDidLoadAd:self];
        self.isRevMobFullScreenAlreadyShown = YES;
    }
}
- (void)revmobUserClosedTheAd{
    if(self.adType == kFullScreenAd){
        self.isRevMobFullScreenAlreadyShown = NO;
    }
}
- (void)revmobAdDidReceive{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.adType == kBannerAd) {
        [self.delegate revMobBannerDidLoadAd:self];
    }else if (self.adType == kFullScreenAd){
        [self.delegate revMobFullScreenDidLoadAd:self];
    }
}
- (void)didFailToLoadInterstitial:(NSString *)location{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // NSLog(@"%@",[NSThread callStackSymbols]);
    /**
     On every callback increment the callback count by one
     on second callback check if the difference between first and second call is more than 1.5 sec
     If its more than 4.5 than most probably its a genuine failure callback
     else if its less than 4.5 just ignore it
     To make things quicker and not having to calculate nsdate instances everytime we're placing them in if else statements with respect to the callback counters.
     */
    callBackCount++;
    if(callBackCount == 1){
       firstCallBackTime = [[NSDate date] timeIntervalSince1970];
        [self.delegate chartBoostFullScreenDidFailToLoad:self];
    }
    else if (callBackCount == 2){
        NSDate *now = [NSDate date];
        double end = [now timeIntervalSince1970];
        double difference = end - firstCallBackTime;
        NSLog(@"Difference between calls is %f", difference);
        if (difference > 7.5) {
            [self.delegate chartBoostFullScreenDidFailToLoad:self];
        }
    }else{
        [self.delegate chartBoostFullScreenDidFailToLoad:self];
    }
        
    
}
- (BOOL)shouldDisplayLoadingViewForMoreApps{
    return YES;
}



#pragma mark -
#pragma mark Play Haven

-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //[self.delegate playHavenFullScreenDidLoadAd:self];
    
}

-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.hasPlayHavenAdLoaded) {
        return;
    }
    self.hasPlayHavenAdLoaded = YES;
    [self.delegate playHavenFullScreenDidFailToLoad:self];
}


-(void)requestDidGetContent:(PHPublisherContentRequest *)request{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.hasPlayHavenAdLoaded = YES;
}

-(void)requestWillGetContent:(PHPublisherContentRequest *)request{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.playHavenTimer = [NSTimer scheduledTimerWithTimeInterval:kPlayHavenAdTimeOutThresholdValue target:self selector:@selector(request:didFailWithError:) userInfo:nil repeats:NO];
    self.hasPlayHavenAdLoaded = NO;
}

#pragma mark -
#pragma mark AppLovin Methods
-(void) ad:(ALAd *) ad wasDisplayedIn: (ALAdView *)view;
{
    // Resize main view to give room for the Ad view
    /*CGRect mainViewFrame = CGRectMake( 0,
                                      0,
                                      [SNAdsManager getRootViewController].view.frame.size.width,
                                      [SNAdsManager getRootViewController].view.frame.size.height - adView.frame.size.height );
    [UIView animateWithDuration: 0.01
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         [SNAdsManager getRootViewController].view.frame = mainViewFrame;
                     }
                     completion: NULL];
     */
    if (self.adType == kBannerAd) {
        [self.delegate appLovinBannerDidLoadAd:self];
    }else if(self.adType == kFullScreenAd) {
        [self.delegate appLovinFullScreenDidLoadAd:self];
    }
}

/**
 * This method is invoked when the ad is hidden from in the view. This occurs
 * when the ad is rotated or when it is explicitly closed.
 *
 * @param ad     Ad that was just hidden. Guranteed not to be null.
 * @param view   Ad view in which the ad was hidden. It will be this controller's view.
 */
-(void) ad:(ALAd *) ad wasHiddenIn: (ALAdView *)view
{
    // Resize main view to fill the whole screen
//    CGRect mainViewFrame = CGRectMake( 0,
//                                      0,
//                                      [SNAdsManager getRootViewController].view.frame.size.width,
//                                      [SNAdsManager getRootViewController].view.frame.size.height );
//    [UIView animateWithDuration: 0.01
//                          delay: 0.0
//                        options: UIViewAnimationOptionCurveLinear
//                     animations: ^{
//                         [SNAdsManager getRootViewController].view.frame = mainViewFrame;
//                     }
//                     completion: NULL];
}

-(void)ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    NSLog(@"wasClickedIn");
}
-(void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"DIDLAOD APP LOVIN");
    if (self.adType == kBannerAd) {
        
        NSLog(@"Banner APPLOVIN SUCCESS");
    }else if (self.adType == kFullScreenAd){
        
        NSLog(@"FULLSCREEN APPLOVIN SUCCESS");
    }
}

-(void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.adType == kBannerAd) {
        [self.delegate appLovinBannerDidFailToLoad:self];
        NSLog(@"Banner APPLOVIN FAILED");
    }else if (self.adType == kFullScreenAd){
        [self.delegate appLovinFullScreenDidFailToLoad:self];
        NSLog(@"FULLSCREEN APPLOVIN FAILED");
    }
    
}
-(void)hideBannerAppLovinAd{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.adView removeFromSuperview];
}
@end
