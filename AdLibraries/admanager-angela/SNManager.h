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

#ifdef DEBUG
#define DebugLog(f, ...) NSLog(f, ## __VA_ARGS__)
#else
#define DebugLog(f, ...)
#endif

//#define FreeApp 1
#define kPlayHavenAdTimeOutThresholdValue 4.0
#define kRevMobAdTimeOutThresholdValue 3.0

#ifdef FreeApp
#define kRevMobId @"51edcf5fb667d58654000003"//@"508b256d3628350d00000025"

#define ChartBoostAppID @"51edcd4716ba47f21e000003" //
#define ChartBoostAppSignature @"f3ec4575fdce3ef891a8aede9e7c1d2f5e375b14" //

#define kAppLovinID @"72p0QCCeF4dcq9v5at2nHmiOJVDd9UfGWSGyeTbvXDVLNORzGTlTERxXx8A4dqL9Gc5w4gpcvJzGhPDztyV5NR"
#define flurryKey @"DQZ32SH8SPV6T3PCQ2XV"
#define kPlayHavenAppToken @"5c511d0d05424265902ea6324016fd0e"
#define kPlayHavenSecret @"f8c7df1a75c443db8937508df86ec742"
#define kPlayHavenPlacement @"main_menu"

#define kTapJoyAppID @""
#define kTapJoySecretKey @""

#define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=695102537"
#endif

#ifdef PaidApp
#define kRevMobId @"51edcf5fb667d58654000003"//@"508b256d3628350d00000025"
#define flurryKey @"9CJNXTXD8S6PJZTJ7KDB"
#define ChartBoostAppID @"51edcd4716ba47f21e000003" //
#define ChartBoostAppSignature @"f3ec4575fdce3ef891a8aede9e7c1d2f5e375b14" //

#define kPlayHavenAppToken @""
#define kPlayHavenSecret @""
#define kPlayHavenPlacement @"main_menu"

#define kTapJoyAppID @""
#define kTapJoySecretKey @""
//#define MOBCLIX_ID @""//@"2C63EF1A-CA74-4467-8D30-1032D073A367"//2C63EF1A-

#define kRateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=470486083"
#endif

#define alSDKKey @"szwFHrfAufK_TAyhLTgJe4nEu9rN5A0x8wAPlqadUwcy4ZeQ2JkgNVwGelekvef1ZqRIe0x8wX5_5kP728pQei"

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
#define kRevMobBannerAdPriority kPriorityNORMAL  //In Game banner Ads
#define kRevMobFullScreenAdPriority kPriorityLOWEST //Full Screen Pop-ups
#define kRevMobButtonAdPriority kPriorityHIGHEST //Button ads this is not currently used in games, its just a wrapper on Link Ads
#define kRevMobLinkAdPriority kPriorityHIGHEST  //This is the Ad that is displayed on buttons on game over screens
#define kRevMobPopAdPriority kPriorityHIGHEST  //UIAlert type pop-up Ads in games
#define kRevMobLocalNotificationAdPriority kPriorityHIGHEST // UILocalNotification Ads //Currently we're not using it

#define kChartBoostFullScreeAdPriority kPriorityLOWEST
#define kChartBoostMoreAppsAd kPriorityHIGHEST

//#define kMobClixBannerAdPriority -1
//#define kMobClixFullScreenAdPriority -1


#define kPlayHavenFullScreenAdPriority kPriorityNORMAL

#define kAppLovinBannerAdPriority kPriorityHIGHEST
#define kAppLovinFullScreenAdPriority kPriorityHIGHEST

#define kNumberOfAdNetworks 5





@interface SNManager : NSObject



@end
