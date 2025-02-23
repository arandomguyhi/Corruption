addHaxeLibrary('FlxTypedGroup', 'flixel.group')
addHaxeLibrary('FlxTypedSpriteGroup', 'flixel.group')
addHaxeLibrary('FlxSound', 'flixel.system')

showTitle = true

local titleScreen = {}
local optionText = {}
local selectedText = {}
local optionBg = {}
local freeplayText = {}
local freeplaySelectedText = {}
local freeplayBg = {}
local difficulties = {}

local middle = {}
local right = {}

local curSelected = 0
local curSelectedFreeplay = 0
local prevSelectedFreeplay = 0
local curDiff = 0
local curSelectedExtra = 0
local selectedSomethin = false
local canSelect = true
local curMenu = 'title' -- initial state

-- shader stuff
initLuaShader('waves')
initLuaShader('blur')
initLuaShader('lens')
local increaseTime = 0
local blurAmount = 0.00
local maxBlur = 0.05
local blurAngle = 90

local menuRevealed = false
local path = '../assets/menus/'

precacheImage(path..'mainmenu/bubbles')

setProperty('skipCountdown', true)
setProperty('isCameraOnForcedPos', true)

luaDebugMode = true

function onPause()
    return Function_Stop
end

function onCreate()
    runHaxeCode([[
        var middle = new FlxTypedSpriteGroup();
        add(middle);
        setVar('middle', middle);

        var right = new FlxTypedSpriteGroup();
        add(right);
        setVar('right', right);
    ]])

    values = {
        {target = 0, desired = 0, speed = 10.0, prev = 0},
        {target = 0, desired = 0, speed = 10.0, prev = 50},
        {target = 0, desired = 0, speed = 10.0, prev = 30},
        {target = 0, desired = 0, speed = 20.0, prev = 10},
        {target = 0, desired = 0, speed = 10.0, prev = 5},
        {target = 0, desired = 0, speed = 20.0, prev = 0}
    }

    addMiddleShit()
    addRightShit()
    --addExtraShit()
    addTextShit()
    addFreeplayText()

    makeLuaSprite('blackCovering') makeGraphic('blackCovering', 3000, 3000, '000000')
    addLuaSprite('blackCovering', true)
    setScrollFactor('blackCovering', 0, 0)
    scaleObject('blackCovering', 2, 2, false)

    if showTitle then
        addTitleShit() end

    makeAnimatedLuaSprite('transition', path..'burnTransition')
    addAnimationByPrefix('transition', 'idle', 'burnTransition idle', 24, false)
    playAnim('transition', 'idle', true)
    setScrollFactor('transition', 0, 0)
    scaleObject('transition', 2.5, 2.5, false)
    setProperty('transition.antialiasing', true)
    setProperty('transition.alpha', 0)
    setProperty('transition.alpha', 9)
    addLuaSprite('transition')
    setPosition('transition', 150, 119)

    if not showTitle then
        return end

    makeLuaSprite('blackTop', path..'mainmenu/fullBlack', 10, -20)
    addLuaSprite('blackTop', true)
    setScrollFactor('blackTop', 0, 0)
    scaleObject('blackTop', 1.7, 1.7, false)

    makeLuaSprite('titlePart6', path..'title/title6', 740, -870)
    addLuaSprite('titlePart6', true)

    doTweenAlpha('blackieTop', 'blackTop', 0, 3, 'sineInOut')

    startTween('harvesterEye', 'titlePart6', {alpha = 0.1}, 6, {ease = 'sineInOut', type = 'pingpong'})
end

function onCreatePost()
    for _, cu in pairs({'camHUD', 'boyfriend', 'gf', 'dad'}) do
        setProperty(cu..'.visible', false) end

    callMethod('camGame.scroll.set', {951 - (screenWidth/2), -270 - (screenHeight/2)})
    callMethod('camFollow.setPosition', {951, -270})

    setProperty('camGame.zoom', 0.593)

    addShaderShit()
    callMethod('right.setPosition', {2510, 0})

    updateDifficulty()

    for i = 0, 6 do
        precacheMusic('menu'..i)
    end
    playMusic('menu5')

    if not showTitle then
        enterMain(true) end
end

function onUpdatePost()
    setShaderFloat('blur', 'strength', blurAmount)
    setShaderFloat('blur', 'angle', blurAngle)
end

