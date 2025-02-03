local path = '../assets/stages/bloodlust/'

local boundaryBreak = false

local frontView = false
local canZoom = true
local henchTime = false
local henchWhich = false
local redLightMode = 0

local debugCamPosX = 608
local debugCamPosY = 214
local debugCamZoom = 0.669

local stringPulsing = true
local stopping = false
local running = false

local startTime = 0

local hurtAmount = 0
local hurtRedAmount = 0
local hurtAmountBlack = 0

local forest = {}
local spiderGroup = {}

luaDebugMode = true
function onCreate()
    addCharacterToList("gfRage", 'boyfriend')
    addCharacterToList("momFront", 'dad')
    addCharacterToList("momFrontSecond", 'dad')
    addCharacterToList("gfNorm", 'boyfriend')
    addCharacterToList("momCorrupt", 'dad')
    addCharacterToList("gfDark", 'boyfriend')
	addCharacterToList("gfRun", 'boyfriend')

    if shadersEnabled then
        initLuaShader('null-and-void/bloom')
        initLuaShader('overlay')
        initLuaShader('zoomblur')

        makeLuaSprite('bloom')
        setSpriteShader('bloom', 'null-and-void/bloom')
        setShaderFloat('bloom', 'blurSize', 0.01)
        setShaderFloat('bloom', 'intensity', 0.0)

        makeLuaSprite('overlay')
        setSpriteShader('overlay', 'overlay')

        makeLuaSprite('blur')
        setSpriteShader('blur', 'zoomblur')
        setShaderFloat('blur', 'posX', 0.5)
        setShaderFloat('blur', 'posY', 0.5)
        setShaderFloat('blur', 'focusPower', 15.0)
    end

    makeLuaSprite('forestSky', path..'forestSky', -1600, -3800)
    setProperty('forestSky.antialiasing', true)
    scaleObject('forestSky', 1.25, 1.25)
    setScrollFactor('forestSky', 0.9, 0.9)
    addLuaSprite('forestSky')

    if not lowQuality then
        createInstance('forestTreeBehinder', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestTreeBehinder', path..'forestTree3', false)
        screenCenter('forestTreeBehinder')
        setProperty('forestTreeBehinder.antialiasing', true)
        setScrollFactor('forestTreeBehinder', 0.25, 0.25)
        setProperty('forestTreeBehinder.x', -900)
        setProperty('forestTreeBehinder.y', -1100)
        addInstance('forestTreeBehinder')
        setProperty('forestTreeBehinder.velocity.x', -666)

        createInstance('forestTreeBehind', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestTreeBehind', path..'forestTree2', false)
        screenCenter('forestTreeBehind')
        setProperty('forestTreeBehind.antialiasing', true)
        setScrollFactor('forestTreeBehind', 0.4, 0.4)
        setProperty('forestTreeBehind.x', -1500)
        setProperty('forestTreeBehind.y', -2053)
        addInstance('forestTreeBehind')
        setProperty('forestTreeBehind.velocity.x', -1000)

        createInstance('forestTree', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestTree', path..'forestTree2', false)
        screenCenter('forestTree')
        setProperty('forestTree.antialiasing', true)
        setScrollFactor('forestTree', 0.75, 0.75)
        setProperty('forestTree.x', -1000)
        setProperty('forestTree.y', -3303)
        addInstance('forestTree')
        setProperty('forestTree.velocity.x', -1666)
    else
        makeLuaSprite('forestTreeBehinder', nil, -999, -999)
        makeGraphic('forestTreeBehinder', 1, 1, '000000')

        createInstance('forestTreeBehind', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestTreeBehind', path..'lowquality/forestTree', false)
        screenCenter('forestTreeBehind')
        setProperty('forestTreeBehind.antialiasing', true)
        setScrollFactor('forestTreeBehind', 0.75, 0.75)
        setProperty('forestTreeBehind.x', -1000)
        setProperty('forestTreeBehind.y', -3103)
        addInstance('forestTreeBehind')
        setProperty('forestTreeBehind.velocity.x', -1600)
        scaleObject('forestTreeBehind', 0.9, 0.9, false)

        createInstance('forestTree', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestTree', path..'lowquality/forestTree', false)
        screenCenter('forestTree')
        setProperty('forestTree.antialiasing', true)
        setScrollFactor('forestTree', 0.75, 0.75)
        setProperty('forestTree.x', -1000)
        setProperty('forestTree.y', -3503)
        addInstance('forestTree')
        setProperty('forestTree.velocity.x', -2000)
    end

    createInstance('forestBush', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
    loadGraphic('forestBush', path..'forestBushBg', false)
    screenCenter('forestBush')
    setProperty('forestBush.antialiasing', true)
    setProperty('forestBush.x', -1000)
    setProperty('forestBush.y', -3350)
    addInstance('forestBush')
    setProperty('forestBush.velocity.x', -1666)

    createInstance('forestFloor', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
    loadGraphic('forestFloor', path..'forestFloor', false)
    screenCenter('forestFloor')
    setProperty('forestFloor.antialiasing', true)
    setProperty('forestFloor.x', -1600)
    setProperty('forestFloor.y', -3004)
    addInstance('forestFloor')
    setProperty('forestFloor.velocity.x', -2500)

    if lowQuality then
        createInstance('forestHench', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestHench', path..'lowquality/forestHench', false)
        scaleObject('forestHench', 2, 2)
        screenCenter('forestHench')
        setProperty('forestHench.antialiasing', true)
        setProperty('forestHench.x', -1000)
        setProperty('forestHench.y', -4033)
        scaleObject('forestHench', 2.5, 2.5)
        setProperty('forestHench.alpha', 0.001)
        addInstance('forestHench')
        setProperty('forestHench.velocity.x', -2550)
    else
        createInstance('forestHench', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestHench', path..'forestHench', false)
        screenCenter('forestHench')
        setProperty('forestHench.antialiasing', true)
        setProperty('forestHench.x', -1600)
        setProperty('forestHench.y', -4033)
        scaleObject('forestHench', 1.25, 1.25)
        setProperty('forestHench.alpha', 0.001)
        addInstance('forestHench')
        setProperty('forestHench.velocity.x', -2550)
    end

    makeLuaSprite('forestBf', path..'henchBf', -720 + 30000, -3610)
    setProperty('forestBf.antialiasing', true)
    scaleObject('forestBf', 0.9, 0.9, false)
    setProperty('forestBf.alpha', 0.001)
    addLuaSprite('forestBf')
    setProperty('forestBf.velocity.x', -2570)

    if not lowQuality then
        createInstance('forestFront', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestFront', path..'forestFront', false)
        screenCenter('forestFront')
        setProperty('forestFront.antialiasing', true)
        setProperty('forestFront.x', -1000)
        setProperty('forestFront.y', -3252)
        addInstance('forestFront', true)
        setProperty('forestFront.velocity.x', -3500)

        createInstance('forestForeground', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestForeground', path..'forestForeground', false)
        screenCenter('forestForeground')
        setProperty('forestForeground.antialiasing', true)
        setScrollFactor('forestForeground', 1.2, 1.2)
        setProperty('forestForeground.x', -750)
        scaleObject('forestForeground', 1.35, 1.1, false)
        setProperty('forestForeground.y', -4860)
        addInstance('forestForeground', true)
        setProperty('forestForeground.velocity.x', -5000)
    else
        makeLuaSprite('forestFront', nil, -999, -999)
        makeGraphic('forestFront', 1, 1, '000000')

        createInstance('forestForeground', 'flixel.addons.display.FlxBackdrop', {nil, 0x01})
        loadGraphic('forestForeground', path..'forestForeground', false)
        scaleObject('forestForeground', 2, 2)
        screenCenter('forestForeground')
        setProperty('forestForeground.antialiasing', true)
        setScrollFactor('forestForeground', 1.2, 1.2)
        setProperty('forestForeground.x', -750)
        setProperty('forestForeground.scale.x', getProperty('forestForeground.scale.x') * 1.35)
        setProperty('forestForeground.scale.y', getProperty('forestForeground.scale.y') * 1.1)
        setProperty('forestForeground.y', -4860)
        addInstance('forestForeground', true)
        setProperty('forestForeground.velocity.x', -5000)
    end

    local xOffset = -1425
    local yOffset = -750

    altFloorGraphic = path.."bloodlust_floor-alt"
	altWallGraphic = path.."bloodlust_wall-alt"

	floorGraphic = path.."bloodlust_floor"
	wallGraphic = path.."bloodlust_wall"

    makeLuaSprite('sky', path..'bloodlust_sky', -1745, -330)
    setProperty('sky.antialiasing', true)
    setScrollFactor('sky', 0.5, 0.5)
    addLuaSprite('sky')

    makeLuaSprite('floor', floorGraphic, -1638, 331)
    setProperty('floor.antialiasing', true)
    setProperty('floor.active', false)
    addLuaSprite('floor')

    makeLuaSprite('building', path..'bloodlust_building', 1185, -255)
    setProperty('building.antialiasing', true)
    setProperty('building.active', false)
    setScrollFactor('building', 0.8, 1)
    addLuaSprite('building')

    makeLuaSprite('wall', wallGraphic, -1634, -875)
    setProperty('wall.antialiasing', true)
    setScrollFactor('wall', 0.95, 1)
    setProperty('wall.active', false)
    addLuaSprite('wall')

    makeLuaSprite('stringsBg', path..'stringsBg')
    setProperty('stringsBg.antialiasing', true)
    setProperty('stringsBg.active', false)
    scaleObject('stringsBg', 1.2, 1.4, false)
    addLuaSprite('stringsBg')
    setPosition('stringsBg', -509, 134)

    makeLuaSprite('stringsBgShoot', path..'stringsBgShoot')
    setProperty('stringsBgShoot.antialiasing', true)
    setProperty('stringsBgShoot.active', false)
    addLuaSprite('stringsBgShoot')
    setPosition('stringsBgShoot', -509, 134)
    scaleObject('stringsBgShoot', 1.2, 1.4)
    setProperty('stringsBgShoot.visible', false)
    setProperty('stringsBg.visible', false)

    makeLuaSprite('fade', path..'fade', 900, 0)
    scaleObject('fade', 1.55, 1.55, false)
    setProperty('fade.antialiasing', true)
    setProperty('fade.alpha', 0.001)
    addLuaSprite('fade')

    scaleObject('wall', 1.5, 1.5)
    scaleObject('building', 1.4, 1.4)
    scaleObject('floor', 1.5, 1.5)
    scaleObject('sky', 1.4, 1.4)

    setProperty('sky.scale.x', getProperty('sky.scale.x') * 1.333)
    setProperty('sky.scale.y', getProperty('sky.scale.y') * 1.333)
    updateHitbox('sky')

    makeAnimatedLuaSprite('stringPrep', path..'stringPrep')
    addAnimationByPrefix('stringPrep', 'idle', 'StringPrep', 24, false)
    playAnim('stringPrep', 'idle', true)
    setProperty('stringPrep.antialiasing', true)
    setPosition('stringPrep', 163.3-85, 535)
    setProperty('stringPrep.alpha', 0.001)
    addLuaSprite('stringPrep', true)

    makeAnimatedLuaSprite('stringPrep2', path..'stringPrep')
    addAnimationByPrefix('stringPrep2', 'idle', 'StringPrep', 24, false)
    playAnim('stringPrep2', 'idle', true)
    setProperty('stringPrep2.antialiasing', true)
    setPosition('stringPrep2', 221.66-85, 550)
    setProperty('stringPrep2.alpha', 0.001)
    addLuaSprite('stringPrep2', true)

    makeAnimatedLuaSprite('stringShoot', path..'stringShoot')
    addAnimationByPrefix('stringShoot', 'idle', 'StringShoot', 24, false)
    playAnim('stringShoot', 'idle', true)
    setProperty('stringShoot.antialiasing', true)
    setPosition('stringShoot', -365-85, 156)
    setProperty('stringShoot.alpha', 0.001)
    addLuaSprite('stringShoot', true)

    makeAnimatedLuaSprite('stringShoot2', path..'stringShoot')
    addAnimationByPrefix('stringShoot2', 'idle', 'StringShoot', 24, false)
    playAnim('stringShoot2', 'idle', true)
    setProperty('stringShoot2.antialiasing', true)
    setPosition('stringShoot2', -303-85, 170)
    setProperty('stringShoot2.alpha', 0.001)
    addLuaSprite('stringShoot2', true)

    makeLuaSprite('henchmanLight', path..'henchmanLight', -1750, -377+45)
    setProperty('henchmanLight.antialiasing', true)
    setProperty('henchmanLight.alpha', 0)
    setProperty('henchmanLight.blend', 0)
    addLuaSprite('henchmanLight')

    makeLuaSprite('henchmanLight2', path..'henchmanLight', -900, -377+45)
    setProperty('henchmanLight2.antialiasing', true)
    setProperty('henchmanLight2.alpha', 0)
    setProperty('henchmanLight2.blend', 0)
    addLuaSprite('henchmanLight2')

    makeLuaSprite('henchmanLight3', path..'henchmanLight', -1750, -377+45)
    setProperty('henchmanLight3.antialiasing', true)
    setProperty('henchmanLight3.alpha', 0)
    setProperty('henchmanLight3.blend', 0)
    addLuaSprite('henchmanLight3')

    makeLuaSprite('henchmanLight4', path..'henchmanLight', -900, -377+45)
    setProperty('henchmanLight4.antialiasing', true)
    setProperty('henchmanLight4.alpha', 0)
    setProperty('henchmanLight4.blend', 0)
    addLuaSprite('henchmanLight4')

    if not lowQuality then
        createInstance('momCorruptBlack', 'objects.Character', {0, 0, 'momCorruptBlack'})
        setProperty('momCorruptBlack.alpha', 0.001)
        setProperty('momCorruptBlack.blend', 0)

        createInstance('gfBlack', 'objects.Character', {0, 0, 'gfBlack'})
        setProperty('gfBlack.alpha', 0.001)
        setProperty('gfBlack.blend', 0)
        setProperty('gfBlack.flipX', getProperty('boyfriend.flipX'))
    end

    makeLuaSprite('blackBG', nil, 300)
    makeGraphic('blackBG', 1, 1, '000000')
    scaleObject('blackBG', 1280, 720)
    setProperty('blackBG.scale.x', getProperty('blackBG.scale.x') * 1.35)
    setProperty('blackBG.scale.y', getProperty('blackBG.scale.y') * 1.35)
    setProperty('blackBG.visible', false)
    addLuaSprite('blackBG')

    makeLuaSprite('redLight', path..'BackLight', -330, -480)
    setProperty('redLight.antialiasing', true)
    setScrollFactor('redLight', 0.95, 1)
    setProperty('redLight.visible', false)
    addLuaSprite('redLight')

    makeLuaSprite('redVin', path..'VinRed', -472, -720)
    setProperty('redVin.antialiasing', true)
    setScrollFactor('redVin', 0, 0)
    setProperty('redVin.visible', false)
    addLuaSprite('redVin')

    makeLuaSprite('gfShocked', path..'gfShockBody', 230, 40)
    scaleObject('gfShocked', 0.9, 0.9, false)
    setProperty('gfShocked.antialiasing', true)
    setScrollFactor('gfShocked', 0, 0)
    setProperty('gfShocked.alpha', 0.001)
    addLuaSprite('gfShocked', true)

    makeLuaSprite('gfShockedEye', path..'gfShockEye', 230, 40)
    scaleObject('gfShockedEye', 0.9, 0.9, false)
    setProperty('gfShockedEye.antialiasing', true)
    setScrollFactor('gfShockedEye', 0, 0)
    setProperty('gfShockedEye.alpha', 0.001)
    setProperty('gfShockedEye.blend', 0)
    addLuaSprite('gfShockedEye', true)

    table.insert(forest, 'forestSky')
    table.insert(forest, 'forestTreeBehinder')
    table.insert(forest, 'forestTreeBehind')
    table.insert(forest, 'forestTree')
    table.insert(forest, 'forestBush')
    table.insert(forest, 'forestFloor')
    table.insert(forest, 'forestBf')
    table.insert(forest, 'forestHench')
    table.insert(forest, 'forestFront')
    table.insert(forest, 'forestForeground')

    addCharacterToList('momSpider', 'dad')

    runHaxeCode([[
        import flixel.group.FlxTypedSpriteGroup;

        var spiderGroup = new FlxTypedSpriteGroup(-998, -3600);
        spiderGroup.scrollFactor.set(1, 1);
        game.addBehindDad(spiderGroup);
        spiderGroup.alpha = 1;
        setVar('spiderGroup', spiderGroup);
    ]])

    makeAnimatedLuaSprite('spiderBackLegs', path..'spiderLegsBack')
    addAnimationByPrefix('spiderBackLegs', 'idle', 'BackLegs', 24, true)
    playAnim('spiderBackLegs', 'idle', true)
    scaleObject('spiderBackLegs', 1.3, 1.3, false)
    setProperty('spiderBackLegs.antialiasing', true)
    runHaxeCode("getVar('spiderGroup').add(game.getLuaObject('spiderBackLegs'));")
    setPosition('spiderBackLegs', -1660, -3255)

    makeAnimatedLuaSprite('spiderBody', path..'spidermm')
    addAnimationByPrefix('spiderBody', 'idle', 'body', 24, true)
    playAnim('spiderBody', 'idle', true)
    scaleObject('spiderBody', 1.3, 1.3, false)
    setProperty('spiderBody.antialiasing', true)
    runHaxeCode("getVar('spiderGroup').add(game.getLuaObject('spiderBody'));")
    setPosition('spiderBody', -1665, -3479)

    runHaxeCode("setVar('momSpider', game.dadMap.get('momSpider'));")

    setProperty('momSpider.alpha', 1)
    runHaxeCode([[
        game.dadGroup.remove(getVar('momSpider'));
        getVar('spiderGroup').add(getVar('momSpider'));
    ]])

    makeAnimatedLuaSprite('spiderFrontLegs', path..'spiderLegsFront')
    addAnimationByPrefix('spiderFrontLegs', 'idle', 'front leg finished', 24, true)
    playAnim('spiderFrontLegs', 'idle', true)
    scaleObject('spiderFrontLegs', 1.3, 1.3, false)
    setProperty('spiderFrontLegs.antialiasing', true)
    runHaxeCode("getVar('spiderGroup').add(game.getLuaObject('spiderFrontLegs'));")
    setPosition('spiderFrontLegs', -1853, -3307)

    setProperty('spiderGroup.x', getProperty('spiderGroup.x') - 275)
    setProperty('spiderGroup.y', getProperty('spiderGroup.y') - 300)

    table.insert(forest, getVar('spiderGroup'))

    makeAnimatedLuaSprite('spiderPunched', path..'spiderPunched')
    addAnimationByPrefix('spiderPunched', 'idle', 'SpiderDeath', 24, false)
    playAnim('spiderPunched', 'idle', true)
    scaleObject('spiderPunched', 1.3, 1.3, false)
    setProperty('spiderPunched.antialiasing', true)
    setProperty('spiderPunched.alpha', 0.001)
    addLuaSprite('spiderPunched', true)
    setPosition('spiderPunched', -1600, -300)

    changingBGCamera = {x = 1070, y = 290}
    frontCameraPos = {x = 830, y = 300}
    forestCameraPos = {x = -200, y = -3300}

    runHaxeCode("setVar('gfRun', game.boyfriendMap.get('gfRun'));")
    setProperty('gfRun.y', -3400)
    setProperty('gfRun.alpha', 1)
    table.insert(forest, 'gfRun')

    for _,spr in pairs(forest) do
        setProperty(spr..'.health', getProperty(spr..'.velocity.x'))
    end

    makeLuaSprite('darkenBG')
    makeGraphic('darkenBG', 1, 1, '000000')
    scaleObject('darkenBG', 1280, 720)
    setScrollFactor('darkenBG', 0, 0)
    setProperty('darkenBG.scale.x', getProperty('darkenBG.scale.x') * 3)
    setProperty('darkenBG.scale.y', getProperty('darkenBG.scale.y') * 3)
    updateHitbox('darkenBG')
    screenCenter('darkenBG')
    setProperty('darkenBG.alpha', 0.001)
    addLuaSprite('darkenBG')

    makeLuaSprite('whiteFade', path..'smallWhiteFade', -1200, -216)
    scaleObject('whiteFade', 1280, 1.5, false)
    setProperty('whiteFade.antialiasing', true)
    setProperty('whiteFade.active', false)
    setProperty('whiteFade.alpha', 0.6)
    setProperty('whiteFade.visible', false)
    addLuaSprite('whiteFade')

    makeLuaSprite('stringsTrappedEnd', path..'stringsTrappedEnd', -1357, -420)
    scaleObject('stringsTrappedEnd', 1.25, 1.25, false)
    setProperty('stringsTrappedEnd.antialiasing', true)
    setProperty('stringsTrappedEnd.active', false)
    setProperty('stringsTrappedEnd.alpha', 0.001)
    addLuaSprite('stringsTrappedEnd')

    makeAnimatedLuaSprite('gfSleep', path..'GfSleep')
    addAnimationByPrefix('gfSleep', 'idle', 'GfSleep', 24, true)
    playAnim('gfSleep', 'idle', true)
    setProperty('gfSleep.antialiasing', true)
    setProperty('gfSleep.alpha', 0.001)
    addLuaSprite('gfSleep', true)

    -- after some videos are added, remember raly
    if not lowQuality then
        addInstance('momCorruptBlack', true)
        addInstance('gfBlack', true)
    end
end

function onCreatePost()
    addOverlay({35.0,16.0,62.0},{203.0, 21.0, 122.0},0.175)

    setPosition('dad', 420, -165)

    if not lowQuality then
        setPosition('gfBlack', getProperty('boyfriend.x') + getProperty('gfBlack.positionArray[0]'), getProperty('boyfriend.y') + getProperty('gfBlack.positionArray[1]'))
        setPosition('momCorruptBlack', getProperty('dad.x'), getProperty('dad.y'))
    end
    setPosition('gfSleep', getProperty('boyfriend.x') + 10, getProperty('boyfriend.y'))

    setProperty('camGame.bgColor', getColorFromHex('808080')) -- gray color in flxcolor


    -- LE VIDEOS
    if buildTarget == 'windows' then
        makeVideoSprite('lightSnow', 'snow light', 0, 0, 'camGame', true)
        scaleObject('lightSnow', 2.5, 2.5, false)
        setScrollFactor('lightSnow', 1.2, 1.2)
        setProperty('lightSnow.blend', 12)
        setObjectOrder('lightSnow', getObjectOrder('gfBlack')+1)

        makeVideoSprite('waveEfx', 'waveEffect', 0, 0, 'camGame', true)
        setProperty('waveEfx.blend', 0)
        setProperty('waveEfx.alpha', 0.001)
        scaleObject('waveEfx', 1.1, 1.1)
        setScrollFactor('waveEfx', 0, 0)
        setProperty('waveEfx.x', -35)
        setProperty('waveEfx.y', -25)
        runHaxeCode("game.getLuaObject('waveEfx').camera = getVar('camOverlay');")
        setObjectOrder('waveEfx', getObjectOrder('gfBlack')+1)
    else
        createInstance('blazeIt', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('blazeIt', 'camGame')
        setObjectOrder('blazeIt', getObjectOrder('gfSleep')+1)
        setProperty('blazeIt.blend', 9)
        setProperty('blazeIt.alpha', 0.001)
        scaleObject('blazeIt', 2.5, 1.5)
        setProperty('blazeIt.x', -70)
        setProperty('blazeIt.y', 0)
		addInstance('blazeIt')

        createInstance('smokeVin', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('smokeVin', 'camGame')
        setObjectOrder('smokeVin', getObjectOrder('blazeIt')+1)
        setProperty('smokeVin.blend', 9)
        setProperty('smokeVin.alpha', 0.001)
        scaleObject('smokeVin', 1.4, 1.4)
        setScrollFactor('smokeVin', 0, 0)
        setProperty('smokeVin.x', -70)
        setProperty('smokeVin.y', 70)
		addInstance('smokeVin')

        createInstance('lightSnow', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('lightSnow', 'camGame')
        setObjectOrder('lightSnow', getObjectOrder('gfBlack')+1)
        scaleObject('lightSnow', 2.5, 2.5, false)
        setScrollFactor('lightSnow', 1.2, 1.2)
        setProperty('lightSnow.blend', 12)
		addInstance('lightSnow')
        callMethod('lightSnow.startVideo', {callMethodFromClass('backend.Paths', 'video', {'snow light'}), true})

        createInstance('heavySnow', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('heavySnow', 'camGame')
        setObjectOrder('heavySnow', getObjectOrder('lightSnow')+1)
        scaleObject('heavySnow', 2.5, 2.5, false)
        setScrollFactor('heavySnow', 1.2, 1.2)
        --screenCenter('heavySnow')
        setProperty('heavySnow.blend', 12)
        setProperty('heavySnow.alpha', 0.001)
		addInstance('heavySnow')

        if not lowQuality then
            createInstance('blackSnow', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		    setObjectCamera('blackSnow', 'camGame')
            setObjectOrder('blackSnow', getObjectOrder('heavySnow')+1)
            scaleObject('blackSnow', 1.25, 1.25)
            setPosition('blackSnow', -960, -190)
            setProperty('blackSnow.blend', 9)
            setProperty('blackSnow.alpha', 0.001)
		    addInstance('blackSnow')
        end

        createInstance('momLaugh', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
        setObjectCamera('momLaugh', 'camGame')
        setObjectOrder('momLaugh', getObjectOrder('blackSnow')+1)
        setScrollFactor('momLaugh', 0, 0)
        setProperty('momLaugh.alpha', 0.001)
        scaleObject('momLaugh', 1 / getProperty('defaultCamZoom'), 1 / getProperty('defaultCamZoom'), false)
        addInstance('momLaugh')

        createInstance('letsSettleThis', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('letsSettleThis', 'camGame')
        setObjectOrder('letsSettleThis', getObjectOrder('momLaugh')+1)
        setScrollFactor('letsSettleThis', 0, 0)
        scaleObject('letsSettleThis', 1 / 1.4, 1 / 1.4, false)
        setProperty('letsSettleThis.alpha', 0.001)
		addInstance('letsSettleThis')

        createInstance('waveEfx', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
        setObjectOrder('waveEfx', getObjectOrder('letsSettleThis')+1)
        setProperty('waveEfx.blend', 0)
        setProperty('waveEfx.alpha', 0.001)
        scaleObject('waveEfx', 1.1, 1.1)
        setScrollFactor('waveEfx', 0, 0)
        setProperty('waveEfx.x', -35)
        setProperty('waveEfx.y', -25)
		addInstance('waveEfx')
        runHaxeCode("getVar('waveEfx').camera = getVar('camOverlay');")
        callMethod('waveEfx.startVideo', {callMethodFromClass('backend.Paths', 'video', {'waveEffect'}), true})
    end

    makeLuaSprite('blackTop')
    makeGraphic('blackTop', 1, 1, '000000')
    scaleObject('blackTop', 1280 * 2, 720 * 2)
    setScrollFactor('blackTop', 0, 0)
    setObjectCamera('blackTop', 'camHUD')
    addLuaSprite('blackTop', true)

    makeLuaSprite('black2')
    makeGraphic('black2', 1, 1, '000000')
    scaleObject('black2', 1280 * 3, 720 * 3)
    setScrollFactor('black2', 0, 0)
    screenCenter('black2')
    setProperty('black2.alpha', 0.001)
    addLuaSprite('black2', true)

    if not lowQuality then
        makeAnimatedLuaSprite('scopeVin', path..'scopeVin')
        addAnimationByPrefix('scopeVin', 'idle', 'scopeVin idle', 20, true)
        playAnim('scopeVin', 'idle', true)
        setScrollFactor('scopeVin', 0, 0)
        scaleObject('scopeVin', 1.6, 1.6, false)
        setProperty('scopeVin.antialiasing', true)
        setProperty('scopeVin.alpha', 0.001)
        setProperty('scopeVin.blend', 0)
        addLuaSprite('scopeVin', true)
        setPosition('scopeVin', 241, 135)
        runHaxeCode("game.getLuaObject('scopeVin').camera = getVar('camOverlay');")

        makeLuaSprite('hurtVin', path..'hurtVin', -300, -170)
        scaleObject('hurtVin', 0.7, 0.7, false)
        setProperty('hurtVin.antialiasing', true)
        setProperty('hurtVin.active', false)
        setProperty('hurtVin.alpha', 0.001)
        setProperty('hurtVin.blend', 9)
        runHaxeCode("game.getLuaObject('hurtVin').camera = getVar('camOverlay');")
        addLuaSprite('hurtVin', true)

        makeLuaSprite('hurtRedVin', path..'redHurtVin', -300, -170)
        setProperty('hurtRedVin.antialiasing', true)
        setScrollFactor('hurtRedVin', 0, 0)
        setProperty('hurtRedVin.active', false)
        setProperty('hurtRedVin.alpha', 0.001)
        setProperty('hurtRedVin.blend', 0)
        runHaxeCode("game.getLuaObject('hurtRedVin').camera = getVar('camOverlay');")
        addLuaSprite('hurtRedVin', true)
    else
        makeLuaSprite('hurtRedVin')
        makeGraphic('hurtRedVin', 1, 1, '000000')
        makeLuaSprite('hurtVin')
        makeGraphic('hurtVin', 1, 1, '000000')
        makeLuaSprite('scopeVin')
        makeGraphic('scopeVin', 1, 1, '000000')
        addLuaSprite('hurtRedVin')
        addLuaSprite('hurtVin')
        addLuaSprite('scopeVin')
    end

    makeLuaSprite('hurtBlack')
    makeGraphic('hurtBlack', 1, 1, '000000')
    scaleObject('hurtBlack', 1280 * 3, 720 * 3)
    setScrollFactor('hurtBlack', 0, 0)
    screenCenter('hurtBlack')
    setProperty('hurtBlack.alpha', 0.001)
    setProperty('hurtBlack.blend', 9)
    addLuaSprite('hurtBlack', true)

    makeLuaSprite('lowVin', path..'lowHealth', -300, -170)
    setProperty('lowVin.antialiasing', true)
    setScrollFactor('lowVin', 0, 0)
    setProperty('lowVin.alpha', 0.001)
    screenCenter('lowVin')
    setProperty('lowVin.blend', 0)
    runHaxeCode("game.getLuaObject('lowVin').camera = getVar('camOverlay');")
    addLuaSprite('lowVin', true)

    makeLuaSprite('bfShadow', path..'shadow', -382, 549)
    scaleObject('bfShadow', 1.1, 1.1, false)
    setProperty('bfShadow.antialiasing', true)
    setProperty('bfShadow.alpha', 0.6)
    addBehindBF('bfShadow')

    makeLuaSprite('dadShadow', path..'shadow', 465,555)
    scaleObject('dadShadow', 1.5, 1.4, false)
    setProperty('dadShadow.antialiasing', true)
    setProperty('dadShadow.alpha', 0.6)
    addBehindBF('dadShadow')

    setObjectCamera('comboGroup', 'camGame')
end

function noteMiss()
    hurtAmount = hurtAmount + 0.2
    hurtAmountBlack = hurtAmountBlack + 0.2

    if curStep >= 631 and curStep < 648 then
        hurtRedAmount = hurtRedAmount + 0.4
        setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.15)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.15)
        setProperty('health', getProperty('health') - 0.35)
    end
end

function altFloor()
    local scaleX = getProperty('floor.scale.x')
    local scaleY = getProperty('floor.scale.y')
    loadGraphic('floor', altFloorGraphic, false)
    setProperty('floor.scale.x', scaleX) setProperty('floor.scale.y', scaleY)
    updateHitbox('floor')
end

function altWall()
    local scaleX = getProperty('wall.scale.x')
    local scaleY = getProperty('wall.scale.y')
    loadGraphic('wall', altWallGraphic, false)
    setProperty('wall.scale.x', scaleX) setProperty('wall.scale.y', scaleY)
    updateHitbox('wall')
end

function normalFloor()
    local scaleX = getProperty('floor.scale.x')
    local scaleY = getProperty('floor.scale.y')
    loadGraphic('floor', floorGraphic, false)
    setProperty('floor.scale.x', scaleX) setProperty('floor.scale.y', scaleY)
    updateHitbox('floor')
end

function normalWall()
    local scaleX = getProperty('wall.scale.x')
    local scaleY = getProperty('wall.scale.y')
    loadGraphic('wall', wallGraphic, false)
    setProperty('wall.scale.x', scaleX) setProperty('wall.scale.y', scaleY)
    updateHitbox('wall')
end

local boyfX = 0
local boyfY = 0

local dadfX = 0
local dadfY = 0

local currentBG = -1

local daBG = -1

function changeBG(id)
    daBG = id
    setProperty('dad.x', dadfX)
    setProperty('dad.y', dadfY)
    setProperty('boyfriend.x', boyfX)
    setProperty('boyfriend.y', boyfY)

    setProperty('camHUD.alpha', 1)
    runHaxeCode("game.camHUD.filters = [];")

    setProperty('stringPrep.visible', false)
    setProperty('stringPrep2.visible', false)
    setProperty('stringsBg.visible', false)

    setProperty('camGame.targetOffset.x', 0)
    setVar('cameraPoint', {x = nil, y = nil})

    if id == 0 then
        addOverlay({79.0,15.0,33.0}, {203.0, 21.0, 122.0}, 0.175)
        normalWall()
        normalFloor()
        setProperty('waveEfx.alpha', 0.1)
        setProperty('gfSleep.alpha', 0.001)
        setProperty('boyfriend.alpha', 1)
        setProperty('heavySnow.alpha', 0.001)
        setProperty('smokeVin.alpha', 0.001)
        setProperty('scopeVin.alpha', 0.4)
    elseif id == 1 then
        setProperty('waveEfx.alpha', 0.001)

        if buildTarget == 'windows' then
            makeVideoSprite('heavySnow', 'snow heavy', 0, 0, 'camGame', true)
            scaleObject('heavySnow', 2.5, 2.5)
            setScrollFactor('heavySnow', 1.2, 1.2)
            screenCenter('heavySnow')
            setProperty('heavySnow.blend', 12)
            setProperty('heavySnow.alpha', 0.6)
            setObjectOrder('heavySnow', getObjectOrder('lightSnow')+1)
        else
            setProperty('heavySnow.paused', false)
            setProperty('heavySnow.alpha', 0.6)
        end

        addOverlay({75.0,26.0,233.0},{203.0, 21.0, 122.0},0.075)

        setProperty('camHUD.alpha', 0.5)
        if shadersEnabled then
            runHaxeCode([[
                game.camGame.filters = [];
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('blur').shader)]);
            ]])
        end
        setProperty('stringPrep.visible', true)
        setProperty('stringPrep2.visible', true)
        altWall()
        altFloor()
        setProperty('stringsBg.visible', true)
        setProperty('boyfriend.alpha', 0.001)
        setProperty('gfSleep.alpha', 1)
        setProperty('scopeVin.alpha', 0.001)
    elseif id == 2 then
        addOverlay({75.0,26.0,233.0},{203.0, 21.0, 122.0},0.075)

        setProperty('smokeVin.alpha', 0.001)
        setProperty('waveEfx.alpha', 0.1)

        setProperty('forestForeground.alpha', 0.001)
        setProperty('forestFront.alpha', 0.001)
        setProperty('forestBf.alpha', 0.001)
        setProperty('forestHench.alpha', 0.001)
        setProperty('gfSleep.alpha', 0.001)
        setProperty('boyfriend.alpha', 1)
        setProperty('boyfriend.y', -3400 + getProperty('boyfriend.positionArray[1]') + 25)
        setProperty('dad.y', -3400 + getProperty('dad.positionArray[1]'))
        setProperty('scopeVin.alpha', 0.4)
    end

    local camDad = {
        x = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'),
        y = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
    }
    local camBf = {
        x = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]'),
        y = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
    }
    callMethod('camFollow.setPosition', {mustHitSection and camBf.x or camDad.x, mustHitSection and camBf.y or camDad.y})
    setProperty('camGame.scroll.x', mustHitSection and camBf.x or camDad.x - (screenWidth/2))
    setProperty('camGame.scroll.y', mustHitSection and camBf.y or camDad.y - (screenHeight/2))
end

local bgs = {2,0,2,1,2,0}

function onEvent(name, v1, v2)
    if name == 'swapbg' then
        setProperty('black2.alpha', 1)
        startTween('blackie2', 'black2', {alpha = 0.001}, 0.8, {ease = 'quadOut'})

        if dadfX == 0 then
            dadfX = getProperty('dad.x')
            dadfY = getProperty('dad.y')
        end

        currentBG = currentBG + 1

        if currentBG >= #bgs then
            currentBG = 0 end

        changeBG(bgs[currentBG])
    end

    if name == 'stoprun' then
        if v1 == '1' then
            stopping = true

            cancelTween('spiderTween')
            startTween('setSPos', 'spiderGroup', {x = 200}, 2, {})

            setProperty('gfRun.alpha', 0.001)
            boyfX = getProperty('boyfriend.x')
            boyfY = getProperty('boyfriend.y')
            setPosition('boyfriend', getProperty('gfRun.x'), getProperty('gfRun.y'))
            setProperty('boyfriend.x', getProperty('boyfriend.x') + 150)
            setProperty('boyfriend.visible', true) setProperty('boyfriend.alpha', 1)
            triggerEvent('Change Character', 'bf', 'gfRage')
        elseif v1 == '4' then
            setCameraAlignment("", "",0,0)
            setProperty('camGame.targetOffset.x', 0)
        elseif v1 == '3' then
            running = false

            setProperty('spiderGroup.alpha', 0.001)
            setProperty('spiderGroup.visible', false)
            setProperty('spiderPunched.alpha', 1)
            playAnim('spiderPunched', 'idle', true)

            setPosition('boyfriend', boyfX, boyfY)

            setProperty('forestForeground.alpha', 0.001)
            setProperty('scopeVin.alpha', 0.001)

            setProperty('stringPrep.visible', false)
            setProperty('stringPrep2.visible', false)
            setProperty('stringsBg.visible', false)
            normalFloor()
            normalWall()

            setProperty('darkenBG.visible', true)
            setProperty('darkenBG.alpha', 1)
            startTween('undark', 'darkenBG', {alpha = 0.001}, 2, {})
            startTween('scope', 'scopeVin', {alpha = 0.4}, 2, {})

            setCameraAlignment("0", "",0,0)
            setProperty('gfSleep.alpha', 0.001)
            setProperty('camGame.targetOffset.x', -300)
        elseif v1 == 'henchbf' then
            setProperty('forestBf.visible', true) setProperty('forestBf.alpha', 1)
            setProperty('forestBf.x', -720 + 2250)
        elseif v1 == 'return' then
            runHaxeCode("game.camHUD.filters = [];")
            running = true

            callMethod('camFollow.setPosition', {forestCameraPos.x, forestCameraPos.y})
            setProperty('camGame.scroll.x', forestCameraPos.x - (screenWidth/2))
            setProperty('camGame.scroll.y', forestCameraPos.y - (screenHeight/2))
            setVar('cameraPoint', forestCameraPos)

            setProperty('camHUD.alpha', 1)

            setProperty('scopeVin.alpha', 0.4)
            
            if buildTarget ~= 'windows' then
                setProperty('heavySnow.paused', true)
                setProperty('heavySnow.alpha', 0.001)
            end
        elseif v1 == 'sad' then
            if buildTarget ~= 'windows' then
                callMethod('heavySnow.startVideo', {callMethodFromClass('backend.Paths', 'video', {'snow heavy'}), true})
                setProperty('heavySnow.alpha', 0.6)
            end

            running = false

            setProperty('waveEfx.alpha', 0.001)
            setProperty('scopeVin.alpha', 0.001)
            
            runHaxeCode([[
                game.camHUD.filters = [];
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('blur').shader)]);
            ]])

            setProperty('camHUD.alpha', 0.5)

            setProperty('gfSleep.alpha', 1)
            setProperty('boyfriend.visible', false)
            altWall()
            altFloor()

            setVar('cameraPoint', {x = nil, y = nil})
            local camBf = {
                x = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]'),
                y = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
            }
            callMethod('camFollow.setPosition', {camBf.x, camBf.y})
            setProperty('camGame.scroll.x', camBf.x - (screenWidth/2))
            setProperty('camGame.scroll.y', camBf.y - (screenHeight/2))

            setProperty('stringsBg.visible', true)
            triggerEvent('Change Character', 'dad', 'momCorrupt')
        elseif v1 == 'henchmen' then
            addOverlay({79.0,15.0,33.0},{203.0,21.0,122.0},0.175)
            setProperty('forestHench.alpha', 1)
        end
    end

    if name == 'addelement' then
        if v1 == 'runsetup' then
            setProperty('camHUD.alpha', 1)
            setProperty('scopeVin.alpha', 0.4)
        elseif v1 == 'fadeout' then
            if v2 == '1' then
                setProperty('blackTop.alpha', 1)
                startTween('unblack', 'blackTop', {alpha = 0.001}, 2, {ease = 'quadOut'})
            elseif v2 == '2' then
                setProperty('blackTop.alpha', 1)
                startTween('unblack', 'blackTop', {alpha = 0.001}, 1, {ease = 'quadOut'})
            end
        elseif v1 == 'camfilters' then
            if shadersEnabled then
                runHaxeCode([[
                    game.camGame.filters = [];
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject('overlay').shader), new ShaderFilter(game.getLuaObject('bloom').shader)]);
                ]])
            end
            setProperty('camHUD.alpha', 1)
        end
    end

    if name == 'playvideo' then
        if v1 == 'letssettle' then
            runHaxeCode("game.camGame.filters = [];")
            if buildTarget == 'windows' then
                makeVideoSprite('letsSettleThis', 'letsSettleThis', 0, 0, 'camGame', false)
                setScrollFactor('letsSettleThis')
                scaleObject('letsSettleThis', 1 / 1.4, 1 / 1.4)
                setObjectOrder('letsSettleThis', getObjectOrder('momLaugh')+1)
            else
                setProperty('letsSettleThis.alpha', 1)
                callMethod('letsSettleThis.startVideo', {callMethodFromClass('backend.Paths', 'video', {'letsSettleThis'}), false})
            end
            setProperty('camHUD.alpha', 0.001)
        elseif v1 == 'smoke' then
            henchTime = false
            startTween('fadie', 'fade', {x = -800, alpha = 1}, 4, {})

            if buildTarget == 'windows' then
                makeVideoSprite('blazeIt', 'smokeEffect', 0, 0, 'camGame', false)
                setProperty('blazeIt.blend', 9)
                setProperty('blazeIt.alpha', 0.001)
                scaleObject('blazeIt', 2.5, 1.5)
                setProperty('blazeIt.x', -1200)
                setProperty('blazeIt.y', -200)
                setObjectOrder('blazeIt', getObjectOrder('gfBlack')+1)
            else
                callMethod('blazeIt.startVideo', {callMethodFromClass('backend.Paths', 'video', {'smokeEffect'}), false})
            end

            startTween('smokie', 'blazeIt', {alpha = 0.8}, 1, {})
            triggerEvent('Change Character', 'bf', 'gfRage')

            addOverlay({75.0,26.0,233.0},{203.0, 21.0, 122.0},0.075)
            if not lowQuaility then
                startTween('momblack', 'momCorruptBlack', {alpha = 1}, 4, {})
                startTween('gfblack', 'gfBlack', {alpha = 1}, 4, {})
            end
        elseif v1 == 'smokevin' then
            if buildTarget == 'windows' then
                makeVideoSprite('smokeVin', 'smokeVin', 0, 0, 'camGame', true)
                setProperty('smokeVin.blend', 9)
                scaleObject('smokeVin', 1.4, 1.4)
                setScrollFactor('smokeVin', 0, 0)
                setProperty('smokeVin.x', -270)
                setProperty('smokeVin.y', -130)
                setProperty('smokeVin.alpha', 0.001)
                setObjectOrder('smokeVin', getObjectOrder('gfBlack')+1)
            else
                callMethod('smokeVin.startVideo', {callMethodFromClass('backend.Paths', 'video', {'smokeVin'}), true})
            end

            startTween('smoke', 'smokeVin', {alpha = 0.8}, 1, {})
        elseif v1 == 'smokevinhide' then
            startTween('smokehide', 'smokeVin', {alpha = 0.001}, 4, {})
        elseif v1 == 'snow' then
            if playing then return end
            playing = true
            setProperty('lightSnow.visible', true)
            startTween('snowie', 'lightSnow', {alpha = 0.5}, 1, {})
        elseif v1 == 'stop snow' then
            if shadersEnabled then
                runHaxeCode([[
                    game.camGame.filters = [];
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject('bloom').shader)]);
                ]])
            end
            addOverlay({79.0,15.0,33.0},{203.0, 21.0, 122.0},0.175)
            setProperty('lightSnow.visible', false)
            setProperty('lightSnow.alpha', 0.001)
            henchTime = true
            callMethod('bfTrail.remove', {''})
        end

        if v1 == 'momlaugh' then
            runHaxeCode("game.camGame.filters = [];")
            setProperty('camZooming', false)

            if buildTarget == 'windows' then
                makeVideoSprite('momLaugh', 'momLaugh', 0, 0, 'camGame')
                setScrollFactor('momLaugh', 0, 0)
                scaleObject('momLaugh', 1 / getProperty('defaultCamZoom'), 1 / getProperty('defaultCamZoom'), false)
                setObjectOrder('momLaugh', getObjectOrder('waveEfx')+1)
            else
                callMethod('momLaugh.startVideo', {callMethodFromClass('backend.Paths', 'video', {'momLaugh'}), false})
                setProperty('momLaugh.alpha', 1)
            end
            setProperty('camHUD.alpha', 0.001)
        end
    end

    if name == 'changeBf' then
        if v1 == 'gfend' then
            if shadersEnabled then
                runHaxeCode([[
                    game.camGame.filters = [];
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject('bloom').shader)]);
                ]])
            end
            setCameraAlignment("0", "",-150,-50)
            triggerEvent('Change Character', 'bf', 'gfDark')
            for _,s in pairs(forest) do
                setProperty(s..'.visible', false) end

            runHaxeCode("game.camHUD.filters = [];")
            setProperty('smokeVin.alpha', 0)
            setProperty('smokeVin.paused', true)
            setPosition('boyfriend', -322, 20)
            
            setProperty('blackSnow.visible', true)
            setProperty('blackSnow.alpha', 1)
            callMethod('blackSnow.startVideo', {callMethodFromClass('backend.Paths', 'video', {'dark snow'}), false})

            setProperty('wall.visible', false)
            setProperty('floor.visible', false)
            setProperty('stringPrep.visible', false)
            setProperty('stringPrep2.visible', false)
            setProperty('sky.visible', false)
            setProperty('building.visible', false)
            runHaxeCode([[
                var heavySnow = buildTarget != 'windows' ? getVar('heavySnow') : game.getLuaObject('heavySnow');
                var lightSnow = buildTarget != 'windows' ? getVar('lightSnow') : game.getLuaObject('lightSnow');
                game.remove(heavySnow);
                heavySnow.destroy();
                game.remove(lightSnow);
                lightSnow.destroy();
            ]])

            setProperty('darkenBG.visible', true)
            setProperty('darkenBG.alpha', 1)

            setProperty('whiteFade.visible', true)
        elseif v1 == 'stringsappear' then
            startTween('cantescape', 'stringsTrappedEnd', {alpha = 1}, 15, {})
        elseif v1 == 'trapped' then
            setProperty('camHUD.alpha', 0.4)
            runHaxeCode([[
                game.camHUD.filters = [];
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('blur').shader)]);
            ]])
            addOverlay({75.0,26.0,233.0},{203.0, 21.0, 122.0},0.075)
            setProperty('dad.visible', false)
            stringPulsing = false
            setCameraAlignment("0", "",0,0)

            changeBG(1)
            daBG = -1

            cameraSetTarget('boyfriend')
            setProperty('camGame.targetOffset.x', -300)

            setProperty('gfSleep.visible', false)
            setProperty('boyfriend.visible', true) setProperty('boyfriend.alpha', 1)
            setProperty('stringsBg.visible', true)
            setProperty('stringsBgShoot.visible', true)
        elseif v1 == 'tween1' then
            cancelTween('spiderTween')
            startTween('setSpiderPos', 'spiderGroup', {x = -2000}, 6, {ease = 'sineInOut'})
        elseif v1 == 'run' then
            running = true
            setProperty('defaultCamZoom', 0.6)
            setProperty('letsSettleThis.visible', false)
            setProperty('blackBG.visible', false)

            addOverlay({75.0,26.0,233.0},{203.0, 21.0, 122.0},0.075)
            setProperty('comboGroup.visible', true)

            redLightMode = 0
            frontView = false

            startTween('spiderTween', 'spiderGroup', {x = -998}, 7, {ease = 'sineInOut', type = 'pingpong'})

            forestCameraPos.x = -100
            forestCameraPos.y = -3300

            callMethod('camFollow.setPosition', {forestCameraPos.x, forestCameraPos.y})
            setProperty('camGame.scroll.x', forestCameraPos.x - (screenWidth/2))
            setProperty('camGame.scroll.y', forestCameraPos.y - (screenHeight/2))
            setVar('cameraPoint', forestCameraPos)
        elseif v1 == 'prepend' then
            canZoom = false
            setProperty('defaultCamZoom', 0.9)
        elseif v1 == 'front2' then
            triggerEvent('Change Character', 'dad', 'momFrontSecond')
            redLightMode = 2
        elseif v1 == 'powerup2' then
            setProperty('defaultCamZoom', 1.8)
            setProperty('camGame.targetOffset.x', 0)
        elseif v1 == 'fronthide' then
            startTween('shocked', 'gfShocked', {alpha = 0}, 1, {})
        elseif v1 == 'front' then
            setProperty('fade.alpha', 0.001)
            setProperty('comboGroup.visible', false)
            setProperty('defaultCamZoom', 1.4)

            setProperty('camGame.targetOffset.x', 0)
            callMethod('camFollow.setPosition', {frontCameraPos.x, frontCameraPos.y})
            setProperty('camGame.scroll.x', frontCameraPos.x - (screenWidth/2))
            setProperty('camGame.scroll.y', frontCameraPos.y - (screenHeight/2))

            runHaxeCode([[
                var blazeIt = buildTarget != 'windows' ? getVar('blazeIt') : game.getLuaObject('blazeIt');
                game.remove(blazeIt);
                blazeIt.destroy();
            ]])

            if shadersEnabled then
                runHaxeCode([[
                    game.camGame.filters = [];
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject('bloom').shader)]);
                ]])
            end

            setProperty('fade.visible', false)
            triggerEvent('Change Character', 'dad', 'momFront')
            frontView = true
            setVar('cameraPoint', frontCameraPos)

            setProperty('redLight.visible', true)
            setProperty('redVin.visible', true)
            if not lowQuality then
                setProperty('gfBlack.visible', false)
                setProperty('momCorruptBlack.visible', false)
            end
            setProperty('boyfriend.visible', false)

            setProperty('blackBG.visible', true)

            redLightMode = 1

            setProperty('gfShocked.alpha', 0.6)
            setProperty('gfShockedEye.alpha', 1)

            startTween('shockEye', 'gfShockedEye', {alpha = 0}, 1, {})
            startTween('hudalpha', 'camHUD', {alpha = 0.4}, 0.2, {})
        elseif v1 == 'gfnorm' then
            triggerEvent('Change Character', 'bf', 'gfNorm')
        elseif v1 == 'gfrage' then
            triggerEvent('Change Character', 'bf', 'gfRage')
        end
    end

    if name == 'stringattack' then
        if v1 == 'prep1' then
            setProperty('stringPrep.alpha', 1)
            playAnim('stringPrep', 'idle', true)
        elseif v1 == 'prep2' then
            setProperty('stringPrep2.alpha', 1)
            playAnim('stringPrep2', 'idle', true)
        elseif v1 == 'shoot1' then
            playSound('stringAttack')
            setProperty('stringPrep.alpha', 0.001)
            setProperty('stringShoot.alpha', 1)
            playAnim('stringShoot', 'idle', true)
            addTrail('boyfriend', 10, 5)
        elseif v1 == 'shoot2' then
            setProperty('stringPrep2.alpha', 0.001)
            setProperty('stringShoot2.alpha', 1)
            playAnim('stringShoot2', 'idle', true)
        end
    end

    if name == 'camshit' then
        if v1 == 'gf2' then
            canZoom = false
            setProperty('defaultCamZoom', 0.9)
            setCameraAlignment("0", "",0,0)
            if not running then
                setProperty('camGame.targetOffset.x', -100)
            end
        elseif v1 == 'mm' then
            canZoom = false
            setProperty('defaultCamZoom', 0.9)
            setCameraAlignment("1", "",150,-50)
        elseif v1 == 'mid' then
            canZoom = false
            setProperty('defaultCamZoom', 0.75)
            setCameraAlignment("0.5", "",-100,0)
        elseif v1 == 'gf' then
            canZoom = false
            setProperty('defaultCamZoom', 0.9)
            setCameraAlignment("0", "",-150,0)
        elseif v1 == 'mm2' then
            canZoom = false
            setProperty('defaultCamZoom', 0.9)
            setCameraAlignment("1", "",0,0)
        elseif v1 == 'undo' then
            canZoom = true
        elseif v1 == 'none' then
            canZoom = true
            setCameraAlignment("", "",0,0)
        end
    end

    if name == 'specialbump' then
        if v1 == 'small' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.1)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.04)
        elseif v1 == 'small2' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.1)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.04)
        elseif v1 == 'run' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.1)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.04)
        elseif v1 == 'riser' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.05)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.02)
            setShaderFloat('bloom', 'intensity', 0.1)
        elseif v1 == 'big' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.15)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.07)
        elseif v1 == 'big2' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.15)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.07)
            setShaderFloat('bloom', 'intensity', 0.5)
        elseif v1 == 'flash' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.2)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.08)
            setShaderFloat('bloom', 'intensity', 1.0)
        elseif v1 == 'dark' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.2)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.08)
            setProperty('black2.alpha', 0.8)
            startTween('undark', 'black2', {alpha = 0}, 0.8, {ease = 'quadOut'})
        end
    end
