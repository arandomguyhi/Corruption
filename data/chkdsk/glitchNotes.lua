if (getModSetting('shadersC') ~= 'All' and not shadersEnabled) or lowQuality then
    return end

local shidGlitching = false
local shaders = {}
local shadered = {}

function onCreatePost()
    initLuaShader('glitchcolorswap')
    makeLuaSprite('glitchColor') setSpriteShader('glitchColor', 'glitchcolorswap')
    setShaderFloatArray('glitchColor', 'iTime', {0, 0, 0})
    setShaderFloatArray('glitchColor', 'flashColor', {1, 1, 1, 1})
    setShaderFloat('glitchColor', 'daAlpha', 1)
    setShaderFloat('glitchColor', 'flash', 0)
    setShaderFloat('glitchColor', 'binaryIntensity', 2.0)

    runHaxeCode([[
        for (note in game.opponentStrums)
            note.shader = getLuaObject('glitchColor').shader;
    ]])

    table.insert(shaders, 'glitchColor')
    for i = 0, 3 do
        table.insert(shadered, 'opponentStrums.members['..i..']')
    end

    shidGlitching = true
end

function onSpawnNote(i)
    if not getPropertyFromGroup('notes', i, 'mustPress') then
        runHaxeCode([[
            for (note in game.notes)
                note.shader = getLuaObject('glitchColor').shader;
        ]])
    end
end

function onStepHit()
    for _, shit in pairs(shaders) do
        setShaderFloat(shit, 'binaryIntensity', getRandomFloat(4.0, 16.0))
    end
end

local removing = {}
function onUpdate(elapsed)
    for _, shit in pairs(shadered) do
        if getProperty(shit..'.shader') == nil then
            table.insert(removing, shit)
        else
            setShaderFloat(shit, 'uTime', elapsed)
        end
    end

    for _,r in pairs(removing) do
        table.remove(shadered, r) end
end