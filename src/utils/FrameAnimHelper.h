//
//  FrameAnimHelper.h
//  Crunching
//
//  Created by andy on 10-12-4.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"

/** 简化帧动画的实现
 */
@interface FrameAnimHelper : NSObject {
	
}

+ (CCSpriteBatchNode *) animWithTexture:(CCTexture2D *)texture
                              numFrames:(int)numFrames
                          plistFilename:(NSString *)plistFilename
                             spriteName:(NSString *)spriteName
                              spriteTag:(int)tag;

@end