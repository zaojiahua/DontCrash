//
//  CircleBy.cpp
//  Test2
//
//  Created by gaohuang on 14-9-25.
//
//

#include "CircleBy.h"

CircleBy * CircleBy::create(float tm,Point circleCenter,float randiansValue)
{
    CircleBy * _circle = new CircleBy();
    _circle->init(tm,circleCenter,randiansValue);
    _circle->autorelease();
    
    return _circle;
}

bool CircleBy::init(float tm,Point circleCenter,float numDegree)
{
    //动作执行时间
    if(initWithDuration(tm))
    {
        //圆心
        _originCenter = circleCenter;
        //半径
        _radius = sqrt(pow(_originCenter.x,2)+pow(_originCenter.y,2));
        //总共需要转过的弧度数
        _numDegree = -numDegree/360*2*M_PI;
        //每帧需要转过的弧度
        _degree = (Director::getInstance()->getAnimationInterval())*_numDegree/tm;
        //刷新次数
        _times = 1;
        //计算起始弧度数
        _beginDegree = M_PI+atan2f(_originCenter.y,_originCenter.x);
        
        return true;
    }
    
    return false;
}

void CircleBy::startWithTarget(Node * target)
{
    ActionInterval::startWithTarget(target);
    
    if(_times == 1 && (int)_numDegree%360 == 0)
        _circleCenter = _originCenter+target->getPosition();
    else
        _circleCenter = _originCenter+target->getPosition();
    _times = 1;
}

//动作管理器调用update函数，每帧刷新坐标
void CircleBy::update(float)
{
    //弧度数
    auto degree = _degree*_times+_beginDegree;
    auto x = _radius*cos(degree);
    auto y = _radius*sin(degree);
    
    _target->setPosition(Point(x+_circleCenter.x,y+_circleCenter.y));
    
    _times++;
    
    /*以下的代码将做圆周运动的轨迹绘制了出来，必要的时候可以删除掉*/
    auto draw = DrawNode::create();
    _target->getParent()->addChild(draw);
    draw->drawDot(_target->getPosition(),1,Color4F(1,1,1,1));
}

CircleBy* CircleBy::reverse() const
{
    return CircleBy::create(_duration,_originCenter,_numDegree*360/(2*M_PI));
}

CircleBy* CircleBy::clone() const
{
	CircleBy * _circle = new CircleBy();
    _circle->init(_duration,_originCenter,-_numDegree*360/(2*M_PI));
    _circle->autorelease();
    return _circle;
}
