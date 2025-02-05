local canPlayVideo = true

local loadAmount = 0
local loadFloat = 0.0
local loadRate = 15.0
local curLoad = 0

local timeSinceLastPress = 0
local timeWithoutPressing = 2

local allowedToLoad = true
local isLoading = false

local hasEnded = false
local startedCutscene = false
local canLeave = true

local quickSwitch = true

luaDebugMode = true
function onGameOver()
    openCustomSubstate('gameover', true)
    return Function_Stop
end

function onCustomSubstateCreate(name)
    if name == 'gameover' then
        setProperty('endingSong', true)
        setProperty('camGame.visible', false) -- some optimization lol
        setProperty('camHUD.alpha', 0)
        setProperty('camZoomingMult', 0)
        setProperty('camZooming', false)
        startedCutscene = true
        setProperty('vocals.volume', 0)
        startGameOverVideo('gameovers/gf death cutscene')

        runTimer('GAMEOVER', 7)
    end
end

function onCustomSubstateUpdate(name, elapsed)
    if name == 'gameover' then
        if not startedCutscene then return end
        if hasEnded then return end

        loadAmount = tonumber(loadFloat)

        if curLoad ~= loadAmount then
            playAnim('loading', loadAmount, true)
            curLoad = loadAmount
        end

        if isLoading and (timeSinceLastPress >= timeWithoutPressing) then
            onSpaceNotPressed()
            isLoading = false
            timeSinceLastPress = 0
        end

        if not allowedToLoad then
            if loadAmount > 0 then
                loadFloat = loadFloat - loadRate * elapsed
                setProperty('loading.alpha', getProperty('loading.alpha') - 1 * elapsed)
            else
                allowedToLoad = true
            end
            return
        end

        if not canLeave then return end

        if getProperty('controls.ACCEPT') or touchedScreen() then
            if quickSwitch then
                canLeave = false
                runHaxeCode("FlxG.sound.music.stop();")
                startAndEnd()
            else
                canLeave = false
                runHaxeCode("FlxG.sound.music.stop();")
                playSound('../music/bloodlust game over end')

                setProperty('gameOverText2.alpha', 1)
                startTween('textScale', 'gameOverText2.scale', {x = 1.3, y = 1.3}, 4, {ease = 'sineIn'})
                startTween('title', 'titleBlack', {alpha = 1}, 4, {ease = 'sineIn'})

                runTimer('restartTheSong', 4)
            end
        else
            timeSinceLastPress = timeSinceLastPress + elapsed
        end
    end
end

function onTimerCompleted(tag)
    if tag == 'GAMEOVER' then
        startTween('textAlpha', 'gameOverText', {alpha = 1, ['scale.x'] = 1.1, ['scale.y'] = 1.1}, 2, {ease = 'sineOut'})
        quickSwitch = false

        playMusic('bloodlust game over loop', 0, true)
        runHaxeCode("FlxG.sound.music.fadeIn(2, 0, 1);")
    end

    if tag == 'restartTheSong' then
        startAndEnd()
    end
end

function onSpaceNotPressed()
    allowedToLoad = false
end

function onCreatePost()
    makeLuaSprite('blackBottom', '../assets/stages/fullBlack')
    setScrollFactor('blackBottom', 0, 0)
    scaleObject('blackBottom', 1.7, 1.7, false)
    setProperty('blackBottom.alpha', 0.001)
    addLuaSprite('blackBottom')

    makeAnimatedLuaSprite('loading', '../assets/loading circle')
    for i = 0, 16 do -- why in the OG code they didn't used a loop for this ☠
        addAnimationByPrefix('loading', i, i..'load', 24, true)
    end
    playAnim('loading', '0', true)
    setScrollFactor('loading', 0, 0)
    scaleObject('loading', 0.5, 0.5, false)
    setProperty('loading.antialiasing', true)
    setProperty('loading.alpha', 1)
    setProperty('loading.blend', 0)
    runHaxeCode("game.getLuaObject('loading').camera = getVar('camOverlay');")
    setProperty('loading.x', 1180) setProperty('loading.y', 630)

    makeLuaSprite('gameOverText', '../assets/game over text')
    setProperty('gameOverText.antialiasing', true)
    setProperty('gameOverText.alpha', 0.001)
    runHaxeCode("game.getLuaObject('gameOverText').camera = getVar('camOverlay');")
    setObjectOrder('gameOverText', getObjectOrder('lowVin')+1)
    addLuaSprite('gameOverText', true)

    makeLuaSprite('gameOverText2', '../assets/game over text2')
    setProperty('gameOverText2.antialiasing', true)
    setProperty('gameOverText2.alpha', 0.001)
    runHaxeCode("game.getLuaObject('gameOverText2').camera = getVar('camOverlay');")
    setObjectOrder('gameOverText2', getObjectOrder('gameOverText')+1)
    addLuaSprite('gameOverText2', true)

    makeLuaSprite('titleBlack', '../assets/stages/fullBlack')
    setScrollFactor('titleBlack', 0, 0)
    scaleObject('titleBlack', 1.7, 1.7, false)
    setObjectOrder('titleBlack', getObjectOrder('gameOverText2')+1)
    addLuaSprite('titleBlack', true)
    runHaxeCode("game.getLuaObject('titleBlack').camera = getVar('camOverlay');")
    startTween('titletween', 'titleBlack', {alpha = 0}, 1, {eaase = 'sineOut'})
end

function startGameOverVideo(name)
    setProperty('blackBottom.alpha', 1)

    if buildTarget == 'windows' then
        makeVideoSprite('gameover', name, 0, 0, 'camGame', false)
        setScrollFactor('gameover', 0, 0)
        runHaxeCode("game.getLuaObject('gameover').camera = getVar('camOverlay');")
    else
        createInstance('gameover', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
        setScrollFactor('gameover', 0, 0)
        runHaxeCode("getVar('gameover').camera = getVar('camOverlay');")
        setObjectOrder('gameover', getObjectOrder('titleBlack')+1)
        addInstance('gameover')
        callMethod('gameover.startVideo', {callMethodFromClass('backend.Paths', 'video', {name})})
    end

    addLuaSprite('loading')
    setObjectOrder('loading', getObjectOrder('gameover')+1)
end

function startAndEnd()
    hasEnded = true
    startTween('loadBye', 'loading', {alpha = 0}, 2, {ease = 'quadOut'})
    closeCustomSubstate()
    restartSong()
end

function touchedScreen()
    local mX, mY = getMouseX('camOther') + getProperty('camOther.scroll.x'), getMouseY('camOther') + getProperty('camOther.scroll.y')
    local x, y = getProperty('camOther.x'), getProperty('camOther.y')
    return mouseClicked() and (mX > x) and (mX < x + screenWidth) and (mY > y) and (mY < y + screenHeight)
end