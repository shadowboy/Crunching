//
//  CrunchSelectScene.h
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"

@interface CrunchSelect : CCLayer {

}

//get label score
-(CCLabelTTF *)getLabelOfScore:(NSString *)name;
//show lock icon
-(void)showLockIcon:(NSString *)name menu:(CCMenuItem *)menuItem px:(int)x py:(int)y;
@end
