-- everything here looks messy!!!!! remaking apart of it later

if getDataFromSave('corruptMenu', 'modcharts') ~= 'Full' then
    return end

luaDebugMode = true

addHaxeLibrary('Song', 'backend')
addHaxeLibrary('SwagSong', 'backend')
addHaxeLibrary('SwagSection', 'backend')

local modManager = require('mods/'..currentModDirectory..'/scripts/modchart/modifiers')

local counter = -1
local counter2 = -1

local yPl = 0
local yOp = 0

local function math_fastCos(insanaMatematica)
    return callMethodFromClass('flixel.math.FlxMath', 'fastCos', {insanaMatematica})
end

local function math_fastSin(insanaMatematica)
    return callMethodFromClass('flixel.math.FlxMath', 'fastSin', {insanaMatematica})
end

local function scale(x,l1,h1,l2,h2)
    return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2))
end

setProperty('skipArrowStartTween', true)

function onCreatePost()
    if shadersEnabled then
        initLuaShader('pooper')
        makeLuaSprite('poop') setSpriteShader('poop', 'pooper')
        setShaderFloat('poop', 'iTime', 0.0)
        setShaderFloat('poop', 'AMT', 0)
        setShaderFloat('poop', 'SPEED', 2)

        runHaxeCode([[
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('poop').shader)]);
        ]])
    end

    for i = 0, 3 do
        setProperty('playerStrums.members['..i..'].alpha', 0)

        strum1 = {
            scaleX = getProperty('opponentStrums.members['..i..'].scale.x'),
            scaleY = getProperty('opponentStrums.members['..i..'].scale.y')
        }
        strum2 = {
            scaleX = getProperty('playerStrums.members['..i..'].scale.x'),
            scaleY = getProperty('playerStrums.members['..i..'].scale.y')
        }

        setVar('defaultPlayerX'..i, _G['defaultPlayerStrumX'..i])
        setVar('defaultPlayerY'..i, _G['defaultPlayerStrumY'..i])

        setVar('defaultOpponentX'..i, _G['defaultOpponentStrumX'..i])
        setVar('defaultOpponentY'..i, _G['defaultOpponentStrumY'..i])
    end

    swagWidth = getPropertyFromClass('objects.Note', 'swagWidth')
    halfWidth = getPropertyFromClass('objects.Note', 'swagWidth') / 2

    runHaxeCode([[
        var arrowCam = new FlxCamera();
        arrowCam.bgColor = 0x0;

        for (cams in [camHUD, camOther])
            FlxG.cameras.remove(cams, false);
        for (cams in [arrowCam, camHUD, camOther])
            FlxG.cameras.add(cams, false);

        var stepToEvent:Array<Float> = [];
        var stepType:Array<Float> = [];

        var shit = Song.loadFromJson('drums1', 'chkdsk');
        var noteData = shit.notes;
        for (sexion in noteData) {
            for (data in sexion.sectionNotes) {
                var time:Float = data[0];
                var type:Int = Std.int(data[1] % 4);
                stepToEvent.push(Math.floor(Conductor.getStep(time)));
                stepType.push(type);

                setVar('drumSteps', stepToEvent);
                setVar('stepType', stepType);
            }
        }

        for (strum in game.strumLineNotes)
            strum.camera = arrowCam;

        setVar('arrowCam', arrowCam);
    ]])
    drumSteps = getVar('drumSteps')
    stepType = getVar('stepType')
end

function numericForInterval(start, endie, interval, func)
    local index = start
    while index < endie do
        func(index)
        index = index + interval
    end
end

