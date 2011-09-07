//
//  GameRecordManager.m
//  Crunching2
//
//  Created by andy on 10-12-25.
//  Copyright 2010 Augmentum. All rights reserved.
//
#import "Config.h"
#import "GameRecordManager.h"
#import "LocalObject.h";

@implementation GameRecordManager

@synthesize gameData;
@synthesize levelList;
@synthesize playing;
@synthesize player;
@synthesize clickTimes;

static  GameRecordManager  * grMgr  =  nil;

+  (GameRecordManager  * ) sharedManager{
	@synchronized(self){
		if  (grMgr  ==  nil){
			[[self alloc] init];
		}
	}
	return  grMgr;
}

+  (id)allocWithZone:(NSZone  * )zone{
	@synchronized(self){
		if (grMgr  ==  nil){
			grMgr  =  [super allocWithZone:zone];
			return  grMgr;
		}
	}
	return  nil;
}

-(id)init {
	
	if( (self=[super init]) ) {
		//读取本地数据
		NSLog(@"load game local data!");
		self.gameData = [self getGameDataFormLocal];
		//设置解锁分数
		self.levelList = [NSMutableDictionary dictionary];
		[self.levelList setObject:@"4.5" forKey:@"fbm"];
		[self.levelList setObject:@"4" forKey:@"atm"];
		[self.levelList setObject:@"3.5" forKey:@"bg"];
		//NSLog(@"level list :%@",self.levelList);
	}
	return self;
}

//保存数据到本地文件
-(void) saveGameDataToLocal {
	gameData.musicVolume = 1;
	gameData.soundVolume = 1;
	
	NSLog(@"save game data to local!");
	NSLog(@"The soundVolume:%.2f",gameData.soundVolume);
	NSLog(@"The musicVolume:%.2f",gameData.musicVolume);
	NSLog(@"The player:%@",gameData.player);
	NSLog(@"The playTimes:%d",gameData.playTimes);
	
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self.gameData forKey:kCurrentUserDataFile];
	[archiver finishEncoding];
	[data writeToFile:[self getFilePath:kCurrentUserDataFile] atomically:YES];
	[archiver release];
	[data release];
}

//读取游戏数据从本地文件
-(LocalObject *) getGameDataFormLocal {
	NSString *filePath = [self getFilePath:kCurrentUserDataFile];
	//NSLog(@"fild path = %@",filePath);
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
		//NSLog(@"NSData %@",data);
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		LocalObject *lo = [unarchiver decodeObjectForKey:kCurrentUserDataFile];
		[unarchiver finishDecoding];
		return lo;
	}else{
		return [[LocalObject alloc] init];
	}
}

/**
 排序把用时最少的放在上面
 2011-04-17
 */
static int sortByScore(id p1, id p2, void *context){
	NSString *ss1 = [(NSMutableArray *)p1 objectAtIndex:1];
	NSString *ss2 = [(NSMutableArray *)p2 objectAtIndex:1];
	return [ss1 floatValue]>[ss2 floatValue];
}

/**
 保存用户成绩
 name 是游戏类型或分类
 user 是游戏用户
 score 是游戏分数
 2011-04-17
 */
-(void)setScoreToList:(NSString *)name user:(NSString *)theUser score:(float)theScore {
	//创建一条分数记录
	NSString *scoreString = [NSString stringWithFormat:@"%.2f", theScore];
	NSMutableArray *item = [NSMutableArray arrayWithObjects:theUser,scoreString,nil];

	//如果此分类的分数列表不存在，就创建一个列表并添加到里面去
	NSMutableArray *itemList = [gameData.scoreList objectForKey:name];
	
	//看看对应的列表里是否有同样的成绩了
	BOOL isExit = NO;
	for(NSMutableArray *sitem in itemList) {
		NSString *ut = [NSString stringWithFormat:@"%@", [sitem objectAtIndex:0]];
		NSString *us = [NSString stringWithFormat:@"%@", [sitem objectAtIndex:1]];
		if ([ut isEqualToString:theUser] && [us isEqualToString:scoreString]) {
			isExit = YES;
			break;
		}
    }
	
	//如果没有同样的用户同样的成绩，添加到对应列表中
	if (isExit == NO) {
		[itemList addObject:item];
	}
	
	//数组排序
	[itemList sortUsingFunction:sortByScore context:@"test"];
	NSLog(@"score list :%@",gameData.scoreList);
}

/**
 获取对应游戏的排行
 2011-04-17
 */
-(NSMutableArray *)getScoreListByName:(NSString *)name {
	return [self.gameData.scoreList objectForKey:name];
}

/**
 获取某个游戏的最小分数
 2011-04-17
 */
-(NSString *)getLeastScoreBySort:(NSString *)name {
	NSMutableArray *list = [self getScoreListByName:name];
	NSLog(@"getLeastScoreBySort score list :%@",list);
	NSMutableArray *item = (NSMutableArray *)[list objectAtIndex:0];
	if (item == nil) {
		return @"0";
	}
	NSString *topScoreStr = [item objectAtIndex:1];
	return topScoreStr;
}

//获取本地存储路径
-(NSString *)getFilePath:(NSString *)kName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:kName];
}

-(void)resetScoreList:(NSString *)type {
	self.gameData.scoreList = [NSMutableDictionary dictionary];
}


-(void)resetGameData {
	self.gameData = [[LocalObject alloc] init];
}


@end
