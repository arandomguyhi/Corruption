local path = '../assets/stages/chkdsk/'

local curBg = 0

local numAccX = 200
local numAccY = 0
local numScale = 5

if shadersEnabled then
    initLuaShader('null-and-void/chroma')
    makeLuaSprite('chroma') setSpriteShader('chroma', 'null-and-void/chroma')
    function setChroma(chromeOffset)
        setShaderFloat('chroma', 'rOffset', chromeOffset)
        setShaderFloat('chroma', 'gOffset', 0.0)
        setShaderFloat('chroma', 'bOffset', chromeOffset * -1)
    end

    initLuaShader('null-and-void/scanlines')
    makeLuaSprite('scanlines') setSpriteShader('scanlines', 'null-and-void/scanlines')

    initLuaShader('null-and-void/bloom')
    makeLuaSprite('bloom') setSpriteShader('bloom', 'null-and-void/bloom')
    setShaderFloat('bloom', 'blurSize', 0.01)
    setShaderFloat('bloom', 'intensity', 0.1)

    initLuaShader('null-and-void/nullglitchshader')
    makeLuaSprite('nullGlitch') setSpriteShader('nullGlitch', 'null-and-void/nullglitchshader')
    setShaderFloat('nullGlitch', 'glitchAmplitude', 2.0)
    setShaderFloat('nullGlitch', 'glitchNarrowness', 1.0)
    setShaderFloat('nullGlitch', 'glitchBlockiness', 4.0)
    setShaderFloat('nullGlitch', 'glitchMinimizer', 5.0)
    setShaderFloatArray('nullGlitch', 'iResolution', {screenWidth, screenHeight})
    setShaderFloat('nullGlitch', 'iTime', 0.0)

    initLuaShader('barrel')
    makeLuaSprite('barrel') setSpriteShader('barrel', 'barrel')
    setShaderFloat('barrel', 'chromaticIntensity', 0.25)
    setShaderFloat('barrel', 'distortionIntensity', -0.25)
    setShaderFloatArray('barrel', 'offset', {0, 0})
    setShaderFloat('barrel', 'angle', 0)
    setShaderBool('barrel', 'mirrorX', false)
    setShaderBool('barrel', 'mirrorY', false)
    setShaderFloat('barrel', 'zoom', 1.0)

    initLuaShader('fuckywucky')
    makeLuaSprite('schoolShader') setSpriteShader('schoolShader', 'fuckywucky')
    setShaderFloat('schoolShader', 'time', 250)
    setShaderFloat('schoolShader', 'prob', 0.15)
    setShaderFloat('schoolShader', 'glitchScale', 0.025)

    makeLuaSprite('bigGlitch') setSpriteShader('bigGlitch', 'fuckywucky')
    setShaderFloat('bigGlitch', 'time', 250)
    setShaderFloat('bigGlitch', 'prob', 0.0)
    setShaderFloat('bigGlitch', 'glitchScale', 0.9)

    makeLuaSprite('iconShader') setSpriteShader('iconShader', 'fuckywucky')
    setShaderFloat('iconShader', 'time', 250)
    setShaderFloat('iconShader', 'prob', 0.75)
    setShaderFloat('iconShader', 'glitchScale', 0.75)

    initLuaShader('fuckywuckymask')
    makeLuaSprite('vignette') setSpriteShader('vignette', 'fuckywuckymask')
    setShaderFloat('vignette', 'time', 250)
    setShaderFloat('vignette', 'prob', 0.75)
    setShaderFloat('vignette', 'glitchScale', 0.5)
    setShaderBool('vignette', 'maskMix', true)
    setShaderSampler2D('vignette', 'mask', '../assets/stages/vignette')

    initLuaShader('pixelate')
    makeLuaSprite('pixelate') setSpriteShader('pixelate', 'pixelate')
    setShaderFloat('pixelate', 'pixelSize', 1)

    local arrT = {100.0,0.0,0.0}
    local arrR = {100.0,0.0,0.0}
    local poses = {0.5,0.5}
    local amtt = 0.0
    local trans = false
    
    initLuaShader('overlay')
    makeLuaSprite('overlay') setSpriteShader('overlay', 'overlay')
    setShaderFloat('overlay', 'rT', arrT[1]/255)
    setShaderFloat('overlay', 'gT', arrT[2]/255)
    setShaderFloat('overlay', 'bT', arrT[3]/255)
    setShaderFloat('overlay', 'rR', arrR[1]/255)
    setShaderFloat('overlay', 'gR', arrR[2]/255)
    setShaderFloat('overlay', 'bR', arrR[3]/255)
    setShaderFloat('overlay', 'ypos', poses[2])
    setShaderFloat('overlay', 'xpos', poses[1])
    setShaderBool('overlay', 'amt', amtt)
    setShaderBool('overlay', 'trans', trans)
end

local pixelateAmount = 1
local hurtAmountBlack = 0

luaDebugMode = true

