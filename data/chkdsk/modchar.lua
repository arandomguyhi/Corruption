luaDebugMode = true

function onCreatePost()
    if shadersEnabled then
        initLuaShader('pooper')
        makeLuaSprite('poop') setSpriteShader('poop', 'pooper')
        setShaderFloat('poop', 'iTime', 0.0)
        setShaderFloat('poop', 'AMT', 0)
        setShaderFloat('poop', 'SPEED', 2)

        runHaxeCode("game.camHUD.setFilters([new ShaderFilter(game.getLuaObject('poop').shader)]);")
    end

    for i = 0, 3 do
        setProperty('playerStrums.members['..i..'].visible', false)

        strum2 = {
            scaleX = getProperty('playerStrums.members['..i..'].scale.x'),
            scaleY = getProperty('playerStrums.members['..i..'].scale.y')
        }
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

    glitch({406, 410}, {'position', {-112, 112}}, 0.5, 2)
    glitch({544, 576}, {'position', {-112, 112}}, 0.5, 2)
    glitch({624, 672}, {'position', {-112, 112}}, 0.5, 2)
end

function bump(step, steplength, modifier, amnt, leease, line)
    local targets = {'Player', 'Opponent'}
    for i=1,2 do
        if line == -1 then line = i end
    end

    if curStep == step then
        for i = 0,3 do
            local currentTarget = targets[line]:lower()..'Strums.members['..i..']'
            setProperty(currentTarget..'.'..modifier:lower(), _G['default'..targets[line]..'Strum'..modifier..i] + amnt)
            startTween('unbump'..i, currentTarget, {x = _G['default'..targets[line]..'StrumX'..i], y = _G['default'..targets[line]..'StrumY'..i]}, (stepCrochet/1000) * steplength, {ease = leease})
        end
    end
end

function glitch(cu, type, interval, target)
    local targets = {'Player', 'Opponent'}
    for i=1,2 do
        if target == -1 then target = i end
    end

    if type[1] == 'shader' then
        if curStep == cu[1]-1 then
            runHaxeCode([[
                FlxTween.num(]]..type[2][1]..[[, ]]..type[2][2]..[[, (Conductor.stepCrochet/1000) * ]]..cu[2]-cu[1]..[[, null, (v:Float) -> {
                    parentLua.call('updatePoop', ['poop', 'AMT', v]);
                });
            ]])
        end

        if curStep == cu[2] then
            setShaderFloat('poop', 'AMT', 0)
        end
    end

    if type[1] == 'confusionOffset' then
        if curStep >= cu[1]-1 and curStep <= cu[2] then
            for i = 0,3 do
                local currentTarget = targets[target]:lower()..'Strums.members['..i..']'

                setProperty(currentTarget..'.angle', getRandomFloat(1, 359))
                if curStep == cu[2] then
                    startTween('backToNormalAng'..i, currentTarget, {angle = 0}, (stepCrochet/1000)*interval, {ease = 'circOut'})
                end
            end
        end
    end

    if type[1] == 'reverse' then
        if curStep >= cu[1]-1 and curStep < cu[2] then
            for i = 0,3 do
                local currentTarget = targets[target]:lower()..'Strums.members['..i..']'

                if getRandomBool(50) then
                    setPropertyFromGroup(targets[target]:lower()..'Strums', getRandomInt(0, 3), 'downScroll', true)
                else
                    setPropertyFromGroup(targets[target]:lower()..'Strums', getRandomInt(0, 3), 'downScroll', false)
                end

                setProperty(currentTarget..'.y', getPropertyFromGroup(targets[target]:lower()..'Strums', i, 'downScroll') and 570 or 50)
            end
        end

        if curStep == cu[2] then
            for i = 0, 3 do
                local currentTarget = targets[target]:lower()..'Strums.members['..i..']'
                
                setPropertyFromGroup(targets[target]:lower()..'Strums', i, 'downScroll', false)
                startTween('backToNormalStr'..i, currentTarget, {y = _G['default'..targets[target]..'StrumY'..i]}, (stepCrochet/1000)*(cu[2]-cu[1]), {ease = 'bounceOut'})
            end
        end
    end
            
    if type[1] == 'position' then
        if curStep >= cu[1]-1 and curStep <= cu[2] then
            local direction = 'x'
            for i = 0,3 do
                direction = 'x'
                if getRandomBool(50) then
                    direction = 'y' end

                local currentTarget = targets[target]:lower()..'Strums.members['..i..']'

                setProperty(currentTarget..'.angle', getRandomFloat(-360, 360))
                setProperty(currentTarget..'.'..direction, _G['default'..targets[target]..'Strum'..direction:upper()..i] + getRandomFloat(type[2][1], type[2][2]))

                if curStep == cu[2] then
                    startTween('backToNormalPos'..i, currentTarget, {x = _G['defaultOpponentStrumX'..i], y = _G['defaultOpponentStrumY'..i], angle = 0}, (stepCrochet/1000)*interval, {ease = 'quadOut'})
                end
            end
        end
    end
end

function updatePoop(n,f,v)
    setShaderFloat(n,f,v)
end