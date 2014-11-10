//
//  WapsAd.cpp
//  Plane
//
//  Created by gaohuang on
//
//
#include "WapsAd.h"

WapsAd::WapsAd(){}

WapsAd::~WapsAd(){}

void WapsAd::showAd(int adTag)
{
    
    //判断当前是否为Android平台 JniMethodInfo showAd;
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    JniMethodInfo minfo;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,"org/cocos2dx/lua/AppActivity","showAdStatic", "(I)V");
    if(!isHave)
    {
        CCLog("jni:showAdStatic is null");
    }
    else
    {
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID,adTag);
    }
#endif
}