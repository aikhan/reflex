//
//  Menu.h
//  Reflex
//
//  Created by Arslan Malik on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Menu : CCLayerColor {
    float counter;
    float ipScaleY;
    float ipScaleX;
    CGSize winsize;
    UIScreen *mainScreen;
    CGFloat scale;
    CGFloat pixelHeight;
}

+(CCScene *) scene;

-(void)Startgame;
-(void)ShowInstructions;
-(void)ShowAbout;


@end
