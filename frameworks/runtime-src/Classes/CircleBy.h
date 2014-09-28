//
//  CircleBy.h
//  Test2
//
//  Created by gaohuang on 14-9-25.
//
//

#ifndef __Test2__CircleBy__
#define __Test2__CircleBy__

#include "cocos2d.h"

USING_NS_CC;

//圆周运动
class CircleBy : public ActionInterval
{
public:
    //时间，圆心，一共需要旋转的角度
    static CircleBy * create(float tm,Point circleCenter,float numDegree);
    bool init(float tm,Point circleCenter,float degree);
    virtual void update(float);
    virtual void startWithTarget(Node *target);
    virtual CircleBy * reverse() const;
    virtual CircleBy * clone() const;
private:
    //圆心
    Point _circleCenter;
    Point _originCenter;
    //半径
    float _radius;
    //一共需要转的弧度
    float _numDegree;
    //每帧需要转过的弧度数
    float _degree;
    //起始弧度数
    float _beginDegree;
    //刷新次数
    int _times;
};

#endif /* defined(__Test2__CircleBy__) */
