//
//  QuestionLayer.m
//  Cocos2dMW
//
//  Created by 篠原正樹 on 2014/05/30.
//  Copyright 2014年 masakishinohara. All rights reserved.
//

#import "QuestionLayer.h"

@implementation QuestionLayer


+(CCScene *)scene
{
    CCScene * scene = [CCScene node];
    QuestionLayer * layer = [QuestionLayer node];
    [scene addChild:layer];
    
    return scene;
    
}

-(id) init
{
	if( (self=[super init]) ) {
        self.TouchEnabled = YES;
        CGSize   screenSize = [CCDirector sharedDirector].winSize;
      
        //背景設定
        CCSprite *backgroundImage;
        backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        backgroundImage.opacity = 150;
		backgroundImage.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild: backgroundImage];
        
        CCSprite *nextBackgroundImage;
        nextBackgroundImage = [CCSprite spriteWithFile:@"nextbackground.png"];
        nextBackgroundImage.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild: nextBackgroundImage];
        
        //遊び方説明
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"遊び方"
                                                fontName:@"Helvetica-BoldOblique"
                                                fontSize:25];
        titleLabel.color = ccc3(0, 0, 0);//黒
        titleLabel.position =  ccp(screenSize.width /2 , screenSize.height/1.3 );
        [self addChild:titleLabel];
        
        CCLabelTTF *howToPlayLabel = [CCLabelTTF labelWithString:
                              @"猿のケツと豚のケツが落ちてくる順番通りに\n\nボタンを押していこう。\n\n落ちるスピードはどんどん速くなるよ。\n\n間違って押したらゲームオーバだよ。"
                                                fontName:@"Helvetica-BoldOblique"
                                                fontSize:15];
        howToPlayLabel.color = ccc3(0, 0, 0);//黒
        howToPlayLabel.position =  ccp(screenSize.width /2 , screenSize.height/2 );
        [self addChild:howToPlayLabel];
    }
 
    return self;

}

//タッチアクション設定
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene]withColor:ccWHITE]];
}

@end
