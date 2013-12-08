//
//  GenericAd.h
//  Alien Tower
//
//  Created by Asad Khan on 05/02/2013.
//
//

#import <Foundation/Foundation.h>
#import "SNManager.h"
#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"
#import "PlayHavenSDK.h"
#import "ALAdView.h"



@class RevMobFullscreen;
@class RevMobBanner;
@class GenericAd;
@class ALAdView;


@protocol GenericAdDelegate <NSObject>
@optional
- (void)revMobFullScreenDidFailToLoad:(GenericAd *)ad;
- (void)chartBoostFullScreenDidFailToLoad:(GenericAd *)ad;
- (void)revMobBannerDidFailToLoad:(GenericAd *)ad;
- (void)appLovinBannerDidFailToLoad:(GenericAd *)ad;
- (void)appLovinFullScreenDidFailToLoad:(GenericAd *)ad;

- (void)revMobBannerDidLoadAd:(GenericAd *)ad;
- (void)revMobFullScreenDidLoadAd:(GenericAd *)ad;
- (void)chartBoostFullScreenDidLoadAd:(GenericAd *)ad;
- (void)appLovinFullScreenDidLoadAd:(GenericAd *)ad;
- (void)appLovinBannerDidLoadAd:(GenericAd *)ad;

- (void)playHavenFullScreenDidLoadAd:(GenericAd *)ad;
- (void)playHavenFullScreenDidFailToLoad:(GenericAd *)ad;
@end


@interface GenericAd : NSObject <RevMobAdsDelegate, ChartboostDelegate,ALAdDisplayDelegate, ALAdLoadDelegate , PHPublisherContentRequestDelegate, ALAdDisplayDelegate>

{

}
enum adNetworkType{
    kChartBoost,
    kRevMob,
    kPlayHaven,
    kAppLovin,
    kUndefined
};

enum adType{
    kBannerAd = 1000,
    kFullScreenAd,
    kButtonAd,
    kLinkAd,
    kPopUpAd,
    kLocalNotificationAd,
    kMoreAppsAd,
    kUndefinedAdType
};

@property(nonatomic, assign)NSUInteger adNetworkType;
@property(nonatomic, assign)NSUInteger adType;
@property(nonatomic, assign)BOOL isTestAd;
@property(nonatomic, assign)NSUInteger adPriority;
@property(nonatomic, assign)BOOL enableCaching;

@property(nonatomic, strong) RevMobFullscreen *revMobFullScreenAd;
@property(nonatomic, strong) NSTimer *revMobFullScreenAdTimer;
@property(nonatomic, strong) NSTimer *revMobBannerAdTimer;

@property(nonatomic, assign) BOOL isRevMobFullScreenAlreadyShown;
@property(nonatomic, strong)RevMobAdLink *adLink;
@property(nonatomic, strong) RevMobBannerView *revMobBannerAdView;
@property (nonatomic, retain) id <GenericAdDelegate> delegate;

@property(nonatomic, strong) ALAdView * adView;

@property(nonatomic, strong)NSTimer *AppLovinTimer;
@property(nonatomic, strong)NSTimer *chartBoostTimer;

@property (nonatomic, strong)Chartboost *chartBoost;
//@property(nonatomic, assign)BOOL isTopBannerAd;

- (id) initWithAdNetworkType:(NSUInteger)adNetworkType andAdType:(NSUInteger)adType;
- (id) initWithAdType:(NSUInteger)adType;

-(void)showBannerAd;
-(void)showBannerAdAtTop;
-(void)showFullScreenAd;
-(void)showLinkButtonAd;
-(void)hideBannerAd;
-(void)hideBannerAppLovinAd;




@end
