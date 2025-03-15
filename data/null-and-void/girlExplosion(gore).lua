luaDebugMode = true

addHaxeLibrary('FlxTypedSpriteGroup', 'flixel.group')
addHaxeLibrary('Song', 'backend')
addHaxeLibrary('SwagSong', 'backend')
addHaxeLibrary('SwagSection', 'backend')

local path = '../assets/stages/null-and-void/'

function onCreatePost()
    runHaxeCode([[
        var girlExplosion = new FlxTypedSpriteGroup();
        game.add(girlExplosion);
        setVar('girlExplosion', girlExplosion);
    ]])

    local girlColours = {0xA4B6F2, 0xA4B6F2, 0xA4B6F2, 0xFFF5FC, 0xFFF5FC}
    for i = 0, 1200 do
        makeLuaSprite('p'..i)
        makeGraphic('p'..i, 16, 16, 'FFFFFF')
        setProperty('p'..i..'.color', girlColours[getRandomInt(1, #girlColours)])
        setProperty('p'..i..'.exists', false)
        addToGrp('girlExplosion', 'p'..i)
    end

    steps = runHaxeCode([[
        var stepToEvent:Array<Float> = [];

        var shit = Song.loadFromJson('girls', 'null-and-void');
        var noteData = shit.notes;
        for (sexion in noteData) {
            for (data in sexion.sectionNotes) {
                var time:Float = data[0];
                stepToEvent.push(Math.floor(Conductor.getStep(time)));
            }
        }
        return stepToEvent;
    ]])
end

local girls = 0
function createGirl()
    makeAnimatedLuaSprite('girl'..girls, path..'bgGirlGlitch', 760 + getRandomFloat(-600, 600), getProperty('boyfriend.y') - getRandomFloat(1600, 2000))

    local ranbool = getRandomBool(50)
    if ranbool then
        setProperty('girl'..girls..'.x', getRandomFloat(10, 500))
    else
        setProperty('girl'..girls..'.x', getRandomFloat(1200, 1650))
    end

    addAnimationByPrefix('girl'..girls, 'idle', 'BackgroundGirlFall', 24, true)
    addAnimationByPrefix('girl'..girls, 'wait', 'BackgroundGirlFall', 0, true)
    playAnim('girl'..girls, 'wait', true)
    scaleObject('girl'..girls, 2, 2)
    setProperty('girl'..girls..'.offset.x', getProperty('girl'..girls..'.offset.x') + 200)
    setProperty('girl'..girls..'.offset.y', getProperty('girl'..girls..'.offset.y') + 100)
    setProperty('girl'..girls..'.antialiasing', false)
end

local emitted = 0
local lastPos = {}
function startExplosion()
    for i = 0, 150 do
        if emitted > 1200 then
            emitted = 0
        elseif emitted < 0 then
            emitted = 0
        end

        local p = getProperty('girlExplosion.members['..emitted..']')
        setProperty(p..'.exists', true)
        setProperty(p..'.x', lastPos[#lastPos].x)
        setProperty(p..'.y', lastPos[#lastPos].y)

        local speed = getRandomFloat(240, 500)
        local angle = getRandomFloat(0, 360)
        setProperty(p..'.velocity.x', math.cos(angle)*speed)
        setProperty(p..'.velocity.y', math.sin(angle)*speed)
        setProperty(p..'.alpha', 1)

        startTween('byePart'..emitted, p, {alpha = 0}, getRandomFloat(0.3, 0.9), {onComplete = 'removePart'})
        removePart = function()
            setProperty(p..'.exists', false)
        end

        emitted = emitted + 1
    end
end

function onStepHit()
    for i = 1, #steps do
        if curStep == steps[i]-8 then
            createGirl()

            playAnim('girl'..girls, 'idle', true)
            setProperty('girl'..girls..'.velocity.y', getRandomFloat(1200, 1400))
            setProperty('girl'..girls..'.acceleration.y', 5000)
            setProperty('girl'..girls..'.maxVelocity.x', 20000)
            setProperty('girl'..girls..'.maxVelocity.y', 20000)
            addLuaSprite('girl'..girls)

            runTimer('removeGirl'..girls, (stepCrochet/1000)*8)

            girls = girls + 1
        end
    end
end

function onTimerCompleted(tag)
    for i = 0, girls do
        if tag == 'removeGirl'..i then
            table.insert(lastPos, {
                x = getProperty('girl'..i..'.x'),
                y = getProperty('girl'..i..'.y')
            })
            startExplosion()
            removeLuaSprite('girl'..i)
        end
    end
end

function addToGrp(grpName, obj)
    runHaxeCode("getVar('"..grpName.."').add(game.getLuaObject('"..obj.."'));")
end