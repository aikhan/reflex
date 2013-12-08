//
//  SNManager.h
//  Alien Tower
//
//  Created by Asad Khan on 05/02/2013.
//
//

#import <Foundation/Foundation.h>

#import <Availability.h>

/*
 #if !__has_feature(objc_arc)
 #error This class requires automatic reference counting
 #endif
 */
#define IS_IOS7_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#ifdef DEBUG
#define DebugLog(f, ...) NSLog(f, ## __VA_ARGS__)
#else
#define DebugLog(f, ...)
#endif


#define kPlayHavenAdTimeOutThresholdValue 4.0
#define kRevMobAdTimeOutThresholdValue 3.0
#define kAppLovinTimeOutThresholdValue 5.0
#define kChartBoostTimeOutThresholdValue 5.0
#ifdef FreeApp
#define kRevMobId @"528f505b3fb84f006d000018"

#define ChartBoostAppID @"5256b5c917ba472505000002"
#define ChartBoostAppSignature @"24802bb7caf8a90b0bcda33bebe0ab7eb0f6c78a"

#define kAppLovinID @"szwFHrfAufK_TAyhLTgJe4nEu9rN5A0x8wAPlqadUwcy4ZeQ2JkgNVwGelekvef1ZqRIe0x8wX5_5kP728pQei"

#define kPlayHavenAppToken @"b043452647634a76b84e0ff2448df438"
#define kPlayHavenSecret @"1b1e1b1cb1bc411a8874641a69e9bf6e"
#define kPlayHavenPlacement @"main_menu"
#ifdef IS_IOS7_AND_UP
#define kRateURL @"itms-apps://itunes.apple.com/app/id766454506"
#else
#define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=766454506"
#endif

#endif

#ifdef PaidApp
#define kRevMobId @"528f505b3fb84f006d000018"

#define ChartBoostAppID @"5256b5c917ba472505000002"
#define ChartBoostAppSignature @"24802bb7caf8a90b0bcda33bebe0ab7eb0f6c78a"

#define kPlayHavenAppToken @""
#define kPlayHavenSecret @""
#define kPlayHavenPlacement @"main_menu"

#define kTapJoyAppID @""
#define kTapJoySecretKey @""


#ifdef IS_IOS7_AND_UP
    #define kRateURL @"itms-apps://itunes.apple.com/app/id771690999"
#else
    #define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=771690999"
#endif

#endif



typedef NS_ENUM(NSUInteger, adPriorityLevel){
    kPriorityLOWEST = 10,
    kPriorityNORMAL,
    kPriorityHIGHEST
};

typedef NS_ENUM(NSUInteger, ConnectionStatus) {
    
    kNotAvailable,
    kWANAvailable,
    kWifiAvailable
    
};

/*
 These are the default values before changing them do consult Angela
 */
#define kRevMobBannerAdPriority kPriorityHIGHEST  //In Game banner Ads
#define kRevMobFullScreenAdPriority kPriorityLOWEST //Full Screen Pop-ups
#define kRevMobButtonAdPriority kPriorityHIGHEST //Button ads this is not currently used in games, its just a wrapper on Link Ads
#define kRevMobLinkAdPriority kPriorityHIGHEST  //This is the Ad that is displayed on buttons on game over screens
#define kRevMobPopAdPriority kPriorityHIGHEST  //UIAlert type pop-up Ads in games
#define kRevMobLocalNotificationAdPriority kPriorityHIGHEST // UILocalNotification Ads //Currently we're not using it

#define kChartBoostFullScreeAdPriority kPriorityNORMAL
#define kChartBoostMoreAppsAd kPriorityHIGHEST

//#define kMobClixBannerAdPriority -1
//#define kMobClixFullScreenAdPriority -1


#define kPlayHavenFullScreenAdPriority kPriorityNORMAL

#define kAppLovinBannerAdPriority kPriorityNORMAL
#define kAppLovinFullScreenAdPriority kPriorityHIGHEST

#define kNumberOfAdNetworks 4





@interface SNManager : NSObject



@end