end

function onBeatHit()
    if curBeat % 4 == 0 and henchTime then
        if henchWhich then
            setProperty('henchmanLight.alpha', 0.6)
            setProperty('henchmanLight3.alpha', 0.1)
        else
            setProperty('henchmanLight2.alpha', 0.6)
            setProperty('henchmanLight4.alpha', 0.1)
        end
        henchWhich = not henchWhich
    end

    if curBeat % 8 == 0 and getProperty('whiteFade.visible') then
        setProperty('whiteFade.alpha', 0.6)
    end

    if curBeat % 4 == 0 then
        setProperty('stringsBg.alpha', 1)
    end
    setProperty('stringsBgShoot.alpha', getProperty('stringsBg.alpha'))

    if redLightMode == 1 then
        if curBeat % 8 == 0 then
            setProperty('redLight.alpha', getProperty('redLight.alpha') + 0.85)
        elseif curBeat % 4 == 0 then
            setProperty('redLight.alpha', getProperty('redLight.alpha') + 0.53)
        end
    elseif redLightMode == 2 then
        if curBeat % 8 == 0 then
            setProperty('redLight.alpha', getProperty('redLight.alpha') + 0.85)
            setProperty('redVin.alpha', getProperty('redVin.alpha') + 0.3)
        elseif curBeat % 4 == 0 then
            setProperty('redLight.alpha', getProperty('redLight.alpha') + 0.53)
            setProperty('redVin.alpha', getProperty('redVin.alpha') + 0.2)
        elseif curBeat % 2 == 0 then
            setProperty('redLight.alpha', getProperty('redLight.alpha') + 0.33)
            setProperty('redVin.alpha', getProperty('redVin.alpha') + 0.1)
        end
    end
