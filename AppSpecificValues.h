/*
 
 File: AppSpecificValues.h
 Abstract: Basic introduction to GameCenter
 
 Version: 1.0
 */



#ifdef FreeApp

#define rateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=579388308"
#define kEasyLeaderboardID @"com.semanticnotion.ReflexFree.leaderboard"
#define featureAIdVar @"com.semanticnotion.ReflexFree.removeads"
//Achievement IDs
#define kAchievement1 @"com.semanticnotion.ReflexFree.rookie"
#define kAchievement2 @"com.semanticnotion.ReflexFree.amateur"
#define kAchievement3 @"com.semanticnotion.ReflexFree.pro"
#define kAchievement4 @"com.semanticnotion.ReflexFree.expert"





#endif




#ifdef PaidApp

#define rateURL @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=470486083"
#define kEasyLeaderboardID @"com.semanticnotion.reflex.leaderboard"
#define featureAIdVar @""
//Achievement IDs
#define kAchievement1 @"com.semanticnotion.reflex.rookie"
#define kAchievement2 @"com.semanticnotion.reflex.amateur"
#define kAchievement3 @"com.semanticnotion.reflex.pro"
#define kAchievement4 @"com.semanticnotion.reflex.expert"

#endif


