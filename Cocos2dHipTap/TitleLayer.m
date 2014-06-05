//
//  TitleLayer.m
//  Cocos2dManWoman
//
//  Created by 篠原正樹 on 2014/05/07.
//  Copyright 2014年 masakishinohara. All rights reserved.
//

#import "TitleLayer.h"
//#import "InfoLayer.h"
//#import "GameLayer.h"
//#import "QuestionLayer.h"
//#import <GameKit/GameKit.h>


@implementation TitleLayer

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    TitleLayer *layer = [TitleLayer node];
    [scene addChild:layer];
    
    return scene;
}


-(id) init
{
	if( (self=[super init])) {
        
        //背景画像
		CGSize screenSize = [CCDirector sharedDirector].winSize;
        startPage = 0;
		CCSprite *backgroundImage;
        backgroundImage = [CCSprite spriteWithFile:@"background.png"];
        backgroundImage.opacity = 150;
		backgroundImage.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild: backgroundImage z:0];
        //背景画像２
        CCSprite *nextBackgroundImage;
        nextBackgroundImage = [CCSprite spriteWithFile:@"nextbackground.png"];
        nextBackgroundImage.position = ccp(screenSize.width/2, screenSize.height/2);
		[self addChild: nextBackgroundImage z:1];
        //スクロールレイヤー
        CCScrollLayer *scrollLayer = (CCScrollLayer *)[self getChildByTag:100];
        scrollLayer = [self scrollLayer];
        [self addChild:scrollLayer z:2 tag:100];
        [scrollLayer selectPage: 1];
        scrollLayer.delegate = self;
        
        [self startPage];
        
	}
	
	return self;
}