local f = 1
function onEvent(name, value1, value2)
    if name == 'chkdskthing' then
        f = f * -1

        -- i sadly can't change the cam scroll :sad_spongebob:
        startTween('fieldY', 'arrowCam', {y = -75}, (stepCrochet/1000)*2, {ease = 'quadOut'})

        cancelTimer('unfield')
        runTimer('unfield', (stepCrochet/1000)*2)
        onTimerCompleted = function(tag)
            if tag == 'unfield' then
                startTween('fieldY', 'arrowCam', {y = 0}, (stepCrochet/1000)*2, {ease = 'quadIn'})
            end
        end

        setProperty('arrowCam.angle', 7*f)
        startTween('normalAng', 'arrowCam', {angle = 0}, (stepCrochet/1000)*4, {ease = 'quadInOut'})

        if value1 == '0' then
            modManager:drunk(1 * f, 1)
            xmod(0.7, 1)

            for i = 0, 3 do
                modManager:confusionOffset(11.25 * f, i, 1)
                startTween('uncoiso'..i, 'playerStrums.members['..i..']', {angle = 0, x = 412+(i*112), y = _G['defaultPlayerStrumY'..i]}, (stepCrochet/1000)*4, {ease = 'quadOut'})
            end

            for i = 0, getProperty('notes.length')-1 do
                if getPropertyFromGroup('notes', i, 'mustPress') then
                    --runHaxeCode("FlxTween.tween(game.notes.members["..i.."], {multSpeed: 0.9}, (Conductor.stepCrochet/1000)*4, {ease: FlxEase.quadOut});")
                end
            end
        elseif value1 == '2' then
            modManager:drunk(0.3 * f, 1)
            modManager:tipsy(3, 1)
            xmod(0.75, 1)

            for c = 0, 3 do
                modManager:confusionOffset(22.5*f, c, 1)
                startTween('uncoiso'..c, 'playerStrums.members['..c..']', {angle = 0, x = 412+(c*112), y = _G['defaultPlayerStrumY'..c]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
            end

            for i = 0, getProperty('notes.length')-1 do
                if getPropertyFromGroup('notes', i, 'mustPress') then
                    --runHaxeCode("FlxTween.tween(game.notes.members["..i.."], {multSpeed: 0.9}, (Conductor.stepCrochet/1000)*4, {ease: FlxEase.quadOut});")
                end
            end
        elseif value1 == '1' then
            modManager:drunk(1.5 * f, 1)
            modManager:tipsy(2, 1)
            xmod(0.75, 1)

            for c = 0, 3 do
                modManager:confusionOffset(30*f, c, 1)
                startTween('uncoiso'..c, 'playerStrums.members['..c..']', {angle = 0, x = 412+(c*112), y = _G['defaultPlayerStrumY'..c]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
            end

            for i = 0, getProperty('notes.length')-1 do
                if getPropertyFromGroup('notes', i, 'mustPress') then
                    --runHaxeCode("FlxTween.tween(game.notes.members["..i.."], {multSpeed: 0.9}, (Conductor.stepCrochet/1000)*4, {ease: FlxEase.quadOut});")
                end
            end
        elseif value1 == '3' then
            modManager:drunk(0.3, 1)
            xmod(0.75, 1)

            for c = 0, 3 do
                modManager:confusionOffset(35*f, c, 1)
                startTween('uncoiso'..c, 'playerStrums.members['..c..']', {angle = 0, x = 412+(c*112), y = _G['defaultPlayerStrumY'..c]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
            end

            for i = 0, getProperty('notes.length')-1 do
                if getPropertyFromGroup('notes', i, 'mustPress') then
                   -- runHaxeCode("FlxTween.tween(game.notes.members["..i.."], {multSpeed: 0.9}, (Conductor.stepCrochet/1000)*4, {ease: FlxEase.quadOut});")
                end
            end
        end
    end
end

function onStepHit()
    if curStep == 60 then
        for i = 0, 3 do
            setProperty('playerStrums.members['..i..'].scale.y', 0.75)

            startTween('unsquish'..i, 'playerStrums.members['..i..']', {['scale.y'] = strum2.scaleY, alpha = 1}, (stepCrochet/1000)*4, {ease = 'quartOut', onUpdate = 'strumie'})
            function strumie()
                updateHitboxFromGroup('playerStrums')
            end
        end
    end

    if curStep == 254 then
        for i = 0, 7 do
            startTween('BZL'..i, 'strumLineNotes.members['..i..']', {alpha = 0, y = defaultOpponentStrumY0 + 200}, (stepCrochet/1000)*24, {ease = 'quadIn'})
        end
    end

    if curStep == 276 then
        for i = 0, 3 do
            setVar('defaultPlayerX'..i, 412+(i*112))

            setProperty('playerStrums.members['..i..'].y', defaultPlayerStrumY0 - 200)
            setProperty('playerStrums.members['..i..'].x', 412+(i*112))

            startTween('alpha'..i, 'playerStrums.members['..i..']', {alpha = 1}, (stepCrochet/1000)*8, {ease = 'quadOut'})
            startTween('transformY'..i, 'playerStrums.members['..i..']', {y = defaultPlayerStrumY0}, (stepCrochet/1000)*8, {ease = 'expoInOut'})
        end
    end

    if (curStep >= 288 and curStep < 544 or curStep >= 960 and curStep < 976) and curStep % 2 == 0 then
        modManager:tipsy(1 * f, 1)
        modManager:drunk(1 * f, 1)

        for v = 0,3 do
            cancelTween('uncoisar'..v)
            startTween('uncoisar'..v, 'playerStrums.members['..v..']', {x = 412+(v*112), y = _G['defaultPlayerStrumY'..v]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
        end
        f = f * -1
    end

    if curStep == 544 then
        local dur = (stepCrochet/1000)*16
        for i = 0, 3 do
            setVar('defaultPlayerX'..i, _G['defaultPlayerStrumX'..i])

            startTween('plX'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, dur, {ease = 'quadOut'})
            startTween('opAlpha'..i, 'opponentStrums.members['..i..']', {alpha = 1}, dur, {ease = 'quadOut'})
        end
    end

    if curStep >= 672 and curStep < 928 then
        local s = (counter == -1 and 3 or 9)
        local s2 = (counter == -1 and 9 or 3)

        if curStep % 2 == 0 then
            counter = counter * -1

            scaleObject('playerStrums.members[0]',s,s) scaleObject('opponentStrums.members[0]',s,s)
            scaleObject('playerStrums.members[3]',s,s) scaleObject('opponentStrums.members[3]',s,s)
            modManager:confusionOffset(90*counter, 0, -1)
            modManager:confusionOffset(90*counter, 3, -1)

            for _,bzl in pairs({'playerStrums', 'opponentStrums'}) do
                startTween('coisoum'.._, bzl..'.members[0]', {['scale.x'] = 6, ['scale.y'] = 6, angle = 0}, (stepCrochet/1000)*2, {ease = 'circOut', onUpdate = 'updateStrumHitbox'})
                startTween('angledois'.._, bzl..'.members[3]', {['scale.x'] = 6, ['scale.y'] = 6, angle = 0}, (stepCrochet/1000)*2, {ease = 'circOut', onUpdate = 'updateStrumHitbox'})
            end

            scaleObject('playerStrums.members[1]',s2,s2) scaleObject('opponentStrums.members[1]',s2,s2)
            scaleObject('playerStrums.members[2]',s2,s2) scaleObject('opponentStrums.members[2]',s2,s2)
            modManager:confusionOffset(-90*counter, 1, -1)
            modManager:confusionOffset(-90*counter, 2, -1)

            for _,bzl in pairs({'playerStrums', 'opponentStrums'}) do
                startTween('coisodoisum'.._, bzl..'.members[1]', {['scale.x'] = 6, ['scale.y'] = 6, angle = 0}, (stepCrochet/1000)*2, {ease = 'circOut', onUpdate = 'updateStrumHitbox'})
                startTween('coisodoisdois'.._, bzl..'.members[2]', {['scale.x'] = 6, ['scale.y'] = 6, angle = 0}, (stepCrochet/1000)*2, {ease = 'circOut', onUpdate = 'updateStrumHitbox'})
            end
        end
    end

    if curStep == 928 then
        for i = 0, 3 do
            setVar('defaultPlayerX'..i, 412+(i*112))

            startTween('cuO'..i, 'opponentStrums.members['..i..']', {alpha = 0, x = 412+(i*112)}, (stepCrochet/1000)*16, {ease = 'quartOut'})
            startTween('cuP'..i, 'playerStrums.members['..i..']', {x = 412+(i*112)}, (stepCrochet/1000)*16, {ease = 'quartOut'})
        end
    end

    if curStep >= 944 and curStep < 960 and curStep % 4 == 0 then
        modManager:tipsy(1 * f, 1)
        modManager:drunk(1 * f, 1)

        for v = 0,3 do
            cancelTween('uncoisar'..v)
            startTween('uncoisar'..v, 'playerStrums.members['..v..']', {x = 412+(v*112), y = _G['defaultPlayerStrumY'..v]}, (stepCrochet/1000)*6, {ease = 'expoOut'})
        end
        f = f * -1
    end

    if curStep >= 976 and curStep < 992 then
        modManager:tipsy(1 * f, 1)
        modManager:drunk(1 * f, 1)

        for v = 0,3 do
            cancelTween('uncoisar'..v)
            startTween('uncoisar'..v, 'playerStrums.members['..v..']', {x = 412+(v*112), y = _G['defaultPlayerStrumY'..v]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
        end
        f = f * -1
    end

    if curStep == 1248 then
        for i = 0, 3 do
            startTween('alphaP'..i, 'playerStrums.members['..i..']', {alpha = 0}, (stepCrochet/1000)*10, {ease = 'quadOut'})
            startTween('playerY'..i, 'playerStrums.members['..i..']', {y = _G['defaultPlayerStrumY'..i]-200}, (stepCrochet/1000)*12, {ease = 'quadOut'})
        end
    elseif curStep == 1268 then
        for i = 0, 3 do
            setVar('defaultPlayerX'..i, _G['defaultPlayerStrumX'..i])

            setProperty('playerStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i])
            setProperty('opponentStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i]-500)

            startTween('plY'..i, 'playerStrums.members['..i..']', {alpha = 1, y = _G['defaultPlayerStrumY'..i]}, (stepCrochet/1000)*22, {ease = 'backOut'})
        end
    elseif curStep == 1404 then
        for i = 0, 3 do
            startTween('opAlp'..i, 'opponentStrums.members['..i..']', {alpha = 1}, (stepCrochet/1000)*16, {ease = 'backOut'})
            startTween('opX'..i, 'opponentStrums.members['..i..']', {x = _G['defaultOpponentStrumX'..i]}, (stepCrochet/1000)*16, {ease = 'quadOut'})
        end
    end

    if curStep == 1532 then
        for i = 0, 3 do
            yPl = 75
            yOp = 0

            cancelTween('tipsy'..i..' (Player)')
            cancelTween('tipsy'..i..' (Opponent)')

            setVar('defaultPlayerX'..i, 457+(i*97))
            setVar('defaultOpponentX'..i, 392+(i*137))
            setVar('defaultOpponentY'..i, 570)

            startTween('plC'..i, 'playerStrums.members['..i..']', {['scale.x'] = 6*0.85, ['scale.y'] = 6*0.85, x = 457+(i*97), y = _G['defaultPlayerStrumY'..i]+yPl}, (stepCrochet/1000)*4, {ease = 'quadOut', onUpdate = 'updateStrumHitbox'})
            startTween('opC'..i, 'opponentStrums.members['..i..']', {alpha = 0.2, ['scale.x'] = 6/0.85, ['scale.y'] = 6/0.85, x = 392+(i*137)}, (stepCrochet/1000)*4, {ease = 'quadOut', onUpdate = 'updateStrumHitbox'})

            startTween('reverseOp'..i, 'opponentStrums.members['..i..']', {y = 570+yOp}, (stepCrochet/1000)*4, {ease = 'bounceOut', onComplete = 'reverse'})
            startTween('plY'..i, 'playerStrums.members['..i..']', {y = _G['defaultPlayerStrumY'..i]+75}, (stepCrochet/1000)*4, {ease = 'quadOut'})
        end
    end

    if curStep == 1664 then
        for i = 0, 3 do
            yPl = 0
            yOp = -75

            setVar('defaultPlayerX'..i, 392+(i*137))
            setVar('defaultOpponentX'..i, 457+(i*97))

            startTween('plC'..i, 'playerStrums.members['..i..']', {['scale.x'] = 6/0.85, ['scale.y'] = 6/0.85, x = 392+(i*137), y = _G['defaultPlayerStrumY'..i]+yPl}, (stepCrochet/1000)*4, {ease = 'bounceOut', onUpdate = 'updateStrumHitbox'})
            startTween('opC'..i, 'opponentStrums.members['..i..']', {['scale.x'] = 6*0.85, ['scale.y'] = 6*0.85, x = 457+(i*97)}, (stepCrochet/1000)*4, {ease = 'bounceOut', onUpdate = 'updateStrumHitbox'})
        end
    end

    if curStep == 1728 then
        for i = 0, 3 do
            yOp = 0

            setVar('defaultPlayerX'..i, 412+(i*112))
            setVar('defaultOpponentX'..i, 412+(i*112))

            -- doing like this so i can read xD
            startTween('plC'..i, 'playerStrums.members['..i..']', {
                ['scale.x'] = strum2.scaleX, ['scale.y'] = strum2.scaleY,
                x = 412+(i*112), y = _G['defaultPlayerStrumY']
            }, (stepCrochet/1000)*6, {
                ease = 'quadOut'
            })

            startTween('opC'..i, 'opponentStrums.members['..i..']', {
                ['scale.x'] = strum1.scaleX, ['scale.y'] = strum1.scaleY,
                x = 412+(i*112), y = 570
            }, (stepCrochet/1000)*6, {
                ease = 'quadOut'
            })
        end
    end

    if curStep == 1792 then
        for i = 0, 3 do
            setVar('defaultPlayerX'..i, _G['defaultPlayerStrumX'..i])
            setVar('defaultOpponentX'..i, _G['defaultOpponentStrumX'..i])
            setVar('defaultOpponentY'..i, _G['defaultOpponentStrumY'..i])

            startTween('opT'..i, 'opponentStrums.members['..i..']', {x = _G['defaultOpponentStrumX'..i], alpha = 1}, (stepCrochet/1000)*12, {ease = 'quadOut'})
            startTween('plT'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, (stepCrochet/1000)*12, {ease = 'quadOut'})
        end
    end

    if curStep >= 1536 and curStep < 1792 and curStep % 4 == 0 then
        for i = 0, 3 do
            modManager:tipsy(1 * f, -1)
            modManager:drunk(1 * f, -1)

            startTween('uncoisar'..i, 'playerStrums.members['..i..']', {x = getVar('defaultPlayerX'..i), y = _G['defaultPlayerStrumY'..i]+yPl}, (stepCrochet/1000)*4, {ease = 'quartOut'})
            startTween('uncoisardois'..i, 'opponentStrums.members['..i..']', {x = getVar('defaultOpponentX'..i), y = getVar('defaultOpponentY'..i)+yOp}, (stepCrochet/1000)*4, {ease = 'quartOut'})
            modManager.drunkOffset = math.cos(curStep*0.75)
            f = f * -1
        end
    end

    if curStep == 1856 then
        for i = 0, 3 do
            noteTweenAlpha('sudden'..i, i, 0, (stepCrochet/1000)*4, 'quadOut')
        end
    end

    if curStep >= 1856 and curStep < 2048 and curStep % 2 == 0 then
        modManager:drunk(0.5 * f, 1)
        modManager.drunkOffset = curDecBeat * 0.01 * f
        for i = 0, 3 do
            startTween('undrunk'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, (stepCrochet/1000)*4, {ease = 'cubeOut'})
        end
        f = f * -1
    end

    if curStep == 2048 then
        for i = 0, 3 do
            noteTweenAlpha('sudden'..i, i, 1, (stepCrochet/1000)*4, 'quadOut')
        end
    end
    if curStep >= 2048 and curStep < 2160 then
        modManager:drunk(1.5 * f, 1)
        modManager.drunkOffset = math.sin(curStep * 0.75)
        for i = 0, 3 do
            startTween('undrunk'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, (stepCrochet/1000)*4, {ease = 'cubeOut'})
        end
    end

    if curStep >= 2176 and curStep < 2432 and curStep % 2 == 0 then
        modManager:drunk(0.25 * f, 1)
        for i = 0, 3 do
            startTween('undrunk'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, (stepCrochet/1000)*16, {ease = 'cubeOut'})
            startTween('opdrunk'..i, 'opponentStrums.members['..i..']', {x = _G['defaultOpponentStrumX'..i]}, (stepCrochet/1000)*16, {ease = 'cubeOut'})
        end

        applyInvert(0.2, -1)
        for i = 0, 3 do
            modManager:confusionOffset(-25*f, i, -1)

            startTween('uncoiso'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i], angle = 0}, (stepCrochet/1000)*4, {ease = 'cubeOut'})
            startTween('uncoisoop'..i, 'opponentStrums.members['..i..']', {x = _G['defaultOpponentStrumX'..i], angle = 0}, (stepCrochet/1000)*4, {ease = 'cubeOut'})
        end

        f = f * -1
    end

    if curStep == 2432 then
        for i = 0, 7 do
            noteTweenAlpha('endd'..i, i, 0, (stepCrochet/1000)*16, 'quadOut')
        end
    end
end

local f = 1

local lastScroll = 0

local el = 0
function onUpdate(elapsed)
    el = el + elapsed
    songPosition = getSongPosition()/1000

    --setShaderFloat('para', 'x', ((el/10)*7)*-1)

    if shadersEnabled then
        setShaderFloat('poop', 'iTime', getSongPosition() * 0.001)
    end

    setProperty('arrowCam.zoom', getProperty('camHUD.zoom'))
    --runHaxeCode("getVar('arrowCam').filters = camHUD.filters;")

    for i = 0, getProperty('notes.length')-1 do
        for f = 0, 3 do
            if getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'scale.x', getPropertyFromGroup('playerStrums', f, 'scale.x'))
                setPropertyFromGroup('notes', i, 'scale.y', getPropertyFromGroup('playerStrums', f, 'scale.y'))
            else
                setPropertyFromGroup('notes', i, 'scale.x', getPropertyFromGroup('opponentStrums', f, 'scale.x'))
                setPropertyFromGroup('notes', i, 'scale.y', getPropertyFromGroup('opponentStrums', f, 'scale.y'))
            end
        end
    end

    bump(0, 4, "Y", 50, 'bounceOut', 2)
    glitch({24, 28}, {'shader', {0.01, 0.2}}, 0.5)
    glitch({24, 28}, {'position', {-112, 112}}, 0.5, 2)

    glitch({61, 64}, {'confusionOffset'}, 0.5, 2)

    bump(60, 4, "Y", 50, 'bounceOut', 1)
    bump(68, 4, "Y", -25, 'bounceOut', 1)

    bump(128, 4, "Y", 25, 'quadOut', 2)
    glitch({150, 155}, {'position', {-112, 112}}, 0.5, 2)
    glitch({150, 155}, {'shader', {0.01, 0.2}}, 0.5)
    bump(160, 4, "Y", -25, 'bounceOut', 2)
    bump(186, 4, "Y", 25, 'bounceOut', 2)
    glitch({188, 192}, {'shader', {0.05, 0.3}}, 0.5)
    glitch({188, 192}, {'reverse'}, 0.5, 2)

    if curStep >= 192 and curStep < 288 then
        for i = 0, 7 do
            modManager:tipsy(0.625, -1, 8)
        end
    end

    glitch({214, 220}, {'shader', {0.05, 0.3}}, 0.5)
    glitch({214, 220}, {'confusionOffset'}, 0.5, -1)

    numericForInterval(224, 256, 2, function(step)
        counter = counter * -1
        bump(step, 2, 'X', 32.5 * counter, 'linear', -1)
    end)
    numericForInterval(240, 256, 1, function(step)
        counter2 = counter2 * -1
        bump(step, 2, 'X', 32.5 * counter2, 'linear', -1)
    end)

    glitch({318, 320}, {'reverse'}, 0.5, 1)
    glitch({342, 346}, {'shader', {0.05, 0.3}}, 0.5)
    glitch({382, 384}, {'confusionOffset'}, 0.5, 1)
    glitch({406, 410}, {'position', {-112, 112}}, 0.5, 1)
    glitch({446, 448}, {'shader', {0.05, 0.3}}, 0.5)
    glitch({534, 538}, {'confusionOffset'}, 0.5, 1)

    glitch({544, 576}, {'reverse'}, 0.5, 2)
    glitch({544, 576}, {'position', {-112, 112}}, 0.5, 2)
    glitch({544, 674}, {'shader', {0.05, 0.125}}, 1)
    glitch({576, 592}, {'confusionOffset'}, 0.5, 2)
    glitch({576, 592}, {'reverse'}, 0.5, 2)
    glitch({608, 672}, {'Z', {-.5, .5}}, 0.5, 2)
    glitch({608, 672}, {'position', {-112, 112}}, 0.5, 2)
    glitch({656, 672}, {'reverse'}, 0.5, 2)

    if curStep >= 1268 and curStep < 1532 then
        modManager:tipsy(0.5, -1, 22, 'backOut')
    end

    numericForInterval(2160, 2170, 0.5, function(i)
        if curStep == i then
            modManager:tipsy(1.25 * f, -1)
            modManager:drunk(1.75 * f, 1)

            for f = 0, 3 do
                startTween('uncoiso'..f, 'playerStrums.members['..f..']', {x = _G['defaultPlayerStrumX'..f], y = _G['defaultPlayerStrumY'..f]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
                startTween('uncoisoop'..f, 'opponentStrums.members['..f..']', {x = _G['defaultOpponentStrumX'..f], y = _G['defaultOpponentStrumY'..f]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
            end

            modManager.drunkOffset = math.sin(i * 1.25)

            f = f * -1
        end
    end)

    glitch({2048, 2080}, {'reverse'}, 0.5, 2)
    glitch({2048, 2080}, {'position', {-112, 112}}, 0.5, 2)
    glitch({2048, 2178}, {'shader', {0.05, 0.125}}, 2)
    glitch({2080, 2096}, {'confusionOffset'}, 0.5, 2)
    glitch({2080, 2096}, {'reverse'}, 0.5, 2)
    glitch({2108, 2176}, {'Z', {-.5, .5}}, 0.5, 2)
    glitch({2108, 2176}, {'position', {-112, 112}}, 0.5, 2)
    glitch({2160, 2176}, {'reverse'}, 0.5, 2)

    glitch({2238, 2240}, {'shader', {0.05,0.3}}, 0.5, 1)
    glitch({2238, 2240}, {'confusionOffset'}, 0.5, 1)
    glitch({2262, 2266}, {'position', {-112, 112}}, 0.5, 1)
    glitch({2262, 2266}, {'Z', {-.25, .25}}, 0.5, 1)
    glitch({2302, 2304}, {'shader', {0.05,0.3}}, 0.5, 1)
    glitch({2326, 2330}, {'shader', {0.05,0.3}}, 0.5, 1)
    glitch({2366, 2368}, {'confusionOffset'}, 0.5, 1)
    glitch({2366, 2368}, {'position', {-112, 112}}, 0.5, 1)
    glitch({2366, 2368}, {'Z', {-.25, .25}}, 0.5, 1)

    glitch({2390, 2394}, {'position', {-112, 112}}, 0.5, 1)
    glitch({2390, 2394}, {'Z', {-.5, .5}}, 0.5, 1)
end

function xmod(perc, pl)
    --[[
        leaving this as a comment atm, i'll try to fix it lately
    for i = 0, getProperty('notes.length')-1 do
        if pl == -1 then
            setPropertyFromGroup('notes', i, 'multSpeed', perc)
        elseif pl == 1 and getPropertyFromGroup('notes', i, 'mustPress') then
            setPropertyFromGroup('notes', i, 'multSpeed', perc)
        elseif pl == 2 and not getPropertyFromGroup('notes', i, 'mustPress') then
            setPropertyFromGroup('notes', i, 'multSpeed', perc)
        end
    end]]
end

function applyInvert(perc, pl)
    local leTargets = (pl == -1) and modManager.targets or {modManager.targets[pl]}

    for i = 0, 3 do
        for _, t in ipairs(leTargets) do
            local currentTarget = t:lower()..'Strums.members['..i..']'

            local songPos = (getSongPosition()/1000)
            local defaultPos = getVar('default'..t..'X'..i)

            local distance = swagWidth * ((i % 2 == 0) and 1 or -1)
            setProperty(currentTarget..'.x', defaultPos + distance * perc)
        end
    end
end

function bump(step, steplength, modifier, amnt, leease, line)
    local targetList = (line == -1) and modManager.targets or {modManager.targets[line]}

    if curStep == step then
        for i = 0,3 do
            for _, t in pairs(targetList) do
                local currentTarget = t:lower()..'Strums.members['..i..']'
                setProperty(currentTarget..'.'..modifier:lower(), _G['default'..t..'Strum'..modifier..i] + amnt)
                if modifier == 'X' then
                    startTween('unbump'..i..' ('..t..')', currentTarget, {x = _G['default'..t..'StrumX'..i]}, (stepCrochet/1000) * steplength, {ease = leease})
                elseif modifier == 'Y' then
                    startTween('unbump'..i..' ('..t..')', currentTarget, {y = _G['default'..t..'StrumY'..i]}, (stepCrochet/1000) * steplength, {ease = leease})
                end
            end
        end
    end
end

function glitch(cu, type, interval, target)
    local targetList = (target == -1) and modManager.targets or {modManager.targets[target]}

    if type[1] == 'shader' and shadersEnabled then
        numericForInterval(cu[1], cu[2] - interval, interval, function(step)
            if curStep == step then
                setShaderFloat('poop', 'AMT', getRandomFloat(type[2][1], type[2][2]))
            end
        end)

        if curStep == cu[2] then
            setShaderFloat('poop', 'AMT', 0)
        end
    end

    if type[1] == 'confusionOffset' then
        for i = 0,3 do
            for _, t in pairs(targetList) do
                numericForInterval(cu[1], cu[2] - interval, interval, function(step)
                    if curStep == step then
                        modManager:confusionOffset(getRandomFloat(1, 359), i, target)
                    end
                end)

                if curStep == cu[2] then
                    local currentTarget = t:lower()..'Strums.members['..i..']'
                    startTween('backToNormalAng'..i..' ('..t..')', currentTarget, {angle = 0}, (stepCrochet/1000)*interval, {ease = 'circOut'})
                end
            end
        end
    end

    if type[1] == 'Z' then
        for i = 0, 3 do
            for _, t in pairs(targetList) do
                numericForInterval(cu[1], cu[2] - interval, interval, function(step)
                    if curStep == step then
                        modManager:confusionOffset(getRandomFloat(-360, 360), i, target)

                        local randomScale = getRandomFloat(type[2][1], type[2][2])
                        local escala = 1280 / (1280 + randomScale*1280)
                        scaleObject(t:lower()..'Strums.members['..i..']', escala*6, escala*6)
                    end
                end)

                if curStep == cu[2] then
                    local currentTarget = t:lower()..'Strums.members['..i..']'
                    startTween('backToNormalScaly'..i..' ('..t..')', currentTarget, {['scale.x'] = strum1.scaleX, ['scale.y'] = strum1.scaleY, angle = 0}, (stepCrochet/1000)*interval, {ease = 'quadOut', onUpdate = 'strumie2'})
                end
            end
        end
    end

    if type[1] == 'reverse' then
        for i = 0, 3 do
            for _, t in pairs(targetList) do
                numericForInterval(cu[1], cu[2] - interval, interval, function(step)
                    if curStep == step then
                        if getRandomBool(50) then
                            setPropertyFromGroup(t:lower()..'Strums', getRandomInt(0, 3), 'downScroll', not downscroll)
                        else
                            setPropertyFromGroup(t:lower()..'Strums', getRandomInt(0, 3), 'downScroll', downscroll)
                        end

                        local currentTarget = t:lower()..'Strums.members['..i..']'
                        setProperty(currentTarget..'.y', getPropertyFromGroup(t:lower()..'Strums', i, 'downScroll') and 570 or 50)
                    end
                end)

                if curStep == cu[2] then
                    local currentTarget = t:lower()..'Strums.members['..i..']'
                    setPropertyFromGroup(t:lower()..'Strums', i, 'downScroll', downscroll)
                    startTween('backToNormalStr'..i..' ('..t..')', currentTarget, {y = getVar('default'..t..'Y'..i)}, (stepCrochet/1000)*interval, {ease = 'bounceOut'})
                end
            end
        end
    end
            
    if type[1] == 'position' then
        local direction = 'x'

        for i = 0,3 do 
            for _, t in pairs(targetList) do
                local currentTarget = t:lower()..'Strums.members['..i..']'

                numericForInterval(cu[1], cu[2] - interval, interval, function(step)
                    direction = 'x'
                    if getRandomBool(50) then
                        direction = 'y' end

                    if curStep == step then
                        modManager:confusionOffset(getRandomFloat(-360, 360), i, target)
                        setProperty(currentTarget..'.'..direction, getVar('default'..t..direction:upper()..i) + getRandomFloat(type[2][1], type[2][2]))
                    end
                end)

                if curStep == cu[2] then
                    startTween('backToNormalPos'..i..' ('..t..')', currentTarget, {x = getVar('default'..t..'X'..i), y = _G['default'..t..'StrumY'..i], angle = 0}, (stepCrochet/1000)*interval, {ease = 'quadOut'})
                end
            end
        end
    end
    -- i wanna die
end

function updatePoop(n,f,v)
    if shadersEnabled then
        setShaderFloat(n,f,v)
    end
end

function onSpawnNote(i)
    runHaxeCode("game.notes.members[0].camera = getVar('arrowCam');")
end

function strumie2()
    for i = 0, 3 do
        updateHitboxFromGroup('opponentStrums', i)
    end
end

function reverse()
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'downScroll', true)
    end
end

function updateStrumHitbox()
    for i = 0, 3 do
        updateHitboxFromGroup('opponentStrums',i)
        updateHitboxFromGroup('playerStrums',i)
    end
end