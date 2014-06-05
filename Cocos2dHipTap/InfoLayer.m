//
//  InfoLayer.m
//  Cocos2dMW
//
//  Created by 篠原正樹 on 2014/05/29.
//  Copyright 2014年 masakishinohara. All rights reserved.
//

#import "InfoLayer.h"
//#import "TitleLayer.h"

@implementation InfoLayer

+(CCScene *)scene
{
    CCScene * scene = [CCScene node];
    InfoLayer * layer = [InfoLayer node];
    [scene addChild:layer];
    
    return scene;
    
}

-(id) init
{
	if( (self=[super init]) ) {
        self.TouchEnabled = YES;
        CGSize   screenSize = [CCDirector sharedDirector].winSize;
     	
        //背景画像
        CCSprite *backgroundImage;
        backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        backgroundImage.opacity = 150;
		backgroundImage.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild: backgroundImage];
        //背景画像２
        CCSprite *nextBackgroundImage;
        nextBackgroundImage = [CCSprite spriteWithFile:@"nextbackground.png"];
        nextBackgroundImage.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild: nextBackgroundImage];
        //クレジット設定
        CCSprite*	credits = [CCSprite spriteWithFile:@"credits.png"];
		credits.position = CGPointMake(screenSize.width /2, screenSize.height);
		[self addChild:credits];
        CCJumpTo* jumpTo = [CCJumpTo actionWithDuration:3 position:CGPointMake(screenSize.width/2, screenSize.height/3) height:60 jumps:3];
        [credits runAction:jumpTo];
        //提供元設定
        CCSprite*	presentedBy = [CCSprite spriteWithFile:@"lefthandmakerco.png"];
		presentedBy.position = CGPointMake(screenSize.width /2, screenSize.height +100);
		[self addChild:presentedBy];
        CCDelayTime * delayM = [CCDelayTime actionWithDuration:5];
        CCJumpTo* jumpTo2 = [CCJumpTo actionWithDuration:3 position:CGPointMake(screenSize.width/2, screenSize.height/3 + credits.contentSize.height + 10) height:60 jumps:3];
        [presentedBy runAction:[CCSequence actions:delayM,jumpTo2, nil]];
        
    }
    return self;
}
//タッチアクション設定
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene]withColor:ccWHITE]];
}



@end


