import "enemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

local spawnTimer


function startSpawner()
    math.randomseed(pd.getSecondsSinceEpoch())
    createTimer()
    printTable(pd.timer.allTimers())
    enemyCounter = 0
end

function createTimer()
    spawnTime = math.random(400, 1200)
    spawnTimer = pd.timer.performAfterDelay(spawnTime, function()
        createTimer()
        spawnEnemy()
    end)
end

function spawnEnemy()
    local spawnPosition = math.random(180, 1900)
    Enemy(spawnPosition, spawnPosition)
 


    local allSprites = gfx.sprite.getAllSprites()
    for index, sprite in ipairs(allSprites) do
        if sprite:isa(Planet) then
            
        end
    end
end

function stopSpawner()
    if spawnTimer then
        spawnTimer:remove()
    end
end

function clearEnemies()
    local allSprites = gfx.sprite.getAllSprites()
    for index, sprite in ipairs(allSprites) do
        if sprite:isa(Enemy) then
            sprite:remove()
        end
    end
end
