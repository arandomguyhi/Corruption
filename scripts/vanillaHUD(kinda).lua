function onCreatePost()
    for _,i in pairs({'timeBar', 'timeBar.bg', 'timeTxt', 'scoreTxt', 'iconP1', 'iconP2', 'healthBar', 'healthBar.bg'}) do
        setProperty(i..'.visible', false) end
    setProperty('botplayTxt.y', getProperty('healthBar.y') + (downscroll and 70 or -120))

    makeLuaText('newScore', 'Score: 0', getProperty('newScore.width'), getProperty('scoreTxt.x')+750, getProperty('scoreTxt.y')-10)
    setTextSize('newScore', 16)
    setObjectCamera('newScore', 'hud')
    addLuaText('newScore')
end

function onUpdatePost()
    setTextString('newScore', 'Score: '..score)
end