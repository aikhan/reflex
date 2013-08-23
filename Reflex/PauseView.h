//
//  PauseView.h
//  LoolyFly
//
//  Created by user on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BsButton.h"

@interface PauseView : CCLayer {
	id			m_delegate;
	CCSprite*	m_background;
	CCSprite*	m_msgPause;
	BsButton*	m_btnResume;
	BsButton*	m_btnQuit;
    BsButton    *m_btnFreeGames;
}
- (id)initWithFrame:(CGPoint)rect delegate:(id)delegate;

@end
