//
//  TitleLayer.h
//  Cocos2dManWoman
//
//  Created by 篠原正樹 on 2014/05/07.
//  Copyright 2014年 masakishinohara. All rights reserved.
//
//アプリ起動直後のタイトルページ処理クラス

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import "QuestionLayer.h"
#import "InfoLayer.h"


@interface TitleLayer : CCLayer<CCScrollLayerDelegate, GKLeaderboardViewControllerDelegate>{
 
    int startPage;//スクロール用
   
}

+(CCScene *) scene;


@end