function enterMain(skipTransition)
    curMenu = 'main'
    if skipTransition then
        if luaSpriteExists('blackCovering') then
            setProperty('blackCovering.alpha', 0) end
        if luaSpriteExists('titlePart1') then
            setProperty('titlePart1.alpha', 1) end
        setProperty('bfFloat.y', getProperty('bfFloat.y') + 10)
        setProperty('camFollow.y', 570)
        playMusic('menu0')

        setShaderFloat('lens', 'ushaderStrength', 0.5)

        for i = 1, 4 do
            setProperty('optionText.members['..i..'].alpha', 0.2)
        end

        setProperty('selectedText.members[0].alpha', 1)
        setProperty('optionBg.members[0].alpha', 0.2)
        canSelect = true
        menuRevealed = true
    else
        cancelTween('harvesterEye')

        playSound('confirmMenu')

        startTween('initialTween', 'camFollow', {y = 570}, 6, {ease = 'backOut'})
        startTween('hiBf', 'bfFloat', {y = getProperty('bfFloat.y') + 10}, 15, {ease = 'sineInOut'})

        playBubbleAnimation()
        playMusic('menu0')

        if not menuRevealed then
            revealMainMenuTexts()
            hideTitleShit()
        else
            runTimer('canSelect', 1)
        end

        if luaSpriteExists('blackCovering') and luaSpriteExists('titlePart1') then
            doTweenAlpha('blackCover'--[[hehe]], 'blackCovering', 0, 1, 'sineInOut')
            doTweenAlpha('part1', 'titlePart1', 0, 0.5, 'sineInOut')
        end
    
        runHaxeCode([[
            FlxTween.num(0.0, 0.5, 0.8, {ease: FlxEase.sineInOut}, function(hi) {
                game.callOnLuas('setShaderFloat', ['lens', 'ushaderStrength', hi]);
            });
        ]])
    end
end

function hideTitleShit()
    runTimer('titleParts', 0.001)
    runTimer('titleParts2', 0.1)
    runTimer('titleParts3', 0.2)
end

function addTitleShit()
    runHaxeCode([[
        var titleScreen = new FlxTypedSpriteGroup();
        add(titleScreen);
        titleScreen.setPosition(740, -870);
        titleScreen.scale.set(1.1,1.1);
        setVar('titleScreen', titleScreen);
    ]])

    makeLuaSprite('titlePart0', path..'title/title0')
    addToGrp('titleScreen', 'titlePart0')

    makeLuaSprite('titlePart1', path..'title/title1', 0, 164)
    addToGrp('titleScreen', 'titlePart1')

    makeLuaSprite('titlePart2', path..'title/title2')
    addToGrp('titleScreen', 'titlePart2')

    makeLuaSprite('titlePart3', path..'title/title3')
    addToGrp('titleScreen', 'titlePart3')

    makeLuaSprite('titlePart4', path..'title/title4')
    addToGrp('titleScreen', 'titlePart4')

    makeLuaSprite('titlePart5', path..'title/title5')
    addToGrp('titleScreen', 'titlePart5')

    makeLuaSprite('titleLogo', path..'title/titleLogo', -870, -770)
    scaleObject('titleLogo', 0.38, 0.38, false)
    addLuaSprite('titleLogo', true)
end

function onUpdate(elapsed)
    increaseTime = increaseTime + elapsed
    setShaderFloat('water', 'iTime', increaseTime)
    setShaderFloat('lens', 'iTime', increaseTime)
    setShaderFloat('blur', 'iTime', increaseTime)

    inputShit()

    if curMenu ~= 'freeplay' then return end

    for i = 1, 6 do
        local step = values[i].speed * elapsed

        if values[i].target < values[i].desired then
            values[i].target = values[i].target + step
            if values[i].target > values[i].desired then
                values[i].target = values[i].desired
            end
        elseif values[i].target > values[i].desired then
            values[i].target = values[i].target - step
            if values[i].target < values[i].desired then
                values[i].target = values[i].desired
            end
        end

        if math.floor(values[i].target) ~= math.floor(values[i].prev) then
            if i == 1 then
                playAnim('num1', math.floor(values[i].target), true)
            elseif i == 2 then
                playAnim('num2', math.floor(values[i].target), true)
            elseif i == 3 then
                playAnim('num3', math.floor(values[i].target), true)
            elseif i == 4 then
                playAnim('num4', math.floor(values[i].target), true)
                playSound('clockTick'..getRandomInt(0,4))
            elseif i == 5 then
                playAnim('num5', math.floor(values[i].target), true)
            elseif i == 6 then
                playAnim('num6', math.floor(values[i].target), true)
            end
            values[i].prev = values[i].target
        end
    end
end

function easierTweenRight()
    startTween('initialTween', 'camFollow', {x = 5221, y = 570}, 0.8, {ease = 'backOut'})
end

