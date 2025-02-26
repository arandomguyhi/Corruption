luaDebugMode = true

addHaxeLibrary('FlxText', 'flixel.text')
addHaxeLibrary('FlxTrail', 'flixel.addons.effects')
addHaxeLibrary('FlxTypedGroup', 'flixel.group')

local curArray = {name = '', info = '', link = ''}
local allArrays = {name = '', info = '', link = ''}

local curSelected = 0
local prevMenuSelected = 0
local canSelect = false

local layer = 'section'
local returnToMainSection = {'animations', 'general', 'if', 'memory', 'extra'}
local corrSongs = {'nullandvoid', 'chkdsk', 'bloodlust', 'accessdenied'}

local path = '../assets/menus/'

function onCreate()
    makeLuaSprite('bg', path..'sidestory/gradient')
    setScrollFactor('bg')
    screenCenter('bg')
    addLuaSprite('bg', true)
    setPosition('bg', 571, -109)
    scaleObject('bg', 0.8, 2, false)
    setProperty('bg.alpha', 0)
    setProperty('bg.color', getColorFromHex('FF0000'))

    startTween('bgTween', 'bg', {alpha = 0.4}, 8, {ease = 'sineInOut', type = 'pingpong'})

    makeLuaSprite('chains', path..'sidestory/chains')
    setScrollFactor('chains')
    screenCenter('chains')

    setPosition('chains', 561, 120)
    scaleObject('chains', 0.9, 1.4, false)
    addLuaSprite('chains', true)

    addCreditsToArray()

    playMusic('menu4', 1, true)

    curArray = allArrays[1]

    makeLuaSprite('blackTop', path..'mainmenu/fullBlack', 10, -20)

    updateTexts()
    updateSelected()

    makeLuaSprite('selectArrow', path..'credits/arrow', -40, -300)
    addLuaSprite('selectArrow', true)
    setProperty('selectArrow.antialiasing', true)

    runHaxeCode([[
        var arrowTrail = new FlxTrail(game.getLuaObject('selectArrow'), null, 4, 12, 0.3, 0.09);
        add(arrowTrail);
        setVar('arrowTrail', arrowTrail);
    ]])

    addLuaSprite('blackTop', true)
    setScrollFactor('blackTop', 0, 0)
    scaleObject('blackTop', 1.7, 1.7, false)

    runTimer('canSelect', 1)
    onTimerCompleted = function(tag)
        if tag == 'canSelect' then
            canSelect = true
        end
    end
end

function onCreatePost()
    callMethod('camGame.scroll.set', {951 - (screenWidth/2), -270 - (screenHeight/2)})
    callMethod('camFollow.setPosition', {951, -270})

    setProperty('camGame.zoom', 0.593)
end

function updateTexts()
    local textOffsetY = 0

    runHaxeCode([[
        var creditsText:FlxTypedGroup<FlxText>;
        var curArrayText:FlxTypedGroup<FlxText>;
        
        creditsText = new FlxTypedGroup();
        add(creditsText);
        setVar('creditsText', creditsText);

        curArrayText = creditsText;
        setVar('curArrayText', curArrayText);
    ]])

    if luaTextExists('infoText') then
        removeLuaText('infoText')
    end

    cancelTween('blackTween')
    setProperty('blackTop.alpha', 1)
    startTween('blackTween', 'blackTop', {alpha = 0}, 1, {ease = 'sineIn'})

    for i = 1, #curArray do
        makeLuaText('name'..i, curArray[i].name, 1000, 80, -320 + textOffsetY)
        setProperty('name'..i..'.antialiasing', true)
        setTextFont('name'..i, 'VollkornRegular-ZVJEZ.ttf')
        setTextSize('name'..i, 85)
        setTextAlignment('name'..i, 'LEFT')
        runHaxeCode("getVar('creditsText').add(game.getLuaObject('name"..i.."'));")
        setObjectCamera('name'..i, 'camGame')
        setProperty('name'..i..'.scrollFactor.x', 1)
        setProperty('name'..i..'.scrollFactor.y', 1)

        textOffsetY = textOffsetY + 190
    end

    makeLuaText('infoText', curArray[curSelected+1].info, 1000, 717, 194)
    setProperty('infoText.antialiasing', true)
    setTextFont('infoText', 'VollkornRegular-ZVJEZ.ttf')
    setTextSize('infoText', 65)
    setTextAlignment('infoText', 'CENTER')
    setObjectCamera('infoText', 'camGame')
    setProperty('infoText.alpha', 0.5)
    addLuaText('infoText', true)
end

