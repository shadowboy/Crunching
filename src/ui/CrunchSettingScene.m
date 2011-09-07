//
//  CrunchSettingScene.m
//  Crunching2
//
//  Created by andy on 10-12-14.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "Config.h"
#import "SimpleAudioEngine.h"
#import "CrunchSettingScene.h"
#import "CrunchMenuScene.h"
#import "LocalObject.h"
#import "GameRecordManager.h"

//设置面板
@implementation CrunchSetting

-(id)init {
	if (self==[super init]) {
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		//创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(s.width/2,s.height/2);
		[self addChild:bg];
        
		//绘制背景
		CCSprite *frame = [CCSprite spriteWithFile:@"Options_frame.png"];
		frame.position = ccp(s.width/2,s.height/2);
		[self addChild:frame];
		
		
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
		
		//重置
        CCMenuItem *resetMenu = [CCMenuItemFont 
								 itemFromString: @"Reset scores" 
								 target: self selector:@selector(resetHightScoreHandler:)];
		CCMenuItem *resetPlayTimesMenu = [CCMenuItemFont 
								 itemFromString: @"Reset play times" 
								 target: self selector:@selector(resetPlayTimesHandler:)];
		
		CCMenu *menu = [CCMenu menuWithItems:
						title1, title2,
						item1, item2,
						resetMenu,
						resetPlayTimesMenu,
						nil]; // 9 items.
		menu.color = kMenuFontColor;
		[menu alignItemsVerticallyWithPadding:20];
		[menu alignItemsInColumns:
			[NSNumber numberWithUnsignedInt:2],
			[NSNumber numberWithUnsignedInt:2],
			[NSNumber numberWithUnsignedInt:1],
			[NSNumber numberWithUnsignedInt:1],
			nil
		];
		menu.position = ccp(130,240);
		[self addChild: menu];
		
		//添加返回按钮
        CCMenuItemImage *backMenuItem = [CCMenuItemImage 
                                     itemFromNormalImage:@"return_normal.png" 
                                     selectedImage:@"return_over.png" 
                                     target:self 
                                     selector:@selector(backCallback:)];
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem,nil];
        backMenu.position = ccp(s.width-43,25);
        [self addChild:backMenu z:0 tag:10001];
		
		//总点击次数
		NSString *pts = [NSString stringWithFormat:@"play times: %d",[GameRecordManager sharedManager].gameData.playTimes];
		CCLabelTTF *playTimesLB =[CCLabelTTF labelWithString:pts fontName:kLabelFontName fontSize:20];
		playTimesLB.anchorPoint = ccp(0,0);
		playTimesLB.position = ccp(70,90);
		playTimesLB.color = ccc3(0x00, 0x00, 0x00);
		[self addChild:playTimesLB];
		//总点击次数
		NSString *cts = [NSString stringWithFormat:@"Click times: %d",[GameRecordManager sharedManager].gameData.clickTimes];
		CCLabelTTF *clickTimesLB =[CCLabelTTF labelWithString:cts fontName:kLabelFontName fontSize:20];
		clickTimesLB.anchorPoint = ccp(0,0);
		clickTimesLB.position = ccp(70,70);
		clickTimesLB.color = ccc3(0x00, 0x00, 0x00);
		[self addChild:clickTimesLB];
		
		
	}
	return self;
}

//保存
-(void) resetHightScoreHandler:(id) sender {
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Reset Scores"];
	[dialog setMessage:@"Do you want to reset your scores?"];
	[dialog addButtonWithTitle:@"NO"];
	[dialog addButtonWithTitle:@"YES"];
	[dialog show];
	[dialog release];
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([alert.title isEqualToString:@"Reset Scores"]) {
		if(buttonIndex==0) {
			NSLog(@"reset scores you choose no button");
		}else {
			NSLog(@"reset scores you choose yes button");
			[[GameRecordManager sharedManager] resetGameData];
		}
	}else if ([alert.title isEqualToString:@"Reset Play Times"]) {
		if(buttonIndex ==0){
			NSLog(@"Reset play times you choose no button");
		}else {
			NSLog(@"Reset play times you choose yes button");
			[GameRecordManager sharedManager].gameData.playTimes = 0;
		}

	}
	

}

//保存
-(void) resetPlayTimesHandler:(id) sender {
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Reset Play Times"];
	[dialog setMessage:@"Do you want to reset your play times?"];
	[dialog addButtonWithTitle:@"NO"];
	[dialog addButtonWithTitle:@"YES"];
	[dialog show];
	[dialog release];
	
}



-(void) soundToggleCallback: (id) sender
{
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
	int index = [sender selectedIndex];
	if (index==0) {
		[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:1];
		[GameRecordManager sharedManager].gameData.soundVolume = 1;
	}else {
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0];
		[GameRecordManager sharedManager].gameData.soundVolume = 0;
	}
	NSLog(@"sound volume:%f",[GameRecordManager sharedManager].gameData.soundVolume);
}

-(void) musicToggleCallback: (id) sender
{
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
	int index = [sender selectedIndex];
	if (index == 0) {
		[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
		[GameRecordManager sharedManager].gameData.musicVolume = 1;
	}else {
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
		[GameRecordManager sharedManager].gameData.musicVolume = 0;
	}
	NSLog(@"sound volume:%f",[GameRecordManager sharedManager].gameData.musicVolume);
}

-(void) backCallback: (id) sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchMenu node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

@end


