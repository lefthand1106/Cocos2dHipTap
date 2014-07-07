//
//  IntroLayer.m
//  Cocos2dHipTap
//
//  Created by 篠原正樹 on 2014/06/03.
//  Copyright masakishinohara 2014年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "TitleLayer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
    
}

-(id) init
{
	if( (self=[super init]))
    {
    
    }
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
 
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene] ]];
}
@end