local camX, camY = 951, 570
function onUpdate(elapsed)
    inputShit()

    local lerpVal = math.exp(-elapsed * 2.4 * 2)
    callMethod('camFollow.setPosition', {
        callMethodFromClass('flixel.math.FlxMath', 'lerp', {camX, getProperty('camFollow.x'), lerpVal}),
        callMethodFromClass('flixel.math.FlxMath', 'lerp', {camY + 100, getProperty('camFollow.y'), lerpVal})
    })

    camY = getProperty('curArrayText.members['..curSelected..'].y')
    setProperty('selectArrow.y', getProperty('curArrayText.members['..curSelected..'].y') + 20)
end

function inputShit()
    if not canSelect then return end

    if getProperty('controls.ACCEPT') then
        enter()
    end

    if getProperty('controls.BACK') then
        backOut()
    end

    if keyJustPressed('up') then
        playSound('scrollMenu')
        curSelected = curSelected - 1
        if curSelected < 0 then
            curSelected = #curArray-1
        end

        updateSelected()
    end

    if keyJustPressed('down') then
        playSound('scrollMenu')
        curSelected = curSelected + 1
        if curSelected >= #curArray then
            curSelected = 0
        end

        updateSelected()
    end
end

function enter()
    playSound('confirmMenu')
    checkLayer()
end

function backOut()
    playSound('cancelMenu')
    if layer == 'corruption' or layer == 'animations' or layer == 'general' or layer == 'if' or layer == 'memory' or layer == 'extra' then
        changeLayer(0, 'section')
        curSelected = prevMenuSelected
        updateTexts()
        updateSelected()
        setProperty('bg.color', getColorFromHex('FF0000'))
    elseif layer == 'opening' or layer == 'badending' then
        changeLayer(2, 'animations')
        curSelected = prevMenuSelected
        updateTexts()
        updateSelected()
        setProperty('bg.color', getColorFromHex('FF6677'))
    elseif layer == 'nullandvoid' or layer == 'chkdsk' or layer == 'bloodlust' or layer == 'accessdenied' then
        changeLayer(1, 'corruption')
        curSelected = prevMenuSelected
        updateTexts()
        updateSelected()
        setProperty('bg.color', getColorFromHex('FF6677'))
    else
        canSelect = false
        
        cancelTween('blackTween')
        setProperty('blackTop.alpha', 0)
        startTween('blackTween', 'blackTop', {alpha = 1}, 1, {ease = 'sineOut'})

        runTimer('back to menu', 1)
        onTimerCompleted = function(tag)
            if tag == 'back to menu' then
                setDataFromSave('corruptMenu', 'main', true)
                setDataFromSave('corruptMenu', 'credits', false)
                restartSong()
            end
        end
    end
end

function checkLayer()
    if layer == 'section' then
        if curSelected == 0 then
            changeLayer(1, 'corruption')
            setProperty('bg.color', 0xFF6677)
        elseif curSelected == 1 then
            changeLayer(2, 'animations')
            setProperty('bg.color', 0xFF6677)
        elseif curSelected == 2 then
            changeLayer(9, 'general')
            setProperty('bg.color', 0xFFFFFF)
        elseif curSelected == 3 then
            changeLayer(8, 'if')
            setProperty('bg.color', 0xFFFFFF)
        elseif curSelected == 4 then
            changeLayer(10, 'memory')
            setProperty('bg.color', 0xFFFFFF)
        elseif curSelected == 5 then
            changeLayer(11, 'extra')
            setProperty('bg.color', 0xFFFFFF)
        end
        prevMenuCurSelected = curSelected
        curSelected = 0
        updateTexts()
        updateSelected()
    elseif layer == 'corruption' then
        if curSelected == 0 then
            changeLayer(12, 'nullandvoid')
        elseif curSelected == 1 then
            changeLayer(3, 'chkdsk')
        elseif curSelected == 2 then
            changeLayer(4, 'bloodlust')
        elseif curSelected == 3 then
            changeLayer(5, 'accessdenied')
        end
        setProperty('bg.color', 0xFFFFFF)
        prevMenuCurSelected = curSelected
        curSelected = 0
        updateTexts()
        updateSelected()
    elseif layer == 'animations' then
        if curSelected == 0 then
            changeLayer(6, 'opening')
        elseif curSelected == 1 then
            changeLayer(7, 'badending')
        end
        setProperty('bg.color', 0xFFFFFF)
        prevMenuCurSelected = curSelected
        curSelected = 0
        updateTexts()
        updateSelected()
    else
        openLink()
    end
