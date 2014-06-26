//
//  GameLayer.m
//  Cocos2dManWoman
//
//  Created by 篠原正樹 on 2014/05/07.
//  Copyright 2014年 masakishinohara. All rights reserved.
//

#import "GameLayer.h"
//#import "TitleLayer.h"

@implementation GameLayer

//@synthesize spriteArray;

+(CCScene *)scene
{
    CCScene * scene = [CCScene node];
    GameLayer * layer = [GameLayer node];
    [scene addChild:layer];
    
    return scene;
    
}

-(id) init
{
	if( (self=[super init]) ) {
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //背景レイヤー
        CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(255,255,255,255)];
        colorLayer.contentSize = CGSizeMake(screenSize.width, screenSize.height);
        colorLayer.position = ccp( 0, 0);
        [self addChild:colorLayer z:0];
        
        //タッチ可にする
        self.TouchEnabled = YES;
		
        // カウンター画像配置start//
        count = 0;
        NSString * stringCount = [NSString stringWithFormat:@"%d", count];
        countLabel = [[CCLabelTTF alloc] init];
        countLabel = [CCLabelTTF labelWithString:stringCount fontName:@"Chalkduster" fontSize:20];
        countLabel.color = ccBLACK;
        countLabel.position = CGPointMake(screenSize.width / 1.15, screenSize.height / 1.2);
        [self addChild:countLabel z:1];
        // カウンターを生成end//
        
        //line配置start//
        line = [CCSprite spriteWithFile:@"line.png"];
        [self addChild:line z:2];
        line.position = CGPointMake(screenSize.width / 2, screenSize.height / 7 );
        //line配置end//
        
        //落下画像配置--start//
        men = [[CCArray alloc] init];
        women = [[CCArray alloc] init];
        menWomen = [[CCArray alloc]init];
        
        for (int i = 0; i < 100; i++) {
            manIcon = [CCSprite spriteWithFile:@"manhip.png"];
            [manIcon setScale:2];
            [men addObject:manIcon];
            [manIcon setTag:1];
            [menWomen addObject:manIcon];
        }
        
        for (int i = 0; i < 100; i++) {
            womanIcon = [CCSprite spriteWithFile:@"womanhip.png"];
            [womanIcon setScale:2];
            [women addObject:womanIcon];
            [womanIcon setTag:2];
            [menWomen addObject:womanIcon];
        }
        
        //落下画像をシャッフル
        for (int i=0; i<[menWomen count]; i++)
        {
            int j = arc4random() % ([menWomen count]-1);
            [menWomen exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        //落下画像配置--end//
        
        //タップ画像配置--start//
        CCMenuItem *menu1 = [CCMenuItemImage itemWithNormalImage:@"manhip.png" selectedImage:nil disabledImage:nil block:^(id sender) {
            [self touchMan];
        }];
        
        CCMenuItem *menu2 = [CCMenuItemImage itemWithNormalImage:@"womanhip.png" selectedImage:nil disabledImage:nil block:^(id sender) {
            [self touchWoman];
        }];
        
        [menu1 setScale:2];
        [menu2 setScale:2];
        CCMenu *tap = [CCMenu menuWithItems:menu1,menu2,nil];
        [tap setPosition:ccp(screenSize.width /2, 100)];
        [tap alignItemsHorizontallyWithPadding:30];
        [self addChild:tap z:3];
        //タップ画像配置--end//
        
        //配列(menwomen)の要素値の初期値を設定
        IndexCount = 0;
        
        //soundをプレロード
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"wrong.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"correct.mp3"];
        
        //画像落下スピード初期値
        dmSpeed = 1.0f;
        
        //画像落下メソッド呼び出し
        [self dropImage];
        //スケジュール設定メソッド呼び出し
        //[self unscheduleAllSelectors];
        [self scheduleUpdate];//衝突判定メソッド呼び出し
        [self schedule:@selector(changeSpeed) interval:3.0f];//3秒毎に落下スピードを上げる
        
    }
    
    return self;
}


///////////////////カウントアップ処理start///////////////////
-(void)countUp{
    count = mancount + womancount;
    NSString * stringCount = [NSString stringWithFormat:@"%d", count];
    [countLabel setString:[NSString stringWithFormat:@"%@", stringCount]];
}
///////////////////カウントアップ処理end///////////////////


///////////////////タッチ処理start///////////////////
-(void)touchMan{
    if ([menWomen objectAtIndex:IndexCount]) {
        //正しい場合
        CCSprite * tempSprite;
        tempSprite = [menWomen objectAtIndex:IndexCount];
        
        if (tempSprite.tag == 1 ) {
            [self removeChildByTag:1 cleanup:NO];
            [[SimpleAudioEngine sharedEngine] playEffect:@"correct.mp3"];
            mancount++;
            [self countUp];
        }
        //間違えた場合
        else if (tempSprite.tag == 2){
            [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.mp3"];
            [self gameover];
        }
        IndexCount++;
    }
}

-(void)touchWoman{
    if ([menWomen objectAtIndex:IndexCount]) {
        //正しい場合
        CCSprite * tempSprite;
        tempSprite = [menWomen objectAtIndex:IndexCount];
        
        if (tempSprite.tag == 2 ) {
            [self removeChildByTag:2 cleanup:NO];
            [[SimpleAudioEngine sharedEngine] playEffect:@"correct.mp3"];
            womancount++;
            [self countUp];
        }
        //間違えた場合
        else if (tempSprite.tag == 1){
            [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.mp3"];
            [self gameover];
        }
        IndexCount++;
    }
}
///////////////////タッチ処理end///////////////////


///////////////////画面落下処理start///////////////////
-(void)dropImage
{
    //配列から順に画像を取得
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float delay = 0;
    for (dropImage in menWomen) {
        dropImage.position = CGPointMake(screenSize.width / 2 , screenSize.height + 100);
        [self addChild:dropImage];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCDelayTime * delayM = [CCDelayTime actionWithDuration:delay];
        delayM.tag = 10;
        
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:15 position:CGPointMake(screenSize.width /2, 60)];
        moveTo.tag = 20;
        
        CCSpeed *speed = [CCSpeed actionWithAction:[CCSequence actions: delayM, moveTo, nil] speed:dmSpeed];
        speed.tag = 30;
        [dropImage runAction:speed];
        delay += 1;
        
    }
}
///////////////////画面落下処理end///////////////////


///////////////////落下画像スピード変更処理start///////////////////
- (void)changeSpeed
{
    for (dropImage in menWomen) {
        CCSpeed *speed = (CCSpeed*)[dropImage getActionByTag:30];
        speed.speed = dmSpeed;
    }
    dmSpeed = dmSpeed + 0.2f;
}
///////////////////落下画像スピード変更処理end///////////////////


///////////////////アップロード処理start///////////////////
-(void)update:(ccTime)delta
{
    [self checkForCollision];
}
///////////////////アップロード処理start///////////////////


///////////////////衝突処理start///////////////////
-(void)checkForCollision
{
    float lineIconSize = [line texture].contentSize.width;
    float manWomanImageSize = [[menWomen lastObject] texture].contentSize.width;
    
    float lineCollisionRadius = lineIconSize * 0.1f;
    float manWomanIconCollisionRadius = manWomanImageSize * 0.4f;
    
    float maxCollisionDistance = lineCollisionRadius + manWomanIconCollisionRadius;
    
    int numMenWomen = [menWomen count];
    for (int i = 0; i < numMenWomen; i++) {
        dropImage = [menWomen objectAtIndex:i];
        if ([dropImage numberOfRunningActions] == 0)
        {
            continue;
        }
        float actualDistance = ccpDistance(line.position, dropImage.position);
        
        if (actualDistance < maxCollisionDistance) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.mp3"];
            [self gameover];
        }
    }
}

/*
-(void)checkForCollision
{
    float lineIconSize = [line texture].contentSize.width;
    float manImageSize = [[men lastObject] texture].contentSize.width;
    float womanImageSize = [[women lastObject] texture].contentSize.width;
    
    float lineCollisionRadius = lineIconSize * 0.005f;
    float manIconCollisionRadius = manImageSize * 0.4f;
    float womanIconCollisionRadius = womanImageSize * 0.4f;
    
    
    float maxCollisionDistance1 = lineCollisionRadius + manIconCollisionRadius;
    float maxCollisionDistance2 = lineCollisionRadius + womanIconCollisionRadius;
    
    int numMen = [men count];
    for (int i = 0; i < numMen; i++) {
        manIcon = [men objectAtIndex:i];
        if ([manIcon numberOfRunningActions] == 0)
        {
            continue;
        }
        float actualDistance = ccpDistance(line.position, manIcon.position);
        
        if (actualDistance < maxCollisionDistance1) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.mp3"];
            [self gameover];
        }
    }
    
    int numWomen = [women count];
    for (int i = 0; i < numWomen; i++) {
        womanIcon = [women objectAtIndex:i];
        if ([womanIcon numberOfRunningActions] == 0)
        {
            continue;
        }
        float actualDistance = ccpDistance(line.position, womanIcon.position);
        
        if (actualDistance < maxCollisionDistance2) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.mp3"];
            [self gameover];
        }
    }
}
 */
///////////////////衝突処理end///////////////////


///////////////////ゲームオーバー処理start///////////////////
-(void)gameover
{
    [self unscheduleAllSelectors];
    [self removeAllChildren];
    
    //gameover画面
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCSprite *gameover = [CCSprite spriteWithFile:@"gameover.png"];
    gameover.position = ccp(screenSize.width /2, 0);
    [self addChild:gameover z: 4];
    
    //結果表示
    CCLabelTTF *resultLabel =
    [CCLabelTTF labelWithString:[NSString stringWithFormat:@"猿：%d　豚：%d",mancount,womancount]
                                           fontName:@"Arial Rounded MT Bold"
                                           fontSize:20];
    resultLabel.color = ccc3(0, 0, 0);
    resultLabel.position =  ccp(screenSize.width /2 , screenSize.height/2 );
    [gameover addChild:resultLabel];
    
    //結果表示アクション
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(screenSize.width /2, screenSize.height/2)];
    [gameover runAction:moveTo];
    
    //menu設定
    //タイトル
    CCMenuItem *goTitle = [CCMenuItemImage itemWithNormalImage:@"title.png" selectedImage:nil disabledImage:nil block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TitleLayer scene]withColor:ccWHITE]];
    }];
    //リスタート
    CCMenuItem *reStart = [CCMenuItemImage itemWithNormalImage:@"restart.png" selectedImage:nil disabledImage:nil block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene]withColor:ccWHITE]];
    }];
    //ツイート
    CCMenuItem *tweet = [CCMenuItemImage itemWithNormalImage:@"twitter.png" selectedImage:nil disabledImage:nil target:self selector:@selector(SLComposeViewControllerButtonPressed:)];
    tweet.tag = 100;
    
    CCMenu *resultMenu = [CCMenu menuWithItems:goTitle, reStart, tweet, nil];
    [resultMenu setScale:1.0];
    [resultMenu setPosition:ccp(screenSize.width /2, 100)];
    [resultMenu alignItemsHorizontallyWithPadding:40];
    [gameover addChild:resultMenu];
    
    // Game Center　スコア送信
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"TapHip"];
    scoreReporter.value = count;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            CCLOG(@"error %@",error);
        }
    }];
}
///////////////////ゲームオーバー処理end///////////////////


