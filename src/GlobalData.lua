require("SoundDeal")

GlobalData = {
    rate = math.pi*cc.Director:getInstance():getWinSize().height*0.2,
    score = 0,
    hightScore = cc.UserDefault:getInstance():getIntegerForKey("hightScore",0),
}

--重置数据
function GlobalData:reset()
    self.rate = math.pi*cc.Director:getInstance():getWinSize().height*0.2
    self.score = 0
    self.hightScore = cc.UserDefault:getInstance():getIntegerForKey("hightScore")
end

--设置分数和速率
function GlobalData:setScore()
    self.score = self.score+1
    if self.score > self.hightScore then
        self.hightScore = self.score
        cc.UserDefault:getInstance():setIntegerForKey("hightScore",self.score)
        SoundDeal:playEffect(EffectType.Newhigh)
    else
        SoundDeal:playEffect(EffectType.Yes)
    end
    
    local score = self.score
    if score > 5 then
        self.rate = math.pi*cc.Director:getInstance():getWinSize().height*0.25
    end
    if score > 10 then
        self.rate = math.pi*cc.Director:getInstance():getWinSize().height*0.3
    end
    if score > 20 then
        self.rate = math.pi*cc.Director:getInstance():getWinSize().height*0.4
    end
    if score > 30 then
        self.rate = math.pi*cc.Director:getInstance():getWinSize().height*0.5
    end
    if score > 50 then
        self.rate = math.pi*cc.Director:getInstance():getWinSize().height*0.6
    end
end