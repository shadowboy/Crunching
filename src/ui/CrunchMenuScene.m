//
//  CrunchMenuScene.m
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//
#import <time.h>
#import <mach/mach_time.h>

#import "Config.h"
#import "CrunchMenuScene.h"
#import "CrunchExtrasScene.h"
#import "CrunchSelectScene.h"
#import "CrunchScoreListScene.h"
#import "InstantNoodlesSprite.h"
#import "SimpleAudioEngine.h"
#import "CrunchSettingScene.h"
#import "HelpTouch.h"
#import "GameRecordManager.h"
#import	"FrameAnimHelper.h"
#import "GADBannerView.h"
#import "CCFileUtils.h"


@implementation CrunchMenu

@synthesize emitter;

-(id) init
{
	if( (self=[super init]) ) {
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		//创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(s.width/2,s.height/2);
		[self addChild:bg];
		
		//男孩
		CCTexture2D *boyTex = [[CCTextureCache sharedTextureCache] addImage:[CCFileUtils fullPathFromRelativePath:@"cover_boy.png"]];
		CCSpriteBatchNode *boy;
		boy = [FrameAnimHelper animWithTexture:boyTex
									   numFrames:6
								   plistFilename:[CCFileUtils fullPathFromRelativePath:@"cover_boy.plist"]
									  spriteName:@"cover_man"
									   spriteTag:1234];
		boy.position = ccp(s.width/2,225);
		[self addChild:boy];
		
		//标题
		CCTexture2D *titleTex = [[CCTextureCache sharedTextureCache] addImage:@"game_title.png"];
		CCSpriteBatchNode *title;
		title = [FrameAnimHelper animWithTexture:titleTex
									   numFrames:4
								   plistFilename:@"game_title.plist"
									  spriteName:@"title"
									   spriteTag:1234];
		title.position = ccp(s.width/2,s.height/4*3);
		[self addChild:title];
		
		
		//构建开始菜单
		[CCMenuItemFont setFontName:kMenuFontName];
		[CCMenuItemFont setFontSize:kMenuFontSize+10];
		
		CCMenuItem *playMenuItem = [CCMenuItemImage 
									itemFromNormalImage:@"play_normal.png" 
									selectedImage:@"play_over.png" 
									target:self 
									selector:@selector(startCallback:)];
		//[CCMenuItemFont itemFromString: @"Play" target: self selector:@selector(startCallback:)];
		CCMenu *playMenu = [CCMenu menuWithItems:playMenuItem,nil];
		playMenu.position = ccp(s.width/2,180);
		[self addChild:playMenu z:1001];
		
		CCMenuItem *topMenu		=  [CCMenuItemImage 
										itemFromNormalImage:@"score_list_normal.png" 
										selectedImage:@"score_list_over.png" 
										target:self 
										selector:@selector(topCallback:)];
		
		CCMenuItem *settingsMenu = [CCMenuItemImage 
										itemFromNormalImage:@"settings_normal.png" 
										selectedImage:@"settings_over.png" 
										target:self 
										selector:@selector(settingsCallback:)];
		
		CCMenuItem *aboutMenu	=  [CCMenuItemImage 
										itemFromNormalImage:@"extras_normal.png" 
										selectedImage:@"extras_over.png" 
										target:self 
										selector:@selector(aboutCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:topMenu,settingsMenu,aboutMenu,nil];
		//menu.color = kMenuFontColor;
		[menu alignItemsHorizontallyWithPadding:30];
		menu.position = ccp(s.width/2,23);
		[self addChild:menu z:1002];
		//定时器用来播放粒子效果
		[self schedule: @selector(loop:) interval: 2.0f];
		
		//播放背景音乐
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu_bg_music.wav"];
	}
	return self;
}


- (void)onEnter {
	viewController = [[UIViewController alloc] init];
	viewController.view = [[CCDirector sharedDirector] openGLView];
	
	//CGSize s = [[CCDirector sharedDirector] winSize];
	adMobAd = [[GADBannerView alloc]
							 initWithFrame:CGRectMake(0.0,0.0,
													  GAD_SIZE_320x50.width,
													  GAD_SIZE_320x50.height)];
	adMobAd.adUnitID = @"a14b19f75680944";
	adMobAd.rootViewController = viewController;
	[viewController.view addSubview:adMobAd];
	[adMobAd loadRequest:[GADRequest request]];
	[super onEnter];
}

- (void)onExit {
	[adMobAd removeFromSuperview];
	[adMobAd release];
	[super onExit];
}


- (UIColor *)adBackgroundColor {
	return [UIColor colorWithRed:0 green:0.749 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColor {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColor {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation {
	return NO; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
}

// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *) view {
	NSLog(@"InterstitialExampleAppDelegate."
		  "adViewDidReceiveAd:");
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *) error {
	NSLog(@"InterstitialExampleAppDelegate."
		  "interstitial:didFailToReceiveAdWithError:%@",
		  [error localizedDescription]);
}


-(void) loop: (ccTime) delta {
	[self createParticle];
}

-(void) startCallback: (id) sender{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchSelect node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) topCallback: (id) sender{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchScoreList node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) settingsCallback: (id) sender{
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchSetting node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) aboutCallback: (id) sender {
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	
	//切换到菜单界面
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchExtras node]];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) createParticle {
	emitter = [[CCParticleExplosion alloc] initWithTotalParticles:30];
	[self addChild: emitter z:100];
	[emitter release];
	
	int rnd = (mach_absolute_time() & 3);
	NSString *cn = [[NSString alloc] initWithFormat:@"fbm_clip_%d.png",rnd];
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage: cn];
	
	emitter.emitterMode = kCCParticleModeGravity;
	
	// duration
	emitter.duration = 1;
	// gravity
	emitter.gravity = ccp(0,-1700);
	// angle
	emitter.angle = 90;
	emitter.angleVar = 360;
	// speed of particles
	emitter.speed = 33;
	emitter.speedVar = 500;
	// radial
	emitter.radialAccel = 0;
	emitter.radialAccelVar = 0;
	// tagential
	emitter.tangentialAccel = 0;
	emitter.tangentialAccelVar = 0;

	// life of particles
	emitter.life = 2.0f;
	emitter.lifeVar = 2.0f;
	// size, in pixels
	emitter.startSize = 12.0f;
	emitter.startSizeVar = 19.0f;
	
	emitter.endSize = 12.0f;
	emitter.endSizeVar = 19.0f;
	
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
	emitter.position = ccp(170,140);
	emitter.posVar = ccp(80,10);
	// additive
	emitter.blendAdditive = NO;
	emitter.autoRemoveOnFinish = YES;
	
	//rnd = (mach_absolute_time() & 3);
	//播放声音
	//NSString *sn = [[NSString alloc] initWithFormat:@"%@_%d.caf",@"fbm",rnd];
	//[[SimpleAudioEngine sharedEngine] playEffect:sn]; 
}

- (void) dealloc
{
	[super dealloc];
}
@end