end

function addOverlay(col1,col2,blend)
    arrT = col1
    arrR = col2
    poses = {0.5,-.15}
    amtt = blend
    trans = false

    setShaderFloat('overlay', 'rT', arrT[1]/255)
    setShaderFloat('overlay', 'gT', arrT[2]/255)
    setShaderFloat('overlay', 'bT', arrT[3]/255)
    setShaderFloat('overlay', 'rR', arrR[1]/255)
    setShaderFloat('overlay', 'gR', arrR[2]/255)
    setShaderFloat('overlay', 'bR', arrR[3]/255)
    setShaderFloat('overlay', 'ypos', poses[2])
    setShaderFloat('overlay', 'xpos', poses[1])
    setShaderFloat('overlay', 'amt', amtt)
    setShaderBool('overlay', 'trans', trans)

    runHaxeCode([[
        game.camGame.filters = [];
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject('overlay').shader), new ShaderFilter(game.getLuaObject('bloom').shader)]);
    ]])
end

function addTrail(who, length, delay, alpha, diff)
    if length == nil then length = 4 end
    if delay == nil then delay = 24 end
    if alpha == nil then alpha = 0.4 end
    if diff == nil then diff = 0.069 end

    runHaxeCode([[
        import flixel.addons.effects.FlxTrail;

        var bfTrail = new FlxTrail(]]..who..[[, null, ]]..length..[[, ]]..delay..[[, ]]..alpha..[[, ]]..diff..[[);
        bfTrail.color = 0xFFFF0000;
        game.addBehindBF(bfTrail);
        setVar('bfTrail', bfTrail);
    ]])
