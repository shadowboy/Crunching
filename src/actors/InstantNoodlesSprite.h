//
//  PupuSprite.h
//  Crunching
//
//  Created by andy on 10-12-1.
//  Copyright 2010 Augmentum. All rights reserved.
//
#import <Foundation/Foundation.h>  
#import "cocos2d.h"

@interface InstantNoodlesSprite : CCSprite<CCTargetedTouchDelegate> {
	
	NSString *foodName;
	CCSprite *noodle;
	CCSpriteFrameCache *cache;
	CCAction *breakAction;
	CCAnimation *breakAnimate;
	
	CCParticleSystem *emitter;
	
	int touchCount;
	int maxTouchCount;
	bool isBreak;
	bool isTouchEnable;
}

@property (nonatomic,retain) NSString *foodName;
@property (nonatomic,retain) CCSprite *noodle;
@property (nonatomic,retain) CCSpriteFrameCache *cache;
@property (nonatomic,retain) CCAction *breakAction;
@property (nonatomic,retain) CCAnimation *breakAnimate;

@property(readwrite,retain) CCParticleSystem *emitter;
@property(nonatomic, readonly) CGRect rect;
@property(nonatomic, readonly) CGRect rectInPixels;
@property(nonatomic, readonly) bool isBreak;
@property(nonatomic, readwrite) bool isTouchEnable;
@property(nonatomic,readwrite) int touchCount;


- (id) initWithName:(NSString *)name;

//相应触摸事件
-(void) startCrunch;
//停止相应触摸事件
-(void) stopCrunch;

-(void) playStep:(int)step;

-(BOOL) isBroken;

-(BOOL) containsTouchLocation:(UITouch *)touch;

-(void) createParticle:(CGPoint) point;


@end
