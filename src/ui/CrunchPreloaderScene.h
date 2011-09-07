//
//  HelloWorldLayer.h
//  Crunching2
//
//  Created by andy on 10-12-4.
//  Copyright Augmentum 2010. All rights reserved.
//

#import "cocos2d.h"

// HelloWorld Layer
@interface CrunchPreloader : CCLayer
{
	UIActivityIndicatorView *spinner;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