end

function onSectionHit()
    if not canZoom then return end

    if running then
        if mustHitSection then
            forestCameraPos.x = -100
			forestCameraPos.y = -3300
        else
            forestCameraPos.x = -750
			forestCameraPos.y = -3550
        end
        setVar('cameraPoint', forestCameraPos)
    end

    if frontView then
        setProperty('defaultCamZoom', 1.4)
        return
    end

    if mustHitSection then
        setProperty('defaultCamZoom', running and 0.925 or 0.825)
    else
        setProperty('defaultCamZoom', running and 0.65 or 0.725)
    end
end

local rate = 1
function onUpdate(elapsed)
    playAnim('gfBlack', getProperty('boyfriend.animation.curAnim.name'), true)
    setProperty('gfBlack.animation.curAnim.curFrame', getProperty('boyfriend.animation.curAnim.curFrame'))
    playAnim('momCorruptBlack', getProperty('dad.animation.curAnim.name'), true)
    setProperty('momCorruptBlack.animation.curAnim.curFrame', getProperty('dad.animation.curAnim.curFrame'))

    if stopping then
		rate = rate - elapsed
		if rate < 0 then
			rate = 0 end
			
	    for _, s in pairs(forest) do
	        setProperty(s..'.velocity.x', getProperty(s..'.health') * rate)
	    end
	end

    if hurtAmount > 0 then
        hurtAmount = hurtAmount - 0.2 * elapsed
    elseif hurtAmount < 0 then
        hurtAmount = 0
    end

    if hurtRedAmount > 0 then
        hurtRedAmount = hurtRedAmount - 0.4 * elapsed
    elseif hurtRedAmount < 0 then
        hurtRedAmount = 0
    end

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

    setProperty('hurtVin.alpha', hurtAmount)
    setProperty('hurtRedVin.alpha', hurtRedAmount)
    setProperty('hurtBlack.alpha', hurtAmountBlack)

    if getProperty('whiteFade.alpha') > 0 and getProperty('whiteFade.visible') then
        setProperty('whiteFade.alpha', getProperty('whiteFade.alpha') - elapsed/4)
    end

    if getProperty('redLight.alpha') > 0 then
        setProperty('redLight.alpha', getProperty('redLight.alpha') - elapsed)
    end
    if getProperty('redVin.alpha') > 0 then
        setProperty('redVin.alpha', getProperty('redVin.alpha') - elapsed)
    end

    if getShaderFloat('bloom', 'intensity') > 0 then
        setShaderFloat('bloom', 'intensity', getShaderFloat('bloom', 'intensity') - elapsed)
    end

    if getProperty('henchmanLight.alpha') > 0 then
        setProperty('henchmanLight.alpha', getProperty('henchmanLight.alpha') - elapsed/2)
    end
    if getProperty('henchmanLight2.alpha') > 0 then
        setProperty('henchmanLight2.alpha', getProperty('henchmanLight2.alpha') - elapsed/2)
    end
    if getProperty('henchmanLight3.alpha') > 0 then
        setProperty('henchmanLight3.alpha', getProperty('henchmanLight3.alpha') - elapsed/6)
    end
    if getProperty('henchmanLight4.alpha') > 0 then
        setProperty('henchmanLight4.alpha', getProperty('henchmanLight4.alpha') - elapsed/6)
    end

    if getProperty('stringsBg.alpha') > 0.5 and getProperty('stringsBg.visible') and stringPulsing then
        setProperty('stringsBg.alpha', getProperty('stringsBg.alpha') - elapsed * 0.5)
    end
