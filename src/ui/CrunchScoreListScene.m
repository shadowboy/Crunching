//
//  CrunchScoreListScene.m
//  Crunching2
//
//  Created by andy on 10-12-9.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "Config.h"
#import "CrunchScoreListScene.h"
#import "CrunchMenuScene.h"
#import <mach/mach_time.h>
#import "SimpleAudioEngine.h"
#import "GameRecordManager.h"

@implementation CrunchScoreList

@synthesize highScores;

-(id)init {
	if (self==[super init]) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //创建背景
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		bg.position = ccp(winSize.width/2,winSize.height/2);
		[self addChild:bg];
        
		//绘制背景
		CCSprite *frame = [CCSprite spriteWithFile:@"Scores_background.png"];
		frame.position = ccp(winSize.width/2,winSize.height/2);
		[self addChild:frame];
        
		//现实默认类别成绩单
        [self showScoreList:@"fbm"];
        //现实切换成绩单按钮
        [CCMenuItemFont setFontName:kMenuFontName];
		[CCMenuItemFont setFontSize:kMenuFontSize];
		CCMenuItem *fbm = [CCMenuItemFont itemFromString: @" #1 " 
                                          target: self 
                                          selector:@selector(fbmCallback:)];
		CCMenuItem *atm = [CCMenuItemFont itemFromString: @" #2 " 
                                          target: self 
                                          selector:@selector(atmCallback:)];
        CCMenuItem *sp = [CCMenuItemFont itemFromString: @" #3 " 
                                          target: self 
                                          selector:@selector(spCallback:)];
		
		CCMenu *menu = [CCMenu menuWithItems:fbm,atm,sp,nil];
        menu.anchorPoint = ccp(0,0);
		menu.color = ccc3(0xff,0xff,0xff);
		menu.position = ccp(280,350);
		[menu alignItemsVertically];
		[self addChild:menu];
        
        //添加返回按钮
        CCMenuItemImage *backMenuItem = [CCMenuItemImage 
										 itemFromNormalImage:@"return_normal.png" 
										 selectedImage:@"return_over.png" 
										 target:self 
										 selector:@selector(backCallback:)];
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem,nil];
        backMenu.position = ccp(winSize.width-43,25);
        [self addChild:backMenu z:0 tag:10001];
	}
	return self;
}

-(void)fbmCallback:(id) sender {
    [self clearScoreList];
    [self showScoreList:@"fbm"];
}

-(void)atmCallback:(id) sender {
    [self clearScoreList];
    [self showScoreList:@"atm"];
}

-(void)spCallback:(id) sender {
    [self clearScoreList];
    [self showScoreList:@"bg"];
}

-(void)showScoreList:(NSString *)type{
    GameRecordManager *grm = [GameRecordManager sharedManager];
    //绘制列表
    highScores = [grm getScoreListByName:type];
    
    float sy = 350;
    float step = 30;
    int count = 0;
    for(NSMutableArray *hightScore in highScores){
        NSString *player = [hightScore objectAtIndex:0];
        float score = [[hightScore objectAtIndex:1] floatValue];
        //排名
        int c = count+1;
        NSString *num;
        if (c<10) {
            num = [NSString stringWithFormat:@" 0%d. ",c];
        }else {
            num = [NSString stringWithFormat:@" %d. ",c];
        }
        CCLabelTTF *lb1 = [CCLabelTTF 
                           labelWithString:num
                           fontName:kSLNumberFontName 
                           fontSize:kSLNumberFontSize
                           ];
        lb1.anchorPoint = ccp(0,0);
        lb1.color = kSLFontColor;
        lb1.position =ccp(28,sy-count*step);
        lb1.tag = 100+count;
        [self addChild:lb1];
        
        //玩家
        NSString *pName = [NSString stringWithFormat:@"  %@ ",player ];
        CCLabelTTF *lb2 = [CCLabelTTF 
                           labelWithString:pName 
                           fontName:kSLNameFontName 
                           fontSize:kSLNameFontSize
                           ];
        lb2.anchorPoint = ccp(0,0);
        lb2.color = kSLFontColor;
        lb2.position =ccp(55,sy-count*step);
        lb2.tag = 200+count;
        [self addChild:lb2];
        
        //分数
        CCLabelTTF *lb3 = [CCLabelTTF 
                           labelWithString:[NSString stringWithFormat:@" %.2f 's ",score] 
                           fontName:kSLScoreFontName 
                           fontSize:kSLScoreFontSize
                           ];
        lb3.anchorPoint = ccp(0,0);
        lb3.color = kSLFontColor;
        lb3.position =ccp(175,sy-count*step);
        lb3.tag = 300+count;
        [self addChild:lb3];
        
        count ++;
        if(count == 10) break;
    }
}

-(void)clearScoreList{
    int count = 0;
    for(NSMutableArray *hightScore in highScores){
        [self removeChildByTag:100+count cleanup:YES];
        [self removeChildByTag:200+count cleanup:YES];
        [self removeChildByTag:300+count cleanup:YES];
        count ++;
        if(count == 10) break;
    }
}

//返回
-(void) backCallback :(id) sender {
    [[SimpleAudioEngine sharedEngine] playEffect:kButtonClickSound];
    
	CCScene *scene = [CCScene node];
	CrunchMenu *layer = [CrunchMenu node];
	[scene addChild: layer];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:kSceneTransitionDuration scene:scene]];
}

-(void) dealloc {
	[super dealloc];
}

@end
