-- i should remake this later, i hate how it works, and i hate working with saveDatas :angyface:

-- main menu one
initSaveData('corruptMenu')

-- state switch shit
setDataFromSave('corruptMenu', 'main', getDataFromSave('corruptMenu', 'main'))
setDataFromSave('corruptMenu', 'if', getDataFromSave('corruptMenu', 'if'))
setDataFromSave('corruptMenu', 'credits', getDataFromSave('corruptMenu', 'credits'))

for _, i in pairs({'main', 'credits', 'if'}) do
    if getDataFromSave('corruptMenu', i) == nil then
        setDataFromSave('corruptMenu', i, i == 'main' and true or false)
    end
end

-- notice shit
setDataFromSave('corruptMenu', 'seenIfNotice', getDataFromSave('corruptMenu', 'seenIfNotice'))
setDataFromSave('corruptMenu', 'seenSidestoryNotice', getDataFromSave('corruptMenu', 'seenSidestoryNotice'))

-- difficulty
setDataFromSave('corruptMenu', 'difficulty', getDataFromSave('corruptMenu', 'difficulty'))
if getDataFromSave('corruptMenu', 'difficulty') == nil then
    setDataFromSave('corruptMenu', 'difficulty', 'safe')
end

-- modshartsss
setDataFromSave('corruptMenu', 'modcharts', getDataFromSave('corruptMenu', 'modcharts'))
if getDataFromSave('corruptMenu', 'modcharts') == nil then
    setDataFromSave('corruptMenu', 'modcharts', 'None')
end

flushSaveData('corruptMenu')