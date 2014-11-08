--使用require引入模块
require("Cocos2d")
require("Cocos2dConstants")
require("SoundDeal")

--创建一个类，继承自scene
local FlashScene = class("FlashScene",function()
    return cc.Scene:create()
end
)

--类似c++中的构造函数
function FlashScene:ctor()
    --self代表的就是FlashScene，将size作为它的成员，添加到这张表中
    self.size = cc.Director:getInstance():getWinSize()
end

--create留下给外部调用的接口
function FlashScene:create()
    --new函数的作用是调用了构造函数ctor，然后将表FlashScene的所有元素复制到了一张新的表中，最后返回这张表
    local flashScene = FlashScene:new()
    local layer = flashScene:createLayer()
    flashScene:addChild(layer)
    
    --加载音效
    SoundDeal:preloadEffect()
    --播放背景声音
    SoundDeal:playBg()
    
    return flashScene
end

--创建一个层，在层上加入元素
function FlashScene:createLayer()
    local layer = cc.Layer:create()
    
    --动作的回调函数
    local action_callback = function()
        cc.Director:getInstance():replaceScene(require("MainGameScene"):create())
    end
    
    --使用Cocos提供的模块cc，调用Sprite的方法创建一个logo出来，你在Cocos2d-x看到的内容，都可以从这个模块中获得（前提是有导出）
    local logo = cc.Sprite:create("logo.png")
    logo:setPosition(self.size.width/2,self.size.height/2)
    logo:setScale(0.1)
    layer:addChild(logo)
    
    --title执行动作
    local title_callback = function()
        local title = {}
        local jumpBy = cc.JumpBy:create(1.5,cc.p(0,0),self.size.height*0.1,5)
        local move = cc.MoveBy:create(1.5,cc.p(-self.size.width*0.8,0))
        local title_action = cc.Spawn:create(jumpBy,move) 

        for i,v in pairs({"奔","跑","吧","新","娘"}) do
            title[i] = cc.Label:createWithBMFont("fonts/1.fnt",v)
            title[i]:setPosition(self.size.width+self.size.width*0.1*i,self.size.height*0.5)
            layer:addChild(title[i])
        end
        
        local index = 1
        local index_callback
        index_callback = function()
            index = index+1
            if index ~= table.getn(title) then
                title[index]:runAction(cc.Sequence:create(title_action,cc.CallFunc:create(index_callback)))
            else
                title[index]:runAction(cc.Sequence:create(title_action,cc.DelayTime:create(1),cc.CallFunc:create(action_callback)))
            end
        end
        title[index]:runAction(cc.Sequence:create(title_action,cc.CallFunc:create(index_callback)))
    end
    
    --logo执行一个淡入淡出的动作
    local scale = cc.EaseElasticOut:create(cc.ScaleTo:create(2,1.5))
    local action = cc.Sequence:create(scale,cc.FadeOut:create(1),cc.CallFunc:create(title_callback))
    logo:runAction(action)
    
    --particle
    local particleSystemQuad = cc.ParticleSystemQuad:create("particle/vanishingPoint.plist")
    particleSystemQuad:setAnchorPoint(cc.p(0.5,0.5))
    particleSystemQuad:setPosition(cc.p(self.size.width/2,self.size.height/2))
    layer:addChild(particleSystemQuad)
     
    return layer
end

--返回FlashScene这个模块
return FlashScene