function inputShit()
    if not canSelect then return end

    if getProperty('controls.ACCEPT') then
        if curMenu == 'title' then
            canSelect = false
            enterMain(false)
        elseif curMenu == 'freeplay' then
            playSound('confirmMenu')
        elseif curMenu== 'extras' then
            if curSelectedExtra == 0 then
                startIf()
            else
                startSidestory()
            end
        else
            checkSelection(curSelected)
        end
    end

    if getProperty('controls.BACK') then
        if curMenu ~= 'title' and curMenu ~= 'main' then
            backOut()
        end
    end

    if keyJustPressed('up') then
        playSound('scrollMenu')

        if curMenu == 'main' then
            curSelected = curSelected - 1
            if curSelected < 0 then
                curSelected = 4
            end
        end
        if curMenu == 'freeplay' then
            curSelectedFreeplay = curSelectedFreeplay - 1
            if curSelectedFreeplay < 0 then
                curSelectedFreeplay = 3
            end
        end

        updateOption()
    end

    if keyJustPressed('down') then
        playSound('scrollMenu')

        if curMenu == 'main' then
            curSelected = curSelected + 1
            if curSelected >= 5 then
                curSelected = 0
            end
        end
        if curMenu == 'freeplay' then
            curSelectedFreeplay = curSelectedFreeplay + 1
            if curSelectedFreeplay >= 4 then
                curSelectedFreeplay = 0
            end
        end

        updateOption()
    end

    if keyJustPressed('right') then
        if curMenu == 'extra' then
            playSound('scrollMenu')
            curSelectedExtra = curSelectedExtra + 1
            if curSelectedExtra > 1 then
                curSelectedExtra = 0
            end
            updateOption()
        end

        if curMenu == 'freeplay' then
            playSound('scrollMenu')
            curDiff = curDiff + 1
            if curDiff > 2 then
                curDiff = 0
            end
            setProperty('diffSelectR.alpha', 1)
            startTween('diffSelectRightTween', 'diffSelectR', {alpha = 0.2}, 1, {ease = 'sineOut'})

            updateDifficulty()
        end
    end

    if keyJustPressed('left') then
        if curMenu == 'extra' then
            playSound('scrollMenu')
            curSelectedExtra = curSelectedExtra - 1
            if curSelectedExtra < 0 then
                curSelectedExtra = 1
            end
            updateOption()
        end

        if curMenu == 'freeplay' then
            playSound('scrollMenu')
            curDiff = curDiff - 1
            if curDiff < 0 then
                curDiff = 2
            end
            setProperty('diffSelectL.alpha', 1)
            startTween('diffSelectLeftTween', 'diffSelectL', {alpha = 0.2}, 1, {ease = 'sineOut'})

            updateDifficulty()
        end
    end

    if prevSelectedFreeplay ~= curSelectedFreeplay then
        prevSelectedFreeplay = curSelectedFreeplay
        updateClock(curSelectedFreeplay)
    end
end

function checkSelection(curSelect)
    cancelTween('initialTween')

    canSelect = false

    if curSelect == 0 then
        startStoryMode()
        curMenu = 'main'
    elseif curSelect == 1 then
        enterFreeplay()
        curMenu = 'freeplay'
        runTimer('canSelect', 1)
    elseif curSelect == 2 then
        enterSettings()
        curMenu = 'options'
        runTimer('canSelect', 1)
    elseif curSelect == 3 then
        enterExtras()
        curMenu = 'extras'
        runTimer('canSelect', 1)
    elseif curSelect == 4 then
        enterCredits()
        curMenu = 'credits'
    end
    playMusic('menu'..curSelect)
    playSound('confirmMenu')
end

function enterFreeplay()
    runTimer('clock update', 0.75)

    maxBlur = 0.05
    blurAngle = 90
    startTween('initialTween', 'camFollow', {x = 4800}, 0.6, {ease = 'circIn', onComplete = 'easierTweenRight'})
    
    runHaxeCode([[
        FlxTween.num(0.0, ]]..maxBlur..[[, 0.3, {ease: FlxEase.quadIn, onComplete: function(b) {
            parentLua.call('hideBlur');
        }}, function(hi) {
            parentLua.call('blurAmount', [hi]);
        });
    ]])
end

function hideBlur()
    runHaxeCode([[
        FlxTween.num(]]..maxBlur..[[, 0.0, 0.5, null, function(hi) {
           parentLua.call('blurAmount', [hi]); 
        });
    ]])
end

function blurAmount(val)
    blurAmount = val
end

