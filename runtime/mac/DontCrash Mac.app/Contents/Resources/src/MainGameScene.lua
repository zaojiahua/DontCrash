require("Cocos2d")
require("Cocos2dConstants")

local MainGameScene = class("MainGameScene",function()
    return cc.Scene:create()
end
)

function MainGameScene:ctor()
    self.size = cc.Director:getInstance():getWinSize()
end

function MainGameScene:create()
    --new函数的作用是调用了构造函数ctor，然后将表FlashScene的所有元素复制到了一张新的表中，最后返回这张表
    local mainGame = MainGameScene:new()
    local layer = mainGame:createLayer()
    mainGame:addChild(layer)

    return mainGame
end

function MainGameScene:createLayer()
    local layer = cc.Layer:create()

    --添加背景图片
--    self:addBg(layer)
    
    --实现与用户的交互
    self:userInteraction(layer)
    
    --运行游戏主逻辑
    self:mainLogic(layer)

    return layer
end

--用户交互
function MainGameScene:userInteraction(layer)

    --触摸处理函数
    local function onTouchBegan()
        self:switchTrace(self.car_red)
        return false
    end
    
    --纪录小车是否变轨的变量
    self.red_switch = true
    self.yello_switch = true

    --注册触摸
    local touch_listener = cc.EventListenerTouchOneByOne:create()
    touch_listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(touch_listener,layer)
end

--小车变道
function MainGameScene:switchTrace(car)

    --停止动作的执行
    car:stopAllActions()
    
    --变轨
    local circleCenter1,circleCenter2,point1,point2 = self:isSwitch(car)

    --根据速率计算小车需要运动的时间
    local rate = 1
    local tm1 = 2*math.pi*circleCenter1/rate
    local tm2 = (point2.x-point1.x)/rate
    local degree = 180

    --[创建动作--]

    --创建第一个动作
    local circle1 = tt.CircleBy:create(tm1,{x=0,y=circleCenter1},degree)
    local circle2 = tt.CircleBy:create(tm1,{x=0,y=circleCenter2},degree)
    local action1 = cc.Sequence:create(
        cc.MoveTo:create(tm2,point1),
        cc.Spawn:create(circle1,cc.RotateBy:create(tm1,degree)),
        cc.MoveTo:create(tm2,point2), 
        cc.Spawn:create(circle2,cc.RotateBy:create(tm1,degree))
    )
    local action_red = cc.RepeatForever:create(action1)
    action_red:setTag(1)

    --创建第二个动作
    local action2 = cc.Sequence:create(
        cc.MoveTo:create(tm2,{x=point2.x,y=point1.y}),
        cc.Spawn:create(circle1:reverse(),cc.RotateBy:create(tm1,-180)),
        cc.MoveTo:create(tm2,{x=point1.x,y=point2.y}),
        cc.Spawn:create(circle2:reverse(),cc.RotateBy:create(tm1,-180)) 
    )
    local action_yello = cc.RepeatForever:create(action2)
    action_yello:setTag(2)

    --[[执行动作--]]

    --红色小车
    if car:getTag() == 1 or car:getTag() == 3 then 
        car:runAction(action_red)
    end

    --黄色小车
    if car:getTag() == 2 then
        car:runAction(action_yello)
    end
end

function MainGameScene:isSwitch(car)
    --[[ 以下的代码用来决定是否变轨--]]

    --初始化运动过程中需要的成员变量 代表外圈的轨道
    local circleCenter1 = self.track_size.height*0.445
    local circleCenter2 = -circleCenter1
    local point1 = cc.p(self.track_size.width*0.245,self.car_bottomy)
    local point2 = cc.p(self.track_size.width*0.745,self.car_topy)

    --每一辆车都有一个变量来控制他们是否变轨
    local switch = true
    if car:getTag() == 1 then
        switch = self.red_switch
        self.red_switch = not switch
    else
        switch = self.yello_switch
        self.yello_switch = not switch
    end

    --决定是否变轨
    if switch then
        --代表里圈的轨道
        circleCenter1 = self.track_size.height*0.335
        circleCenter2 = -circleCenter1
        point1 = cc.p(self.track_size.width*0.245,self.track_size.height*0.171) 
        point2 = cc.p(self.track_size.width*0.745,self.track_size.height*0.844) 
    end
    
    return circleCenter1,circleCenter2,point1,point2
