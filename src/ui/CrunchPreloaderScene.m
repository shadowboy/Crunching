//
//  HelloWorldLayer.m
//  Crunching2
//
//  Created by andy on 10-12-4.
//  Copyright Augmentum 2010. All rights reserved.
//

// Import the interfaces

#import "Config.h"
#import "CrunchPreloaderScene.h"
#import "FrameAnimHelper.h"
#import "SimpleAudioEngine.h"
#import "CrunchMenuScene.h"

// HelloWorld implementation
@implementation CrunchPreloader

+(id) scene
{
	CCScene *scene = [CCScene node];
	CrunchPreloader *layer = [CrunchPreloader node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		CCSprite *bg = [CCSprite spriteWithFile:@"Loading_background.png"];
		
		bg.position = ccp( s.width /2 , s.height/2 );
		[self addChild:bg];
		
		//男孩
		CCTexture2D *boyTex = [[CCTextureCache sharedTextureCache] addImage:@"ez.png"];
		CCSpriteBatchNode *boy;
		boy = [FrameAnimHelper animWithTexture:boyTex
									 numFrames:11
								 plistFilename:@"ez.plist"
									spriteName:@"jxw"
									 spriteTag:1234];
		boy.position = ccp(s.width/2,s.height/2);
		[self addChild:boy];
		
		
		CCLabelTTF *label =[CCLabelTTF labelWithString:@"loading" fontName:kLabelFontName fontSize:30];
		label.position =  ccp( s.width /2 , s.height/2-200 );
		label.color = ccc3(0x00, 0x00, 0x00);
		label.tag = 1001;
		[self addChild: label];
		
		//Add the UIActivityIndicatorView (in UIKit universe)
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[spinner setCenter:CGPointMake(s.width/2,s.height/2+150)]; 
		[[[CCDirector sharedDirector] openGLView] addSubview:spinner];
		[spinner startAnimating];
		[spinner release];
		
		[self schedule: @selector(loadingInit)];
	}
	return self;
}

//加载开始
- (void) loadingInit {
	NSLog(@"loadingInit");
	[self unschedule: @selector(loadingInit)];
	
	//加载menu界面的元素
	[[CCTextureCache sharedTextureCache]addImage:@"fbm_clip_0.png"];
	[[CCTextureCache sharedTextureCache]addImage:@"fbm_clip_1.png"];
	[[CCTextureCache sharedTextureCache]addImage:@"fbm_clip_2.png"];
	[[CCTextureCache sharedTextureCache]addImage:@"fbm_clip_3.png"];
	[[CCTextureCache sharedTextureCache]addImage:[CCFileUtils fullPathFromRelativePath:@"cover_boy.png"]];
	[[CCTextureCache sharedTextureCache]addImage:@"game_title.png"];
	//加载通用显示元素
	[[CCTextureCache sharedTextureCache]addImage:@"background.png"];
	
	//加载声音
	[[SimpleAudioEngine sharedEngine] preloadEffect:kButtonClickSound];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"menu_bg_music.wav"];

	[self schedule: @selector(loadingDone) interval: 1.0f];
}

//加载完成
- (void) loadingDone {
	[self unschedule: @selector(loadingDone)];
	//现实加载完成，然后删除Label
	CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:1001];
	label.color = kMenuFontColor;
	[label setString:@"complete"];
	[self removeChild:label cleanup:YES];
	//删除浮动层
	[spinner removeFromSuperview];
	
	//切换到菜单界面
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchMenu node]];
	[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[spinner dealloc];
	[super dealloc];
}

@end
