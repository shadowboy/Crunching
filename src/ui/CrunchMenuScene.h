//
//  CrunchMenuScene.h
//  Crunching2
//
//  Created by andy on 10-12-5.
//  Copyright 2010 Augmentum. All rights reserved.
//

#import "cocos2d.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"
#import "GADBannerView.h"

@interface CrunchMenu : CCLayer <GADBannerViewDelegate>{
	CCParticleSystem *emitter;
	// Declare one as an instance variable
	GADBannerView *adMobAd;
	NSTimer *refreshTimer; // timer to get fresh ads
	UIViewController *viewController;
	
}


@property(readwrite,retain) CCParticleSystem *emitter;

-(void) createParticle;

@end
