//
//  CrunchPlayScene.m
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//
#import <time.h>
#import <mach/mach_time.h>
#import "SimpleAudioEngine.h"
#import "LocalObject.h"
#import "FrameAnimHelper.h"
#import "InstantNoodlesSprite.h"

#import "Config.h"
#import "CrunchMenuScene.h"
#import "CrunchPlayScene.h"
#import "CrunchSelectScene.h"
#import "CrunchGameOverScene.h"
#import "CrunchSettingScene.h"
#import "CrunchPauseLayer.h"
#import "CrunchExtrasScene.h"
#import "GameRecordManager.h"
#import "FrameAnimHelper.h"

@implementation CrunchPlay

@synthesize food;
@synthesize pauseMenu;
@synthesize helpFinger;


-(id) init	
{
	if( (self=[super init]) ) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		//创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(s.width/2,s.height/2);
		[self addChild:bg];	
		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	return self;
}

//
//开始玩某种食物的游戏
//
-(void)playWithName:(NSString *)foodName
{
	//游戏次数统计
	[GameRecordManager sharedManager].gameData.playTimes++;
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	// 主角食物
	[GameRecordManager sharedManager].playing = foodName;
	
	food = [[InstantNoodlesSprite node] initWithName:foodName];
	food.position = ccp(s.width/2,s.height/2);
	[self addChild:food];
	
	//ready 动画
	ready = [CCSprite spriteWithFile:@"Playing_ready.png"];
	ready.position = ccp(s.width/2,s.height);
	[self addChild:ready];
	
	float readyStayTime = 2;
	//id rotate = [CCRotateBy actionWithDuration:stayTime angle:360];
	id readyMover = [CCMoveBy actionWithDuration:readyStayTime position:ccp(0,-240)];
	id readyEase = [CCEaseBackOut actionWithAction:readyMover];
	[ready runAction:readyEase];
	//播放ready音效
	[[SimpleAudioEngine sharedEngine] playEffect:@"ready.mp3"];
	
	[self schedule:@selector(goState:) interval: readyStayTime+.5];
	
}

//
//播放 go 元件
//
-(void)goState: (ccTime) delta  {
	//一点点清理
	[self unschedule:@selector(goState:)];
	[self removeChild:ready cleanup:YES];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	//go 图片
	go = [CCSprite	spriteWithFile:@"Playing_go.png"];
	go.position = ccp(s.width/2,s.height);
	[self addChild:go];
	//go 动画
	float goStayTime = .6;
	id goMover = [CCMoveBy actionWithDuration:goStayTime position:ccp(0,-240)];
	id goEase = [CCEaseBackOut actionWithAction:goMover];
	[go runAction:goEase];
	//播放go音效
	[[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
	//定时器
	[self schedule:@selector(startCrunching:) interval: goStayTime];
}

//
//开始Crunching
//
-(void) startCrunching: (ccTime) delta {
	//一点点清理
	[self unschedule:@selector(startCrunching:)];
	//删除 go sprite
	[self removeChild:go cleanup:YES];
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	//[self.view setUserInteractionEnabled:YES];
	
	//添加标签
	timeLabel =[CCLabelTTF labelWithString:@"" fontName:kLabelFontName fontSize:60];
	timeLabel.position = ccp(s.width/2,s.height-70);
	timeLabel.color = ccc3(0x00, 0x00, 0x00);
	[self addChild:timeLabel];
	
	//添加返回按钮
	CCMenuItemImage *menuItem = [CCMenuItemImage 
								 itemFromNormalImage:@"pause_normal.png" 
								 selectedImage:@"pause_over.png" 
								 target:self 
								 selector:@selector(pauseCallback:)];
	menuItem.tag = 103;
	menuItem.anchorPoint = ccp(0,0);
	pauseMenu = [CCMenu menuWithItems:menuItem,nil];
	pauseMenu.position = ccp(0,-50);
	[self addChild:pauseMenu];
	

	id mover = [CCMoveTo actionWithDuration:0.5 position:ccp(0,-2)];
	id ease = [CCEaseBackOut actionWithAction:mover];
	[pauseMenu runAction:ease];
	
	//参数初始化
	timeMax = 20;
	timeCount = 0;
	touchMax = 80;
	
	//播放背景音乐
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:kPlayingBgMusic];
	
	//方便面可以点击
	[food startCrunch];
	
	//开始循环
	[self schedule: @selector(loop:) interval: 0.01f];
	
	//显示帮助动画
	LocalObject *gd = [GameRecordManager sharedManager].gameData;
	int playTimes  = gd.playTimes;
	//如果玩游戏的次数少于3次，出现提示
	if (playTimes<3) {
		CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:@"help_touch.png"];
		helpFinger = [FrameAnimHelper animWithTexture:tex
											numFrames:12
										plistFilename:@"help_touch.plist"
										   spriteName:@"touch"
											spriteTag:1232];
		[self addChild:helpFinger];
		helpFinger.position = ccp(280,100);
	}
}

