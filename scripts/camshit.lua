local points = {x = nil, y = nil}
setVar('cameraPoint', points)

function onUpdate()
    if getVar('cameraPoint').x ~= nil and getVar('cameraPoint').y ~= nil then
        setProperty('camFollow.x', getVar('cameraPoint').x)
        setProperty('camFollow.y', getVar('cameraPoint').y)
    end
end