//
//  CrunchPlayScene.h
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"
#import "InstantNoodlesSprite.h"

@interface CrunchPlay : CCLayer {
	
	InstantNoodlesSprite *food;
	
	CCSprite		*background;
	CCLabelTTF		*countLabel;
	CCLabelTTF		*timeLabel;
	CCLabelTTF		*timeLeastLabel;
	CCSprite		*ready;
	CCSprite		*go;
	CCSprite		*clear;
	CCSpriteBatchNode		*helpFinger;
	CCMenu			*pauseMenu;
	float			timeMax;
	float			timeCount;
	float			timeLeast;
	int				touchCount;
	int				touchMax;
	int				highScore;
	NSString		*highScorePrefix;
}

@property (nonatomic,retain) InstantNoodlesSprite *food;
@property (nonatomic,retain) CCMenu	*pauseMenu;
@property (nonatomic,retain) CCSpriteBatchNode *helpFinger;

-(void)playWithName:(NSString *)foodName;

-(void) playClearState;

//event handler

-(void) resumeEventHandler: (NSNotification *) notification;

-(void) replayEventHandler:(NSNotification *) notification;

-(void) gameMenuEventHandler:(NSNotification *) notification;

-(void) removeEventListeners;


@end
