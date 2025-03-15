-- everything here looks messy!!!!! remaking apart of it later

luaDebugMode = true

addHaxeLibrary('Song', 'backend')
addHaxeLibrary('SwagSong', 'backend')
addHaxeLibrary('SwagSection', 'backend')

if getDataFromSave('corruptMenu', 'modcharts') ~= 'Full' then
    return end

setProperty('skipArrowStartTween', true)

local function math_fastCos(insanaMatematica)
    return callMethodFromClass('flixel.math.FlxMath', 'fastCos', {insanaMatematica})
end

local function math_fastSin(insanaMatematica)
    return callMethodFromClass('flixel.math.FlxMath', 'fastSin', {insanaMatematica})
end

local function scale(x,l1,h1,l2,h2)
    return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2))
end

local yPl = 0
local yOp

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
    end

    debugPrint(strum2.scaleX)

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
function onStepHit()
    for i = 1, #drumSteps do
        for v = 1, #stepType do
            if curStep == drumSteps[i] then
                f = f * -1

                -- i sadly can't change the cam scroll :sob:
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

                if stepType[v] == 2 then
                    applyDrunk(0.3 * f, 1)
                    applyTipsy(3, 1)

                    for c = 0, 3 do
                        setProperty('playerStrums.members['..c..'].angle', 22.5*f)
                        startTween('uncoiso'..c, 'playerStrums.members['..c..']', {angle = 0, x = 412+(c*112), y = _G['defaultPlayerStrumY'..c]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
                    end
                elseif stepType[v] == 1 then
                    applyDrunk(1.5 * f, 1)
                    applyTipsy(2, 1)

                    for c = 0, 3 do
                        setProperty('playerStrums.members['..c..'].angle', 30*f)
                        startTween('uncoiso'..c, 'playerStrums.members['..c..']', {angle = 0, x = 412+(c*112), y = _G['defaultPlayerStrumY'..c]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
                    end
                end
            end
        end
    end

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
        applyTipsy(1 * f, 1)
        applyDrunk(1 * f, 1)

        for v = 0,3 do
            cancelTween('uncoisar'..v)
            startTween('uncoisar'..v, 'playerStrums.members['..v..']', {x = 412+(v*112), y = _G['defaultPlayerStrumY'..v]}, (stepCrochet/1000)*4, {ease = 'expoOut'})
        end
        f = f * -1
    end

    if curStep == 544 then
        local dur = (stepCrochet/1000)*16
        for i = 0, 3 do
            startTween('plX'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, dur, {ease = 'quadOut'})
            startTween('opAlpha'..i, 'opponentStrums.members['..i..']', {alpha = 1}, dur, {ease = 'quadOut'})
        end
    end

    if curStep == 928 then
        for i = 0, 3 do
            startTween('cuO'..i, 'opponentStrums.members['..i..']', {alpha = 0, x = 412+(i*112)}, (stepCrochet/1000)*16, {ease = 'quartOut'})
            startTween('cuP'..i, 'playerStrums.members['..i..']', {x = 412+(i*112)}, (stepCrochet/1000)*16, {ease = 'quartOut'})
        end
    end

    if curStep >= 944 and curStep < 960 and curStep % 4 == 0 then
        applyTipsy(1 * f, 1)
        applyDrunk(1 * f, 1)

        for v = 0,3 do
            cancelTween('uncoisar'..v)
            startTween('uncoisar'..v, 'playerStrums.members['..v..']', {x = 412+(v*112), y = _G['defaultPlayerStrumY'..v]}, (stepCrochet/1000)*6, {ease = 'expoOut'})
        end
        f = f * -1
    end

    if curStep >= 976 and curStep < 992 then
        applyTipsy(1 * f, 1)
        applyDrunk(1 * f, 1)

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

            startTween('plC'..i, 'playerStrums.members['..i..']', {['scale.x'] = 6*0.76, ['scale.y'] = 6*0.76, x = 472+(i*92), y = _G['defaultPlayerStrumY'..i]+yPl}, (stepCrochet/1000)*4, {ease = 'quadOut', onUpdate = 'updateStrumHitbox'})
            startTween('opC'..i, 'opponentStrums.members['..i..']', {alpha = 0.2, ['scale.x'] = 6/0.76, ['scale.y'] = 6/0.76, x = 412+(i*142)}, (stepCrochet/1000)*4, {ease = 'quadOut', onUpdate = 'updateStrumHitbox'})

            startTween('reverseOp'..i, 'opponentStrums.members['..i..']', {y = 570+yOp}, (stepCrochet/1000)*4, {ease = 'bounceOut', onComplete = 'reverse'})
            startTween('plY'..i, 'playerStrums.members['..i..']', {y = _G['defaultPlayerStrumY'..i]+75}, (stepCrochet/1000)*4, {ease = 'quadOut'})
        end
    end

    if curStep >= 1536 and curStep < 1792 and curStep % 4 == 0 then
        for i = 0, 3 do
            setVar('defaultPlayerX'..i, 472+(i*92))

            applyTipsy(1 * f, 1)
            applyDrunk(1 * f, 1)

            for v = 0,3 do
                startTween('uncoisar'..v, 'playerStrums.members['..v..']', {x = 472+(v*92), y = _G['defaultPlayerStrumY'..v]+yPl}, (stepCrochet/1000)*4, {ease = 'quartOut'})
            end
            drunkOffset = math.cos(curStep*0.75)
            f = f * -1
        end
    end

    if curStep >= 1856 and curStep < 2048 and curStep % 2 == 0 then
        applyDrunk(0.5 * f, 1)
        drunkOffset = curDecBeat * 0.01 * f
        for i = 0, 3 do
            startTween('undrunk'..i, 'playerStrums.members['..i..']', {x = _G['defaultPlayerStrumX'..i]}, (stepCrochet/1000)*4, {ease = 'cubeOut'})
        end
        f = f * -1
    end
end

local counter = -1
local counter2 = -1
local f = 1

local lastScroll = 0

local drunkOffset = 0
function onUpdate(elapsed)
    songPosition = getSongPosition()/1000

    setShaderFloat('poop', 'iTime', getSongPosition() * 0.001)

    setProperty('arrowCam.zoom', getProperty('camHUD.zoom'))
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
            applyTipsy(0.625, -1, 8)
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

    if curStep >= 1268 and curStep < 1531 then
        applyTipsy(0.5, -1, 2, 'backOut')
    end
end

local targets = {'Player', 'Opponent'}

local ypos = 0
function applyTipsy(perc, pl, dur, curease)
    local leTargets = {}
    if pl == -1 then
        leTargets = targets
    else
        leTargets = {targets[pl]}
    end

    if curease == nil then
        curease = 'linear'
    end

    for i = 0, 3 do
        for _, t in ipairs(leTargets) do
            local currentTarget = t:lower()..'Strums.members['..i..']'

            local songPos = (getSongPosition()/1000)
            local defaultPos = _G['default'..t..'StrumY'..i]+(pl ~= -1 and (pl == 1 and yPl or yOp) or 0)

            ypos = defaultPos + perc * (math_fastCos((songPos * ((1 * 1.2) + 1.2) + i*((0*1.8)+1.8)))*112*.4)

            if dur == nil then
                setProperty(currentTarget..'.y', ypos)
            else
                startTween('tipsy'..i..' ('..t..')', currentTarget, {y = ypos}, (stepCrochet/1000)*dur, {ease = curease})
            end
        end
    end
end

local xpos = 0
function applyDrunk(perc, pl)
    local leTargets = {}
    if pl == -1 then
        leTargets = targets
    else
        leTargets = {targets[pl]}
    end

    for i = 0, 3 do
        for _, t in ipairs(leTargets) do
            local currentTarget = t:lower()..'Strums.members['..i..']'

            local songPos = (getSongPosition()/1000)
            local defaultPos = 0
            if curStep >= 288 and curStep < 544 or curStep >= 928 and curStep < 1268 or curStep >= 1532 and curStep < 1792 then
                defaultPos = getVar('defaultPlayerX'..i)
            else
                defaultPos = _G['default'..t..'StrumX'..i]
            end

            local angle = songPos * (1 + 1)+i*((drunkOffset*0.2)+0.2) + 1 * ((1*10)+10) / screenHeight
            xpos = defaultPos + perc * (math_fastCos(angle) * (112/2))
            setProperty(currentTarget..'.x', xpos)
        end
    end
end

function bump(step, steplength, modifier, amnt, leease, line)
    local targetList = {}
    if line == -1 then
        targetList = targets
    else
        targetList = {targets[line]}
    end

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
    local targetList = {}
    if target == -1 then
        targetList = targets
    else
        targetList = {targets[target]}
    end

    if type[1] == 'shader' then
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
                        setProperty(t:lower()..'Strums.members['..i..'].angle', getRandomFloat(1, 359))
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
                        setProperty(t:lower()..'Strums.members['..i..'].angle', getRandomFloat(-360, 360))

                        local randomScale = getRandomFloat(type[2][1], type[2][2])
                        local escala = 1280 / (1280 + randomScale*1280)
                        scaleObject(t:lower()..'Strums.members['..i..']', escala*4, escala*4)
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
                    startTween('backToNormalStr'..i..' ('..t..')', currentTarget, {y = _G['default'..t..'StrumY'..i]}, (stepCrochet/1000)*interval, {ease = 'bounceOut'})
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
                        local currentTarget = t:lower()..'Strums.members['..i..']'
                        setProperty(currentTarget..'.angle', getRandomFloat(-360, 360))

                        if (curStep >= 288 and curStep < 544 or curStep >= 928 and curStep < 1268) and target == 1 then
                            setProperty(currentTarget..'.'..direction, getVar('defaultPlayerX'..i) + getRandomFloat(type[2][1], type[2][2]))
                        else
                            setProperty(currentTarget..'.'..direction, _G['default'..t..'Strum'..direction:upper()..i] + getRandomFloat(type[2][1], type[2][2]))
                        end
                    end
                end)

                if curStep == cu[2] then
                    if (curStep >= 288 and curStep < 544 or curStep >= 928 and curStep < 1268) and target == 1 then
                        startTween('backToNormalPos'..i..' ('..t..')', currentTarget, {x = getVar('defaultPlayerX'..i), y = _G['defaultPlayerStrumY'..i], angle = 0}, (stepCrochet/1000)*interval, {ease = 'quadOut'})
                    else
                        startTween('backToNormalPos'..i..' ('..t..')', currentTarget, {x = _G['default'..t..'StrumX'..i], y = _G['default'..t..'StrumY'..i], angle = 0}, (stepCrochet/1000)*interval, {ease = 'quadOut'})
                    end
                end
            end
        end
    end
    -- i wanna die
end

function updatePoop(n,f,v)
    setShaderFloat(n,f,v)
end

function onSpawnNote(i)
    runHaxeCode("game.notes.members[0].camera = getVar('arrowCam');")
end

function strumie2()
    runHaxeCode([[
        for (cu in game.opponentStrums)
            cu.updateHitbox();
    ]])
end

function reverse()
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'downScroll', true)
    end
end