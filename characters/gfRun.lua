local path = '../assets/stages/bloodlust/gfRun/'

function onCreate()
    makeAnimatedLuaSprite('idle', path..'GFRunning')
    addAnimationByPrefix('idle', 'idle', 'runIdle', 24, true)
    playAnim('idle', 'idle')

    for _, i in pairs({'Left', 'Right', 'Up', 'Down'}) do
        makeAnimatedLuaSprite(i:lower(), path..'gfRun'..i)
        addAnimationByPrefix(i:lower(), 'idle', 'run'..i, 24, true)
        playAnim(i:lower(), 'idle')
        setProperty(i:lower()..'.visible', false)

        addLuaSprite(i:lower(), true)
    end
    addLuaSprite('idle', true)

    addOffset('idle', 'idle', 0, 0)
    addOffset('left', 'idle', -3, -2)
    addOffset('right', 'idle', 0, 7)
    addOffset('up', 'idle', -3, -12)
    addOffset('down', 'idle', -2, 9)
end

local sprites = {'left', 'down', 'up', 'right', 'idle'}
function onUpdate()
    for _, spr in pairs(sprites) do
        setProperty(spr..'.x', getProperty('gfRun.x'))
        setProperty(spr..'.y', getProperty('gfRun.y'))
        setProperty(spr..'.alpha', getProperty('gfRun.alpha'))

        if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
            setProperty(sprites[5]..'.visible', true)
            for smt = 1,4 do setProperty(sprites[smt]..'.visible', false) end
        end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    for _, i in pairs(sprites) do
        setProperty(i..'.visible', false)
        setProperty(sprites[noteData+1]..'.visible', true)
    end
end