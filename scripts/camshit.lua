local points = {x = nil, y = nil}
setVar('cameraPoint', points)

function onCreate()
    runHaxeCode([[
        var camOverlay = new FlxCamera();
        camOverlay.bgColor = 0x0;
        setVar('camOverlay', camOverlay);

        FlxG.cameras.remove(game.camHUD, false);
        FlxG.cameras.remove(game.camOther, false);

        for (cams in [camOverlay, game.camHUD, game.camOther])
            FlxG.cameras.add(cams, false);
    ]])
end

function onUpdate()
    if getVar('cameraPoint').x ~= nil and getVar('cameraPoint').y ~= nil then
        setProperty('isCameraOnForcedPos', true)
        setProperty('camFollow.x', getVar('cameraPoint').x)
        setProperty('camFollow.y', getVar('cameraPoint').y)
    else
        setProperty('isCameraOnForcedPos', false)
        return
    end
end