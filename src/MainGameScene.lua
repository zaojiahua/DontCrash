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
    
    --bg
    local bg = cc.Sprite:create("bg.png")
    bg:setPosition(self.size.width/2,self.size.height/2)
    layer:addChild(bg)
    
    --bg2
    local bg2 = cc.Sprite:create("bg2.png")
    bg2:setPosition(self.size.width/2,self.size.height/2)
    layer:addChild(bg2)
    
    return layer
end


return MainGameScene