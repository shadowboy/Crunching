//
//  CrunchScoreListScene.h
//  Crunching2
//
//  Created by andy on 10-12-9.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"


@interface CrunchScoreList : CCLayer{
	NSMutableArray *highScores;
}

@property (nonatomic, retain) NSMutableArray *highScores;


-(void)showScoreList:(NSString *)type;
-(void)clearScoreList;
@end
