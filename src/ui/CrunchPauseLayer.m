//
//  CrunchPauseLayer.m
//  Crunching2
//
//  Created by andy on 10-12-16.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "CrunchPauseLayer.h"
#import "Config.h"
#import "SimpleAudioEngine.h"
#import "CrunchSettingScene.h"
#import "CrunchMenuScene.h"
#import "LocalObject.h"
#import "GameRecordManager.h"

//暂停时出现的菜单
@implementation CrunchPause

-(id)init {
	if (self==[super init]) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		[self setContentSize:s];
		//创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"Pause_background.png"];
		bg.position = ccp(s.width/2,s.height/2);
		[self addChild:bg];
		
		//设置菜单字体
		[CCMenuItemFont setFontName:kMenuFontName];
		[CCMenuItemFont setFontSize:kMenuFontSize];
		
		//切换声音开关
		CCMenuItemFont *title1 = [CCMenuItemFont itemFromString: @"Sound"];
		[title1 setIsEnabled:NO];
		CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundToggleCallback:) items:
								   [CCMenuItemImage 
									itemFromNormalImage:@"sound_unmute_normal.png"		
									selectedImage:@"sound_unmute_normal.png"
									],
								   [CCMenuItemImage 
									itemFromNormalImage:@"sound_mute_normal.png"		
									selectedImage:@"sound_mute_normal.png"
									],
								   nil];
		
		//切换背景音乐开关
		CCMenuItemFont *title2 = [CCMenuItemFont itemFromString: @"Music"];
		[title2 setIsEnabled:NO];
		CCMenuItemToggle *item2 = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicToggleCallback:) items:
								   [CCMenuItemImage 
									itemFromNormalImage:@"music_unmute_normal.png"		
									selectedImage:@"music_unmute_normal.png"
									],
								   [CCMenuItemImage 
									itemFromNormalImage:@"music_mute_normal.png"		
									selectedImage:@"music_mute_normal.png"
									],
								   nil];
		
		//根据存储来设置状态
		LocalObject *lo = [GameRecordManager sharedManager].gameData;
		NSLog(@"sound volume: %f",lo.soundVolume);
		NSLog(@"music volume: %f",lo.musicVolume);
		if(lo.soundVolume == 1){
			item1.selectedIndex = 0;
		}else {
			item1.selectedIndex = 1;
		}
		
		if(lo.musicVolume == 1){
			item2.selectedIndex = 0;
		}else {
			item2.selectedIndex = 1;
		}
		
		//设置菜单字体和样式
		[CCMenuItemFont setFontName: kMenuFontName];
		[CCMenuItemFont setFontSize: kMenuFontSize];
		//resule
		CCMenuItemLabel *resumLabel = [CCMenuItemFont itemFromString: @" Resume " target:self selector:@selector(resumeHandler:)];
		//menu
		CCMenuItemLabel *menuLabel = [CCMenuItemFont itemFromString: @" Menu " target:self selector:@selector(menuHandler:)];
		//try again
		CCMenuItemLabel *tryLabel = [CCMenuItemFont itemFromString: @" Retry " target:self selector:@selector(replayHandler:)];
		
		
		CCMenu *menu = [CCMenu menuWithItems:
						title1, title2,
						item1, item2,
						resumLabel,
						menuLabel,
						tryLabel,
						nil];
		menu.color = ccc3(0x00, 0x00, 0x00);
		// 9 items.
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:2],
		 [NSNumber numberWithUnsignedInt:2],
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 [NSNumber numberWithUnsignedInt:1],
		 nil
		 ]; // 2 + 2 + 2 + 2 + 1 = total count of 9.
		
		
		[self addChild: menu];
	}
	return self;
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];	
}

- (void)onEnter {
	[super onEnter];
	NSLog(@"on enter");
}

- (void)onExit
{
	//[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
	NSLog(@"on exit");
}

//开始触摸
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	NSLog(@"pause layer touched");
	return YES;
}
	

-(void) soundToggleCallback: (id) sender
{
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
	int index = [sender selectedIndex];
	if (index==0) {
		[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:1];
		[GameRecordManager sharedManager].gameData.soundVolume = 1.0f;
	}else {
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0];
		[GameRecordManager sharedManager].gameData.soundVolume = 0.0f;
	}
}

-(void) musicToggleCallback: (id) sender
{
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
	int index = [sender selectedIndex];
	if (index==0) {
		[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
		[GameRecordManager sharedManager].gameData.musicVolume = 1.0f;
	}else {
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
		[GameRecordManager sharedManager].gameData.musicVolume = 0.0f;
	}
}

-(void) resumeHandler:(id)sender{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"resumeEvent" object:nil];
	//删除自己
	[self removeFromParentAndCleanup:YES];
	
}

-(void) menuHandler:(id)sender{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"menuEvent" object:nil];
	[self removeFromParentAndCleanup:YES];
	
}

-(void) replayHandler:(id)sender{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"replayEvent" object:nil];
	[self removeFromParentAndCleanup:YES];
	
}

-(void) dealloc {
	
	[super dealloc];
}

@end
