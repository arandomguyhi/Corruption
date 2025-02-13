local path = '../assets/stages/chkdsk/'

local curBg = 0

local numAccX = 200
local numAccY = 0
local numScale = 5

local hasGameOvered = false

local tweenStarted = false

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
    setShaderFloatArray('nullGlitch', 'iResolution', {getPropertyFromClass('openfl.Lib', 'current.stage.stageWidth'), getPropertyFromClass('openfl.Lib', 'current.stage.stageHeight')})
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
    setShaderInt('pixelate', 'pixelSize', 1)

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
            setVar('bfTrail', bfTrail);
        ]])
    elseif which == 1 then
        runHaxeCode([[
            var evilTrail = new flixel.addons.effects.FlxTrail(]]..tostring(who)..[[, null, ]]..length..[[, ]]..delay..[[, ]]..alpha..[[, ]]..diff..[[);
            game.addBehindDad(evilTrail);
            setVar('evilTrail', evilTrail);
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
    if buildTarget == 'android' then
        setGraphicSize('video6', 1920, 1080)
    else
        runHaxeCode("getVar('video6s').setGraphicSize(1920, 1080);")
    end
    setProperty('video6.scale.x', getProperty('video6.scale.x') * 1.1)
    setProperty('video6.scale.y', getProperty('video6.scale.y') * 1.3)
    setPosition('video6', -200, -100)
    setProperty('video6.antialiasing', false)

    makeVideoSprite('video7', 0, 0, 'camGame')
    if buildTarget == 'android' then
        setGraphicSize('video7', 1920, 1080)
    else
        runHaxeCode("getVar('video7s').setGraphicSize(1920, 1080);")
    end
    setProperty('video7.scale.x', getProperty('video7.scale.x') * 1.1)
    setProperty('video7.scale.y', getProperty('video7.scale.y') * 1.3)
    setPosition('video7', -200, -100)
    setProperty('video7.antialiasing', false)

    makeVideoSprite('video8', 0, 0, 'camGame')
    setPosition('video8', -130, -110)
    if buildTarget == 'android' then
        setGraphicSize('video8', 1920, 1080)
    else
        runHaxeCode("getVar('video8s').setGraphicSize(1920, 1080);")
    end
    setProperty('video8.scale.x', getProperty('video8.scale.x') * 1.4)
    setProperty('video8.scale.y', getProperty('video8.scale.y') * 1.4)
    setProperty('video8.antialiasing', false)

    makeAnimatedLuaSprite('helpme', path..'HelpMe')
    addAnimationByPrefix('helpme', 'anim', 'HelpMe idle', 16, false)
    playAnim('helpme', 'anim', true)
    setScrollFactor('helpme', 0, 0)
    setProperty('helpme.alpha', 1)
    updateHitbox('helpme')
    screenCenter('helpme')
    scaleObject('helpme', 3, 3, false)
    setProperty('helpme.antialiasing', false)

    makeVideoSprite('video4', 0, 0, 'camGame')
    if buildTarget == 'android' then
        setGraphicSize('video4', 1920, 1080)
    else
        runHaxeCode("getVar('video4s').setGraphicSize(1920, 1080);")
    end
    setProperty('video4.scale.x', getProperty('video4.scale.x') * 1.3)
    setProperty('video4.scale.y', getProperty('video4.scale.y') * 1.3)
    setPosition('video4', -130, -110)
    setProperty('video4.antialiasing', false)

    makeVideoSprite('video5', 0, 0, 'camGame')
    setGraphicSize('video5', 1920, 1080)
    if buildTarget == 'android' then
        setGraphicSize('video5', 1920, 1080)
    else
        runHaxeCode("getVar('video5s').setGraphicSize(1920, 1080);")
    end
    setProperty('video5.scale.x', getProperty('video5.scale.x') * 1.3)
    setProperty('video5.scale.y', getProperty('video5.scale.y') * 1.3)
    setPosition('video5', -130, -110)
    setProperty('video5.antialiasing', false)
    setObjectOrder('video5', getObjectOrder('boyfriendGroup')-1)

    -- hand transition video4
    -- hands loop video5
    -- SecondTunnel video6
    -- SecondTunnel video7
    -- glitch intermission video8

    setProperty('video6.alpha', 0.3)
    setProperty('video6.blend', 12)
    setProperty('video7.alpha', 0.7)

    setProperty('numTunnel.blend', 12)

    callMethod('boyfriend.setPosition', {790, 741})
    callMethod('dad.setPosition', {740, 45})
    scaleObject('dad', 3, 3, false)

    setVar('cameraPoint', {x = 810, y = 420})

    setProperty('defaultCamZoom', 0.5)
    setProperty('camGame.zoom', getProperty('defaultCamZoom'))

    makeAnimatedLuaSprite('school', path..'animatedEvilSchool')
    addAnimationByIndices('school', 'idle', 'background 2 instance 1', {1}, 12, true)
    playAnim('school', 'idle', true)
    scaleObject('school', 8, 8)
    setProperty('school.antialiasing', false)
    runHaxeCode("game.getLuaObject('school').shader = game.getLuaObject('schoolShader').shader")
    setProperty('school.x', -1220)
    setProperty('school.y', -1790)
    addBehindDad('school')

    makeAnimatedLuaSprite('glitchBump', path..'spiritBump')
    addAnimationByPrefix('glitchBump', 'anim', 'spiritBump', 24, true)
    playAnim('glitchBump', 'anim', true)
    setScrollFactor('glitchBump', 0, 0)
    setProperty('glitchBump.alpha', 0.001)
    updateHitbox('glitchBump')
    screenCenter('glitchBump')
    scaleObject('glitchBump', 1.9, 1.9, false)
    addLuaSprite('glitchBump', true)

    setChroma(0.002)

    setShaderFloat('bloom', 'blurSize', 0.01)
    setShaderFloat('bloom', 'intensity', 0.1)

    setShaderFloat('nullGlitch', 'glitchNarrowness', 25.0)

    if getModSetting('shadersC') == 'All' then
        runHaxeCode([[
            var cu = game.getLuaObject;
            game.camGame.setFilters([new ShaderFilter(cu('barrel').shader), new ShaderFilter(cu('vignette').shader), new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader), new ShaderFilter(cu('overlay').shader), new ShaderFilter(cu('pixelate').shader)]);
            game.camHUD.setFilters([new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader), new ShaderFilter(cu('overlay').shader)]);
        ]])
    elseif getModSetting('shadersC') == 'Minimal' then
        runHaxeCode([[
            var cu = game.getLuaObject;
            game.camGame.setFilters([new ShaderFilter(cu('barrel').shader), new ShaderFilter(cu('pixelate').shader)]);
        ]])
    end

    addTrail('dad', 1, 8, 5, 0.4, 0.030)

    setProperty('helpme.visible', false)
    addLuaSprite('helpme', true)

    setObjectOrder('video4', getObjectOrder('helpme')+1)
    setProperty('video4.visible', false)
    setProperty('video5.visible', false)
    setProperty('video5.blend', 12)
    setProperty('video5.alpha', 0.85)

    makeAnimatedLuaSprite('bfSigh', path..'BfSigh')
    addAnimationByPrefix('bfSigh', 'anim', 'BfSigh', 24, false)
    playAnim('bfSigh', 'anim', true)
    scaleObject('bfSigh', 13, 13, false)
    setPosition('bfSigh', 4000, 1055)
    addLuaSprite('bfSigh', true)

    makeAnimatedLuaSprite('handGrabEnd', path..'hand_grab_end')
    addAnimationByPrefix('handGrabEnd', 'anim', 'hand_grab_end_idle', 15, false)
    playAnim('handGrabEnd', 'anim', true)
    updateHitbox('handGrabEnd')
    setProperty('handGrabEnd.antialiasing', false)
    setProperty('handGrabEnd.blend', 0)
    setPosition('handGrabEnd', -9000, -9000)
    scaleObject('handGrabEnd', 3, 3, false)
    addLuaSprite('handGrabEnd', true)

    makeAnimatedLuaSprite('speedLines', path..'speedlines')
    addAnimationByPrefix('speedLines', 'anim', 'speedlines idle', 25, true)
    playAnim('speedLines', 'anim', true)
    updateHitbox('speedLines')
    setProperty('speedLines.antialiasing', false)
    setProperty('speedLines.blend', 0)
    setPosition('speedLines', -9000, 200)
    scaleObject('speedLines', 3, 3, false)
    addLuaSprite('speedLines', true)

    makeAnimatedLuaSprite('scanlinesFake', path..'ScanlinesThin')
    addAnimationByPrefix('scanlinesFake', 'anim', 'ScanlinesThin idle', 24, true)
    playAnim('scanlinesFake', 'anim', true)
    updateHitbox('scanlinesFake')
    setProperty('scanlinesFake.antialiasing', true)
    setProperty('scanlinesFake.alpha', 0.1)
    setProperty('scanlinesFake.blend', 9)
    setPosition('scanlinesFake', 280, 170)
    scaleObject('scanlinesFake', 1.9, 1.9, false)
    setScrollFactor('scanlinesFake', 0, 0)
    runHaxeCode("game.getLuaObject('scanlinesFake').camera = getVar('camOverlay');")
    addLuaSprite('scanlinesFake', true)

    makeLuaSprite('hurtBlack')
    makeGraphic('hurtBlack', 1, 1, 'FF0000')
    scaleObject('hurtBlack', 1280 * 3, 720 * 3)
    setScrollFactor('hurtBlack', 0, 0)
    screenCenter('hurtBlack')
    setProperty('hurtBlack.alpha', 0)
    addLuaSprite('hurtBlack', true)

    makeLuaSprite('lowVin', path..'lowHealthPixel', -300, -170)
    scaleObject('lowVin', 0.7, 0.7, false)
    setProperty('lowVin.antialiasing', true)
    setScrollFactor('lowVin', 0, 0)
    setProperty('lowVin.alpha', 0)
    screenCenter('lowVin')
    setProperty('lowVin.blend', 0)
    runHaxeCode("game.getLuaObject('lowVin').camera = getVar('camOverlay');")
    addLuaSprite('lowVin', true)

    makeAnimatedLuaSprite('staticOverlay', path..'tv_static')
    addAnimationByPrefix('staticOverlay', 'anim', 'tv_static idle', 25, true)
    playAnim('staticOverlay', 'anim', true)
    updateHitbox('staticOverlay')
    scaleObject('staticOverlay', 1.7, 1.7, false)
    setProperty('staticOverlay.antialiasing', false)
    screenCenter('staticOverlay')
    runHaxeCode("game.getLuaObject('staticOverlay').camera = getVar('camOverlay');")
    addLuaSprite('staticOverlay', true)
end

function noteMiss()
    pixelateAmount = pixelateAmount + 2
    hurtAmountBlack = hurtAmountBlack + 0.05
end

function opponentNoteHit()
    if curBg == 0 then
        setProperty('dad.x', getRandomFloat(-30, 1570))
        setProperty('dad.y', getRandomFloat(-175, 355))
        local scaleLol = getRandomFloat(1, 4)
        scaleObject('dad', scaleLol, scaleLol, false)
    end
end

function onEvent(name, value1, value2)
    if getProperty('endingSong') then return end
    
    if name == 'addelement' then
        if value1 == 'speedlines' then
            setProperty('speedLines.x', 300)
        elseif value1 == 'nospeedlines' then
            setProperty('speedLines.x', -9000)
        end
    end

    if name == 'removechars' then
        setProperty('glitchBump.alpha', 0.25)
        setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.08)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.10)

        startTween('noDad', 'dad', {alpha = 0}, 1, {})
        startTween('noBf', 'boyfriend', {alpha = 0}, 1, {})
    end

    if name == 'playendanim' then
        playAnim('handGrabEnd', 'anim', true)
        setPosition('handGrabEnd', 300, 200)
        setProperty('video5s.visible', false)
    end

    if name == 'prob' then
        setShaderFloat('bigGlitch', 'prob', value1)
        setShaderFloat('bigGlitch', 'time', getRandomFloat(0.0, 999.0))
    end

    if name == 'specialbump' then
        if value1 == '2' then
            setProperty('glitchBump.alpha', 0.5)
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.16)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.15)
        elseif value1 == '3' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.03)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.05)
        elseif value1 == '4' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.03)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.05)
        elseif value1 == '5' then
            setProperty('glitchBump.alpha', 0.25)
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.08)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.10)
        elseif value1 == '6' then
            setProperty('glitchBump.alpha', 0.15)
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.04)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.05)
        elseif value1 == '7' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.03)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.05)
        elseif value1 == '8' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.1)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.5)
        elseif value1 == 'glitch' then
            setShaderFloat('bigGlitch', 'time', getRandomFloat(0.0, 999.0))
        else
            setProperty('glitchBump.alpha', 0.25)
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.08)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.05)
        end
    end

    if name == 'playvideo' then
        if value1 == 'help' then
            setProperty('helpme.visible', true)
            setProperty('camHUD.alpha', 0)
            playAnim('helpme', 'anim', true)
        elseif value1 == 'hand' then
            setProperty('video4.visible', true)
            setPosition('video4', -130, -110)
            playVideo('video4', 'hand transition')
        elseif value1 == 'handloop' then
            setProperty('video5.visible', true)
            setPosition('video5', -130, -110)
            playVideo('video5', 'hands loop', true)
        elseif value1 == 'intermission' then
            runHaxeCode("game.camGame.filters = [];")
            setProperty('health', 2)

            playVideo('video8', 'glitch intermission', true)
            setObjectOrder('video8', getObjectOrder('staticOverlay')+1)

            setProperty('dad.alpha', 0)
            setProperty('boyfriend.alpha', 0)
            setProperty('evilTrail.visible', false)

            setProperty('numTunnel.alpha', 0)
            setProperty('numTunnel2.alpha', 0)

            setProperty('camHUD.alpha', 0.5)
        elseif value1 == 'tunnel2' then
            if playing2 then return end
            playing2 = true

            setObjectOrder('video6', getObjectOrder('boyfriendGroup')-1)
            setObjectOrder('video7', getObjectOrder('boyfriendGroup')-1)

            setProperty('numTunnel.x', 4000)
            setProperty('numTunnel2.x', 4000)

            playVideo('video6', 'SecondTunnel', true)
            playVideo('video7', 'SecondTunnel', true)
        elseif value1 == 'remove' then
            if value2 == '4' then
                setProperty('video4.visible', false)
                setProperty('video4.x', 8000)
                setProperty('numTunnel.x', 240)
                setProperty('numTunnel.alpha', 0.3)
            elseif value2 == '5' then
                setProperty('video5.visible', false)
                setProperty('video5.x', 8000)
            elseif value2 == 'hands' then
                -- nothing lol
            else
                startTween('BZL', 'helpme', {alpha = 0}, 0.2, {})
            end
            setProperty('camHUD.alpha', 1)
        else
            playAnim('numTunnel', 'anim', true)
            playAnim('numTunnel2', 'anim', true)

            setProperty('glitchBump.alpha', 0.25)
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.08)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.10)
        end
    end

    if name == 'addtrail' then
        addTrail('boyfriend', 0, 4, 2)
        setProperty('bfTrail.color', callMethodFromClass('psychlua.CustomFlxColor', 'fromRGB', {0,142,255,255}))
    elseif name == 'removetrail' then
        setProperty('bfTrail.visible', false)
    end

    if name == 'changeBf' then
        if value1 == 'fall' then
            startTween('hihud', 'camHUD', {alpha = 1}, 1.5, {})

            triggerEvent('Change Character', 'bf', 'bf-pixel-dive')
            callMethod('boyfriend.setPosition', {740 - 200, 500})
            scaleObject('boyfriend', 6, 6, false)

            setPosition('bfSigh', 4000, 1055)

            triggerEvent('Change Character', 'dad', 'spiritBack')

            addTrail('dad', 1)
            setProperty('evilTrail.visible', true)

            callMethod('dad.setPosition', {640 + 100, 220+25})
            scaleObject('dad', 10, 10, false)

            numAccY = -500
            numAccX = -1000
            numScale = 10

            if not tweenStarted then
                startTween('bfTweenX', 'boyfriend', {x = getProperty('boyfriend.x') + 400}, 4, {ease = 'sineInOut', type = 'pingpong'})
                startTween('bfTweenY', 'boyfriend', {y = getProperty('boyfriend.y') + 100}, 1, {ease = 'sineInOut', type = 'pingpong'})
                startTween('bfTweenScale', 'boyfriend.scale', {x = 7, y = 7}, 3, {ease = 'sineInOut', type = 'pingpong'})

                startTween('dadTweenX', 'dad', {x = getProperty('dad.x') - 200}, 4, {ease = 'sineInOut', type = 'pingpong'})
                startTween('dadTweenY', 'dad', {y = getProperty('dad.y') - 50}, 1, {ease = 'sineInOut', type = 'pingpong'})
                tweenStarted = true
            elseif tweenStarted then
                cancelTween('dadTweenX')
                cancelTween('dadTweenY')
                setProperty('dad.x', getProperty('dad.x') + 200)
                setProperty('dad.y', getProperty('dad.y') + 50)

                startTween('dadTweenX', 'dad', {x = getProperty('dad.x') - 200}, 4, {ease = 'sineInOut', type = 'pingpong'})
                startTween('dadTweenY', 'dad', {y = getProperty('dad.y') - 50}, 1, {ease = 'sineInOut', type = 'pingpong'})
            end

            curBg = 1
            setScrollFactor('dad', 1, 1)

            setProperty('video6.visible', false)
            setProperty('video7.visible', false)

            setProperty('numTunnel2.alpha', 0.7)
            setProperty('numTunnel2.x', 240)
            setProperty('numTunnel.alpha', 0.3)
            setProperty('numTunnel.x', 240)

            setShaderFloat('nullGlitch', 'glitchAmplitude', 10.0)
        elseif value1 == 'altfall' then
            startTween('hihud', 'camHUD', {alpha = 1}, 1.5, {})

            triggerEvent('Change Character', 'bf', 'bf-pixel-dive')
            callMethod('boyfriend.setPosition', {740 - 200, 500})
            scaleObject('boyfriend', 6, 6, false)

            setPosition('bfSigh', 4000, 1055)

            triggerEvent('Change Character', 'dad', 'spiritSad')

            callMethod('dad.setPosition', {640 + 100, 220+25})
            scaleObject('dad', 10, 10, false)

            addTrail('dad', 1)
            setProperty('evilTrail.visible', true)

            numAccY = -500
            numAccX = -1000
            numScale = 10

            cancelTween('dadTweenX')
            cancelTween('dadTweenY')
            setProperty('dad.x', getProperty('dad.x') - 200)
            setProperty('dad.y', getProperty('dad.y') - 50)

            startTween('dadTweenX', 'dad', {x = getProperty('dad.x') + 200}, 4, {ease = 'sineInOut', type = 'pingpong'})
            startTween('dadTweenY', 'dad', {y = getProperty('dad.y') + 50}, 1, {ease = 'sineInOut', type = 'pingpong'})
            tweenStarted = true

            curBg = 1
            setScrollFactor('dad', 1, 1)

            setProperty('numTunnel.alpha', 0)
            setProperty('numTunnel2.alpha', 0)

            setProperty('video6.visible', true)
            setProperty('video7.visible', true)

            setShaderFloat('nullGlitch', 'glitchAmplitude', 10.0)
        elseif value1 == 'remove' then
            if value2 == 'overlay' then
                runHaxeCode([[
                    var cu = game.getLuaObject;
                    game.camGame.setFilters([new ShaderFilter(cu('barrel').shader), new ShaderFilter(cu('vignette').shader), new ShaderFilter(cu('bigGlitch').shader), new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader)/*, new ShaderFilter(cu('nullGlitch').shader)*/, new ShaderFilter(cu('pixelate').shader)]);
                    game.camHUD.setFilters([new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader)/*, new ShaderFilter(cu('nullGlitch').shader)*/]);
                ]])
            elseif value2 == 'addoverlay' then
                runHaxeCode([[
                    var cu = game.getLuaObject;
                    game.camGame.setFilters([new ShaderFilter(cu('barrel').shader), new ShaderFilter(cu('vignette').shader), new ShaderFilter(cu('bigGlitch').shader), new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader)/*, new ShaderFilter(cu('nullGlitch').shader)*/, new ShaderFilter(cu('overlay').shader), new ShaderFilter(cu('pixelate').shader)]);
                    game.camHUD.setFilters([new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader)/*, new ShaderFilter(cu('nullGlitch').shader)*/, new ShaderFilter(cu('overlay').shader)]);
                ]])
            else
                setProperty('boyfriend.x', 4000)
            end
        elseif value1 == 'main' then
            curBg = 0

            triggerEvent('Change Character', 'bf', 'bf-pixel')
            scaleObject('boyfriend', 6, 6, false)
            callMethod('boyfriend.setPosition', {790, 741})

            triggerEvent('Change Character', 'dad', 'spiritBack')
            callMethod('dad.setPosition', {740, 45})
            scaleObject('dad', 3, 3, false)

            addTrail('dad', 1, 8, 5, 0.4, 0.030)
            setProperty('evilTrail.visible', true)

            setProperty('numTunnel.alpha', 0)
            setProperty('numTunnel2.alpha', 0)

            setShaderFloat('nullGlitch', 'glitchAmplitude', 10.0)

            cancelTween('dadTweenX')
            cancelTween('dadTweenY')
        elseif value1 == 'sigh' then
            runHaxeCode([[
                var cu = game.getLuaObject;
                game.camGame.setFilters([new ShaderFilter(cu('barrel').shader), new ShaderFilter(cu('vignette').shader), new ShaderFilter(cu('bigGlitch').shader), new ShaderFilter(cu('chroma').shader), new ShaderFilter(cu('bloom').shader)/*, new ShaderFilter(cu('nullGlitch').shader)*/, new ShaderFilter(cu('pixelate').shader)]);
            ]])

            startTween('hihud', 'camHUD', {alpha = 1}, 3, {})

            triggerEvent('Change Character', 'bf', 'bf-pixelFront')
            callMethod('boyfriend.setPosition', {4000, 810})
            scaleObject('boyfriend', 13, 13, false)
            setPosition('bfSigh', 754, 1055)
            playAnim('bfSigh', 'anim', true)

            setProperty('video8.visible', false)
            runHaxeCode([[
                var video8 = buildTarget == 'windows' ? game.getLuaObject('video8') : getVar('video8');
                remove(video8);
                video8.destroy(); 
            ]])

            setProperty('camHUD.alpha', 1)
            setProperty('boyfriend.alpha', 1)

            arrT = {0.0,0.0,255.0}
            arrR = {0.0,0.0,255.0}
            setShaderFloat('overlay', 'rT', arrT[1]/255)
            setShaderFloat('overlay', 'gT', arrT[2]/255)
            setShaderFloat('overlay', 'bT', arrT[3]/255)
            setShaderFloat('overlay', 'rR', arrR[1]/255)
            setShaderFloat('overlay', 'gR', arrR[2]/255)
            setShaderFloat('overlay', 'bR', arrR[3]/255)

            if value2 == '1' then
                triggerEvent('Change Character', 'dad', 'senpaiBackFirst')
            else
                triggerEvent('Change Character', 'dad', 'spiritSad')
            end
            curBg = 2
            numAccY = 200
            numAccX = 0
            numScale = 5
            callMethod('dad.setPosition', {540, -105})
            scaleObject('dad', 6.7, 6.7, false)
            setScrollFactor('dad', 0.2, 0.2)
            setProperty('dad.alpha', 0)

            setProperty('numTunnel.alpha', 0)
            setProperty('numTunnel2.alpha', 0)

            setProperty('evilTrail.visible', false)

            setShaderFloat('nullGlitch', 'glitchAmplitude', 10.0)
        elseif value1 == 'showbf' then
            callMethod('boyfriend.setPosition', {770, 810})
            setPosition('bfSigh', 4000, 1055)
        elseif value1 == 'showspirit' then
            startTween('showDadTween', 'dad', {alpha = 1}, 4, {})
        elseif value1 == 'removeStatic' then
            startTween('nostatic', 'staticOverlay', {alpha = 0}, 3, {})
        else
            startTween('hihud', 'camHUD', {alpha = 1}, 3, {})

            triggerEvent('Change Character', 'bf', 'bf-pixelFront')
            callMethod('boyfriend.setPosition', {770, 810})
            scaleObject('boyfriend', 13, 13, false)

            if value2 == '1' then
                triggerEvent('Change Character', 'dad', 'senpaiBackFirst')
            else
                triggerEvent('Change Character', 'dad', 'spiritSad')
            end

            if tweenStarted then
                cancelTween('dadTweenX')
                cancelTween('dadTweenY')
            end

            curBg = 2
            numAccY = 200
            numAccX = 0
            numScale = 5
            callMethod('dad.setPosition', {540,-105})
            scaleObject('dad', 6.7, 6.7, false)
            setScrollFactor('dad', 0.2, 0.2)

            callMethod('evilTrail.remove', {''})
            setProperty('evilTrail.visible', false)
            
            setShaderFloat('nullGlitch', 'glitchAmplitude', 10.0)
        end

        setProperty('glitchBump.alpha', 0.75)
        setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.08)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.10)
    end
