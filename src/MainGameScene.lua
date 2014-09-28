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
    self:addBg(layer)
    
    --运行游戏主逻辑
    self:mainLogic(layer)

    return layer
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
    
    --创建一个黄色小车
    local car_yello = cc.Sprite:create("car2.png")
    car_yello:setPosition(car_red:getPositionX()+car_red:getContentSize().width,self.track_size.height*0.063)
    car_yello:setTag(2)
   
    --将车添加到轨道上
    track:addChild(car_red)
    track:addChild(car_yello)
    --让小车动起来
    self:runCar(car_red)
    self:runCar(car_yello)
    
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
    
    --如果存在正在执行的动作，先停止动作的执行
    if car:getActionByTag(1) ~= nil then
        car:stopActionByTag(1)
    end
    --满足条件执行动作1
    if car:getTag() == 1 then 
        car:runAction(action_red)
    end
    
    --如果正在执行动作2，停止正在执行的动作
    if car:getActionByTag(2) ~= nil then
        car:stopActionByTag(2)
    end
    if car:getTag() == 2 then
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