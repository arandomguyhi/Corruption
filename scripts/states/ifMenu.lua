luaDebugMode = true

local path = '../assets/menus/'
local canSelect = true

function onCreate()
    makeLuaSprite('bg', path..'if/bgBase')
    setScrollFactor('bg', 0, 0)
    scaleObject('bg', 1.7, 1.7, false)
    addLuaSprite('bg', true)

    makeLuaSprite('cloud', path..'if/cloudScroll', -2330, 0)
    setScrollFactor('cloud', 0, 0)
    scaleObject('cloud', 1.7, 1.7, false)
    addLuaSprite('cloud', true)
    setProperty('cloud.alpha', 0)
    setProperty('cloud.blend', 11)
    startTween('moveTween', 'cloud', {x = -880, alpha = 0.6}, 10, {onComplete = 'cloudEase1'})

    makeLuaSprite('disk', path..'if/spinnyDisk', 379, 267)
    setScrollFactor('disk', 0, 0)
    scaleObject('disk', 1.7, 1.7, false)
    addLuaSprite('disk', true)
    setProperty('disk.alpha', 0)
    doTweenAlpha('dskAlpha', 'disk', 0.8, 10)

    makeLuaSprite('falsethorn', path..'if/falsethorn', 700, 0)
    setScrollFactor('falsethorn', 0, 0)
    scaleObject('falsethorn', 1.7, 1.7, false)
    addLuaSprite('falsethorn', true)
    setProperty('falsethorn.alpha', 0)
    startTween('thornTween', 'falsethorn', {alpha = 1, x = 0}, 2, {ease = 'circOut'})

    makeLuaSprite('bf', path..'if/bf', -700, 0)
    setScrollFactor('bf', 0, 0)
    scaleObject('bf', 1.7, 1.7, false)
    addLuaSprite('bf', true)
    setProperty('bf.alpha', 0)
    startTween('bfTween', 'bf', {alpha = 1, x = 0}, 2, {ease = 'circOut'})

    makeLuaSprite('bars', path..'if/bars')
    setScrollFactor('bars', 0, 0)
    scaleObject('bars', 1.7, 1.7, false)
    addLuaSprite('bars', true)

    makeLuaSprite('logo', path..'if/logo')
    setScrollFactor('logo', 0, 0)
    scaleObject('logo', 1.7, 1.7, false)
    addLuaSprite('logo', true)
    setProperty('logo.alpha', 0)
    setProperty('logo.antialiasing', true)
    startTween('logoTween', 'logo', {alpha = 1, x = 0}, 3, {ease = 'circIn'})

    makeLuaSprite('songName', path..'if/songName')
    setScrollFactor('songName', 0, 0)
    scaleObject('songName', 1.7, 1.7, false)
    addLuaSprite('songName', true)
    setProperty('songName.alpha', 0)
    startTween('songTween', 'songName', {alpha = 1, x = 0}, 4, {ease = 'circIn'})

    playMusic('menu6', 1, true)

    makeAnimatedLuaSprite('transition', path..'burnTransition')
    addAnimationByPrefix('transition', 'idle', 'burnTransition idle', 24, false)
    playAnim('transition', 'idle', true)
    setScrollFactor('transition', 0, 0)
    scaleObject('transition', 2.5, 2.5, false)
    setProperty('transition.antialiasing', true)
    setProperty('transition.alpha', 0)
    setProperty('transition.blend', 9)
    addLuaSprite('transition', true)
    setPosition('transition', 150, 119)

    makeLuaSprite('titleBlack', path..'mainmenu/fullBlack')
    setScrollFactor('titleBlack', 0, 0)
    scaleObject('titleBlack', 1.7, 1.7, false)
    setProperty('titleBlack.alpha', 0)
    addLuaSprite('titleBlack', true)
end

function onCreatePost()
    callMethod('camGame.scroll.set', {951 - (screenWidth/2), -270 - (screenHeight/2)})
    callMethod('camFollow.setPosition', {951, -270})

    setProperty('camGame.zoom', 0.593)
end

function onUpdate(elapsed)
    inputShit()

    setProperty('disk.angle', getProperty('disk.angle') + 100 * elapsed)
end

function cloudEase1()
    cancelTween('moveTween')
    startTween('moveTween', 'cloud', {x = 610, alpha = 0}, 10, {onComplete = 'cloudEase2'})
end

function cloudEase2()
    cancelTween('moveTween')

    setProperty('cloud.x', -2330)
    startTween('moveTween', 'cloud', {x = -880, alpha = 0.6}, 10, {onComplete = 'cloudEase1'})
end

function inputShit()
    if not canSelect then return end

    if getProperty('controls.ACCEPT') then
        canSelect = false
        playSound('confirmMenu')
        startStoryMode()
    end

    if keyJustPressed('left') or keyJustPressed('right') then
        playSound('scrollMenu')
    end

    if getProperty('controls.BACK') then
        canSelect = false
        playSound('confirmMenu')
        leaveScene()
    end
end

function startStoryMode()
    startTween('initialTween', 'camGame', {zoom = 0.8}, 1.2, {ease = 'backIn', onComplete = 'storyTweenZoom'})

    playSound('confirmMenu')
    playSound('water rush')

    runTimer('transition', 0.75)
    runTimer('cover black', 1.7)
    onTimerCompleted = function(tag)
        if tag == 'transition' then
            setProperty('transition.alpha', 1)
            playAnim('transition', 'idle', true)
        end
    
        if tag == 'cover black' then
            setProperty('titleBlack.alpha', 1)
        end
    end
end

function storyTweenZoom()
    runHaxeCode("FlxG.sound.music.fadeOut(1.5, 0);")
    startTween('initialTween', 'camGame', {zoom = 6}, 1.5, {})

    runTimer('pretence', 1.5)
    onTimerCompleted = function(tag)
        if tag == 'pretence' then
            loadSong('pretence')
        end
    end
end

function leaveScene()
    setDataFromSave('corruptMenu', 'if', false)
    setDataFromSave('corruptMenu', 'main', true)
    restartSong()
end

function setPosition(obj, x, y)
    setProperty(obj..'.x', x)
    setProperty(obj..'.y', y)
end