setVar('cameraPoint', {x = nil, y = nil})

function onUpdate()
    for i = 1,2 do
        if getVar('cameraPoint')[i] ~= nil then
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', getVar('cameraPoint').x)
            setProperty('camFollow.y', getVar('cameraPoint').y)
            debugPrint('testingggg')
        else
            debugPrint('tafalso')
            setProperty('isCameraOnForcedPos', false)
        end
    end
end