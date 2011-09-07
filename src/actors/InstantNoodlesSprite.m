//
//  PupuSprite.m
//  Crunching
//
//  Created by andy on 10-12-1.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "InstantNoodlesSprite.h"
#import "SimpleAudioEngine.h"
#import <mach/mach_time.h>
#import "CCTouchDispatcher.h"
#import "GameRecordManager.h"


@implementation InstantNoodlesSprite

@synthesize foodName;
@synthesize noodle;
@synthesize cache;
@synthesize breakAction;
@synthesize breakAnimate;
@synthesize isBreak;
@synthesize isTouchEnable;
@synthesize touchCount;
@synthesize emitter;

- (id) initWithName:(NSString *)name {
	self = [super init];
	if (self) {
		//参数初始化
		maxTouchCount = 50;
		touchCount = 0;
		isBreak = NO;
		isTouchEnable = NO;
		
		foodName = name;
		NSString *plName = [NSString stringWithFormat:@"%@.plist",foodName];
		cache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[cache addSpriteFramesWithFile:plName];
		
		NSString *imgName = [NSString stringWithFormat:@"%@.png",foodName];
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:imgName];
		
		[self addChild:spriteSheet];
		
		NSMutableArray *frames = [[NSMutableArray array] retain];
		// 构造每一个帧的实际图像数据
		for (int i = 1; i <= 5; i++) {
			NSString *frameName = [NSString stringWithFormat:@"%@_%01d.png",foodName, i];
			CCSpriteFrame *frame = [cache spriteFrameByName:frameName];
			[frames addObject:frame];
		}
		
		//创建第一张图片作为静止时显示的画面
		NSString *firstFrameName = [NSString stringWithFormat:@"%@_%01d.png",foodName, 1];
		self.noodle = [CCSprite spriteWithSpriteFrameName:firstFrameName];
		
		//创建一个毁坏的动画
		self.breakAnimate = [CCAnimation animationWithFrames:frames delay:0.1f];
		self.breakAction = [CCAnimate actionWithAnimation:breakAnimate restoreOriginalFrame:NO];
		// 将构造好的动画加入显示列表
		[spriteSheet addChild:noodle];
	}
	return self;
}

//现实某个状态
-(void) playStep:(int)step {
	NSString *frameName = [NSString stringWithFormat:@"%@_%01d.png",foodName, step];
	[noodle setDisplayFrame:[cache spriteFrameByName:frameName]];
}

//是否已经被破坏掉了 
-(BOOL) isBroken {
	return isBreak;
}

//相应触摸事件
-(void) startCrunch {
	//NSLog(@"Instant noodles start crunch");
	isTouchEnable = YES;
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

//停止响应触摸事件
-(void) stopCrunch {
	//NSLog(@"Instant noodles stop crunch");
	isTouchEnable = NO;
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (void)onEnter
{
	[super onEnter];
}

- (void)onExit
{
	[super onExit];
}

//开始触摸
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	if ( isTouchEnable == NO ) return NO;
	if ( ![self containsTouchLocation:touch] ) return NO;
	NSLog(@"touched the sprite");
	
	if (touchCount<maxTouchCount) {
		touchCount++;
		int rnd = (mach_absolute_time() & 3);
		//播放声音
		NSString *sn = [[NSString alloc] initWithFormat:@"%@_%d.caf",foodName,rnd];
		[[SimpleAudioEngine sharedEngine] playEffect:sn]; 
		
		//更替画面
		if (touchCount<50) {
			[self playStep:rnd+1];
	
		}else if (touchCount==50) {
			[self playStep:5];
		}
		
		//显示粒子效果
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
		CGPoint pos = [self convertToWorldSpace:CGPointZero];
		CGPoint resultPos = ccpSub(convertedLocation, pos);	
		
		[self createParticle:resultPos];
		//微移动
		//self.position = ccp(self.position.x+(rnd-3),self.position.y+(rnd-3));
		
		//统计点击次数
		[GameRecordManager sharedManager].gameData.clickTimes++;
	}else {
		//NSLog(@"this is break");
		
		[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
		isBreak = YES;
	}
	return YES;
}

//触摸并移动
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
}

//检测区域
- (BOOL)containsTouchLocation:(UITouch *)touch {
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
}

//响应区域矩形
- (CGRect)rectInPixels {
	//CGSize s = [texture_ contentSizeInPixels];
	return CGRectMake(-100, -100, 200, 200);
}

//相应区域矩形
- (CGRect)rect{
    CGSize s = [self.texture contentSize];
    return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

-(void) createParticle:(CGPoint) point {
	NSLog(@" touch x :%f, y:%f",point.x,point.y);
	emitter = [[CCParticleExplosion alloc] initWithTotalParticles:10];
	[self addChild: emitter z:100];
	[emitter release];
	
	int rnd = (mach_absolute_time() & 3);
	NSString *cn = [[NSString alloc] initWithFormat:@"%@_clip_%d.png",foodName,rnd];
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage: cn];
	emitter.emitterMode = kCCParticleModeGravity;
	// duration
	emitter.duration = 0.5;
	// gravity
	emitter.gravity = ccp(0,-1500);
	// angle
	emitter.angle = 90;
	emitter.angleVar = 360;
	// speed of particles
	emitter.speed = 500;
	emitter.speedVar = 20;
	// radial
	emitter.radialAccel = -120;
	emitter.radialAccelVar = 0;
	// tagential
	emitter.tangentialAccel = 30;
	emitter.tangentialAccelVar = 0;
	// emitter position
	emitter.position = ccp(160,240);
	// life of particles
	emitter.life = 0.6f;
	emitter.lifeVar = 0.2f;
	// size, in pixels
	emitter.startSize = 20.0f;
	emitter.startSizeVar = 19.0f;
	emitter.endSize = 30.0f;
	// emits per second
	emitter.emissionRate = emitter.totalParticles/emitter.life;
	// color of particles
	ccColor4F startColor = {1.0f, 1.0f, 1.0f, 5.0f};
	emitter.startColor = startColor;
	ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
	emitter.startColorVar = startColorVar;
	//ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};	
	emitter.endColor = startColor;
	ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};	
	emitter.endColorVar = endColorVar;
	//position
	emitter.position = ccp(point.x,point.y);
	emitter.posVar = ccp(30,30);
	// additive
	emitter.blendAdditive = NO;
	emitter.autoRemoveOnFinish = YES;
}

- (void) dealloc{
	[super dealloc];
}

@end
