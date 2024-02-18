local pd <const> = playdate


function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        if gameData.saveData then
            saveData = gameData.saveData
        else
            saveData = saveData
        end
        if gameData.quests then
            quests = gameData.quests
        else
            quests = quests
        end
        if gameData.items then
            items = gameData.items
        else
            items = items
        end
        if gameData.recipes then
            recipes = gameData.recipes
        else
            recipes = recipes
        end
        if gameData.levelNum then
            levelNum = gameData.levelNum
        else
            levelNum = 0
        end
        if gameData.cosmoX then
            cosmoX = gameData.cosmoX
        else
            cosmoX = cosmoX
        end
        if gameData.cosmoY then
            cosmoY = gameData.cosmoY
        else
            cosmoY = cosmoY
        end
        if gameData.returnRoomNumber then
            returnRoomNumber = gameData.returnRoomNumber
        else
            returnRoomNumber = returnRoomNumber
        end
        if gameData.roomNumber then
            roomNumber = gameData.roomNumber
        else
            roomNumber = roomNumber
        end
        if gameData.returnX then
            returnX = gameData.returnX
        else
            returnX = returnX
        end
        if gameData.returnY then
            returnY = gameData.returnY
        else
            returnY = returnY
        end
        if gameData.playerLevel then
            playerLevel = gameData.playerLevel
        else
            playerLevel = playerLevel
        end
        if gameData.playerXP then
            playerXP = gameData.playerXP
        else
            playerXP = playerXP
        end
        if gameData.playerHP then
            playerHP = gameData.playerHP
        else
            playerHP = playerHP
        end
        if gameData.playerMaxHP then
            playerMaxHP = gameData.playerMaxHP
        else
            playerMaxHP = playerMaxHP
        end
        if gameData.playerNextLevel then
            playerNextLevel = gameData.playerNextLevel
        else
            playerNextLevel = playerNextLevel
        end
        if gameData.credits then
            credits = gameData.credits
        else
            credits = credits
        end
        if gameData.previouslevel then
            previouslevel = gameData.previouslevel
        else
            previouslevel = previouslevel
        end
    end
end

function saveGameData()
    local gameData = {
        saveData = saveData,
        quests = quests,
        items = items,
        recipes = recipes,
        levelNum = levelNum,
        cosmoX = cosmoX,
        cosmoY = cosmoY,
        returnX = returnX,
        returnY = returnY,
        playerHP = playerHP,
        roomNumber = roomNumber,
        returnRoomNumber = returnRoomNumber,
        playerMaxHP = playerMaxHP,
        playerLevel = playerLevel,
        playerXP = playerXP,
        playerNextLevel = playerNextLevel,
        previouslevel = previouslevel,
        credits = credits
    }
    pd.datastore.write(gameData)
end

-- function pd.gameWillTerminate()
--     saveGameData()
-- end

-- function pd.gameWillSleep()
--     saveGameData()
-- end

loadGameData()