//
// 游戏循环
//
-(void) loop: (ccTime) delta {
	timeCount+=0.01;
	NSString *t = [[NSString alloc] initWithFormat:@"%.2f 's",timeCount];
	[timeLabel setString:t];
	[t release];
	
	if(food.touchCount>10){
		[self removeChild:helpFinger cleanup:YES];
	}
	if (food.isBreak==YES) {
		[self playClearState];
	}
}

//
// 播放clear动画
//
-(void) playClearState {	
	[self unschedule:@selector(loop:)];
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	
	//记录点击到指定次数需要的最小时间
	if (timeLeast==0 || timeCount<timeLeast) {
		timeLeast = timeCount;
	}
	
	//显示Clear提示
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	float clearDisplayTime = 1;
	clear = [CCSprite spriteWithFile:@"Playing_clear.png"];
	clear.position = ccp(s.width/2,s.height);
	[self addChild:clear];
	
	id clearMover = [CCMoveBy actionWithDuration:clearDisplayTime position:ccp(0,-240)];
	id clearEase = [CCEaseBackOut actionWithAction:clearMover];
	[clear runAction:clearEase];
	//发出欢呼声
	[[SimpleAudioEngine sharedEngine] playEffect:@"wow.mp3"];
	
	//定时器
	[self schedule:@selector(goAndShowGameOverLayer:) interval: clearDisplayTime+1];	
}

//
//显示游戏结束图层
//
-(void) goAndShowGameOverLayer: (ccTime) delta {
	[self unschedule:@selector(loop:)];
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	
	[self unschedule:@selector(goAndShowGameOverLayer:)];
	
	[self removeChild:clear cleanup:YES];
	
	CCScene *scene = [CCScene node];
	CrunchGameOver *layer = [CrunchGameOver node];
	[layer setUseTime:timeCount leastTime:timeLeast];
	[scene addChild: layer];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

//
//暂停游戏
//
-(void) pauseCallback :(id) sender {
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	//游戏暂停
	[[CCDirector sharedDirector] pause];
	//暂停背景音乐
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	//暂停按钮不可用
	[[pauseMenu getChildByTag:103] setIsEnabled:NO];
	//增加事件监听
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(resumeEventHandler:)
											 name:@"resumeEvent"
											 object:nil ];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(replayEventHandler:)
											 name:@"replayEvent"
											 object:nil ];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(gameMenuEventHandler:)
											 name:@"menuEvent"
										     object:nil ];
	
	//显示暂停面板
	CrunchPause *pausePanel = [CrunchPause node];
	//pausePanel.position = ccp(s.width/2,s.height/2);
	[self addChild: pausePanel];
}

//
//恢复游戏
//
-(void) resumeEventHandler: (NSNotification *) notification {
    NSLog(@" playState resumeEvent Handler");
	[self removeEventListeners];
	[[pauseMenu getChildByTag:103] setIsEnabled:YES];
	[[CCDirector sharedDirector] resume];
	[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
} 

//
//重新开始
//
-(void) replayEventHandler:(NSNotification *) notification {
	NSLog(@" playState replayEvent Handler");
	//恢复游戏
	[[CCDirector sharedDirector] resume];
	//删除暂停面板所有监听
	[self removeEventListeners];
	//停止食物响应
	[food stopCrunch];
	
	//切换场景
	CCScene * scene = [CCScene node];
	NSString *foodName = [GameRecordManager sharedManager].playing;
	CrunchPlay *playLayer = [CrunchPlay node];
	[playLayer playWithName:foodName];
	[scene addChild: playLayer];
	[[CCDirector sharedDirector] replaceScene:scene];
	
	[food stopCrunch];
}

//
//跳转到菜单选择
//
-(void) gameMenuEventHandler:(NSNotification *) notification {
	NSLog(@" playState menuEvent Handler");
	//恢复游戏
	[[CCDirector sharedDirector] resume];
	//删除暂停面板所有监听
	[self removeEventListeners];
	//停止食物响应
	[food stopCrunch];
	//切换场景
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchMenu node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
	
}

//
//删除所有监听
//
-(void) removeEventListeners {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"resumeEvent" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"menuEvent" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"replayEvent" object:nil];
}

//
//失去
//
-(void) dealloc {
	[super dealloc];
}

@end
