function onCreatePost()
    for i = 0, 3 do
        setProperty('playerStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i])
        setProperty('opponentStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i])
    end
end

function onStepHit()
    if curStep == 2944 then
        for i = 0, 3 do
            startTween('playerStrumPos'..i, 'playerStrums.members['..i..']', {x = 412 + (112 * i)}, (stepCrochet/1000) * 8, {ease = 'quadOut'})
            startTween('opStrumAlpha'..i, 'opponentStrums.members['..i..']', {alpha = 0.001}, (stepCrochet/1000) * 8, {ease = 'quadOut'})
        end
    end

    if curStep >= 1914 and curStep < 1918 then
        setProperty('blackTop.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0, 1, curStep}))
    end

    if curStep >= 3344 and curStep < 3392 then
        setProperty('waveEfx.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0.5, 0.1, curStep}))
    end

    if curStep >= 1664 and curStep < 1712 then
        setProperty('waveEfx.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0.1, 0.6, curStep}))
    end

    if curStep >= 1892 and curStep < 1919 then
        setProperty('waveEfx.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0.1, 0.6, curStep}))
    end

    if curStep >= 1916 and curStep < 1919 then
        setProperty('black2.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0, 1, curStep}))
    end

    if curStep >= 1920 and curStep < 1929 then
        setProperty('black2.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {1, 0, curStep}))
    end

    if curStep >= 2048 and curStep < 2108 then
        setProperty('waveEfx.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0.5, 0.1, curStep}))
    end

    if curStep >= 2940 and curStep < 2943 then
        setProperty('black2.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {0, 1, curStep}))
    end

    if curStep >= 2944 and curStep < 2958 then
        setProperty('black2.alpha', callMethodFromClass('flixel.math.FlxMath', 'lerp', {1, 0, curStep}))
    end
end