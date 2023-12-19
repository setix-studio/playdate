local pd <const> = playdate


function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        if gameData.saveData then
            saveData = gameData.saveData
        else
            saveData = saveData
        end
        if gameData.items then
            items = gameData.items
        else
            items = items { {

                ["category"] = "toppings",
                ["found"] = false,
                ["name"] = "Berries",
                ["ID"] = "Berries",
                ["basedescription"] = "??????????????????????????????????????????????????",
                ["description"] = "Sweet and juicy.",
                ["quantity"] = 0
            },
                {
                    ["category"] = "spices",
                    ["found"] = false,
                    ["name"] = "HOT SPICES",
                    ["ID"] = "HOT SPICES",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "spices",
                    ["found"] = false,
                    ["name"] = "TANGY SPICES",
                    ["ID"] = "TANGY SPICES",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "meat",
                    ["found"] = false,
                    ["name"] = "MEATY STALK",
                    ["ID"] = "MEATY STALK",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "meat",
                    ["found"] = false,
                    ["name"] = "SHROOMAS",
                    ["ID"] = "SHROOMAS",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "meat",
                    ["found"] = false,
                    ["name"] = "FLYING FISH",
                    ["ID"] = "FLYING FISH",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "toppings",
                    ["found"] = false,
                    ["name"] = "CHEESE",
                    ["ID"] = "CHEESE",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "toppings",
                    ["found"] = false,
                    ["name"] = "LIME",
                    ["ID"] = "LIME",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                },
                {
                    ["category"] = "toppings",
                    ["found"] = false,
                    ["name"] = "TOMAS",
                    ["ID"] = "TOMAS",
                    ["basedescription"] = "??????????????????????????????????????????????????",
                    ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
                    ["quantity"] = 0
                }, }
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
    end
end

function saveGameData()
    local gameData = {
        saveData = saveData,
        items = items,
        levelNum = levelNum,
        cosmoX = cosmoX,
        cosmoY = cosmoY,
        returnX = returnX,
        returnY = returnY,
        playerHP = playerHP,
        playerMaxHP = playerMaxHP,
        playerLevel = playerLevel,
        playerXP = playerXP,
        playerNextLevel = playerNextLevel
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
