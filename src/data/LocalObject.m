//
//  LocalObject.m
//  Crunching
//
//  Created by andy on 10-5-29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocalObject.h"

@implementation LocalObject

@synthesize player;
@synthesize level;

@synthesize	soundVolume;
@synthesize	musicVolume;


@synthesize scoreList;

@synthesize playTimes;
@synthesize clickTimes;
@synthesize step;

-(id)init{
	if (self==[super init]) {
		NSLog(@"init LocalData");
		self.player = @"Noname";
		self.level = 0;
		self.scoreList = [NSMutableDictionary dictionary];
		self.soundVolume = 1.0f;
		self.musicVolume = 1.0f;
		self.playTimes = 0;
		self.clickTimes = 0;
		self.step = 0;
		
		[self.scoreList setObject:[self getEmptyList] forKey:@"fbm"];
		[self.scoreList setObject:[self getEmptyList] forKey:@"atm"];
		[self.scoreList setObject:[self getEmptyList] forKey:@"bg"];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
	if (self==[super init]) {
		self.player = [decoder decodeObjectForKey:kPlayer];
		self.level = [decoder decodeObjectForKey:kLevel];
		self.scoreList = [decoder decodeObjectForKey:kScoreList];
		self.soundVolume = [decoder decodeFloatForKey:kSoundVolume];
		self.musicVolume = [decoder decodeFloatForKey:kMusicVolume];
		self.playTimes = [decoder decodeIntForKey:kPlayCount];
		self.clickTimes = [decoder decodeIntForKey:kClickCount];
		self.step = [decoder decodeIntForKey:kStep];
	}
	return self;
}

-(NSMutableArray *)getEmptyList {
	NSMutableArray *list = [NSMutableArray array];
	for (float i=0; i<=10; i++) {
		NSString *score = [NSString stringWithFormat:@"%.2f", (i+1)*5];
		NSMutableArray *item = [NSMutableArray arrayWithObjects:@"Crunching",score,nil];
		[list addObject:item];
	}
	return list;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:player forKey:kPlayer];
	[encoder encodeObject:level forKey:kLevel];
	[encoder encodeObject:scoreList forKey:kScoreList];
	[encoder encodeFloat:soundVolume forKey:kSoundVolume];
	[encoder encodeFloat:musicVolume forKey:kMusicVolume];
	[encoder encodeInt:playTimes forKey:kPlayCount];
	[encoder encodeInt:clickTimes forKey:kClickCount];
	[encoder encodeInt:step forKey:kStep];
}

-(id)copyWithZone:(NSZone *)zone {
	LocalObject *copy = [[[self class] allocWithZone:zone]init];
	copy.player = [[self.player copyWithZone:zone] autorelease];
	copy.level = [[self.level copyWithZone:zone] autorelease];
	copy.soundVolume = self.soundVolume;
	copy.musicVolume = self.musicVolume;
	copy.scoreList = self.scoreList;
	copy.playTimes = self.playTimes;
	copy.clickTimes = self.clickTimes;
	copy.step = self.step;
	return copy;
}
@end