end

function onBeatHit()
    if curBeat % 4 == 0 then
        setShaderFloat('nullGlitch', 'glitchAmplitude', getRandomFloat(1.0,5.0))
    end
end

function onStepHit()
    if curStep == 896 then
        runHaxeCode([[
            FlxTween.num(2, 1, (Conductor.stepCrochet/1000) * 20, {onUpdate: (v:Float) -> {
                parentLua.call('updateShaderValue', ['barrel', 'zoom', v]);
            }}, (vl:Float) -> { parentLua.call('updateShaderValue', ['barrel', 'zoom', vl]); });

            FlxTween.num(-1.5, -0.25, (Conductor.stepCrochet/1000) * 20, {onUpdate: (v:Float) -> {
                parentLua.call('updateShaderValue', ['barrel', 'distortionIntensity', v]);
            }}, (vl:Float) -> { parentLua.call('updateShaderValue', ['barrel', 'distortionIntensity', vl]); });
        ]])
    end
end

function updateShaderValue(s,n,v)
    setShaderFloat(s,n,v)
end

function onGameOverStart()
    setProperty('lowVin.alpha', 0)
    hurtAmountBlack = 0

    hasGameOvered = true
    runHaxeCode("game.camGame.filters = game.camHUD.filters = [];")
    setProperty('scanlinesFake.alpha', 0)
