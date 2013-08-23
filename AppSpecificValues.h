/*
 
 File: AppSpecificValues.h
 Abstract: Basic introduction to GameCenter
 
 Version: 1.0
 */

#define maxBirds 5
#define MaxBirdstoShow 10///i.e 10 after combining both left and right




#ifdef FreeApp

#define rateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=579388308"

//Leaderboard Category IDs
#define kEasyLeaderboardID @"com.semanticnotion.reflex.leaderboard"
#define featureAIdVar @"com.semanticnotion.Reflex.removeads"
//Achievement IDs
#define kAchievement1 @"com.semanticnotion.reflex.rookie"
#define kAchievement2 @"com.semanticnotion.TapHunt.second"
#define kAchievement3 @"com.semanticnotion.TapHunt.third"
#define kAchievement4 @"com.semanticnotion.TapHunt.fourth"

#endif




#ifdef PaidApp

#define rateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=689269923"
//Leaderboard Category IDs
#define kEasyLeaderboardID @"com.semanticnotion.ReflexPaid.leaderboard"
//Achievement IDs
#define kAchievement1 @"com.semanticnotion.ReflexPaid.rookie"
#define kAchievement2 @"com.semanticnotion.ReflexPaid.amateur"
#define kAchievement3 @"com.semanticnotion.ReflexPaid.pro"
#define kAchievement4 @"com.semanticnotion.ReflexPaid.expert"
#define featureAIdVar @""

#endif


