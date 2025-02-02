local points = {x = nil, y = nil}
setVar('cameraPoint', points)

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