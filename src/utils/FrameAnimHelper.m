//
//  FrameAnimHelper.m
//  Crunching
//
//  Created by andy on 10-12-4.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "FrameAnimHelper.h"
#import "Config.h"

@implementation FrameAnimHelper

+ (CCSpriteBatchNode *) animWithTexture:(CCTexture2D *)texture
                              numFrames:(int)numFrames
                          plistFilename:(NSString *)plistFilename
                             spriteName:(NSString *)spriteName
                              spriteTag:(int)tag
{
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithTexture:texture];
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:plistFilename texture:texture];
	
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numFrames];
    CCSpriteFrame *frame;
    CCSprite *node;
    NSString *frameName;
    for (int i = 1; i <= numFrames; i++) {
        frameName = [NSString stringWithFormat:@"%@_%01d.png", spriteName, i];
        if (i == 1) {
            node = [CCSprite spriteWithSpriteFrameName:frameName];
        }
        frame = [frameCache spriteFrameByName:frameName];
        [frames addObject:frame];
    }
	
    CCAnimation *anim = [CCAnimation animationWithFrames:frames
                                                   delay:1.0f/DEFAULT_GAME_FPS];
    node.tag = tag;
    id animateAction = [CCAnimate actionWithAnimation:anim
                                 restoreOriginalFrame:NO];
    [node runAction:[CCRepeatForever actionWithAction:animateAction]];
    [batchNode addChild:node];
    return batchNode;
}

@end