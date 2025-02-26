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

flushSaveData('corruptMenu')