function updateOption()
    if curMenu == 'extras' then
        if curSelectedExtra == 0 then
            setProperty('ifBg.alpha', 0.2)
            setProperty('ifSelected.alpha', 1)
            setProperty('ifText.alpha', 0)

            setProperty('sidestoryBg.alpha', 0)
            setProperty('sidestorySelected.alpha', 0)
            setProperty('sidestoryText.alpha', 0)
        else
            setProperty('ifBg.alpha', 0)
            setProperty('ifSelected.alpha', 0)
            setProperty('ifText.alpha', 0.2)

            setProperty('sidestoryBg.alpha', 0.2)
            setProperty('sidestorySelected.alpha', 1)
            setProperty('sidestoryText.alpha', 0)
        end
        return
    end

    for i = 0, 3 do
        if i == curSelectedFreeplay then
            setProperty('freeplayText.members['..i..'].alpha', 0)
            setProperty('freeplaySelectedText.members['..i..'].alpha', 1)
            setProperty('freeplayBg.members['..i..'].alpha', 0.2)

            callMethod('freeplaySelectedText.members['..i..'].scale.set', {1.2, 1.2})
            callMethod('freeplayBg.members['..i..'].scale.set', {1.2, 1.2})
        else
            setProperty('freeplayText.members['..i..'].alpha', 0.2)
            setProperty('freeplaySelectedText.members['..i..'].alpha', 0)
            setProperty('freeplayBg.members['..i..'].alpha', 0)

            callMethod('freeplaySelectedText.members['..i..'].scale.set', {1.1, 1.1})
            callMethod('freeplayBg.members['..i..'].scale.set', {1.1, 1.1})
        end
    end

    for i = 0, 4 do
        if i == curSelected then
            setProperty('optionText.members['..i..'].alpha', 0)
            setProperty('selectedText.members['..i..'].alpha', 1)
            setProperty('optionBg.members['..i..'].alpha', 0.2)

            callMethod('selectedText.members['..i..'].scale.set', {0.8, 0.8})
            callMethod('optionBg.members['..i..'].scale.set', {0.8, 0.8})
        else
            setProperty('optionText.members['..i..'].alpha', 0.2)
            setProperty('selectedText.members['..i..'].alpha', 0)
            setProperty('optionBg.members['..i..'].alpha', 0)

            callMethod('selectedText.members['..i..'].scale.set', {0.75, 0.75})
            callMethod('optionBg.members['..i..'].scale.set', {0.75, 0.75})
        end
    end
end

function updateDifficulty()
    cancelTween('diffTween')

    for i = 0, 2 do
        if i == curDiff then
            setProperty('difficulties.members['..i..'].alpha', 1)
            startTween('diffTween', 'difficulties.members['..i..']', {alpha = 0.2}, 4, {ease = 'sineOut'})
        else
            setProperty('difficulties.members['..i..'].alpha', 0)
        end
    end
end

function updateClock(which)
    if which == 0 then
        values[1].desired = 2
        values[1].target = 6
        values[2].desired = 3
        values[2].target = 5
        values[3].desired = 5
        values[3].target = 9
        values[4].desired = 9
        values[4].target = 0
        values[5].desired = 0
        values[5].target = 4
        values[6].desired = 9
        values[6].target = 5
    elseif which == 1 then
        values[1].desired = 0
        values[1].target = 5
        values[2].desired = 0
        values[2].target = 3
        values[3].desired = 0
        values[3].target = 4
        values[4].desired = 2
        values[4].target = 9
        values[5].desired = 1
        values[5].target = 4
        values[6].desired = 0
        values[6].target = 5
    elseif which == 2 then
        values[1].desired = 0
        values[1].target = 4
        values[2].desired = 0
        values[2].target = 5
        values[3].desired = 0
        values[3].target = 4
        values[4].desired = 8
        values[4].target = 0
        values[5].desired = 1
        values[5].target = 4
        values[6].desired = 0
        values[6].target = 5
    elseif which == 3 then
        values[1].desired = 0
        values[1].target = 3
        values[2].desired = 0
        values[2].target = 3
        values[3].desired = 0
        values[3].target = 4
        values[4].desired = 7
        values[4].target = 0
        values[5].desired = 1
        values[5].target = 4
        values[6].desired = 0
        values[6].target = 3
    end
end

function addFreeplayText()
    runHaxeCode([[
        var freeplayBg = new FlxTypedSpriteGroup();
        add(freeplayBg);
        setVar('freeplayBg', freeplayBg);

        var freeplayText = new FlxTypedSpriteGroup();
        add(freeplayText);
        setVar('freeplayText', freeplayText);

        var freeplaySelectedText = new FlxTypedSpriteGroup();
        add(freeplaySelectedText);
        setVar('freeplaySelectedText', freeplaySelectedText);

        var difficulties = new FlxTypedSpriteGroup();
        add(difficulties);
        setVar('difficulties', difficulties);
    ]])

    for i = 0, 3 do
        makeAnimatedLuaSprite('freeTextBg'..i, path..'freeplay/freeplayButtons', 1030, -190)
        addAnimationByPrefix('freeTextBg'..i, 'idle', 's'..i, 0, true)
        playAnim('freeTextBg'..i, 'idle')
        scaleObject('freeTextBg'..i, 1.2, 1.2, false)
        setProperty('freeTextBg'..i..'.alpha', 0)
        setProperty('freeTextBg'..i..'.blend', 0)
        addToGrp('freeplayBg', 'freeTextBg'..i)

        makeAnimatedLuaSprite('freeTextOpt'..i, path..'freeplay/freeplayButtons', 1030, -190)
        addAnimationByPrefix('freeTextOpt'..i, 'idle', 't'..i, 0, true)
        playAnim('freeTextOpt'..i, 'idle')
        scaleObject('freeTextOpt'..i, 1.2, 1.2, false)
        setProperty('freeTextOpt'..i..'.alpha', 0)
        setProperty('freeTextOpt'..i..'.blend', 0)
        addToGrp('freeplayText', 'freeTextOpt'..i)

        makeAnimatedLuaSprite('freeTextSel'..i, path..'freeplay/freeplayButtons', 1030, -190)
        addAnimationByPrefix('freeTextSel'..i, 'idle', 'b'..i, 0, true)
        playAnim('freeTextSel'..i, 'idle')
        scaleObject('freeTextSel'..i, 1.2, 1.2, false)
        setProperty('freeTextSel'..i..'.alpha', 0)
        addToGrp('freeplaySelectedText', 'freeTextSel'..i)
    end

    for i = 0, 2 do
        makeLuaSprite('textDiff'..i, path..'freeplay/d'..i)
        setProperty('textDiff'..i..'.alpha', 0)
        addToGrp('difficulties', 'textDiff'..i)
    end

    makeLuaSprite('diffSelectL', path..'freeplay/dSelectLeft', 4660, 150)
    setProperty('diffSelectL.alpha', 0.2)
    addLuaSprite('diffSelectL', true)

    makeLuaSprite('diffSelectR', path..'freeplay/dSelectRight', 4660, 150)
    setProperty('diffSelectR.alpha', 0.2)
    addLuaSprite('diffSelectR', true)

    callMethod('difficulties.setPosition', {4660, 150})

    callMethod('freeplaySelectedText.setPosition', {3410, 400})
    callMethod('freeplayText.setPosition', {3410, 400})
    callMethod('freeplayBg.setPosition', {3410, 400})

    scaleObject('freeplaySelectedText', 1.2, 1.2, false)
    scaleObject('freeplayText', 1.2, 1.2, false)
    scaleObject('freeplayBg', 1.2, 1.2, false)
