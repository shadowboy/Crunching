//
//  CrunchAboutScene.m
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "Config.h"
#import "SimpleAudioEngine.h"
#import "CrunchExtrasScene.h"
#import "CrunchMenuScene.h"
#import "CrunchPauseLayer.h"
#import "CrunchSelectScene.h"

@implementation CrunchExtras

-(id) init
{
	if( (self=[super init]) ) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		//创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(s.width/2,s.height/2);
		[self addChild:bg];
		
		//创建边框
		CCSprite *frame = [CCSprite spriteWithFile:@"About_frame.png"];
		frame.position = ccp(s.width/2,s.height/2);
		[self addChild:frame];
		
		
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

- (void) dealloc
{
	[super dealloc];
}

@end
