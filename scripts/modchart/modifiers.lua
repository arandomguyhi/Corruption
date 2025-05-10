local modifier = {
    swagWidth = getPropertyFromClass('objects.Note', 'swagWidth'),
    halfWidth = getPropertyFromClass('objects.Note', 'swagWidth') / 2,
    targets = {'Player', 'Opponent'},
    drunkOffset = 0
}

local tipsy, drunk  

function modifier:confusionOffset(perc, idx, pl)
    local leTargets = (pl == -1) and self.targets or {self.targets[pl]}
    for _, t in ipairs(leTargets) do
        setProperty(t:lower()..'Strums.members['..idx..'].angle', perc)
    end
end

function modifier:tipsy(perc, pl, dur, curease)
    local leTargets = (pl == -1) and self.targets or {self.targets[pl]}
    curease = curease or 'linear'

    for i = 0, 3 do
        for _, t in ipairs(leTargets) do
            local currentTarget = t:lower()..'Strums.members['..i..']'

            local songPos = (getSongPosition()/1000)
            local defaultPos = getVar('default'..t..'Y'..i)+(pl ~= -1 and (pl == 1 and yPl or yOp) or 0)

            tipsy = defaultPos + perc * (fastCos((songPos * ((1 * 1.2) + 1.2) + i*((0*1.8)+1.8)))*self.swagWidth*.4)

            if dur then
                startTween('tipsy'..i..' ('..t..')', currentTarget, {y = tipsy}, (stepCrochet/1000)*dur, {ease = curease})
            else
                setProperty(currentTarget..'.y', tipsy)
            end
        end
    end
end

function modifier:drunk(perc, pl)
    local leTargets = (pl == -1) and self.targets or {self.targets[pl]}

    for i = 0, 3 do
        for _, t in ipairs(leTargets) do
            local currentTarget = t:lower()..'Strums.members['..i..']'

            local songPos = (getSongPosition()/1000)
            local defaultPos = getVar('default'..t..'X'..i)

            local angle = songPos * (1 + 1)+i*((self.drunkOffset*0.2)+0.2) + 1 * ((1*10)+10) / screenHeight
            drunk = defaultPos + perc * (fastCos(angle) * self.halfWidth)
            setProperty(currentTarget..'.x', drunk)
        end
    end
end

function fastCos(value)
    return callMethodFromClass('flixel.math.FlxMath', 'fastCos', {value})
end

return modifier