end

function addTextShit()
    runHaxeCode([[
        var optionBg = new FlxTypedSpriteGroup();
        add(optionBg);
        setVar('optionBg', optionBg);

        var optionText = new FlxTypedSpriteGroup();
        add(optionText);
        setVar('optionText', optionText);

        var selectedText = new FlxTypedSpriteGroup();
        add(selectedText);
        setVar('selectedText', selectedText);

        optionText.scale.set(0.8, 0.8);
        optionText.setPosition(-60, 40);

        selectedText.scale.set(0.8, 0.8);
        selectedText.setPosition(-60, 40);

        optionBg.scale.set(0.8, 0.8);
        optionBg.setPosition(-60, 40);
    ]])

    for i = 0, 4 do
        makeAnimatedLuaSprite('textBg'..i, path..'mainmenu/menuButtons', 954, -156)
        addAnimationByPrefix('textBg'..i, 'idle', 'b'..i, 0, true)
        playAnim('textBg'..i, 'idle')
        scaleObject('textBg'..i, 0.8, 0.8, false)
        setProperty('textBg'..i..'.alpha', 0)
        setProperty('textBg'..i..'.blend', 0)
        addToGrp('optionBg', 'textBg'..i)

        makeAnimatedLuaSprite('textOpt'..i, path..'mainmenu/menuButtons', 954, -156)
        addAnimationByPrefix('textOpt'..i, 'idle', 't'..i, 0, true)
        playAnim('textOpt'..i, 'idle')
        scaleObject('textOpt'..i, 0.75, 0.75, false)
        setProperty('textOpt'..i..'.alpha', 0)
        addToGrp('optionText', 'textOpt'..i)

        makeAnimatedLuaSprite('textSel'..i, path..'mainmenu/menuButtons', 954, -156)
        addAnimationByPrefix('textSel'..i, 'idle', 's'..i, 0, true)
        playAnim('textSel'..i, 'idle')
        scaleObject('textSel'..i, 0.8, 0.8, false)
        setProperty('textSel'..i..'.alpha', 0)
        addToGrp('selectedText', 'textSel'..i)
    end

    --setProperty('optionText.alpha', 0)
end

function revealMainMenuTexts()
    runTimer('reveal1', 0.7)
    runTimer('reveal2', 0.9)
    runTimer('reveal3', 1.1)
    runTimer('reveal4', 1.3)
    runTimer('reveal5', 1.5)
    runTimer('reveal6', 2)
end

