require("Cocos2d")
require("Cocos2dConstants")
require("SoundDeal")
require("GlobalData")

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
    
    --实现与用户的交互
    self:userInteraction(layer)
    
    --ui
    self:setUI(layer)
    
    --加入广告
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        cc.WapsAd:showAd(14)
    end
      
    return layer
end

--设置UI，比如分数
function MainGameScene:setUI(layer)
    self.score = cc.Label:createWithBMFont("fonts/number.fnt","0")
    self.score:setPosition(cc.p(self.size.width/2,self.size.height/2))
    layer:addChild(self.score)
end

--碰撞检测
function MainGameScene:collision(layer)
    --是否播放yes的声音
    local isYes = false
    
    local collistion_update = function()
        --获得俩辆小车的位置，宽度
        local red_x,red_y = self.car_red:getPosition()
        local yello_x,yello_y = self.car_yello:getPosition()
        local red_width = self.car_red:getContentSize().width
        local yello_width = self.car_yello:getContentSize().width
        --碰撞检测的条件
        if self.red_switch == self.yello_switch and math.abs(red_x-yello_x)<(red_width+yello_width)/2 then
            --停止小车运动，停止游戏
            self.car_red:stopAllActions()
            self.car_yello:stopAllActions()
            self.play = false
            --播放声音
            SoundDeal:playEffect(EffectType.Crash)
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_update)
            self:gameOver(layer)
        --没有发生碰撞检测俩车错过去，记录一下
        elseif self.red_switch ~= self.yello_switch and math.abs(red_x-yello_x)<(red_width+yello_width)/2 then
            --满足播放yes的条件
            isYes = true    
        --在俩车相错的这段时间如果任然没有发生碰撞检测则真的是错过去了
        elseif math.abs(red_x-yello_x)>(red_width+yello_width)/2 and isYes then
            isYes = false
            --设置全局的分数数据
            GlobalData:setScore()
            --改变UI
            self.score:setString(GlobalData.score)
            self.score:setScale(0.1)
            self.score:runAction(cc.EaseElasticOut:create(cc.ScaleTo:create(0.2,1)))
        end
    end
    --每帧都进行碰撞检测
    self.schedule_update = cc.Director:getInstance():getScheduler():scheduleScriptFunc(collistion_update,0,false)
end

--游戏介绍以后的处理
function MainGameScene:gameOver(layer)
    --清除数据
    GlobalData:reset()
    self.score:setString("0")
    --重新设置小车的位置
    self:resetCar()
    
    --添加分享和更多菜单项
    self:addButton(layer)
end

function MainGameScene:addButton(layer)
    local share = cc.MenuItemImage:create("share.png","","")
    share:setScale(0.8)
    local more = cc.MenuItemImage:create("more.png","","")
    more:setScale(0.8)
    local retry = cc.MenuItemImage:create("retry.png","","")
    retry:setScale(0.8)
    local menu = cc.Menu:create(share,retry,more)
    menu:alignItemsHorizontallyWithPadding(self.size.width*0.1)
    menu:setPosition(cc.p(self.size.width/2,self.size.height/2))
    layer:addChild(menu,3)

    --callback
    local retry_callback = function()
        --播放音效
        SoundDeal:playEffect(EffectType.Start)
        retry:runAction(cc.Sequence:create(cc.ScaleTo:create(0.05,1.3),
            cc.CallFunc:create(function()menu:removeFromParentAndCleanup(true) end)))
        self:runRedCar(self.car_red)
        self:runYelloCar(self.car_yello)
        self.play = true
        self:collision(layer)
    end
    local share_callback = function()
        share:runAction(cc.Sequence:create(cc.ScaleTo:create(0.05,1.3),cc.ScaleTo:create(0.05,0.8)))
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
            cc.WeixinShare:sendToTimeLine()
        end
    end
    local more_callback = function()
        --加入插屏广告
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
            cc.WapsAd:showAd(1)
        end
        more:runAction(cc.Sequence:create(cc.ScaleTo:create(0.05,1.3),cc.ScaleTo:create(0.05,0.8)))
    end
    retry:registerScriptTapHandler(retry_callback)
    share:registerScriptTapHandler(share_callback)
    more:registerScriptTapHandler(more_callback)
    --判断游戏是否开始的变量
    self.play = false
