--[[
 * Script creado Por Perez Sen *
  SIRVE PARA EL PSYCH ENGINE 0.7.3 (ANDROID Y PC) !!!!
]]--
luaDebugMode = true

local videoSprites = {}
function onCreate() 
    runHaxeCode([[ // Para No Andar Llamando las funciones Con Un callOnLuas :)
        createGlobalCallback('makeVideoSprite', function(tag:String, ?x:Float, ?y:Float, ?camera:String) {
            return parentLua.call("makeVideoSprit", [tag, x, y, camera]);
        });

        createGlobalCallback('precacheVideo', function(videoPath:String) {
            return parentLua.call("precachePath", [videoPath]);
        });


        // 3 new cool functions :fire: :fire:
        createGlobalCallback('playVideoSprite', function(tag:String, path:String, ?shouldLoop:Bool = false) {
            return parentLua.call("playTheVideo", [tag, path, shouldLoop]);
        });
        createGlobalCallback('pauseVideoSprite', function(tag:String) {
            return parentLua.call("pauseTheVideo", [tag]);
        });
        createGlobalCallback('resumeVideoSprite', function(tag:String) {
            return parentLua.call("resumeTheVideo", [tag]);
        });
    ]]);

    if buildTarget ~= 'android' then
        addHaxeLibrary("LuaUtils","psychlua")
        addHaxeLibrary("FlxVideo","hxcodec.flixel")
    end
end

function makeVideoSprit(videoTag, x, y, camera)
    if buildTarget ~= 'android' then
        runHaxeCode([[
            var sprite:FlxSprite = new FlxSprite(']]..x..[[', ']]..y..[[').makeGraphic(1, 1, FlxColor.TRANSPARENT);
            sprite.camera = LuaUtils.cameraFromString(']]..camera..[[');
            game.modchartSprites.set(']]..videoTag..[[', sprite);
            add(sprite);
            
            var video:FlxVideo = new FlxVideo();
            video.alpha = 0;

            video.onEndReached.add(function(){
                FlxG.game.removeChild(video);
                video.dispose();

                if (FlxG.game.contains(video))
                    FlxG.game.removeChild(video);
            
                if (game.modchartSprites.exists(']]..videoTag..[['))
                {
                    game.modchartSprites.get(']]..videoTag..[[').destroy();
                    game.modchartSprites.remove(']]..videoTag..[[');
                }
                game.callOnLuas('onVideoFinished', [']]..videoTag..[[']);
                return;
            }, true);

            FlxG.game.addChild(video);
            setVar(']]..videoTag..[[', video);
        ]])

        table.insert(videoSprites, videoTag)
    else
        createInstance(videoTag, 'backend.VideoSpriteManager', {x, y})
        setObjectCamera(videoTag, camera)
        addInstance(videoTag)
    end
end

function precachePath(videoPath)
    if buildTarget ~= 'android' then
        runHaxeCode([[
            var videoC:FlxVideo = new FlxVideo();
            videoC.play(Paths.video(']]..videoPath..[['), false);
            videoC.stop();
        ]])
    else
        local videoCache = callMethodFromClass('backend.Paths', 'video', {videoPath})
        createInstance(videoPath..'c', 'backend.VideoSpriteManager', {0, 0})
        callMethod(videoPath..'c'..'.startVideo')
        callMethod(videoPath..'c'..'.dispatch')
        setProperty(videoPath..'c'..'.visible', false)
   end
end

function playTheVideo(tag, path, shouldLoop)
    setVar('shouldLoop', shouldLoop) -- I KNOW, I KNOW. DON'T SAY NOTHING
    if buildTarget ~= 'android' then
        runHaxeCode([[
            var video = getVar(']]..tag..[[');
            video.onTextureSetup.add(function(){
                game.modchartSprites[']]..tag..[['].loadGraphic(video.bitmapData);
            });

            video.play(Paths.video(']]..path..[['), getVar('shouldLoop'));
            video.rate = game.playbackRate;
        ]])
    else
        local tagLoad = callMethodFromClass('backend.Paths', 'video', {path})
        callMethod(tag ..'.startVideo', {tagLoad, shouldLoop})
    end
end

function pauseTheVideo(tag)
    if buildTarget ~= 'android' then
        runHaxeCode("getVar('"..tag.."').pause();")
    else
        setProperty(tag..'.paused', true)
    end
end

function resumeTheVideo(tag)
    if buildTarget ~= 'android' then
        runHaxeCode("getVar('"..tag.."').resume();")
    else
        setProperty(tag..'.paused', false)
    end
end

function onPause()
    if buildTarget ~= 'android' then
        for _, video in pairs(videoSprites) do
            if video then 
                runHaxeCode([[ 
                    getVar(']] .. video .. [[').pause(); 
                ]])
            end
        end
    end
end

function onResume()
    if buildTarget ~= 'android' then
        for _, video in pairs(videoSprites) do
            if video then 
                runHaxeCode([[ 
                    getVar(']] .. video .. [[').resume();
                ]])
            end
        end
    end
end

function onDestroy()
    if buildTarget ~= 'android' then
        for _, video in pairs(videoSprites) do
            if video then 
                runHaxeCode([[
                    getVar(']] .. video .. [[').stop();
                ]])
            end
        end
    end
end

-- Android Build

-- https://github.com/BarbaraOficial/Moon-Engine-07/blob/3ac3a685337693c18699ebd171eed8cb536fb9c8/source/backend/VideoSpriteManager.hx#L55