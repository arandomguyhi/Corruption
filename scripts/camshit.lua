setVar('cameraPoint', {x = nil, y = nil})

function onUpdate()
    debugPrint(getVar('cameraPoint').x)
    for k in pairs(getVar('cameraPoint')) do
        if getVar('cameraPoint')[k] ~= nil then
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', getVar('cameraPoint').x)
            setProperty('camFollow.y', getVar('cameraPoint').y)
            debugPrint('x: '.. getVar('cameraPoint').x ..'. y: '.. getVar('cameraPoint').y ..'.')
        else
            setProperty('isCameraOnForcedPos', false)
        end
    end
end