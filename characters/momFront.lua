function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if isSustainNote then
        setProperty('dad.holdTimer', 0)
        return Function_Stop
    end
    return Function_Continue
end