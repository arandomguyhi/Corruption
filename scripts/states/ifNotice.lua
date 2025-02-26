luaDebugMode = true

addHaxeLibrary('FlxTypedSpriteGroup', 'flixel.group')

setDataFromSave('corruptMenu', 'seenIfNotice', true)

local path = '../assets/menus/'

local curInfo = 0
local canSelect = false

function onCreatePost()
    callMethod('camGame.scroll.set', {951 - (screenWidth/2), -270 - (screenHeight/2)})
    callMethod('camFollow.setPosition', {951, -270})

    setProperty('camGame.zoom', 0.593)
    setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)

    nextCard()
end

function onUpdate()
    inputShit()
end

function inputShit()
    if not canSelect then return end

    if getProperty('controls.ACCEPT') then
        canSelect = false
        playSound('confirmMenu')

        if curInfo == 2 then
            removeCardAndLeave()
        else
            removeInfoCard()
        end
    end
end

function createInfoCard(infoText, subInfoText)
    runHaxeCode([[
        var infoCard = new FlxTypedSpriteGroup();
        add(infoCard);
        setVar('infoCard', infoCard);
    ]])

    cancelTween('moveTween')
    cancelTween('textTween')

    makeLuaSprite('infoSprite', path..'infoCard', 290, -630)
    setScrollFactor('infoSprite', 0, 0)
    setProperty('infoSprite.alpha', 0.8)
    addToGrp('infoCard', 'infoSprite')

    makeLuaText('mainText', infoText, 1000, 441, -460)
    setTextFont('mainText', 'VollkornRegular-ZVJEZ.ttf')
    setTextSize('mainText', 48)
    setTextAlignment('mainText', 'CENTER')
    setTextColor('mainText', 'CC5363')
    addToGrp('infoCard', 'mainText')

    makeLuaText('subText', subInfoText, 1000, 441, -140)
    setTextFont('subText', 'VollkornRegular-ZVJEZ.ttf')
    setTextSize('subText', 52)
    setTextAlignment('subText', 'CENTER')
    setTextColor('subText', 'CC5363')
    addToGrp('infoCard', 'subText')
    setProperty('subText.alpha', 0)

    setProperty('infoCard.x', -1610)
    setProperty('infoCard.alpha', 0)

    startTween('moveTween', 'infoCard', {x = 0, alpha = 1}, 0.2, {ease = 'sineOut'})
    startTween('textTween', 'subText', {alpha = 1}, 1, {ease = 'sineOut'})
end

function removeInfoCard()
    cancelTween('moveTween')
    cancelTween('textTween')

    startTween('moveTween', 'infoCard', {x = 1710, alpha = 0}, 0.2, {ease = 'sineOut', onComplete = 'nextCard'})
end

function nextCard()
    runTimer('canSelect', 1)
    onTimerCompleted = function(tag)
        if tag == 'canSelect' then
            canSelect = true
        end
    end

    if curInfo == 0 then
        createInfoCard('Corruption:IF\nacts as non-canonical\n"What if?"\nscenarios for moments in the mod.', "I understand. →")
    elseif curInfo == 1 then
        createInfoCard('\nCorruption:IF\nis directed by:\nPincerProd', "I understand. →")
    end

    curInfo = curInfo + 1
end

function removeCardAndLeave()
    cancelTween('moveTween')
    cancelTween('textTween')

    startTween('moveTween', 'infoCard', {x = 1710, alpha = 0}, 0.2, {ease = 'sineOut', onComplete = 'leaveScene'})
end

function leaveScene()
    restartSong()
end

function addToGrp(grpName, obj)
    runHaxeCode("getVar('"..grpName.."').add(game.getLuaObject('"..obj.."'));")
end