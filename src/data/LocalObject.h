//
//  LocalObject.h
//  Crunching
//
//  Created by andy on 10-5-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPlayer				@"playerKey"
#define kLevel				@"levelKey"

#define kSoundVolume		@"soundVolumeKey"
#define kMusicVolume		@"musicVolumeKey"


#define kScoreList			@"scoreListKey"
#define kPlayCount			@"playTimes"
#define kClickCount			@"clickTimes"
#define kStep				@"step"

@interface LocalObject : NSObject <NSCoding, NSCopying> {
	NSString	*player;
	NSString	*level;
	
	float soundVolume;
	float musicVolume;
	
	//分数列表
	NSMutableDictionary *scoreList;
	//一共玩的次数
	int playTimes;
	
	//点击次数
	int clickTimes;
	//游戏阶段
	int step;
}

@property (nonatomic, retain) NSString *player;
@property (nonatomic, retain) NSString *level;

@property (nonatomic, readwrite) float	soundVolume;
@property (nonatomic, readwrite) float	musicVolume;

@property (nonatomic, retain) NSMutableDictionary *scoreList;

@property (nonatomic, readwrite) int playTimes;
@property (nonatomic, readwrite) int clickTimes;
@property (nonatomic, readwrite) int step;
-(NSMutableArray *)getEmptyList;
@end
