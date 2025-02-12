--[[
 * Script creado Por Perez Sen *
  SIRVE PARA EL PSYCH ENGINE 0.7.3 (ANDROID Y PC) !!!!
]]--
luaDebugMode = false

local videoSprites = {}
function onCreate() 
    runHaxeCode([[ // Para No Andar Llamando las funciones Con Un callOnLuas :)
        createGlobalCallback('makeVideoSprite', function(tag:String, ?x:Float, ?y:Float, ?camera:String) {
            return parentLua.call("makeVideoSprit", [tag, x, y, camera]);
        });

        createGlobalCallback('precacheVideo', function(videoPath:String) {
            return parentLua.call("precachePath", [videoPath]);
        });

        createGlobalCallback('playVideo', function(tag:String, videoPath:String, ?shouldLoop:Bool) {
            shouldLoop ??= false;
            return parentLua.call("videoPlay", [tag, videoPath, shouldLoop]);
        });

        createGlobalCallback('pauseVideo', function(tag:String) {
            return parentLua.call("videoPausa", [tag]);
        });

        createGlobalCallback('resumeVideo', function(tag:String) {
            return parentLua.call("videoReanudar", [tag]);
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
        
            setVar(']]..videoTag..[[', video);
            setVar(']]..videoTag..[['+'s', sprite);
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

function videoPlay(tag, videoFile, shouldLoop)
    if buildTarget ~= 'android' then
        runHaxeCode([[
            var tagVideo = getVar(']]..tostring(tag)..[[');
            ver sprite = getVar(']]..tostring(tag)..[['+'s');
            var loopVideo = ]]..tostring(shouldLoop)..[[;

            video.onTextureSetup.add(function(){
                sprite.loadGraphic(tagVideo.bitmapData);}  
            });

            if (!loopVideo){
                tagVideo.onEndReached.add(function(){
                    tagVideo.dispose();

                    if (FlxG.game.contains(tagVideo))
                        FlxG.game.removeChild(tagVideo);
                
                    if (game.modchartSprites.exists(']]..tag..[['))
                    {
                        game.modchartSprites.get(']]..tag..[[').destroy();
                        game.modchartSprites.remove(']]..tag..[[');
                    }
                    game.callOnLuas('onVideoFinished', [']]..tag..[[']);
                    return;
                }, true);
            }

            tagVideo.play(Paths.video(']]..videoFile..[['), ]]..tostring(shouldLoop)..[[);
            FlxG.game.addChild(video);
        ]])
    else
        local tagVideo = callMethodFromClass('backend.Paths', 'video', {videoFile});
        callMethod(tag ..'.startVideo', {tagVideo, shouldLoop});
    end
end

function videoPausa(tag)
    if getVar(tag) ~= nil then
        if buildTarget ~= 'android' then
            runHaxeCode([[ 
                    getVar(']] .. tag .. [[').pause(); 
                ]])
        else
            setProperty(tag .. '.paused', true)
        end
    else
        debugPrint("Function resumeVideo: There's no video with the tag: "..tag)
    end
end

function videoReanudar(tag)
    if getVar(tag) ~= nil then 
        if buildTarget ~= 'android' then
            runHaxeCode([[ 
                        getVar(']] .. tag .. [[').resume(); 
                    ]])
        else
            setProperty(tag..'.paused', false)
        end
    else 
        debugPrint("Function resumeVideo: There's no video with the tag: "..tag)
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