end

local trans = false
function onStartCountdown()
    if trans then return end
    setProperty('camHUD.visible', false)
    trans = true

    setProperty('boyfriend.visible', true)
    setProperty('boyfriend.animation.curAnim.curFrame', 0)
    setProperty('camHUD.visible', true)
    startCountdown()
    
    return Function_Stop
end

local timer = 0

function onUpdate(elapsed)
    if getSongPosition() <= 0 then
        setShaderFloat('schoolShader', 'time', getShaderFloat('schoolShader', 'time') + elapsed * 0.25)
        setShaderFloat('iconShader', 'time', getShaderFloat('iconShader', 'time') + elapsed * 0.75)
        setShaderFloat('vignette', 'time', getShaderFloat('vignette', 'time') + elapsed * 0.5)
        setShaderFloat('nullGlitch', 'iTime', getShaderFloat('nullGlitch', 'iTime') + elapsed)
    else
        setShaderFloat('schoolShader', 'time', getSongPosition() * 0.001 * 0.25)
        setShaderFloat('iconShader', 'time', getSongPosition() * 0.001 * 0.75)
        setShaderFloat('nullGlitch', 'iTime', getSongPosition() * 0.001)
        setShaderFloat('vignette', 'time', getSongPosition() * 0.001 * 0.5)
    end

    if hurtAmountBlack > 0 then
        hurtAmountBlack = hurtAmountBlack - 0.2 * elapsed
    elseif hurtAmountBlack < 0 then
        hurtAmountBlack = 0
    end

    setProperty('hurtBlack.alpha', hurtAmountBlack)

    setShaderInt('pixelate', 'pixelSize', tonumber(pixelateAmount))

    if pixelateAmount > 1 then
        pixelateAmount = pixelateAmount - 2 * elapsed
    elseif pixelateAmount < 1 then
        pixelateAmount = 1
    end

    if not hasGameOvered then
        if getHealth() <= 0.4 then
            if getProperty('lowVin.alpha') < 0.8 then
                setProperty('lowVin.alpha', getProperty('lowVin.alpha') + 0.4 * elapsed)
            else
                setProperty('lowVin.alpha', 0.8)
            end
        else
            if getProperty('lowVin.alpha') > 0 then
                setProperty('lowVin.alpha', getProperty('lowVin.alpha') - 0.4 * elapsed)
            end
        end
    end

    if getProperty('dad.animation.curAnim.name') == 'idle' and curBg == 0 then
        setProperty('dad.x', -4000)
    end

    if curBg == 2 then
        timer = timer + elapsed * 0.35
        setProperty('school.alpha', ((callMethodFromClass('flixel.math.FlxMath', 'fastSin', {timer}) * 0.5) + (getProperty('glitchBump.alpha') * 0.75)) * getProperty('dad.alpha'))
    else
        timer = 0
        setProperty('school.alpha', 0)
    end

    if getProperty('glitchBump.alpha') > 0 then
        setProperty('glitchBump.alpha', getProperty('glitchBump.alpha') - elapsed)
    end

    setShaderFloat('nullGlitch', 'glitchAmplitude', getShaderFloat('nullGlitch', 'glitchAmplitude') - 0.001 * elapsed)
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