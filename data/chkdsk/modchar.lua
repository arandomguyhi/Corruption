luaDebugMode = true

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
        setProperty('playerStrums.members['..i..'].visible', false)

        strum1 = {
            scaleX = getProperty('opponentStrums.members['..i..'].scale.x'),
            scaleY = getProperty('opponentStrums.members['..i..'].scale.y')
        }
        strum2 = {
            scaleX = getProperty('playerStrums.members['..i..'].scale.x'),
            scaleY = getProperty('playerStrums.members['..i..'].scale.y')
        }
    end
end

function numericForInterval(start, endie, interval, func)
    local index = start
    while index < endie do
        func(index)
        index = index + interval
    end
end

function onStepHit()
    if curStep == 60 then
        for i = 0, 3 do
            setProperty('playerStrums.members['..i..'].scale.y', 0.75)
            setProperty('playerStrums.members['..i..'].visible', true)
            setProperty('playerStrums.members['..i..'].alpha', 0.001)

            startTween('unsquish'..i, 'playerStrums.members['..i..']', {['scale.y'] = strum2.scaleY, alpha = 1}, (stepCrochet/1000)*4, {ease = 'quartOut', onUpdate = 'strumie'})
            function strumie()
                runHaxeCode([[
                    for (cu in game.playerStrums)
                        cu.updateHitbox();
                ]])
            end
        end
    end
end

local counter = -1
local counter2 = -1
function onUpdate()
    setShaderFloat('poop', 'iTime', getSongPosition() * 0.001)

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

    glitch({214, 220}, {'shader', {0.05, 0.3}}, 0.5)
    glitch({214, 220}, {'confusionOffset'}, 0.5, -1)

    numericForInterval(224, 256, 2, function(curStep)
        counter = counter * -1
        bump(curStep, 2, 'X', 32.5 * counter, 'linear', -1)
    end)
    numericForInterval(240, 256, 1, function(curStep)
        counter2 = counter2 * -1
        bump(curStep, 2, 'X', 32.5 * counter2, 'linear', -1)
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
    glitch({624, 672}, {'position', {-112, 112}}, 0.5, 2)
    glitch({624, 672}, {'reverse'}, 0.5, 2)
end

local targets = {'Player', 'Opponent'}

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
                startTween('unbump'..i..' ('..t..')', currentTarget, {x = _G['default'..t..'StrumX'..i], y = _G['default'..t..'StrumY'..i]}, (stepCrochet/1000) * steplength, {ease = leease})
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
                        scaleObject(t:lower()..'Strums.members['..i..']', strum1.scaleX + randomScale * 3, strum1.scaleY + randomScale * 3)
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
                            setPropertyFromGroup(t:lower()..'Strums', getRandomInt(0, 3), 'downScroll', true)
                        else
                            setPropertyFromGroup(t:lower()..'Strums', getRandomInt(0, 3), 'downScroll', false)
                        end

                        local currentTarget = t:lower()..'Strums.members['..i..']'
                        setProperty(currentTarget..'.y', getPropertyFromGroup(t:lower()..'Strums', i, 'downScroll') and 570 or 50)
                    end
                end)

                if curStep == cu[2] then
                    local currentTarget = t:lower()..'Strums.members['..i..']'
                    setPropertyFromGroup(t:lower()..'Strums', i, 'downScroll', false)
                    startTween('backToNormalStr'..i..' ('..t..')', currentTarget, {y = _G['default'..t..'StrumY'..i]}, (stepCrochet/1000)*interval, {ease = 'bounceOut'})
                end
            end
        end
    end
            
    if type[1] == 'position' then
        local direction = 'x'
        for i = 0,3 do
            for _, t in pairs(targetList) do
                numericForInterval(cu[1], cu[2] - interval, interval, function(step)
                    direction = 'x'
                    if getRandomBool(50) then
                        direction = 'y' end

                    local currentTarget = t:lower()..'Strums.members['..i..']'

                    if curStep == step then
                        setProperty(currentTarget..'.angle', getRandomFloat(-360, 360))
                        setProperty(currentTarget..'.'..direction, _G['default'..t..'Strum'..direction:upper()..i] + getRandomFloat(type[2][1], type[2][2]))
                    end
                end)

                if curStep == cu[2] then
                    local currentTarget = t:lower()..'Strums.members['..i..']'
                    startTween('backToNormalPos'..i..' ('..t..')', currentTarget, {x = _G['default'..t..'StrumX'..i], y = _G['default'..t..'StrumY'..i], angle = 0}, (stepCrochet/1000)*interval, {ease = 'quadOut'})
                end
            end
        end
    end
    -- i wanna die
end

function updatePoop(n,f,v)
    setShaderFloat(n,f,v)
end

function strumie2()
    runHaxeCode([[
        for (cu in game.opponentStrums)
            cu.updateHitbox();
    ]])
end