//////////////////////スクロールレイヤー設定start///////////////////////////
-(NSArray *)scrollLayerPages
{
    CGSize   screenSize = [CCDirector sharedDirector].winSize;
    
    /////gamestartpageレイヤーstart/////
	CCLayer *gameStartPage = [CCLayer node];
	CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"HIPTAP"
                                            fontName:@"Helvetica-BoldOblique"
                                            fontSize:25];
    titleLabel.color = ccc3(0, 0, 0);//黒
	titleLabel.position =  ccp(screenSize.width / 2, screenSize.height / 2);
	[gameStartPage addChild:titleLabel];
    
    
    //メニュー設定
    CCMenuItem *soundOn = [CCMenuItemImage itemWithNormalImage:@"soundon.png" selectedImage:@"soundon.png" disabledImage:nil block:^(id sender) {
        [self setSoundOn];
    }];
    
    CCMenuItem *soundOff = [CCMenuItemImage itemWithNormalImage:@"soundoff.png" selectedImage:@"soundoff.png" disabledImage:nil block:^(id sender) {
        [self setSoundOff];
    }];
    
    CCMenuItem *question = [CCMenuItemImage itemWithNormalImage:@"question.png" selectedImage:nil disabledImage:nil block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[QuestionLayer scene]withColor:ccWHITE]];
    }];
    
    CCMenuItem *gamecenter = [CCMenuItemImage itemWithNormalImage:@"gamecenter.png" selectedImage:nil disabledImage:nil block:^(id sender) {
        [self GoToRanking];
    }];
    
    CCMenu *Menu = [CCMenu menuWithItems:soundOn,soundOff, question, gamecenter, nil];
    [Menu setScale:1.0];
    [Menu setPosition:ccp(screenSize.width /3,  Menu.contentSize.height -50 )];
    [Menu alignItemsHorizontallyWithPadding:15];
    [gameStartPage addChild:Menu];
    
    //インフォ設定
    CCMenuItem *info = [CCMenuItemImage itemWithNormalImage:@"info.png" selectedImage:nil disabledImage:nil block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[InfoLayer scene]withColor:ccWHITE]];
    }];
    
    CCMenu *infoMenu = [CCMenu menuWithItems:info, nil];
    [infoMenu setScale:1.0];
    [infoMenu setPosition:ccp(screenSize.width /1.1,  Menu.contentSize.height -50 )];
    [gameStartPage addChild:infoMenu];
    
    //ゲームスタートボタン設定
    [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
    [CCMenuItemFont setFontSize:20];
    CCMenuItemFont * gameStartItem = [CCMenuItemFont itemWithString:@"GAMESTART" block:^(id sender){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene]withColor:ccWHITE]];
	}];
    gameStartItem.color = ccc3(0, 0, 0);
    CGSize winSize = [[CCDirector sharedDirector] winSize];
	CCMenu *gameStartMenu = [CCMenu menuWithItems:gameStartItem, nil];
	gameStartMenu.position = CGPointMake(winSize.width / 2, 60);
	[gameStartPage addChild:gameStartMenu];
    /////gamestartpageレイヤーend/////

    /* 保留
    //ランキングレイヤー
	CCLayer *rankingPage = [CCLayer node];
	CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Ranking"
                                            fontName:@"Arial Rounded MT Bold"
                                            fontSize:25];
	label1.color = ccc3(0, 0, 0);//黒
    label1.position =  ccp(size.width /2 , size.height/1.2 );
	[rankingPage addChild:label1];
    
    //達成率レイヤー
    CCLayer *achievementsPage = [CCLayer node];
	CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Achievements"
                                            fontName:@"Arial Rounded MT Bold"
                                            fontSize:25];
    
	label2.color = ccc3(0, 0, 0);//黒
    label2.position =  ccp(size.width /2 , size.height/1.2 );
	[achievementsPage addChild:label2];
     */
    
    /////キャラクターレイヤーstart/////
    CCLayer *characterPage = [CCLayer node];
	CCLabelTTF *characterLabel = [CCLabelTTF labelWithString:@"CHARACTER"
                                            fontName:@"Helvetica-BoldOblique"
                                            fontSize:25];
	characterLabel.color = ccc3(0, 0, 0);//黒
    characterLabel.position =  ccp(screenSize.width /2 , screenSize.height/1.2);
	[characterPage addChild:characterLabel];
    //男ヒップ画像配置
    CCSprite *manCharacter = [CCSprite spriteWithFile:@"manhip.png"];
	manCharacter.position = CGPointMake(self.contentSize.width / 3, self.contentSize.height / 2);
    manCharacter.scale = 2;
    [characterPage addChild:manCharacter];
    //女ヒップ画像配置
    CCSprite *womanCharacter = [CCSprite spriteWithFile:@"womanhip.png"];
	womanCharacter.position = CGPointMake(self.contentSize.width / 1.5, self.contentSize.height / 2);
    womanCharacter.scale = 2;
    [characterPage addChild:womanCharacter];
    /////キャラクターレイヤーend/////
    
    return [NSArray arrayWithObjects:gameStartPage, characterPage, nil];
}
//////////////////////スクロールレイヤー設定end///////////////////////////


//////////////////////スクロール処理start///////////////////////////
-(CCScrollLayer *) scrollLayer
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    //ガイドを表示
	// Create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages).
	CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0.05f * screenSize.width ];
	scroller.pagesIndicatorPosition = ccp(screenSize.width * 0.5f, 130.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
    scroller.marginOffset = 0.5f * screenSize.width;
	
	return scroller;
    
}

-(void) startPage
{
	CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:100];
	[scroller moveToPage: startPage];
}
//////////////////////スクロール処理end///////////////////////////


//////////////////////サウンド設定start///////////////////////////
-(void)setSoundOn{
    // This will unmute <span id="IL_AD1" class="IL_AD">the sound</span>
    [[SimpleAudioEngine sharedEngine] setMute:0];
}

-(void)setSoundOff{
    //This will mute the sound
    [[SimpleAudioEngine sharedEngine] setMute:1];
}
//////////////////////サウンド設定end///////////////////////////


//////////////////////ゲームセンターstart///////////////////////////
//リーダーボードを立ち上げる
- (void)GoToRanking {
    GKLeaderboardViewController *leaderboardController =
    [[GKLeaderboardViewController alloc] init];
    
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        [[CCDirector sharedDirector]
         presentModalViewController:leaderboardController animated:YES];
    }
}
//リーダーボードで完了を押した時に呼ばれる
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [[CCDirector sharedDirector] dismissModalViewControllerAnimated:YES];
}
//////////////////////ゲームセンターend///////////////////////////


-(void) onEnter
{
    [super onEnter];
    
}


@end
