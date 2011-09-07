//
//  Crunching2AppDelegate.h
//  Crunching2
//
//  Created by andy on 10-12-4.
//  Copyright Augmentum 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface Crunching2AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	
	
}

@property (nonatomic, retain) UIWindow *window;

@end