function addExtraShit()
    makeLuaSprite('bgRed', path..'mainmenu/RedBg', 54, -336)
    addLuaSprite('bgRed')
    setScrollFactor('bgRed', 0, 0)
    scaleObject('bgRed', 2, 2, false)
    setProperty('bgRed.alpha', 0)

    makeLuaSprite('buildingRed', path..'mainmenu/RedBuildings', -36, -196)
    addLuaSprite('buildingRed')
    setScrollFactor('buildingRed', 0, 0.1)
    scaleObject('buildingRed', 1.8, 1.8, false)
    setProperty('buildingRed.alpha', 0)

    makeLuaSprite('chainRed', path..'mainmenu/chainRed', -276, -1116)
    addLuaSprite('chainRed')
    setScrollFactor('chainRed', 0, 0.3)
    scaleObject('chainRed', 1.8, 1.8, false)
    setProperty('chainRed.alpha', 0)
    setProperty('chainRed.angle', 144)

    makeAnimatedLuaSprite('bfFloatRed', path..'mainmenu/floatingBfRed')
    addAnimationByPrefix('bfFloatRed', 'idle', 'BfFloat', 24, true)
    playAnim('bfFloatRed', 'idle', true)
    setProperty('bfFloatRed.angle', 180)
    setProperty('bfFloatRed.antialiasing', true)
    setPosition('bfFloatRed', 574, 210)
    addLuaSprite('bfFloatRed')
    setProperty('bfFloatRed.alpha', 0)

    makeLuaSprite('ifBg', path..'title/ifBg', -307, 503)
    setProperty('ifBg.alpha', 0)
    addLuaSprite('ifBg')

    makeLuaSprite('ifText', path..'title/ifText', -300, 503-10)
    scaleObject('ifText', 0.9, 0.9, false)
    setProperty('ifText.alpha', 0)
    addLuaSprite('ifText')

    makeLuaSprite('ifSelected', path..'title/ifSelected', -307, 503)
    addLuaSprite('ifSelected')
    setProperty('ifSelected.alpha', 0)

    makeLuaSprite('sidestoryBg', path..'title/sidestoryBg', 883, 504)
    scaleObject('sidestoryBg', 0.9, 0.9, false)
    setProperty('sidestoryBg.alpha', 0)
    addLuaSprite('sidestoryBg')

    makeLuaSprite('sidestoryText', path..'title/sidestoryText', 890, 504-10)
    scaleObject('sidestoryText', 0.8, 0.8, false)
    setProperty('sidestoryText.alpha', 0)
    addLuaSprite('sidestoryText')

    makeLuaSprite('sidestorySelected', path..'title/sidestorySelected', 883, 504)
    scaleObject('sidestorySelected', 0.9, 0.9, false)
    setProperty('sidestorySelected.alpha', 0)
    addLuaSprite('sidestorySelected')
end

function addMiddleShit()
    makeLuaSprite('layer1', path..'mainmenu/layer1', -536, -806)
    addToGrp('middle', 'layer1')
    setScrollFactor('layer1', 0, 0)

    makeLuaSprite('layer2', path..'mainmenu/layer2', -387, -230)
    addToGrp('middle', 'layer2')
    setScrollFactor('layer2', 0.6, 0.1)

    makeLuaSprite('layer3', path..'mainmenu/layer3', 119, -90)
    addToGrp('middle', 'layer3')
    setScrollFactor('layer3', 0.6, 0.15)

    makeLuaSprite('layer4', path..'mainmenu/layer2', -202.3, -575.35)
    addToGrp('middle', 'layer4')
    setScrollFactor('layer4', 0.7, 0.3)
    setProperty('layer4.alpha', 0.5)

    makeAnimatedLuaSprite('bfFloat', path..'mainmenu/floatingBf')
    addAnimationByPrefix('bfFloat', 'idle', 'BfFloat', 24, true)
    playAnim('bfFloat', 'idle', true)
    setProperty('bfFloat.antialiasing', true)
    setPosition('bfFloat', 574, 200)
    addToGrp('middle', 'bfFloat')

    makeLuaSprite('layer5', path..'mainmenu/layer5', -132, -651)
    addToGrp('middle', 'layer5')
    setScrollFactor('layer5', 1.3, 2)
    scaleObject('layer5', 1, 1.5, false)

    makeAnimatedLuaSprite('lightRays', path..'mainmenu/lightRays')
    addAnimationByPrefix('lightRays', 'idle', 'LightRays', 8, true)
    playAnim('lightRays', 'idle', true)

    scaleObject('lightRays', 1.5, 1.5, false)
    setProperty('lightRays.antialiasing', true)
    setPosition('lightRays', -106, -360)
    addToGrp('middle', 'lightRays')
    setScrollFactor('lightRays', 1, 0)

    makeAnimatedLuaSprite('lightRays2', path..'mainmenu/lightRays')
    addAnimationByPrefix('lightRays2', 'idle', 'LightRays', 8, true)
    playAnim('lightRays2', 'idle', true)
    scaleObject('lightRays2', 1.5, 1.5, false)
    setProperty('lightRays2.antialiasing', true)
    setPosition('lightRays2', -106, -160)
    addToGrp('middle', 'lightRays2')
    setScrollFactor('lightRays2', 1, 0)

    makeLuaSprite('blackFade', path..'mainmenu/blackFade', -6, 484)
    addLuaSprite('blackFade')
    setScrollFactor('blackFade', 0, 1)
    scaleObject('blackFade', 1.3, 1.3, false)

    makeLuaSprite('fullBlack', path..'mainmenu/fullBlack', -6, 1841)
    addLuaSprite('fullBlack')
    setScrollFactor('fullBlack', 0, 1)
    scaleObject('fullBlack', 1.3, 2, false)
end