function addTrail(who, which, length, delay, alpha, diff)
    if length == nil then length = 4 end
    if delay == nil then delay = 24 end
    if alpha == nil then alpha = 0.4 end
    if diff == nil then diff = 0.069 end

    if which == 0 then
        runHaxeCode([[
            var bfTrail = new flixel.addons.effects.FlxTrail(]]..tostring(who)..[[, null, ]]..length..[[, ]]..delay..[[, ]]..alpha..[[, ]]..diff..[[);
            game.addBehindBF(bfTrail);
        ]])
    elseif which == 1 then
        runHaxeCode([[
            var evilTrail = new flixel.addons.effects.FlxTrail(]]..tostring(who)..[[, null, ]]..length..[[, ]]..delay..[[, ]]..alpha..[[, ]]..diff..[[);
            game.addBehindDad(evilTrail);
        ]])
    end
end

function onCreatePost()
    makeAnimatedLuaSprite('numTunnel', path..'NumberTunnel')
    addAnimationByPrefix('numTunnel', 'anim', 'NumberTunnel idle', 30, true)
    playAnim('numTunnel', 'anim', true)
    setScrollFactor('numTunnel', 0, 0)
    setProperty('numTunnel.alpha', 0.001)
    updateHitbox('numTunnel')
    screenCenter('numTunnel')
    scaleObject('numTunnel', 2.8, 2.8, false)
    addBehindBF('numTunnel')

    makeAnimatedLuaSprite('numTunnel2', path..'NumberTunnel')
    addAnimationByPrefix('numTunnel2', 'anim', 'NumberTunnel idle', 30, true)
    playAnim('numTunnel2', 'anim', true)
    setScrollFactor('numTunnel2', 0, 0)
    setProperty('numTunnel2.alpha', 0.001)
    updateHitbox('numTunnel2')
    screenCenter('numTunnel2')
    scaleObject('numTunnel2', 2.8, 2.8, false)
    addBehindDad('numTunnel2')

    makeVideoSprite('video6', 0, 0, 'camGame')
    setGraphicSize('video6s', 1920, 1080)
    setProperty('video6s.scale.x', getProperty('video6s.scale.x') * 1.1)
    setProperty('video6s.scale.y', getProperty('video6s.scale.y') * 1.3)
    setPosition('video6s', -200, -100)
    setProperty('video6s.antialiasing', false)

    makeVideoSprite('video7', 0, 0, 'camGame')
    setGraphicSize('video7s', 1920, 1080)
    setProperty('video7s.scale.x', getProperty('video7s.scale.x') * 1.1)
    setProperty('video7s.scale.y', getProperty('video7s.scale.y') * 1.3)
    setPosition('video7s', -200, -100)
    setProperty('video7s.antialiasing', false)

    makeVideoSprite('video8', 0, 0, 'camGame')
    setPosition('video8s', -130, -110)
    setGraphicSize('video8s', 1920, 1080)
    setProperty('video8s.scale.x', getProperty('video8s.scale.x') * 1.4)
    setProperty('video8s.scale.y', getProperty('video8s.scale.y') * 1.4)
    setProperty('video8s.antialiasing', false)

    makeAnimatedLuaSprite('helpme', path..'HelpMe')
    addAnimationByPrefix('helpme', 'anim', 'HelpMe idle', 16, false)
    playAnim('helpme', 'anim', true)
    setScrollFactor('helpme', 0, 0)
    setProperty('helpme.alpha', 1)
    updateHitbox('helpme')
    screenCenter('helpme')
    scaleObject('helpme', 3, 3)
    setProperty('helpme.antialiasing', false)

    makeVideoSprite('video4', 0, 0, 'camGame')
    setGraphicSize('video4s', 1920, 1080)
    setProperty('video4s.scale.x', getProperty('video4s.scale.x') * 1.3)
    setProperty('video4s.scale.y', getProperty('video4s.scale.y') * 1.3)
    setPosition('video4s', -130, -110)
    setProperty('video4s.antialiasing', false)

    makeVideoSprite('video5', 0, 0, 'camGame')
    setGraphicSize('video5s', 1920, 1080)
    setProperty('video5s.scale.x', getProperty('video5s.scale.x') * 1.3)
    setProperty('video5s.scale.y', getProperty('video5s.scale.y') * 1.3)
    setPosition('video5s', -130, -110)
    setProperty('video5s.antialiasing', false)
    setObjectOrder('video5s', getObjectOrder('boyfriendGroup')-1)

    -- hand transition video4
    -- hands loop video5
    -- SecondTunnel video6
    -- SecondTunnel video7
    -- glitch intermission video8

    setProperty('video6s.alpha', 0.3)
    setProperty('video6.blend', 12)
    setProperty('video7.alpha', 0.7)

    setProperty('numTunnel.blend', 12)

    callMethod('boyfriend.setPosition', {790, 741})
    callMethod('dad.setPosition', {740, 45})
    scaleObject('dad', 3, 3, false)

    setProperty('defaultCamZoom', 0.5)
    setProperty('camGame.zoom', getProperty('defaultCamZoom'))
end

function setPosition(spr, x, y)
    setProperty(spr..'.x', x)
    setProperty(spr..'.y', y)
end

function addBehindDad(spr)
    addLuaSprite(spr)
    setObjectOrder(spr, getObjectOrder('dadGroup')-1)
end

function addBehindBF(spr)
    addLuaSprite(spr)
    setObjectOrder(spr, getObjectOrder('boyfriendGroup')-1)
end