end

function MainGameScene:setParam(car,circleCenter1,circleCenter2,point1,point2)
    
    --[[ 以下的代码用来计算执行动作的各个参数--]]
    
    --根据速率计算小车需要运动的时间
    local rate = 1
    local tm = 4
    local degree = 180

    
    
    return tm,degree
end

--主逻辑
function MainGameScene:mainLogic(layer)
    --添加主逻辑的背景图片，也就是小车运行的轨道
    local track = cc.Sprite:create("track.png")
    track:setPosition(self.size.width/2,self.size.height/2)
    layer:addChild(track)
    
    --轨道长宽
    self.track_size = track:getContentSize()
    
    --创建一个红色小车
    local car_red = cc.Sprite:create("car.png")
    car_red:setPosition(self.track_size.width*0.45,self.track_size.height*0.063)
    car_red:setTag(1)
    self.car_bottomy = car_red:getPositionY()
    self.car_topy = self.track_size.height*0.95
    self.car_red = car_red
    
    --创建一个黄色小车
    local car_yello = cc.Sprite:create("car2.png")
    car_yello:setRotation(180)
    car_yello:setPosition(car_red:getPositionX()+car_red:getContentSize().width,self.track_size.height*0.063)
    car_yello:setTag(3)
    self.car_yello = car_yello
   
    --将车添加到轨道上
    track:addChild(car_red)
    track:addChild(car_yello)
    
    --让小车动起来
    self:switchTrace(car_red)
    self:switchTrace(car_yello)
end

--小车运动起来
function MainGameScene:runCar(car)
    --小车运动的时间
    local tm = 1
    
    --创建第一个动作
    local circle1 = tt.CircleBy:create(tm,{x=0,y=self.track_size.height*0.445},180)
    local circle2 = tt.CircleBy:create(tm,{x=0,y=-self.track_size.height*0.445},180)
    local action1 = cc.Sequence:create(
        cc.MoveTo:create(tm,cc.p(self.track_size.width*0.245,self.car_bottomy)),
        cc.Spawn:create(circle1,cc.RotateBy:create(tm,180)),
        cc.MoveTo:create(tm,cc.p(self.track_size.width*0.745,self.car_topy)),
        cc.Spawn:create(circle2,cc.RotateBy:create(tm,180))
    )
    local action_red = cc.RepeatForever:create(action1)
    action_red:setTag(1)
    
    --创建第二个动作
    local action2 = cc.Sequence:create(
        cc.MoveTo:create(tm,cc.p(self.track_size.width*0.745,self.car_bottomy)),
        cc.Spawn:create(circle1:reverse(),cc.RotateBy:create(tm,-180)),
        cc.MoveTo:create(tm,cc.p(self.track_size.width*0.245,self.car_topy)),
        cc.Spawn:create(circle2:reverse(),cc.RotateBy:create(tm,-180)) 
    )
    local action_yello = cc.RepeatForever:create(action2)
    action_yello:setTag(2)
    
    --满足条件执行动作1
    if car:getTag() == 1 or car:getTag() == 3 then 
        --如果存在正在执行的动作，先停止动作的执行
        if car:getActionByTag(1) ~= nil then
            car:stopActionByTag(1)
        end
        car:runAction(action_red)
    end
    
    if car:getTag() == 2 then
        --如果正在执行动作2，停止正在执行的动作
        if car:getActionByTag(2) ~= nil then
            car:stopActionByTag(2)
        end
        car:runAction(action_yello)
    end
end

--添加背景图片
function MainGameScene:addBg(layer)
    --bg
    local bg = cc.Sprite:create("bg.png")
    bg:setPosition(self.size.width/2,self.size.height/2)
    layer:addChild(bg)

    --bg2
    local bg2 = cc.Sprite:create("bg2.png")
    bg2:setPosition(self.size.width/2,self.size.height/2)
    layer:addChild(bg2)
end

return MainGameScene