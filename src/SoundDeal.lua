SoundDeal = {audioEngine = cc.SimpleAudioEngine:getInstance()}

EffectType = {
    Crash = "sound/crash.mp3",
    Newhigh = "sound/newhigh.mp3",
    Yes = "sound/point.mp3",
    Start = "sound/start.mp3",
    Tap = "sound/tap.mp3"
}

function SoundDeal:playBg()
    self.audioEngine:playMusic("sound/bg.mp3",true)
    self.audioEngine:setMusicVolume(1)
end

function SoundDeal:stopBg()
    self.audioEngine:stopMusic()
end

function SoundDeal:preloadEffect()
    self.audioEngine:preloadEffect(EffectType.Crash)
    self.audioEngine:preloadEffect(EffectType.Newhigh)
    self.audioEngine:preloadEffect(EffectType.Yes)
    self.audioEngine:preloadEffect(EffectType.Start)
    self.audioEngine:preloadEffect(EffectType.Tap)
    self.audioEngine:setEffectsVolume(1)
end

function SoundDeal:playEffect(type)
    self.audioEngine:playEffect(type)
end