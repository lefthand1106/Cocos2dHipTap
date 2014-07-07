//
//  GameLayer.h
//  Cocos2dManWoman
//
//  Created by 篠原正樹 on 2014/05/07.
//  Copyright 2014年 masakishinohara. All rights reserved.
//
//ゲーム機能処理クラス

//#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <Social/Social.h>
#import "TitleLayer.h"

@interface GameLayer : CCLayer {
    
    int mancount;               //男尻タップ回数保持
    int womancount;             //女尻タップ回数保持
    int count;                  //男女タップ回数保持
    int IndexCount;             //配列(menwomen)の要素値を保持
    CCSprite * line;            //衝突先画像
    CCSprite * manIcon;         //落下画像
    CCSprite * womanIcon;       //落下画像
    CCArray * men;              //落下画像(manIcon)格納配列
    CCArray * women;            //落下画像(womanIcon)格納配列
    CCArray * menWomen;         //落下画像(men,women)格納配列
    CCSprite * dropImage;       //落下処理画像、落下スピード処理画像、衝突処理画像
    CCLabelTTF* countLabel;     //カウンター用ラベル
    float dmSpeed;              //落下画像スピード設定変数
}

//@property (nonatomic, retain)NSMutableArray *spriteArray;   //

+(CCScene *)scene;

@end