function addRightShit()
    makeLuaSprite('right1', path..'mainmenu/right1', -366, -467)
    scaleObject('right1', 2, 2, false)
    addToGrp('right', 'right1')
    setScrollFactor('right1', 0, 0)

    makeLuaSprite('right3', path..'mainmenu/right3', 2764 - 2510, -97)
    scaleObject('right3', 2, 2, false)
    addToGrp('right', 'right3')
    setScrollFactor('right3', 0.4, 0.1)

    makeLuaSprite('right4', path..'mainmenu/right4', -208, 223)
    scaleObject('right4', 2, 2, false)
    addToGrp('right', 'right4')
    setScrollFactor('right4', 0.6, 0.3)

    makeLuaSprite('right2', path..'mainmenu/right2', 1294, 203)
    scaleObject('right2', 2, 2, false)
    addToGrp('right', 'right2')
    setScrollFactor('right2', 0.6, 0.3)

    makeAnimatedLuaSprite('right5', path..'mainmenu/right5')
    addAnimationByPrefix('right5', 'idle', 'layer5', 6, true)
    playAnim('right5', 'idle', true)
    setProperty('right5.antialiasing', true)
    setPosition('right5', 424+4220 - 2510, 610)
    addToGrp('right', 'right5')

    makeLuaSprite('right6', path..'mainmenu/right6', 1162+1710, 503)
    scaleObject('right6', 2, 2, false)
    addToGrp('right', 'right6')

    makeLuaSprite('jan', path..'mainmenu/jan', 5630, 538)
    setProperty('jan.antialiasing', true)
    addLuaSprite('jan')

    makeAnimatedLuaSprite('num1', path..'mainmenu/num1')
    setProperty('num1.antialiasing', true)
    setPosition('num1', 1017+1710, 541)
    addToGrp('right', 'num1')

    makeAnimatedLuaSprite('num2', path..'mainmenu/num2')
    setProperty('num2.antialiasing', true)
    setPosition('num2', 1097+1710, 524)
    addToGrp('right', 'num2')

    makeAnimatedLuaSprite('num3', path..'mainmenu/num3')
    setProperty('num3.antialiasing', true)
    setPosition('num3', 1224+1710, 506)
    addToGrp('right', 'num3')

    makeAnimatedLuaSprite('num4', path..'mainmenu/num4')
    setProperty('num4.antialiasing', true)
    setPosition('num4', 1315+1710, 490)
    addToGrp('right', 'num4')

    makeAnimatedLuaSprite('num5', path..'mainmenu/num5')
    setProperty('num5.antialiasing', true)
    setPosition('num5', 1426+1710, 477)
    addToGrp('right', 'num5')

    makeAnimatedLuaSprite('num6', path..'mainmenu/num6')
    setProperty('num6.antialiasing', true)
    setPosition('num6', 1464+1710, 473)
    addToGrp('right', 'num6')

    for i = 0, 9 do
        addAnimationByPrefix('num1', i, i..'first', 24, true)
        addAnimationByPrefix('num2', i, i..'second', 24, true)
        addAnimationByPrefix('num3', i, i..'third', 24, true)
        addAnimationByPrefix('num4', i, i..'fourth', 24, true)
        addAnimationByPrefix('num5', i, i..'fith', 24, true)
        addAnimationByPrefix('num6', i, i..'sixth', 24, true)
    end

    playAnim('num1', '8', true)
    playAnim('num2', '8', true)
    playAnim('num3', '8', true)
    playAnim('num4', '8', true)
    playAnim('num5', '8', true)
    playAnim('num6', '8', true)

    makeAnimatedLuaSprite('clockTick', path..'mainmenu/clockTick')
    addAnimationByPrefix('clockTick', 'idle', 'clockTick', 24, true)
    playAnim('clockTick', 'idle', true)
    setProperty('clockTick.antialiasing', true)
    setPosition('clockTick', 1199+1710, 582)
    addToGrp('right', 'clockTick')

    makeLuaSprite('right6dark', path..'mainmenu/right6dark', 1752+1710, 603)
    scaleObject('right6dark', 2, 2, false)
    setProperty('right6dark.blend', 9)
    addToGrp('right', 'right6dark')

    makeAnimatedLuaSprite('rightRays', path..'mainmenu/rightLightRays')
    addAnimationByPrefix('rightRays', 'idle', 'right2', 12, true)
    playAnim('rightRays', 'idle', true)
    setScrollFactor('rightRays', 0.6, 1)
    scaleObject('rightRays', 1.2, 1.2, false)
    setProperty('rightRays.antialiasing', true)
    setPosition('rightRays', 3814- 2510, -280)
    addToGrp('right', 'rightRays')

    makeAnimatedLuaSprite('rightRays2', path..'mainmenu/rightLightRays')
    addAnimationByPrefix('rightRays2', 'idle', 'right2', 12, true)
    playAnim('rightRays2', 'idle', true)
    setScrollFactor('rightRays2', 0.6, 1)
    scaleObject('rightRays2', 1.2, 1.4, false)
    setProperty('rightRays2.antialiasing', true)
    setPosition('rightRays2', 3414- 2510, -280)
    addToGrp('right', 'rightRays2')

    makeLuaSprite('layer5', path..'mainmenu/layer5', 3078 - 2510, -1751)
    addToGrp('right', 'layer5')
    setScrollFactor('layer5', 1.3, 2)
    scaleObject('layer5', 1, 1.5, false)