end

function openLink()
    if curArray[curSelected+1].link ~= nil then
        os.execute('start '..curArray[curSelected+1].link)
    end
end

function updateSelected()
    cancelTween('infoTween')

    setProperty('infoText.alpha', 0)
    setTextString('infoText', curArray[curSelected+1].info)
    startTween('infoTween', 'infoText', {alpha = 0.5}, 1, {ease = 'sineOut'})

    for i = 0, getProperty('curArrayText.length') do
        if i == curSelected then
            setProperty('curArrayText.members['..i..'].alpha', 1)
            callMethod('curArrayText.members['..i..'].scale.set', {1.3,1.3})
            setProperty('curArrayText.members['..i..'].x', 200)
        elseif (i-1) == curSelected or (i+1) == curSelected then
            setProperty('curArrayText.members['..i..'].alpha', 0.15)
            callMethod('curArrayText.members['..i..'].scale.set', {1,1})
            setProperty('curArrayText.members['..i..'].x', 0)
        else
            setProperty('curArrayText.members['..i..'].alpha', 0.1)
            callMethod('curArrayText.members['..i..'].scale.set', {0.95,0.95})
            setProperty('curArrayText.members['..i..'].x', -50)
        end
    end
end

function changeLayer(whichArray, whichLayer)
    for i = 1, #curArray do
        removeLuaText('name'..i)
    end
    curArray = allArrays[whichArray+1]

    cancelTween('infoTween')
    layer = whichLayer
end

