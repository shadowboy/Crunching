//
//  CrunchGameOver.m
//  Crunching2
//
//  Created by andy on 10-12-7.
//  Copyright 2010 Augmentum. All rights reserved.
//
#import "SimpleAudioEngine.h"

#import "Config.h"
#import "CrunchGameOverScene.h"
#import "CrunchMenuScene.h"
#import "CrunchPlayScene.h"
#import "CrunchScoreListScene.h"
#import "LocalObject.h"
#import "GameRecordManager.h"
//#import "SHKItem.h"
//#import "SHKActionSheet.h"
//#import "SHKTwitter.h"
//#import "SHKMail.h"
//#import "SHKFacebook.h"

@implementation CrunchGameOver

@synthesize useTimeLabel;
@synthesize bestTimeLB;
@synthesize playerLabel;
@synthesize playerTextField;

-(id)init {
	if (self==[super init]) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(winSize.width/2,winSize.height/2);
		[self addChild:bg];
		
		CCSprite *complete = [CCSprite spriteWithFile:@"complete.png"];
		complete.position = ccp(winSize.width/2,412);
		[self addChild:complete];
		
		int sx = 37;
		//用了多久
		useTimeLabel =[CCLabelTTF labelWithString:@" Time: 0.00's " fontName:kLabelFontName fontSize:kPlayOverScoreFontSize];
		useTimeLabel.position = ccp(sx+90,337);
		useTimeLabel.color = kPlayOverScoreFontColor;
		[self addChild:useTimeLabel];
		//动画出现
		useTimeLabel.scale = 2;
		id actionTo = [CCScaleTo actionWithDuration: 0.6 scale:1];
		id readyEase = [CCEaseExponentialIn actionWithAction:actionTo];
		[useTimeLabel runAction:readyEase];
		[self schedule: @selector(showScoreMotionComplete) interval: 0.5];
		
		
		//最好成绩
		bestTimeLB =[CCLabelTTF labelWithString:@" Best: 0.00's " fontName:kLabelFontName fontSize:kPlayOverScoreFontSize-8];
		bestTimeLB.position = ccp(sx+80,281);
		bestTimeLB.color = ccc3(0x00, 0x00, 0x00);
		[self addChild:bestTimeLB];
		
		//用户名
		playerLabel =[CCLabelTTF labelWithString:@" Your name: " fontName:kLabelFontName fontSize:36];
		playerLabel.position = ccp(86+60,228);
		playerLabel.color = ccc3(0x00, 0x00, 0x00);
		[self addChild:playerLabel];
		
		//创建玩家名字输入框
		playerTextField = [[UITextField alloc] initWithFrame: CGRectMake(210, 245, 100, 28)];
		playerTextField.backgroundColor = [UIColor clearColor];
		playerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		playerTextField.borderStyle = UITextBorderStyleNone;
		playerTextField.delegate = self; // set this layer as the UITextFieldDelegate
		playerTextField.returnKeyType = UIReturnKeyDone; // add the 'done' key to the keyboard
		playerTextField.autocorrectionType = UITextAutocorrectionTypeNo; // switch of auto correction
		playerTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		playerTextField.text = [GameRecordManager sharedManager].gameData.player;
		
		//创建分享按钮
		[CCMenuItemFont setFontName:kMenuFontName];
		[CCMenuItemFont setFontSize:22];
		CCMenuItem *share = [CCMenuItemFont 
								itemFromString: @" Share: " 
								target: self 
								selector:@selector(shareHandler:)];
		CCMenuItem *shareByMail = [CCMenuItemImage 
									 itemFromNormalImage:@"email_32.png" 
									 selectedImage:@"email_32.png" 
									 target:self 
									 selector:@selector(shareByMailHandler:)];
		CCMenuItem *shareByTwitter = [CCMenuItemImage 
								   itemFromNormalImage:@"twitter_32.png" 
								   selectedImage:@"twitter_32.png" 
								   target:self 
								   selector:@selector(shareByTwitterHandler:)];
		CCMenuItem *shareByFacebook = [CCMenuItemImage 
									  itemFromNormalImage:@"facebook_32.png" 
									  selectedImage:@"facebook_32.png" 
									  target:self 
									  selector:@selector(shareByFacebookHandler:)];
		
		CCMenu *shareMenu = [CCMenu menuWithItems:share,shareByMail,shareByTwitter,shareByFacebook,nil];
		shareMenu.position = ccp(winSize.width/2,180);
		[shareMenu alignItemsHorizontallyWithPadding:15];
		[self addChild:shareMenu];
		
		//创建返回菜单
		[CCMenuItemFont setFontName:kMenuFontName];
		[CCMenuItemFont setFontSize:42];
		CCMenuItem *retry = [CCMenuItemFont itemFromString: @" Retry " 
											target: self 
											selector:@selector(retryCallback:)];
		CCMenuItem *backToMenu = [CCMenuItemFont itemFromString: @" OK " 
											target: self 
											selector:@selector(backToMenuCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:retry,backToMenu,nil];
		//menu.color = kMenuFontColor;
		menu.position = ccp(winSize.width/2,100);
		[menu alignItemsVerticallyWithPadding:15];
		[self addChild:menu];
		
		//结束画面现实完毕，调用函数来现实输入框
		[self schedule: @selector(sceneShowComplete) interval: kSceneTransitionDuration];
	}
	return self;
}

//场景现实完毕后再出现玩家姓名的输入框
-(void)sceneShowComplete {
	[self unschedule:@selector(sceneShowComplete)];
	// add the textField to the main game openGLVview
	[[[CCDirector sharedDirector] openGLView] addSubview: playerTextField];
}