end

--用户交互
function MainGameScene:userInteraction(layer)

    --触摸处理函数
    local function onTouchBegan()
        if self.play then
            --播放音效
            SoundDeal:playEffect(EffectType.Tap)
            self:switchTrace(self.car_red)
            return false
        end
    end

    --注册触摸
    local touch_listener = cc.EventListenerTouchOneByOne:create()
    touch_listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(touch_listener,layer)
    
    --监听手机返回键
    local key_listener = cc.EventListenerKeyboard:create()

    --返回键回调
    local function key_return(keyCode)
        --结束游戏
        if keyCode == cc.KeyCode.KEY_BACK or keyCode == cc.KeyCode.KEY_BACKSPACE then
            cc.Director:getInstance():endToLua()
        end
    end
    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    key_listener:registerScriptHandler(key_return,cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatch = layer:getEventDispatcher()
    eventDispatch:addEventListenerWithSceneGraphPriority(key_listener,layer)
end

--小车变道
function MainGameScene:switchTrace(car)
    --变轨
    local circleCenter1,circleCenter2,point1,point2 = self:isSwitch(car)

    --设置运动参数
    local tm1,tm2,tm3,tm4,degree1,degree2 = self:setParam(car,circleCenter1,point1,point2)

    --执行最后的动作
    self:switch(car,tm1,tm2,tm3,tm4,degree1,degree2,circleCenter1,circleCenter2,point1,point2)
end

--根据是否变轨，返回不同的运动参数
function MainGameScene:isSwitch(car)
    --[[ 以下的代码用来决定是否变轨--]]

    --初始化运动过程中需要的成员变量 代表外圈的轨道
    local circleCenter1 = self.track_size.height*0.445
    local circleCenter2 = -circleCenter1
    local point1 = cc.p(self.track_size.width*0.245,self.car_bottomy)
    local point2 = cc.p(self.track_size.width*0.745,self.car_topy)

    --改变变轨的变量
    local switch = true
    if car:getTag() == 1 then
        switch = self.red_switch
        self.red_switch = not switch
    end

    --决定是否变轨
    if switch == false then
        --代表里圈的轨道
        circleCenter1 = self.track_size.height*0.335
        circleCenter2 = -circleCenter1
        point1 = cc.p(self.track_size.width*0.245,self.track_size.height*0.171) 
        point2 = cc.p(self.track_size.width*0.745,self.track_size.height*0.844) 
    end

    --因为小车使用的里外圈轨道是不一样的，所以需要重新设置小车的位置和一些运动参数
    if car:getTag() == 1 then
        --根据小车所处的位置不同，来决定如何位置已经相关参数
        local x = car:getPositionX()
        --左圆周运动
        if x < self.track_size.width*0.245 then
            --首先需要计算圆周运动已经转过的弧度数，这个值等于x方向的值除以半径，也就是一个cos值
            local radians
            --circleCenter代表圆心的绝对位置
            local circleCenter = cc.pAdd(point1,{x=0,y=circleCenter1})
            --计算出弧度数
            radians = math.acos((point1.x-x)/self._radius)
            --根据弧度数计算出需要旋转的度数
            if car:getPositionY() > circleCenter.y then
                --_degree中保存圆周运动需要旋转的度数
                self._degree = 90-math.deg(radians)
                --设置变轨以后的坐标
                car:setPosition({x=circleCenter.x-circleCenter1*math.cos(radians),y=circleCenter.y+circleCenter1*math.sin(radians)})
            else
                self._degree = 90+math.deg(radians)
                --设置变轨以后的坐标
                car:setPosition({x=circleCenter.x-circleCenter1*math.cos(radians),y=circleCenter.y-circleCenter1*math.sin(radians)})
            end
            --设置相对于当前坐标点的圆心位置
            circleCenter1 = cc.pSub(circleCenter,{x=car:getPositionX(),y=car:getPositionY()})
            circleCenter2 = {x=0,y=circleCenter2}
        elseif x > self.track_size.width*0.745 then
            --首先需要计算圆周运动已经转过的弧度数，这个值等于x方向的值除以半径，也就是一个cos值
            local radians
            --circleCenter代表圆心的绝对位置
            local circleCenter = cc.pAdd(point2,{x=0,y=circleCenter2})
            --计算出弧度数
            radians = math.acos((x-point2.x)/self._radius)
            --根据弧度数计算出需要旋转的度数
            if car:getPositionY() > circleCenter.y then
                --_degree中保存圆周运动需要旋转的度数
                self._degree = 90+math.deg(radians)
                --设置变轨以后的坐标
                car:setPosition({x=circleCenter.x+circleCenter1*math.cos(radians),y=circleCenter.y+circleCenter1*math.sin(radians)})
            else
                self._degree = 90-math.deg(radians)
                --设置变轨以后的坐标
                car:setPosition({x=circleCenter.x+circleCenter1*math.cos(radians),y=circleCenter.y-circleCenter1*math.sin(radians)})
            end
            --设置相对于当前坐标点的圆心位置
            circleCenter1 = {x=0,y=circleCenter1}
            circleCenter2 = cc.pSub(circleCenter,{x=car:getPositionX(),y=car:getPositionY()})
        elseif car:getPositionY() > self.track_size.height*0.5 then
            circleCenter1 = {x=0,y=circleCenter1}
            circleCenter2 = {x=0,y=circleCenter2}
            car:setPositionY(point2.y)
        else
            circleCenter1 = {x=0,y=circleCenter1}
            circleCenter2 = {x=0,y=circleCenter2}
            car:setPositionY(point1.y)
        end
    end

    --将本次圆周运动的半径保存下来
    self._radius = math.sqrt(math.pow(circleCenter1.x,2)+math.pow(circleCenter1.y,2))

    --返回相对的圆心点以及绝对的point点
    return circleCenter1,circleCenter2,point1,point2
end

--设置运动的参数
function MainGameScene:setParam(car,circleCenter1,point1,point2)
    --根据速率计算小车需要运动的时间
    local rate = GlobalData.rate
    --圆周运动的半径
    local radius = self._radius
    --以下的变量代表的含义是，左圆周运动时间，上直线运动时间，右圆周运动时间，下直线运动时间，左圆周运动弧度数，右圆周运动的弧度数
    local tm1,tm2,tm3,tm4,degree1,degree2
    --根据小车位置的不同，计算不同的位移时间
    local x = car:getPositionX()
    if x < self.track_size.width*0.245 then
        tm1 = self._degree*2*math.pi/360*radius/rate
        tm2 = (point2.x-point1.x)/rate
        tm3 = math.pi*radius/rate
        tm4 = (point2.x-point1.x)/rate
        degree1 = self._degree
        degree2 =180
    elseif x > self.track_size.width*0.745 then
        tm1 = math.pi*radius/rate
        tm2 = (point2.x-point1.x)/rate
        tm3 = self._degree*2*math.pi/360*radius/rate
        tm4 = (point2.x-point1.x)/rate
        degree1 = 180
        degree2 = self._degree
    elseif car:getPositionY() > self.track_size.height*0.5 then
        tm1 = math.pi*radius/rate
        tm2 = (point2.x-x)/rate
        tm3 = math.pi*radius/rate
        tm4 = (point2.x-point1.x)/rate
        degree1 = 180
        degree2 = 180
    else
        tm1 = math.pi*radius/rate
        tm2 = (point2.x-point1.x)/rate
        tm3 = math.pi*radius/rate
        tm4 = (x-point1.x)/rate
        degree1 = 180
        degree2 = 180
    end

    return tm1,tm2,tm3,tm4,degree1,degree2
end

--变轨
function MainGameScene:switch(car,tm1,tm2,tm3,tm4,degree1,degree2,circleCenter1,circleCenter2,point1,point2)
    --停止动作的执行
    car:stopAllActions()

    --创建第一个动作
    local circle1 = tt.CircleBy:create(tm1,circleCenter1,degree1)
    local spawn1 = cc.Spawn:create(circle1,cc.RotateBy:create(tm1,degree1))
    spawn1 = cc.Sequence:create(spawn1,cc.RotateTo:create(0,180))
    --右圆周运动
    local circle2 = tt.CircleBy:create(tm3,circleCenter2,degree2)
    local spawn2 = cc.Spawn:create(circle2,cc.RotateBy:create(tm3,degree2))
    spawn2 = cc.Sequence:create(spawn2,cc.RotateTo:create(0,360))
    --下边的直线运动
    local move1 = cc.MoveTo:create(tm4,point1)
    --上边的直线运动
    local move2 = cc.MoveTo:create(tm2,point2)
    --动作执行完毕调用的函数
    local callfunc = cc.CallFunc:create(function()
        self:runRedCar(self.car_red)
    end)

    --设置动作执行的顺序
    local sequence
    --根据小车所在位置的不同，执行不同的动作序列
    local x = car:getPositionX()
    if x <= self.track_size.width*0.245 then
        sequence = {spawn1,move2,spawn2,move1,callfunc}
    elseif x >= self.track_size.width*0.745 then
        sequence = {spawn2,move1,spawn1,move2,callfunc}
    elseif car:getPositionY() > self.track_size.height*0.5 then
        sequence = {move2,spawn2,move1,spawn1,callfunc}
    else
        sequence = {move1,spawn1,move2,spawn2,callfunc}
    end

    local action_red = cc.Sequence:create(sequence)
    action_red:setTag(1)

    --[[执行动作--]]

    --红色小车
    if car:getTag() == 1 then 
        car:runAction(action_red)
    end
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
    local car_red = cc.Sprite:create("car3.png")
    car_red:setPosition(self.track_size.width*0.45,self.track_size.height*0.063)
    car_red:setTag(1)
    car_red:setRotation(180)
    self.car_bottomy = car_red:getPositionY()
    self.car_topy = self.track_size.height*0.95
    self.car_red = car_red

    --创建一个黄色小车
    local car_yello = cc.Sprite:create("car4.png")
    car_yello:setRotation(180)
    car_yello:setPosition(car_red:getPositionX()+2*car_red:getContentSize().width,self.track_size.height*0.063)
    car_yello:setTag(2)
    self.car_yello = car_yello

    --将车添加到轨道上
    track:addChild(car_red)
    track:addChild(car_yello)
    
    --纪录小车是否变轨的变量
    self.red_switch = false
    self.yello_switch = false
end

--重置小车的位置
function MainGameScene:resetCar()
    self.car_red:setPosition(self.track_size.width*0.45,self.track_size.height*0.063)
    self.car_red:setRotation(180)
    self.car_yello:setRotation(180)
    self.car_yello:setPosition(self.car_red:getPositionX()+2*self.car_red:getContentSize().width,self.track_size.height*0.063)
    --纪录小车是否变轨的变量
    self.red_switch = false
    self.yello_switch = false
end

--小车运动
function MainGameScene:runRedCar(car)
    
    --[[根据小车所在位置的不同，返回不同的动作序列--]]
    local function getSequence(spawn1,spawn2,move1,move2)
        --设置动作执行的顺序
        local sequence
        --根据小车所在位置的不同，执行不同的动作序列
        local x = car:getPositionX()
        --lua中只有浮点数，不能用相等来判断位置是否一样
        if math.abs(x-self.track_size.width*0.245) < 0.01 and car:getPositionY() < self.track_size.height*0.5 then
            sequence = {spawn1,move2,spawn2,move1}
        elseif math.abs(x-self.track_size.width*0.745) < 0.01 and car:getPositionY() > self.track_size.height*0.5 then
            sequence = {spawn2,move1,spawn1,move2}
        elseif car:getPositionY() > self.track_size.height*0.5 then
            sequence = {move2,spawn2,move1,spawn1}
        else
            sequence = {move1,spawn1,move2,spawn2}
        end
        return sequence
    end

    --[[设置在内圈轨道上执行动作还是在外圈轨道上执行动作--]]
    local function getParam()
        --初始化运动过程中需要的成员变量 代表外圈的轨道
        local y1 = self.track_size.height*0.445
        local y2 = -y1
        local point1 = cc.p(self.track_size.width*0.245,self.car_bottomy)
        local point2 = cc.p(self.track_size.width*0.745,self.car_topy)

        --决定执行里圈的轨道还是外圈的轨道
        local switch = self.red_switch
        --代表里圈的轨道
        if switch then
            y1 = self.track_size.height*0.335
            y2 = -y1
            point1 = cc.p(self.track_size.width*0.245,self.track_size.height*0.171) 
            point2 = cc.p(self.track_size.width*0.745,self.track_size.height*0.844) 
        end

        --将本次圆周运动的半径保存下来，变轨的时候会用到
        self._radius = y1

        return y1,y2,point1,point2
    end

    --根据内外圈轨道的不同，获得不同的运动参数
    local y1,y2,point1,point2 = getParam()

    --[[根据速率计算小车需要运动的时间--]]
    local rate = GlobalData.rate
    --圆周运动的时间
    local tm = math.pi*self._radius/rate
    --直线运动的时间
    local tm2 = (self.track_size.width*0.5)/rate

    --创建动作
    local circle1 = tt.CircleBy:create(tm,{x=0,y=y1},180)
    local spawn1 = cc.Spawn:create(circle1,cc.RotateBy:create(tm,180))
    --右圆周运动
    local circle2 = tt.CircleBy:create(tm,{x=0,y=y2},180)
    local spawn2 = cc.Spawn:create(circle2,cc.RotateBy:create(tm,180))
    --下边的直线运动
    local move1 = cc.MoveTo:create(tm2,point1)
    --上边的直线运动
    local move2 = cc.MoveTo:create(tm2,point2)
    --动作序列
    local action_red = cc.RepeatForever:create(cc.Sequence:create(getSequence(spawn1,spawn2,move1,move2)))
    action_red:setTag(1)
    
    --执行红车的动作
    if car:getTag() == 1 then
        --如果存在正在执行的动作，先停止动作的执行
        if car:getActionByTag(1) ~= nil then
            car:stopActionByTag(1)
        end
        car:runAction(action_red)
    end
end

function MainGameScene:runYelloCar(car)
    
    --返回执行里圈轨道或者外圈轨道的动作
    local function getAction()
        --初始化运动过程中需要的成员变量 代表外圈的轨道
        local y1 = self.track_size.height*0.445
        local y2 = -y1
        local point1 = cc.p(self.track_size.width*0.245,self.car_bottomy)
        local point2 = cc.p(self.track_size.width*0.745,self.car_topy)
        
        --判断执行里圈的轨道还是外圈的轨道
        local switch = self.yello_switch
        --代表里圈的轨道
        if switch then
            y1 = self.track_size.height*0.335
            y2 = -y1
            point1 = cc.p(self.track_size.width*0.245,self.track_size.height*0.171) 
            point2 = cc.p(self.track_size.width*0.745,self.track_size.height*0.844) 
        end
         
        --[[根据速率计算小车需要运动的时间--]]
        local rate = GlobalData.rate
        --圆周运动的时间
        local tm = math.pi*y1/rate
        --直线运动的时间
        local tm2 = (self.track_size.width*0.5)/rate
        
        --创建动作
        local circle1 = tt.CircleBy:create(tm,{x=0,y=y1},180)
        local spawn1 = cc.Spawn:create(circle1:reverse(),cc.RotateBy:create(tm,-180))
        local move2 = cc.MoveTo:create(tm2,{x=point1.x,y=point2.y})
        local circle2 = tt.CircleBy:create(tm,{x=0,y=y2},180)
        local spawn2 = cc.Spawn:create(circle2:reverse(),cc.RotateBy:create(tm,-180))
        local move1 = cc.MoveTo:create(tm2,{x=point2.x,y=point1.y})
        
        return tm,tm2,spawn1,move2,spawn2,move1
    end
    
    local tm,tm2,spawn1,move2,spawn2,move1 = getAction()
        
    --先将是否变轨的变量保存一下
    local switch= self.yello_switch
    
    --获得一个随机数
    math.randomseed(os.time())
    local r = math.random(0,100)
    --只有当小车在外部的轨道，并且满足概率的时候才会进入内部的轨道
    if r > 50 and (self.yello_switch == false) then
        --变轨固定在这个点 进入内部的轨道
        local circle1 = cc.Spawn:create(tt.CircleBy:create(tm/2,{x=-30,y=self.track_size.height*0.4},-90),cc.RotateBy:create(tm/2,-90))
        local circle2 = cc.Spawn:create(tt.CircleBy:create(tm/2,{x=-162,y=self.track_size.height*0.0015},-90),cc.RotateBy:create(tm/2,-90))
        --修正bug，增加一个动作，当小车运行完四分之一的轨迹以后就设置代表内外圈轨道的变量switch
        spawn1 = cc.Sequence:create(
        circle1,cc.CallFunc:create(function()self.yello_switch = true end),
        circle2
        )
        --代表里圈轨道
        self.yello_switch = true
        tm,tm2,_,move2,spawn2,_ = getAction()
    end
    
    r = math.random(0,100)
    if r > 50 and (self.yello_switch == true) then
        --变轨固定在这个点 转到外部的轨道
        local circle1 = cc.Spawn:create(tt.CircleBy:create(tm/2,{x=-25,y=-self.track_size.height*0.4},-90),cc.RotateBy:create(tm/2,-90))
        local circle2 = cc.Spawn:create(tt.CircleBy:create(tm/2,{x=225,y=self.track_size.height*0.02},-90),cc.RotateBy:create(tm/2,-90))
        spawn2 = cc.Sequence:create(
        circle1,cc.CallFunc:create(function()self.yello_switch = false end),
        circle2
        )
        --代表外圈轨道
        self.yello_switch = false
    end

    --执行完毕一圈以后重新执行动作，这样轨道就是随机的
    local callfunc = cc.CallFunc:create(function() 
        self:runYelloCar(self.car_yello)
    end)

    --动作序列
    local action_yello = cc.Sequence:create(move1,spawn1,move2,spawn2,callfunc)
    action_yello:setTag(2)
    
    --使用玩switch来获得运动的轨迹以后，将原始switch还给小车
    self.yello_switch = switch
    car:runAction(action_yello)
end

--添加背景图片
function MainGameScene:addBg(layer)
    --bg
    local bg = cc.Sprite:create("bg.png")
    bg:setPosition(self.size.width/2,self.size.height/2)
    layer:addChild(bg)
    
    --play
    self:setButton("play.png",layer)
end

function MainGameScene:setButton(imageName,layer)
    local play = cc.MenuItemImage:create(imageName,"","")
    play:setPosition(self.size.width/2,self.size.height/2)
    play:setScale(0.8)
    local menu = cc.Menu:create(play)
    menu:setPosition(cc.p(0,0))
    layer:addChild(menu,3)

    --callback
    local play_callback = function()
        --播放音效
        SoundDeal:playEffect(EffectType.Start)
        play:runAction(cc.Sequence:create(cc.ScaleTo:create(0.05,1.3),cc.RemoveSelf:create()))
        self:runRedCar(self.car_red)
        self:runYelloCar(self.car_yello)
        self.play = true
        self:collision(layer)
    end
    play:registerScriptTapHandler(play_callback)
    --判断游戏是否开始的变量
    self.play = false
end

return MainGameScene