///////////////////ツイッター処理start///////////////////
- (void)SLComposeViewControllerButtonPressed:(id)sender
{
    NSString *iosDevice = [[UIDevice currentDevice] systemVersion];
    if ([iosDevice intValue] >= 6.0 ){
        
        NSString* serviceType;
        CCMenuItemImage *itemSelected = (CCMenuItemImage*)sender;
        int typeIndex = itemSelected.tag;
        
        switch (typeIndex) {
            case 100:
                serviceType = SLServiceTypeTwitter;
                //CCLOG(@"twitter");
                break;
        }
        
        SLComposeViewController *composeViewController = [SLComposeViewController
                                                          composeViewControllerForServiceType:serviceType];
        //デフォルトメッセージ　ハッシュタグ付き
        [composeViewController setInitialText:[NSString stringWithFormat:@"猿：%d　豚：%d#ケツタップ", mancount,womancount]];
        // URLを追加(アプリのストアURL)
        [composeViewController addURL:[NSURL URLWithString:@"https://itunes.apple.com/"]];
        //cocos2d対応
        [[[CCDirector sharedDirector]parentViewController]  presentViewController:composeViewController animated:YES completion:nil];
        
    }
}
///////////////////ツイッター処理end///////////////////


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [super dealloc];
}

@end
