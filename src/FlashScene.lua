--使用require引入模块
require("Cocos2d")
require("Cocos2dConstants")

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
    layer:addChild(logo)
    
    --logo执行一个淡入淡出的动作
    logo:setOpacity(0)
    local action = cc.Sequence:create(cc.FadeIn:create(2),cc.CallFunc:create(action_callback)) 
    logo:runAction(action)
     
    --游戏标题
    local title = cc.Sprite:create("title.png")
    title:setPosition(self.size.width+title:getContentSize().width/2,self.size.height*0.88) 
    layer:addChild(title)
    
    --title执行动作
    --moveto的第二个参数是一个table，里边的成员是命名参数，必须指定参数的名字为x和y，许多的函数调用都需要这么做
    local title_action = cc.Sequence:create(cc.MoveTo:create(0.5,{x=self.size.width/2-100,y=title:getPositionY()}),                               
         cc.Spawn:create(cc.MoveBy:create(0.1,{x=200,y=0}),cc.SkewTo:create(0.1,0,-45)),
         cc.Spawn:create(cc.MoveBy:create(0.2,{x=-150,y=0}),cc.SkewTo:create(0.2,0,45)),
         cc.Spawn:create(cc.MoveBy:create(0.2,{x=50,y=0}),cc.SkewTo:create(0.2,0,0))
         )           
    title:runAction(title_action)     
    
    return layer
end

--返回FlashScene这个模块
return FlashScene