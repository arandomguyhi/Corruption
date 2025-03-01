local path = '../assets/menus/'

local selectedDiff = 1
local selectedModDiff = 2

local whichSelected = 0

setVar('settingStory')

luaDebugMode = true

function onCreate()
end

function onCustomSubstateCreate(name)
    if name == 'diffSelector' then
        if not getVar('settingStory') then
            whichSelected = 1
        else
            setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
        end

        runHaxeCode([[
            var diffCamera = new FlxCamera();
            diffCamera.bgColor = 0x0;

            FlxG.cameras.remove(game.camHUD, false);
            FlxG.cameras.remove(game.camOther, false);

            for (cams in [diffCamera, game.camHUD, game.camOther])
                FlxG.cameras.add(cams, false);

            setVar('diffCamera', diffCamera);
        ]])

        makeLuaSprite('black') makeGraphic('black', 1, 1, '000000')
        scaleObject('black', screenWidth, screenHeight)
        runHaxeCode("game.getLuaObject('black').camera = getVar('diffCamera');")
        screenCenter('black')
        setProperty('black.alpha', 0.5)
        addLuaSprite('black')

        makeLuaText('canonWarn', "Canon disables ghost-tapping and has higher health loss!", 0, 0, 0)
        setTextFont('canonWarn', 'VollkornRegular-ZVJEZ.ttf')
        setTextColor('canonWarn', 'FF0000')
        setTextSize('canonWarn', 24)
        runHaxeCode("game.getLuaObject('canonWarn').camera = getVar('diffCamera');")
        screenCenter('canonWarn')
        setProperty('canonWarn.visible', false)
        setProperty('canonWarn.y', getProperty('canonWarn.y') - 100)
        if getVar('settingStory') then
            addLuaText('canonWarn') end

        makeLuaSprite('SHART', path..'difficulty/difficulty')
        runHaxeCode("game.getLuaObject('SHART').camera = getVar('diffCamera');")
        screenCenter('SHART')
        setProperty('SHART.x', getProperty('SHART.x') - (getProperty('SHART.width') / 2)+15)

        makeLuaSprite('modshart', path..'difficulty/modchart')
        runHaxeCode("game.getLuaObject('modshart').camera = getVar('diffCamera');")
        screenCenter('modshart')
        setProperty('modshart.x', getProperty('modshart.x') - (getProperty('modshart.width') / 2)+15)

        makeLuaSprite('selectorLeft', path..'difficulty/selector')
        runHaxeCode("game.getLuaObject('selectorLeft').camera = getVar('diffCamera');")
        screenCenter('selectorLeft')
        setProperty('selectorLeft.x', getProperty('selectorLeft.x') - 320)
        addLuaSprite('selectorLeft')

        makeLuaSprite('selectorRight', path..'difficulty/selector')
        setProperty('selectorRight.flipX', true)
        runHaxeCode("game.getLuaObject('selectorRight').camera = getVar('diffCamera');")
        screenCenter('selectorRight')
        setProperty('selectorRight.x', getProperty('selectorRight.x') + 280)
        addLuaSprite('selectorRight')

        makeLuaSprite('SHARTdiff', nil, 146, 24)
        loadGraphic('SHARTdiff', path..'difficulty/diffs', 146, 24)
        addAnimation('SHARTdiff', 'easy', {0}, 0, false)
        addAnimation('SHARTdiff', 'normal', {1}, 0, false)
        addAnimation('SHARTdiff', 'hard', {2}, 0, false)
        playAnim('SHARTdiff', 'normal', true)
        runHaxeCode("game.getLuaObject('SHARTdiff').camera = getVar('diffCamera');")
        screenCenter('SHARTdiff')
        setProperty('SHARTdiff.x', getProperty('SHARTdiff.x') + (getProperty('SHARTdiff.width') / 2)+15)

        makeLuaSprite('modshartdiff', nil, 146, 24)
        loadGraphic('modshartdiff', path..'difficulty/moddiffs', 117, 25)
        addAnimation('modshartdiff', 'easy', {0}, 0, false)
        addAnimation('modshartdiff', 'normal', {1}, 0, false)
        addAnimation('modshartdiff', 'hard', {2}, 0, false)
        playAnim('modshartdiff', 'normal', true)
        runHaxeCode("game.getLuaObject('modshartdiff').camera = getVar('diffCamera');")
        screenCenter('modshartdiff')
        setProperty('modshartdiff.x', getProperty('modshartdiff.x') + (getProperty('SHARTdiff.width') / 2)+15)
        addLuaSprite('modshartdiff')

        makeLuaSprite('confirm', path..'difficulty/confirm')
        runHaxeCode("game.getLuaObject('confirm').camera = getVar('diffCamera');")
        screenCenter('confirm')
        setProperty('confirm.x', getProperty('confirm.x') - 15)
        setProperty('confirm.y', getProperty('confirm.y') + 200)
        addLuaSprite('confirm')

        setProperty('selectorLeft.y', getProperty('modshart.y'))
        if getVar('settingStory') then
            setProperty('modshart.y', getProperty('modshart.y') + 50)
            setProperty('modshartdiff.y', getProperty('modshartdiff.y') + 50)
            setProperty('SHART.y', getProperty('SHART.y') - 50)
            setProperty('selectorLeft.y', getProperty('SHART.y'))
            setProperty('SHARTdiff.y', getProperty('SHARTdiff.y') - 50)
            addLuaSprite('SHART')
            addLuaSprite('SHARTdiff')
        end
        addLuaSprite('modshart')

        setProperty('diffCamera.alpha', 0)
        startTween('choose', 'diffCamera', {alpha = 1}, 1, {ease = 'quadOut'})
    end
