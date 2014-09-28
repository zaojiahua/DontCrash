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
    
    local track_size = track:getContentSize()
    
    --创建一个小车
    local car_red = cc.Sprite:create("car.png")
    car_red:setPosition(track_size.width/2,track_size.height*0.063)
    --将车添加到轨道上
    track:addChild(car_red)
    
    local circle1 = tt.CircleBy:create(4,{x=0,y=track_size.height*0.445},180)
    local circle2 = tt.CircleBy:create(4,{x=0,y=-track_size.height*0.445},0)
    circle1:setRadians(180)
    circle2:setRadians(180)
    local action = cc.Sequence:create(
        cc.MoveBy:create(1,cc.p(-track_size.width*0.25,0)),
        cc.Spawn:create(circle1,cc.RotateBy:create(4,180)),
        cc.MoveBy:create(1,cc.p(track_size.width*0.5,0)),
        cc.Spawn:create(circle2,cc.RotateBy:create(4,180)),
        cc.MoveBy:create(1,cc.p(-track_size.width*0.5,0))
    )
    car_red:runAction(cc.RepeatForever:create(circle1))
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