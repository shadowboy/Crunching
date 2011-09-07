//
//  GameRecordManager.h
//  Crunching2
//
//  Created by andy on 10-12-25.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"
#import "LocalObject.h"

@interface GameRecordManager : NSObject {
	LocalObject *gameData;
	NSMutableDictionary *levelList;
	NSString *playing;
	NSString *player;
	int clickTimes;
}

+  (GameRecordManager  * ) sharedManager;
+  (id)allocWithZone:(NSZone  * )zone;

@property(nonatomic,retain) LocalObject *gameData;
@property(nonatomic,retain) NSMutableDictionary *levelList;
@property(nonatomic,retain) NSString *playing;
@property(nonatomic,retain) NSString *player;

@property(nonatomic,readwrite) int clickTimes;

//存储某个项目的一条成绩
-(void)setScoreToList:(NSString *)food user:(NSString *)theUser score:(float)theScore;
//获取某个项目的成绩列表
-(NSMutableArray *)getScoreListByName:(NSString *)name;
// 获取某个游戏的最小分数
-(NSString *) getLeastScoreBySort:(NSString *)name;
//获取持久存储路径
-(NSString *)getFilePath:(NSString *)kName;

-(void) saveGameDataToLocal;
//获取本地数据
-(LocalObject *)getGameDataFormLocal;

//重置游戏排行榜
-(void)resetScoreList:(NSString *)type;

//重置所有游戏数据
-(void) resetGameData;

@end
