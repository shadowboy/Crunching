//
//  CrunchSelectScene.m
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//
#import "SimpleAudioEngine.h"
#import "Config.h"
#import "CrunchSelectScene.h"
#import "CrunchPlayScene.h"
#import "CrunchMenuScene.h"
#import "GameRecordManager.h"

@implementation CrunchSelect

-(id) init
{
	if( (self=[super init]) ) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		//创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(s.width/2,s.height/2);
		[self addChild:bg];
		//title
		CCSprite *title = [CCSprite spriteWithFile:@"title_select.png"];
		title.position = ccp(80,440);
		[self addChild:title];
		
		int scoreLeftPos = 260;
		//方便面
		CCMenuItemImage *fbmMenu = [CCMenuItemImage 
									itemFromNormalImage:@"select_fbm.png" 
									selectedImage:@"select_fbm_over.png" 
									target:self 
									selector:@selector(playFBMCallback:)];
		
		CCLabelTTF * fbmsl = [self getLabelOfScore:@"fbm"];
		fbmsl.position = ccp(scoreLeftPos,320);
		[self addChild:fbmsl];
		
		//薯片
		CCMenuItemImage *spMenu = [CCMenuItemImage 
								   itemFromNormalImage:@"select_sp.png" 
								   selectedImage:@"select_sp_over.png" 
								   target:self 
								   selector:@selector(playATMCallback:)];
		
		CCLabelTTF * spsl = [self getLabelOfScore:@"atm"];
		spsl.position = ccp(scoreLeftPos,220);
		[self addChild:spsl];
		
		//饼干
		CCMenuItemImage *bgMenu = [CCMenuItemImage 
								   itemFromNormalImage:@"select_bg.png" 
								   selectedImage:@"select_bg_over.png" 
								   target:self 
								   selector:@selector(playCallback:)];
		
		CCLabelTTF * bgsl = [self getLabelOfScore:@"bg"];
		bgsl.position = ccp(scoreLeftPos,120);
		[self addChild:bgsl];
		
		CCMenu *menu = [CCMenu menuWithItems:fbmMenu,spMenu,bgMenu,nil];
		menu.position = ccp(s.width/2-30,238);
		[menu alignItemsVertically];
		[self addChild:menu z:0 tag:101];
		
		[self showLockIcon:@"fbm" menu:spMenu px:scoreLeftPos-100 py:230];
		
		[self showLockIcon:@"atm" menu:bgMenu px:scoreLeftPos-100 py:130];
		
		//添加返回按钮
        CCMenuItemImage *backMenuItem = [CCMenuItemImage 
										 itemFromNormalImage:@"return_normal.png" 
										 selectedImage:@"return_over.png" 
										 target:self 
										 selector:@selector(backCallback:)];
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem,nil];
        backMenu.position = ccp(s.width-43,25);
        [self addChild:backMenu z:0 tag:10001];
		
	}
	return self;
}

-(void) backCallback :(id) sender {
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchMenu node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
	
}

-(void) playFBMCallback:(id) sender {
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	CrunchPlay *playLayer = [CrunchPlay node];
	[playLayer playWithName:@"fbm"];
	[scene addChild: playLayer];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) playATMCallback:(id) sender {
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	CrunchPlay *playLayer = [CrunchPlay node];
	[playLayer playWithName:@"atm"];
	[scene addChild: playLayer];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) playCallback:(id) sender {
	
}

//获取最好成绩的标签
-(CCLabelTTF *)getLabelOfScore:(NSString *)name {
	GameRecordManager *grm = [GameRecordManager sharedManager];
	NSString *scoreStr = [NSString stringWithFormat:@"%@'s",[grm getLeastScoreBySort:name]];
	
	CCLabelTTF *lb =[CCLabelTTF 
					 labelWithString: scoreStr
					 fontName:kLabelFontName 
					 fontSize:kMenuFontSize];
	//fbmsl.position = ccp(260,300);
	lb.color = ccc3(0xff, 0xff, 0xff);
	return lb;
}

-(void)showLockIcon:(NSString *)name menu:(CCMenuItem *)menuItem px:(int)x py:(int)y {
	GameRecordManager *grm = [GameRecordManager sharedManager];
	NSString *bestScore  = [grm getLeastScoreBySort:name];
	float bestScoreFloat = [bestScore floatValue];
	
	NSString *needScore = [grm.levelList objectForKey:name];
	float needScoreFloat = [needScore floatValue];
	if (bestScoreFloat < needScoreFloat ) {
		NSLog(@" %@ show lock false",name);
		[menuItem setIsEnabled:YES];
	}else {
		NSLog(@" %@ show lock true",name);
		CCSprite *lockImg = [CCSprite spriteWithFile:@"lock.png"];
		lockImg.position = ccp(x,y);
		[self addChild:lockImg];
		
		[menuItem setIsEnabled:NO];
	}

	
	
}

-(void) dealloc {
	[super dealloc];
}

@end