function addCreditsToArray()
    local sectionCredits = {
        { name = "CORRUPTION", info = "\nSelect to see credits.", link = nil},
        { name = "ANIMATIONS", info = "\nSelect to see credits.", link = nil},
        { name = "GENERAL", info = "\nSelect to see credits.", link = nil},
        { name = "CORRUPTION: IF", info = "\nSelect to see credits.", link = nil},
        { name = "MEMORY", info = "\nIn loving memory\nof those who we lost.", link = nil},
        { name = "EXTRA", info = "\nSelect to see more.", link = nil}
    }

    local corruptionCredits = {
        { name = "NULL AND VOID", info = "\nSelect to see credits.", link = nil},
        { name = "CHKDSK", info = "\nSelect to see credits.", link = nil},
        { name = "BLOODLUST", info = "\nSelect to see credits.", link = nil},
        { name = "ACCESS DENIED", info = "\nSelect to see credits.", link = nil}
    }

    local animationCredits = {
        { name = "OPENING", info = "\nSelect to see credits.", link = nil},
        { name = "BAD ENDING", info = "\nSelect to see credits.", link = nil}
    }

    local nullAndVoidCredits = {
        { name = "NULL AND VOID", info = "\nSong: fluffyFHX", link = "https://www.youtube.com/channel/UC45OK9Bcx9R7uJ1tPMJaTkg"},
        { name = "PHANTOMFEAR", info = "Director\nArt\nCode\nCutscenes\nCharting", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "FUSA", info = "\nPixel BF front view sprite.", link = "https://x.com/fusanensan_fnf"},
        { name = "NEBULA THE ZORUA", info = "\nCode\nMod chart", link = "https://bsky.app/profile/nebulazorua.bsky.social"},
        { name = "DUSKIEWHY", info = "\nOG Mod chart", link = "https://www.youtube.com/@DuskieWhy"},
        { name = "PINCERPROD", info = "\nCutscene BG wall details", link = "https://www.youtube.com/@PincerProd"},
        { name = "LEEBERT", info = "\nCutscene Song", link = "https://www.youtube.com/@leebert"},
        { name = "NOTSPRING", info = "\nCharting", link = "https://www.youtube.com/@NotSpring"},
        { name = "TSUKIMI MIKAZUKI", info = "\nHarvester VA", link = "https://www.youtube.com/@TsukimiDe1pai"},
        { name = "KOSPI", info = "\nCutscene Skybox", link = "https://x.com/@frixen__"}
    }

    local chkdskCredits = {
        { name = "CHKDSK", info = "\nSong:\nKazuya,\nLiterallyNoOne", link = "https://youtu.be/BjOvA9us7bE?si=qG5d6D1rcqn7zArB"},
        { name = "PHANTOMFEAR", info = "Director\nArt\nCode\nCutscenes", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "FUSA", info = "\nPixel BF front view sprite.", link = "https://x.com/fusanensan_fnf"},
        { name = "NEBULA THE ZORUA", info = "\nMod chart", link = "https://bsky.app/profile/nebulazorua.bsky.social"},
        { name = "DUSKIEWHY", info = "\nMod chart", link = "https://www.youtube.com/@DuskieWhy"},
        { name = "KAZUYA", info = "\nMusician", link = "https://www.youtube.com/@raytraxdtm"},
        { name = "LITERALLYNOONE", info = "\nMusician", link = "https://www.youtube.com/@LiterallyNoOne"},
        { name = "LEEBERT", info = "\nCutscene Song", link = "https://www.youtube.com/@leebert"},
        { name = "FLOOTENA", info = "\nCharting", link = "https://x.com/FlootenaDX"},
        { name = "KOSPI", info = "\nCutscene Skybox", link = "https://x.com/@frixen__"}
    }

    local bloodlustCredits = {
        { name = "BLOODLUST", info = "\nSong: Leebert", link = "https://www.youtube.com/@leebert"},
        { name = "PHANTOMFEAR", info = "Director\nArt\nCode\nCutscenes", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "BEEFSTARCHJELLO", info = "\nCutscenes\nSpider Mommy Mearest Sprite\nSprite animations", link = "https://x.com/beefstarchjello"},
        { name = "AKNIYET", info = "\nSprite Line Art\nGF + MM Sprite coloring", link = "https://x.com/akniyet_z"},
        { name = "NOVASAUR", info = "\nGF Pose Concepts Art", link = "https://www.youtube.com/@NNovasaur"},
        { name = "YUKIZAKURA", info = "\nForest Background", link = "https://x.com/yukizakura1126"},
        { name = "NEBULA THE ZORUA", info = "\nCode", link = "https://bsky.app/profile/nebulazorua.bsky.social"},
        { name = "FLOOTENA", info = "\nCharting", link = "https://x.com/FlootenaDX"},
        { name = "PINCERPROD", info = "\nGF VA", link = "https://www.youtube.com/@PincerProd"},
        { name = "KOSPI", info = "\nCutscene Skybox", link = "https://x.com/@frixen__"}
    }

    local accessDeniedCredits = {
        { name = "ACCESS DENIED", info = "\nSong: GRYSCL", link = "https://youtu.be/HRg91nxRyo0?si=8M3NUniXalOiWTur"},
        { name = "PHANTOMFEAR", info = "Director\nArt\nCode\nCutscenes", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "NEBULA THE ZORUA", info = "\nModChart\nCode", link = "https://bsky.app/profile/nebulazorua.bsky.social"},
        { name = "DUSKIEWHY", info = "\nBase modchart", link = "https://www.youtube.com/@DuskieWhy"},
        { name = "FLOOTENA", info = "\nCharting", link = "https://x.com/FlootenaDX"}
    }

    local openingCredits = {
        { name = "CORRUPTION OPENING", info = "by: Funnyleech,\nDani Susatyo,\nZhafiraWildhania,\nWillyJayasukma,\nLunaticParfait", link = "https://www.youtube.com/watch?v=rwclhBa1Tqo"},
        { name = "PHANTOMFEAR", info = "\nArt\nAnimation", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "YUKIZAKURA", info = "\nArt", link = "https://x.com/yukizakura1126"},
        { name = "SACUNIULTIMATE", info = "\nArt\nAnimation", link = "https://x.com/sacuniUltimate"},
        { name = "BLUEGARDEN", info = "\nArt", link = "https://x.com/Oceanlight375"},
        { name = "DAYANCI", info = "\nArt", link = "https://x.com/dayanci_"},
        { name = "KOSPI", info = "\nPico Week Background", link = "https://x.com/@frixen__"},
        { name = "FLOOTENA", info = "\nCharting", link = "https://x.com/FlootenaDX"}
    }

    local badendingCredits = {
        { name = "SHINIGAMI", info = "\nSong:\neverything falls to the floor", link = "https://www.youtube.com/watch?v=FN2hLbcs974"},
        { name = "BEEFSTARCHJELLO", info = "\nBF Cutscene\nBF VA", link = "https://x.com/beefstarchjello"},
        { name = "PHANTOMFEAR", info = "\nNull Deletion Cutscene\nCredits Visualizer", link = "https://www.youtube.com/@PhantomFearYT"}
    }

    local ifCredits = {
        { name = "PRETENCE", info = "Song:\nLeebert,\nZeroh\nRazorDaMusician\nAureCraft", link = null},
        { name = "PINCERPROD", info = "\nDirector\nArt\nConcept Art\nVA", link = "https://www.youtube.com/@PincerProd"},
        { name = "BEEFSTARCHJELLO", info = "\nArt\nAnimation", link = "https://x.com/beefstarchjello"},
        { name = "ACECRE4M", info = "\nIcon Art\nBackground Art\nConcept Art", link = "https://bsky.app/profile/acecre4m.bsky.social"},
        { name = "AURECRAFT", info = "\nConcept Art\nAnimator\nPromo Art\nMusician", link = "http://www.youtube.com/@AureCraft_"},
        { name = "TOTALLYNBF", info = "\nConcept Art\nPromo Art", link = "https://totallynbf.newgrounds.com/"},
        { name = "STEAMPANDAA", info = "\nPromo Art\nJolly Mode", link = "https://bsky.app/profile/steampandaa.bsky.social"},
        { name = "LEEBERT", info = "\nMusician", link = "https://x.com/Bruh_Leebert"},
        { name = "ZEROH", info = "\nMusician", link = "https://www.youtube.com/channel/UC5Km5yZrSF7t4molQk9MYhg"},
        { name = "RAZORDAMUSICIAN", info = "\nMusician\nHurt SFX", link = "https://youtube.com/@razordamusician?si=jgtm5_6OiQO1ZzXX"},
        { name = "ULTRAVIOLET", info = "\nMenu Music", link = "https://www.youtube.com/@UltraaVioletMusic"},
        { name = "PHANTOMFEAR", info = "\nCode", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "DUODOES", info = "\nVA\nChart", link = "https://www.youtube.com/@DuoDoesStuff"}
    }

    local generalCredits = {
        { name = "PHANTOMFEAR", info = "\nMenu Art\nCode", link = "https://www.youtube.com/@PhantomFearYT"},
        { name = "NEBULA THE ZORUA", info = "\nTroll Engine\nCode\nOptimization", link = "https://bsky.app/profile/nebulazorua.bsky.social"},
        { name = "BEEFSTARCHJELLO", info = "\nMenu Art", link = "https://x.com/beefstarchjello"},
        { name = "SACUNIULTIMATE", info = "\nTitle Screen Art", link = "https://x.com/sacuniUltimate"},
        { name = "FLUFFYFHX", info = "\nBF Death Screen Music", link = "https://www.youtube.com/channel/UC45OK9Bcx9R7uJ1tPMJaTkg"},
        { name = "LEEBERT", info = "\nGF Death Screen Music", link = "https://x.com/Bruh_Leebert"},
        { name = "YUKIZAKURA", info = "\nCorruption: Side Story", link = "https://x.com/yukizakura1126"},
        { name = "SMILEYSQUEAK", info = "\nOriginal Menu Song", link = "https://www.youtube.com/@smileysqueak"},
        { name = "SAI", info = "\nConverting MP4s to Spritesheets", link = "https://x.com/sacuniUltimate"},
		{ name = "SWORDCUBE", info = "\nPlaytesting for super low-end\nPixel Miss judgement", link = "https://bsky.app/profile/swordcube.bsky.social"},
		{ name = "LAVENDER", info = "\nOptimized the videos", link = "https://bsky.app/profile/lavender06.bsky.social"},
        { name = "FUNKIN' CREW INC.", info = "\nFriday Night Funkin'", link = "https://funkin.me"}
    }

    local memoryCredits = {
        { name = "Rod", info = "\nIn loving memory.\n24/08/03 - 17/07/24", link = "https://x.com/AstactArcade4K"},
        { name = "Onyx", info = "\nIn loving memory.", link = nil}
    }

    local extraCredits = {
        { name = "MERCH", info = "\ncrowdmade.com", link = "https://crowdmade.com/collections/phantomfear"},
        { name = "FULL STORY", info = "\nEvery episode in order.", link = "https://youtube.com/playlist?list=PLPtjMqSqi-a0R38VWeZndX26rUu8TK_rc&si=YKyAwbXBs2hA1yla"}
    }

    table.insert(allArrays, sectionCredits)
    table.insert(allArrays, corruptionCredits)
    table.insert(allArrays, animationCredits)
    table.insert(allArrays, chkdskCredits)
    table.insert(allArrays, bloodlustCredits)
    table.insert(allArrays, accessDeniedCredits)
    table.insert(allArrays, openingCredits)
    table.insert(allArrays, badendingCredits)
    table.insert(allArrays, ifCredits)
    table.insert(allArrays, generalCredits)
    table.insert(allArrays, memoryCredits)
    table.insert(allArrays, extraCredits)
    table.insert(allArrays, nullAndVoidCredits)
end

function setPosition(obj, x, y)
    setProperty(obj..'.x', x)
    setProperty(obj..'.y', y)
end