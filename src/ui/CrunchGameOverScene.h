//
//  CrunchGameOver.h
//  Crunching2
//
//  Created by andy on 10-12-7.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"

@interface CrunchGameOver : CCLayer<UITextFieldDelegate> {
	CCLabelTTF	*useTimeLabel;
	CCLabelTTF	*bestTimeLB;
	CCLabelTTF	*playerLabel;
	
	UITextField *playerTextField;
	
	float currentScore;
	float highScore;
	
}

@property(nonatomic,retain) CCLabelTTF *useTimeLabel;
@property(nonatomic,retain) CCLabelTTF *bestTimeLB;
@property(nonatomic,retain) CCLabelTTF *playerLabel;
@property(nonatomic,retain) UITextField *playerTextField;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;

-(void)setUseTime:(float)useTime leastTime:(float)time;

-(void)savePlayerScore;

-(void)shareHandler;
-(void)createParticle;

@end
