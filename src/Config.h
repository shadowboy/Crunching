//
//  Config.h.h
//  Crunching2
//
//  Created by andy on 10-12-4.
//  Copyright Augmentum 2010. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController


#endif // __GAME_CONFIG_H

//
//Game Other Configs
#define DEFAULT_GAME_FPS 18

//场景切换的速度
#define kSceneTransitionDuration			0.5
//保存成绩单的文件名
#define kHighScoresArchiveFilename			@"highScoreArchiveFileName"
//保存当前用户状态的文件名
#define kCurrentUserDataFile				@"kCurrentUserDataArchiveFileName"
//当前最高分记录
#define kCurrentHighScore					@"CurrentHighScoreKey"
//高分
#define kHighScroes							@"HighScroes"
//标签字体样式设置
#define kLabelFontName						@"Punk_s_not_dead.ttf"
#define kLabelColor							ccc3(0x33, 0x33, 0x33);
#define kLabelFontColor						ccc3(0xff,0x54,0x21);
//菜单的字体样式设置
#define kMenuFontName						@"Punk_s_not_dead.ttf"
#define kMenuFontSize						34
#define	kMenuFontColor						ccc3(0x00, 0x00, 0x00);
//结束后分数字体大小
#define kPlayOverScoreFontColor				ccc3(0xff,0x54,0x21);
#define kPlayOverScoreFontSize				48
//排行榜字体设置5c3303
#define kSLFontColor						ccc3(0x5c, 0x33, 0x03);
#define kSLNumberFontName					@"Punk_s_not_dead.ttf"
#define kSLNumberFontSize					32
#define kSLNameFontName						@"Punk_s_not_dead.ttf"
#define kSLNameFontSize						28
#define kSLScoreFontName					@"Punk_s_not_dead.ttf"
#define kSLScoreFontSize					28
//声音
#define kButtonClickSound					@"button_click.mp3"
#define kPlayingBgMusic						@"play_bg_music.mp3"
#define kPlayOverHit						@"hit.mp3"