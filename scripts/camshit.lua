setVar('cameraPoint', {x = nil, y = nil})

function onUpdate()
    for i = 1,2 do
        if getVar('cameraPoint')[i] ~= nil then
            setProperty('camFollow.x', getVar('cameraPoint').x)
            setProperty('camFollow.y', getVar('cameraPoint').y)
        end
    end
end