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
            note.shader = game.getLuaObject('glitchColor').shader;
    ]])

    table.insert(shaders, 'glitchColor')
    for i = 0, 3 do
        table.insert(shadered, 'opponentStrums.members['..i..']')
    end

    shidGlitching = true
end

function onSpawnNote(i)
    runHaxeCode([[
        for (note in game.notes) {
            if (!note.mustPress)
                note.shader = game.getLuaObject('glitchColor').shader;
        }
    ]])
end

function onStepHit()
    for _, shit in pairs(shaders) do
        setShaderFloat(shit, 'binaryIntensity', getRandomFloat(4.0, 16.0))
    end
end

local removing = {}
local bzl = 0
function onUpdate(elapsed)
    bzl = bzl + elapsed
    for _, shit in pairs(shadered) do
        if getProperty(shit..'.shader') == nil then
            table.insert(removing, shit)
        else
            setShaderFloat(shit, 'uTime', bzl)
        end
    end

    for _,r in pairs(removing) do
        table.remove(shadered, r) end
end