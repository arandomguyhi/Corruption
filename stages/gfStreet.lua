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
    addCharacterToList("gfRage", 'bf')
    addCharacterToList("momFront", 'dad')
    addCharacterToList("momFrontSecond", 'dad')
    addCharacterToList("gfNorm", 'bf')
    addCharacterToList("momCorrupt", 'dad')
    addCharacterToList("gfDark", 'bf')
	addCharacterToList("gfRun", 'bf')

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
    setProperty('stringsBgShoot.alpha', 0.001)
    setProperty('stringsBg.alpha', 0.001)

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
        setPosition('momCorruptBlack', getProperty('dad.x'), getProperty('dad.y'))
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
    setProperty('blackBG.alpha', 0.001)
    addLuaSprite('blackBG')

    makeLuaSprite('redLight', path..'BackLight', -330, -480)
    setProperty('redLight.antialiasing', true)
    setScrollFactor('redLight', 0.95, 1)
    setProperty('redLight.alpha', 0.001)
    addLuaSprite('redLight')

    makeLuaSprite('redVin', path..'VinRed', -472, -720)
    setProperty('redVin.antialiasing', true)
    setScrollFactor('redVin', 0, 0)
    setProperty('redVin.alpha', 0.001)
    addLuaSprite('redVin')

    makeLuaSprite('gfShocked', path..'gfShockedBody', 230, 40)
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

    addCharacterToList("momSpider", 'dad')

    makeAnimatedLuaSprite('spiderBackLegs', path..'spiderLegsBack')
    addAnimationByPrefix('spiderBackLegs', 'idle', 'BackLegs', 24, true)
    playAnim('spiderBackLegs', 'idle', true)
    scaleObject('spiderBackLegs', 1.3, 1.3, false)
    setProperty('spiderBackLegs.antialiasing', true)
    table.insert(spiderGroup, 'spiderBackLegs')
    addLuaSprite('spiderBackLegs')
    setPosition('spiderBackLegs', -1660, -3255)

    makeAnimatedLuaSprite('spiderBody', path..'spidermm')
    addAnimationByPrefix('spiderBody', 'idle', 'body', 24, true)
    playAnim('spiderBody', 'idle', true)
    scaleObject('spiderBody', 1.3, 1.3, false)
    setProperty('spiderBody.antialiasing', true)
    table.insert(spiderGroup, 'spiderBody')
    addLuaSprite('spiderBody')
    setPosition('spiderBody', -1665, -3479)

    makeAnimatedLuaSprite('spiderFrontLegs', path..'spiderLegsFront')
    addAnimationByPrefix('spiderFrontLegs', 'idle', 'front leg finished', 24, true)
    playAnim('spiderFrontLegs', 'idle', true)
    scaleObject('spiderFrontLegs', 1.3, 1.3, false)
    setProperty('spiderFrontLegs.antialiasing', true)
    table.insert(spiderGroup, 'spiderFrontLegs')
    addLuaSprite('spiderFrontLegs')
    setPosition('spiderFrontLegs', -1853, -3307)

    for _, i in pairs(spiderGroup) do
        setProperty(i..'.y', getProperty(i..'.y') - 275)
        setProperty(i..'.x', getProperty(i..'.x') - 300)

        table.insert(forest, i)
    end

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
    setProperty('gfSleep.visible', false)
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
        setObjectCamera('waveEfx', 'camOther')
        setObjectOrder('waveEfx', getObjectOrder('gfBlack')+1)
    else
        createInstance('smokeVin', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('smokeVin', 'camGame')
        setObjectOrder('smokeVin', getObjectOrder('gfBlack')+1)
        setProperty('smokeVin.blend', 9)
        setProperty('smokeVin.alpha', 0.001)
        scaleObject('smokeVin', 1.4, 1.4)
        setScrollFactor('smokeVin', 0, 0)
        setProperty('smokeVin.x', -270)
        setProperty('smokeVin.y', -130)
		addInstance('smokeVin')

        createInstance('lightSnow', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('lightSnow', 'camGame')
        setObjectOrder('lightSnow', getObjectOrder('smokeVin')+1)
        scaleObject('lightSnow', 2.5, 2.5, false)
        setScrollFactor('lightSnow', 1.2, 1.2)
        setProperty('lightSnow.blend', 12)
		addInstance('lightSnow')
        callMethod('lightSnow.startVideo', {callMethodFromClass('backend.Paths', 'video', {'snow light'}), true})

        createInstance('waveEfx', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
		setObjectCamera('waveEfx', 'camGame')
        setObjectOrder('waveEfx', getObjectOrder('lightSnow')+1)
        setProperty('waveEfx.blend', 12)
        setProperty('waveEfx.alpha', 0.001)
        scaleObject('waveEfx', 1.1, 1.1)
        setScrollFactor('waveEfx', 0, 0)
        setProperty('waveEfx.x', -35)
        setProperty('waveEfx.y', -25)
		addInstance('waveEfx')
        callMethod('waveEfx.startVideo', {callMethodFromClass('backend.Paths', 'video', {'waveEffect'}), true})

        createInstance('momLaugh', 'backend.VideoSpriteManager', {0, 0, screenWidth, screenHeight})
        setObjectCamera('momLaugh', 'camGame')
        setObjectOrder('momLaugh', getObjectOrder('waveEfx')+1)
        setScrollFactor('momLaugh', 0, 0)
        scaleObject('momLaugh', 1 / getProperty('defaultCamZoom'), 1 / getProperty('defaultCamZoom'), false)
        addInstance('momLaugh')
    end

    makeLuaSprite('blackTop')
    makeGraphic('blackTop', 1, 1, '000000')
    scaleObject('blackTop', 1280 * 2, 720 * 2)
    setScrollFactor('blackTop', 0, 0)
    setProperty('blackTop.alpha', 0.001)
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
        setObjectCamera('scopeVin', 'camOther') -- creating camOverlay when i find it

        makeLuaSprite('hurtVin', path..'hurtVin', -300, -170)
        scaleObject('hurtVin', 0.7, 0.7, false)
        setProperty('hurtVin.antialiasing', true)
        setProperty('hurtVin.active', false)
        setProperty('hurtVin.alpha', 0.001)
        setProperty('hurtVin.blend', 9)
        setObjectCamera('scopeVin', 'camOther')
        addLuaSprite('hurtVin', true)

        makeLuaSprite('hurtRedVin', path..'redHurtVin', -300, -170)
        setProperty('hurtRedVin.antialiasing', true)
        setScrollFactor('hurtRedVin', 0, 0)
        setProperty('hurtRedVin.active', false)
        setProperty('hurtRedVin.alpha', 0.001)
        setProperty('hurtRedVin.blend', 0)
        setObjectCamera('hurtRedVin', 'camOther')
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
    setObjectCamera('lowVin', 'camOther')
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

    setProperty('stringPrep.alpha', 0.001)
    setProperty('stringPrep2.alpha', 0.001)
    setProperty('stringsBg.alpha', 0.001)

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

        makeVideoSprite('heavySnow', 'snow heavy', 0, 0, 'camGame', true)
        scaleObject('heavySnow', 2.5, 2.5)
        setScrollFactor('heavySnow', 1.2, 1.2)
        screenCenter('heavySnow')
        setProperty('heavySnow.blend', 12)
        setObjectOrder('heavySnow', getObjectOrder('lightSnow')+1)

        addOverlay({75.0,26.0,233.0},{203.0, 21.0, 122.0},0.075)

        setProperty('camHUD.alpha', 0.5)
        if shadersEnabled then
            runHaxeCode([[
                game.camGame.filters = [];
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('blur').shader)]);
            ]])
        end
        setProperty('stringPrep.alpha', 1)
        setProperty('stringPrep2.alpha', 1)
        altWall()
        altFloor()
        setProperty('stringsBg.alpha', 1)
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
        setProperty('boyfriend.alpha', 1)
        setProperty('boyfriend.y', -3400+25)
        setProperty('dad.y', -3400)
        setProperty('scopeVin.alpha', 0.4)
    end
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

    if name == 'addelement' then
        if v1 == 'fadeout' then
            if v2 == '1' then
                setProperty('blackTop.alpha', 1)
                startTween('unblack', 'blackTop', {alpha = 0.001}, 2, {ease = 'quadOut'})
            elseif v2 == '2' then
                setProperty('blackTop.alpha', 1)
                startTween('unblack', 'blackTop', {alpha = 0.001}, 1, {ease = 'quadOut'})
            end
        end

        if v1 == 'camfilters' then
            if shadersEnabled then
                runHaxeCode([[
                    game.camGame.filters = [];
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject('overlay').shader), new ShaderFilter(game.getLuaObject('bloom').shader)]);
                ]])
            end
            setProperty('camHUD.alpha', 1)
        end
    end

    if name == 'changeBf' then
        if v1 == 'gfnorm' then
            triggerEvent('Change Character', 'bf', 'gfNorm')
        elseif v1 == 'gfrage' then
            triggerEvent('Change Character', 'bf', 'gfRage')
        end
    end

    if name == 'playvideo' then
        if v1 == 'smokevin' then
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
        elseif v1 == 'stop snow' then
            if shadersEnabled then
                runHaxeCode([[
                    game.camGame.filters = [];
                    game.camGame.setFilters([new ShaderFilter(game.getLuaObject('bloom').shader)]);
                ]])
            end
            addOverlay({79.0,15.0,33.0},{203.0, 21.0, 122.0},0.175)
            setProperty('lightSnow.alpha', 0.001)
            henchTime = true
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
            end
            setProperty('camHUD.alpha', 0.001)
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
        elseif v1 == 'shoot2' then
            setProperty('stringPrep2.alpha', 0.001)
            setProperty('stringShoot2.alpha', 1)
            playAnim('stringShoot2', 'idle', true)
        end
    end

    if name == 'camshit' then
        if v1 == 'mm' then
            canZoom = false
            setProperty('defaultCamZoom', 0.9)
        end
    end

    if name == 'specialbump' then
        if v1 == 'big' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.15)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.07)
        elseif v1 == 'riser' then
            setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.05)
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.02)
            setShaderFloat('bloom', 'intensity', 0.1)
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
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject('ovelay').shader), new ShaderFilter(game.getLuaObject('bloom').shader)]);
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

function onUpdate(elapsed)
    if getShaderFloat('bloom', 'intensity') > 0 then
        setShaderFloat('bloom', 'intensity', getShaderFloat('bloom', 'intensity')-elapsed)
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
end

function setPosition(obj,x,y)
    setProperty(obj..'.x', x)
    setProperty(obj..'.y', y)
end

function addBehindBF(spr)
    addLuaSprite(spr)
    setObjectOrder(spr, getObjectOrder('boyfriendGroup'))
end