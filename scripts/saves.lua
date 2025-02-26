initSaveData('corruptMenu')

-- state switch shit
setDataFromSave('corruptMenu', 'main', getDataFromSave('corruptMenu', 'main'))
setDataFromSave('corruptMenu', 'if', getDataFromSave('corruptMenu', 'if'))
setDataFromSave('corruptMenu', 'credits', getDataFromSave('corruptMenu', 'credits'))

-- notice shit
setDataFromSave('corruptMenu', 'seenIfNotice', getDataFromSave('corruptMenu', 'seenIfNotice'))
setDataFromSave('corruptMenu', 'seenSidestoryNotice', getDataFromSave('corruptMenu', 'seenSidestoryNotice'))

flushSaveData('corruptMenu')