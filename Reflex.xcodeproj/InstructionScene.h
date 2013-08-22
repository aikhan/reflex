//
//  InstructionScene.h
//  Reflex
//
//  Created by Arslan Malik on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface InstructionScene : CCLayerColor {
    float counter;
    float ipScaleY;
    float ipScaleX;
    CGSize winsize;
    UIScreen *mainScreen;
    CGFloat scale;
    CGFloat pixelHeight;
}

+(CCScene *) scene;

-(void)MainMenu;

@end
