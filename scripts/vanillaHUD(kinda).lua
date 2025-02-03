function onCreatePost()
    setProperty('timeBar.visible', false)
    setProperty('timeBar.bg.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('scoreTxt.visible', false)
    setProperty('botplayTxt.y', getProperty('healthBar.y') + (downscroll and 70 or -120))

    callMethod('healthBar.setColors', {0xFF0000, 0x00FF00})

    makeLuaText('newScore', 'Score: 0', getProperty('newScore.width'), getProperty('scoreTxt.x')+750, getProperty('scoreTxt.y')-10)
    setTextSize('newScore', 16)
    setObjectCamera('newScore', 'hud')
    addLuaText('newScore')
end

function onUpdatePost()
    setTextString('newScore', 'Score: '..score)
end