end

function playBubbleAnimation()
    makeAnimatedLuaSprite('bubbles', path..'mainmenu/bubbles')
    addAnimationByPrefix('bubbles', 'idle', 'Symbol 29', 24, false)
    playAnim('bubbles', 'idle', true)
    scaleObject('bubbles', 0.7, 0.7, false)
    setProperty('bubbles.antialiasing', true)
    setPosition('bubbles', 94, -150)
    setProperty('bubbles.alpha', 0.8)
    addLuaSprite('bubbles', true)
    doTweenAlpha('bubTween', 'bubbles', 0.2, 15, 'sineInOut')

    makeAnimatedLuaSprite('bubbles2', path..'mainmenu/bubbles')
    addAnimationByPrefix('bubbles2', 'idle', 'Symbol 29', 24, false)
    playAnim('bubbles2', 'idle', true)
    scaleObject('bubbles2', 0.9, 0.9, false)
    setProperty('bubbles2.antialiasing', true)
    setPosition('bubbles2', 1414, -350)
    setProperty('bubbles2.alpha', 0.8)
    addLuaSprite('bubbles2', true)
    doTweenAlpha('bub2Tween', 'bubbles2', 0.2, 15, 'sineInOut')

    runTimer('destroy bubbles', 4)
end

function addShaderShit()
    makeLuaSprite('water') setSpriteShader('water', 'waves')
    makeLuaSprite('lens') setSpriteShader('lens', 'lens')
    makeLuaSprite('blur') setSpriteShader('blur', 'blur')
    runHaxeCode("game.camGame.setFilters([new ShaderFilter(game.getLuaObject('water').shader), new ShaderFilter(game.getLuaObject('lens').shader), new ShaderFilter(game.getLuaObject('blur').shader)]);")
    setShaderFloat('water', 'iTime', 0.0)
    setShaderFloat('blur', 'iTime', 0.0)
    setShaderFloat('lens', 'iTime', 0.0)
    setShaderFloat('lens', 'ushaderStrength', 0.0)
    blurAngle = 90.0
end

function onTimerCompleted(tag)
    if tag == 'canSelect' then
        canSelect = true
    end

    if tag == 'clock update' then
        updateClock(curSelectedFreeplay)
    end

    if tag == 'destroy bubbles' then
        setProperty('bubbles.alpha', 0)
        setProperty('bubbles2.alpha', 0)
        removeLuaSprite('bubbles')
        removeLuaSprite('bubbles2')
    end

    if tag == 'titleParts' then
        doTweenAlpha('part0tween', 'titlePart0', 0, 0.4, 'sineIn')
        if luaSpriteExists('titlePart6') then doTweenAlpha('part6tween', 'titlePart6', 0, 0.4, 'sineIn') end
        doTweenAlpha('part2tween', 'titlePart2', 0, 0.4, 'sineIn')
    elseif tag == 'titleParts2' then
        doTweenAlpha('part3tween', 'titlePart3', 0, 0.4, 'sineIn')
        doTweenAlpha('part4tween', 'titlePart4', 0, 0.6, 'sineIn')
    elseif tag == 'titleParts3' then
        doTweenAlpha('part5tween', 'titlePart5', 0, 0.4, 'sineIn')
        doTweenAlpha('logotween', 'titleLogo', 0, 0.4, 'sineIn')
    end

    if tag == 'reveal1' then
        startTween('selText1', 'selectedText.members[0]', {alpha = 1}, 1, {ease = 'sineOut'})
        startTween('optBg1', 'optionBg.members[0]', {alpha = 0.2}, 1, {ease = 'sineOut'})
    elseif tag == 'reveal2' then
        startTween('optTxt1', 'optionText.members[1]', {alpha = 0.2}, 1, {ease = 'sinOut'})
    elseif tag == 'reveal3' then
        startTween('optTxt2', 'optionText.members[2]', {alpha = 0.2}, 1, {ease = 'sinOut'})
    elseif tag == 'reveal4' then
        startTween('optTxt3', 'optionText.members[3]', {alpha = 0.2}, 1, {ease = 'sinOut'})
    elseif tag == 'reveal5' then
        startTween('optTxt4', 'optionText.members[4]', {alpha = 0.2}, 1, {ease = 'sinOut'})
    elseif tag == 'reveal6' then
        canSelect = true
        menuRevealed = true
    end
end

function addToGrp(grpName, obj)
    runHaxeCode("getVar('"..grpName.."').add(game.getLuaObject('"..obj.."'));")
end

function setPosition(obj, x, y)
    setProperty(obj..'.x', x)
    setProperty(obj..'.y', y)
end