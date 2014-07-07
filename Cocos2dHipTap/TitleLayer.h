//
//  TitleLayer.h
//  Cocos2dManWoman
//
//  Created by 篠原正樹 on 2014/05/07.
//  Copyright 2014年 masakishinohara. All rights reserved.
//
//アプリ起動直後のタイトルページ処理クラス

//#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
//#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import "QuestionLayer.h"
#import "InfoLayer.h"


@interface TitleLayer : CCLayer<CCScrollLayerDelegate, GKGameCenterControllerDelegate>{//gamecenter
 
    int startPage;//スクロール用
    CCMenuItem * soundon;
    CCMenuItem * soundoff;
    CCMenuItemToggle *toggleItem;
    int soundEffect;
}

+(CCScene *) scene;


@end