-(void)showScoreMotionComplete{
	[self unschedule:@selector(showScoreMotionComplete)];
	[[SimpleAudioEngine sharedEngine] playEffect:kPlayOverHit];
}

//设置使用的最小时间和本次使用时间
-(void)setUseTime:(float)useTime leastTime:(float)time{
	GameRecordManager *grm = [GameRecordManager sharedManager];
	currentScore = useTime;
	NSString *ut = [[NSString alloc] initWithFormat:@" Time: %.2f's ",useTime];
	[useTimeLabel setString:ut];
	[ut release];
	
	
	NSString *hs = [grm getLeastScoreBySort:grm.playing];
	NSString *lt = [[NSString alloc] initWithFormat:@" Best: %@'s ",hs];
	[bestTimeLB setString:lt];
	[lt release];
	
	if (useTime < [hs floatValue]) {
		//分数会闪烁
		id fade = [CCFadeOut actionWithDuration:0.5f];
		id fade_in = [fade reverse];
		id seq = [CCSequence actions:fade, fade_in, nil];
		id repeat = [CCRepeatForever actionWithAction:seq];
		useTimeLabel.color = ccc3(0xff,0x00,0x00);
		[useTimeLabel runAction:repeat];
		
		//TODO:增加喜悦的声音
		//增加粒子
		[self createParticle];
	}
}

-(void) shareHandler:(id) sender {
}

-(void) shareByMailHandler:(id) sender {
	//NSString *text = [NSString stringWithFormat:@"I scored %.2f in Crunching", currentScore];
	//NSString *title = [NSString stringWithFormat:@"How high score I scored in Crunching"];
	//SHKItem *item = [SHKItem text:text title:title];
	//[SHKMail shareItem:item];
	
}
-(void) shareByTwitterHandler:(id) sender {
	//NSString *text = [NSString stringWithFormat:@"I scored %.2f in Crunching", currentScore];
	//NSString *title = [NSString stringWithFormat:@"How high score I scored in Crunching"];
	//SHKItem *item = [SHKItem text:text title:title];
	//[SHKTwitter shareItem:item];
}
-(void) shareByFacebookHandler:(id) sender {
	//NSString *text = [NSString stringWithFormat:@"I scored %.2f in Crunching", currentScore];
	//NSString *title = [NSString stringWithFormat:@"How high score I scored in Crunching"];
	//SHKItem *item = [SHKItem text:text title:title];
	//[SHKFacebook shareItem:item];
}

-(void)retryCallback:(id) sender {
	[self savePlayerScore];
	
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	[playerTextField removeFromSuperview];
	
	CCScene * scene = [CCScene node];
	CrunchPlay *playLayer = [CrunchPlay node];
	
	NSString *foodName = [GameRecordManager sharedManager].playing;
	[playLayer playWithName:foodName];
	
	[scene addChild: playLayer];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void)backToMenuCallback:(id) sender {
	[self savePlayerScore];
	[[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
	[playerTextField removeFromSuperview];
	
	CCScene * scene = [CCScene node];
	[scene addChild: [CrunchScoreList node]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

//保存分数
-(void)savePlayerScore {
	NSString *playerName = playerTextField.text;
	if (playerName == nil || [playerName isEqualToString:@""]) {
		playerName = @"Noname";
	}
	
	NSString *foodName = [GameRecordManager sharedManager].playing;
	[GameRecordManager sharedManager].gameData.player = playerName;
	[[GameRecordManager sharedManager] setScoreToList:foodName user:playerName score:currentScore];
}	

//关闭输入键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//NSLog(@"textFieldShouldReturn");
	[textField resignFirstResponder];
	return YES;
}

//限制名字输入只能有10个字符构成
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 10)
        return NO; // return NO to not change text
    return YES;
}

-(void) dealloc {
	[playerTextField release];
	[super dealloc];
}

-(void) createParticle {
	CCParticleExplosion *emitter = [[CCParticleExplosion alloc] initWithTotalParticles:100];
	[self addChild: emitter z:100];
	[emitter release];
	
	int rnd = (mach_absolute_time() & 3);
	NSString *cn = [[NSString alloc] initWithFormat:@"fbm_clip_%d.png",rnd];
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage: cn];
	
	emitter.emitterMode = kCCParticleModeGravity;
	
	// duration
	emitter.duration = -1;
	// gravity
	emitter.gravity = ccp(0,-1700);
	// angle
	emitter.angle = 90;
	emitter.angleVar = 360;
	// speed of particles
	emitter.speed = 59;
	emitter.speedVar = 0;
	// radial
	emitter.radialAccel = 0;
	emitter.radialAccelVar = 0;
	// tagential
	emitter.tangentialAccel = 0;
	emitter.tangentialAccelVar = 0;
	
	// life of particles
	emitter.life = 2.0f;
	emitter.lifeVar = 4.2f;
	// size, in pixels
	emitter.startSize = 20.0f;
	emitter.startSizeVar = 5.0f;
	
	emitter.endSize = 3.0f;
	emitter.endSizeVar = 0.0f;
	
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
	emitter.position = ccp(160,430);
	emitter.posVar = ccp(320,40);
	// additive
	emitter.blendAdditive = NO;
	emitter.autoRemoveOnFinish = YES;
	
	//rnd = (mach_absolute_time() & 3);
	//播放声音
	//NSString *sn = [[NSString alloc] initWithFormat:@"%@_%d.caf",@"fbm",rnd];
	//[[SimpleAudioEngine sharedEngine] playEffect:sn]; 
}

@end
