//
//  Splash.h
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Splash : CCLayerColor {
    CCSprite *splash;
    float counter;
    float ipScaleY;
    float ipScaleX;
    CGSize winsize;
    UIScreen *mainScreen;
    CGFloat scale;
    CGFloat pixelHeight;
}

@property(nonatomic,retain) CCSprite *splash;
@property(nonatomic,readwrite) float counter;

+(CCScene *) scene;
-(void)checkCounter:(ccTime)dt;

@end
