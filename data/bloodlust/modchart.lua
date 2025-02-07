function onCreatePost()
    for i = 0, 3 do
        setProperty('playerStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i])
        setProperty('opponentStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i])
    end
    for _, obj in pairs({'iconP1','iconP2','healthBar','timeBar','timeTxt'}) do
        setProperty(obj..'.visible', false) end
end

function onStepHit()
    if curStep == 2944 then
        for i = 0, 3 do
            startTween('playerStrumPos'..i, 'playerStrums.members['..i..']', {x = 412 + (112 * i)}, (stepCrochet/1000) * 8, {ease = 'quadOut'})
            startTween('opStrumAlpha'..i, 'opponentStrums.members['..i..']', {alpha = 0.001}, (stepCrochet/1000) * 8, {ease = 'quadOut'})
        end
    end

    -- lerping to tween
    if curStep == 1914 then
        setProperty('blackTop.alpha', 0.001)
        startTween('blacktoptween', 'blackTop', {alpha = 1}, (stepCrochet/1000)*4, {})
    elseif curStep == 3344 then
        setProperty('waveEfx.alpha', 0.5)
        startTween('wavealpha', 'waveEfx', {alpha = 0.1}, (stepCrochet/1000)*48, {})
    elseif curStep == 1664 then
        setProperty('waveEfx.alpha', 0.1)
        startTween('wavealpha', 'waveEfx', {alpha = 0.6}, (stepCrochet/1000)*48, {})
    elseif curStep == 1892 then
        setProperty('waveEfx.alpha', 0.1)
        startTween('wavealpha', 'waveEfx', {alpha = 0.6}, (stepCrochet/1000)*27, {})
    elseif curStep == 1916 then
        startTween('blackalphatwwen', 'black2', {alpha = 1}, (stepCrochet/1000)*3, {})
    elseif curStep == 1920 then
        startTween('blackalphatwwen', 'black2', {alpha = 0.001}, (stepCrochet/1000)*9, {})
    elseif curStep == 2048 then
        setProperty('waveEfx.alpha', 0.5)
        startTween('wavealpha', 'waveEfx', {alpha = 0.6}, (stepCrochet/1000)*60, {})
    elseif curStep == 2940 then
        startTween('blackalphatwwen', 'black2', {alpha = 1}, (stepCrochet/1000)*3, {})
    elseif curStep == 2944 then
        startTween('blackalphatwwen', 'black2', {alpha = 0.001}, (stepCrochet/1000)*14, {})
    end
end