-- hi buddy

setProperty('skipCountdown', true)
setProperty('isCameraOnForcedPos', true)

if getDataFromSave('corruptMenu', 'main') then
    addLuaScript('scripts/states/menu')
end

if getDataFromSave('corruptMenu', 'credits') then
    addLuaScript('scripts/states/creditsMenu')
end

if getDataFromSave('corruptMenu', 'if') then
    if not getDataFromSave('corruptMenu', 'seenIfNotice') then
        addLuaScript('scripts/states/ifNotice')
    else
        addLuaScript('scripts/states/ifMenu')
    end
end

function onCreatePost()
    for _, i in pairs({'boyfriend', 'gf', 'dad', 'camHUD'}) do
        setProperty(i..'.visible', false) end
end

function onPause()
    return Function_Stop
end

function onUpdate()
    if keyboardJustPressed('SPACE') then
        restartSong()
    end
end