end

function setCameraAlignment(value1, value2, offsetX, offsetY)
    local sowy = tonumber(value1)

    if type(sowy) == 'number' then
        local camDad = {
            x = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'),
            y = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]')
        }
        local camBf = {
            x = getMidpointX('boyfriend') - 100 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]'),
            y = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]')
        }

        local dadX = camDad.x + offsetX
        local dadY = camDad.y + offsetY

        local bfX = camBf.x + offsetX
        local bfY = camBf.y + offsetY

        local minX
        local minY
        local maxX
        local maxY

        if dadX < bfX then
            minX = dadX
            maxX = bfX

            minY = dadY
            maxY = bfY
        else
            maxX = dadX
            minX = bfX

            maxY = dadY
            minY = bfY
        end

        triggerEvent(
            "Camera Follow Pos",
            tostring(callMethodFromClass('flixel.math.FlxMath', 'lerp', {minX, maxX, sowy})),
            tostring(callMethodFromClass('flixel.math.FlxMath', 'lerp', {minY, maxY, sowy}))
        )

        local cusSpeed = tonumber(value2)
        if type(cusSpeed) == 'number' then
            setProperty('cameraSpeed', getProperty('cameraSpeed') * cusSpeed)
        end
    else
        triggerEvent("Camera Follow Pos", "", "")
    end
end

function opponentNoteHit(i,d,_,_)
    playAnim('momSpider', getProperty('singAnimations')[d+1], true)
    setProperty('momSpider.holdTimer', 0)
end

function setPosition(obj,x,y)
    setProperty(obj..'.x', x)
    setProperty(obj..'.y', y)
end

function addBehindBF(spr)
    addLuaSprite(spr)
    setObjectOrder(spr, getObjectOrder('boyfriendGroup'))
end