end

local anims = {'easy', 'normal', 'hard'}

local diffs = {'safe', 'normal', 'canon'}
local modcharts = {'None', 'Simple', 'Full'}

function onCustomSubstateUpdate(name, elapsed)
    if name == 'diffSelector' then
        if not getVar('settingStory') then
            if keyJustPressed('up') or keyJustPressed('down') then
                whichSelected = (whichSelected == 1 and 2 or 1)
                playSound('scrollMenu')
            end
        else
            if keyJustPressed('up') then
                playSound('scrollMenu')
                whichSelected = whichSelected - 1
            elseif keyJustPressed('down') then
                playSound('scrollMenu')
                whichSelected = whichSelected + 1
            end

            if whichSelected < 0 then
                whichSelected = 2
            elseif whichSelected > 2 then
                whichSelected = 0
            end
        end

        if keyJustPressed('left') then
            if whichSelected == 0 then
                selectedDiff = selectedDiff - 1
            elseif whichSelected == 1 then
                selectedModDiff = selectedModDiff - 1
            end
            playSound('scrollMenu')
        elseif keyJustPressed('right') then
            if whichSelected == 0 then
                selectedDiff = selectedDiff + 1
            elseif whichSelected == 1 then
                selectedModDiff = selectedModDiff + 1
            end
            playSound('scrollMenu')
        end
        
        setVar('selectedDiff', selectedDiff)

        if selectedDiff < 0 then
            selectedDiff = 2
        elseif selectedDiff > 2 then
            selectedDiff = 0
        end

        if selectedModDiff < 0 then
            selectedModDiff = 2
        elseif selectedModDiff > 2 then
            selectedModDiff = 0
        end

        if whichSelected == 0 then
            setProperty('modshart.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('modshart.alpha'), 0.5, elapsed * 60 * 0.3}))
            setProperty('SHART.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('SHART.alpha'), 1, elapsed * 60 * 0.3}))
            setProperty('confirm.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('confirm.alpha'), 0.5, elapsed * 60 * 0.3}))
            setProperty('selectorLeft.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorLeft.x'), 305, elapsed * 60 * 0.3}))
            setProperty('selectorRight.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorRight.x'), 905, elapsed * 60 * 0.3}))
            setProperty('selectorLeft.y', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorLeft.y'), getProperty('SHART.y'), elapsed * 60 * 0.3}))
        elseif whichSelected == 1 then
            setProperty('modshart.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('modshart.alpha'), 1, elapsed * 60 * 0.3}))
            setProperty('SHART.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('SHART.alpha'), 0.5, elapsed * 60 * 0.3}))
            setProperty('confirm.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('confirm.alpha'), 0.5, elapsed * 60 * 0.3}))
            setProperty('selectorLeft.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorLeft.x'), 305, elapsed * 60 * 0.3}))
            setProperty('selectorRight.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorRight.x'), 905, elapsed * 60 * 0.3}))
            setProperty('selectorLeft.y', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorLeft.y'), getProperty('modshart.y'), elapsed * 60 * 0.3}))
        elseif whichSelected == 2 then
            setProperty('modshart.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('modshart.alpha'), 0.5, elapsed * 60 * 0.3}))
            setProperty('SHART.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('SHART.alpha'), 0.5, elapsed * 60 * 0.3}))
            setProperty('confirm.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('confirm.alpha'), 1, elapsed * 60 * 0.3}))
            setProperty('selectorLeft.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorLeft.x'), 405, elapsed * 60 * 0.3}))
            setProperty('selectorRight.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorRight.x'), 845, elapsed * 60 * 0.3}))
            setProperty('selectorLeft.y', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('selectorLeft.y'), getProperty('confirm.y'), elapsed * 60 * 0.3}))
        end

        setProperty('canonWarn.visible', selectedDiff == 2)
        setProperty('selectorRight.y', getProperty('selectorLeft.y'))
        setProperty('SHARTdiff.alpha', getProperty('SHART.alpha'))
        setProperty('modshartdiff.alpha', getProperty('modshart.alpha'))

        playAnim('SHARTdiff', anims[selectedDiff+1], true)
        playAnim('modshartdiff', anims[selectedModDiff+1], true)

        if whichSelected == 2 then
            if getProperty('controls.ACCEPT') then
                setDataFromSave('corruptMenu', 'modcharts', modcharts[selectedModDiff+1])
                if getVar('settingStory') then
                    setDataFromSave('corruptMenu', 'difficulty', diffs[selectedDiff+1])
                end
                
                playSound('confirmMenu')
                closeCustomSubstate()
                callOnLuas('onConfirm')
            end
        end

        if getProperty('controls.BACK') and not getVar('settingStory') then
            closeCustomSubstate()
            callOnLuas('subClose')
        end
    end
end

function onCustomSubstateDestroy(name)
    if name == 'diffSelector' then
        runHaxeCode("FlxG.cameras.remove(getVar('diffCamera'), true);")
    end
end