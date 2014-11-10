//
//  WeixinShare.h
//  ColorBlind
//
//  Created by gaohuang on 14-10-30.
//
//

#ifndef __ColorBlind__WeixinShare__
#define __ColorBlind__WeixinShare__

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "platform/android/jni/JniHelper.h"
#include <jni.h>

#endif

#include "Cocos2d.h"
USING_NS_CC;

class CC_DLL WeixinShare
{
public:
    static void sendToFriend();
    static void sendToTimeLine();
};

#endif /* defined(__DontCrash__WeixinShare__) */
