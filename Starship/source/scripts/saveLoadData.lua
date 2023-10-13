local pd <const> = playdate

HIGH_SCORE = 0

function loadGameData()
    local gameData = pd.datastore.read()
    if gameData then
        if gameData.highscore then
            HIGH_SCORE = gameData.highscore
        else
            HIGH_SCORE = 0
        end
        
       
    end
end


function saveGameData()
    local gameData = {
        highscore = HIGH_SCORE
    }
    pd.datastore.write(gameData)
end

function pd.gameWillTerminate()
    saveGameData()
end

function pd.gameWillSleep()
    saveGameData()
end

loadGameData()