-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"


-- Libraries
import "scripts/libraries/AnimatedSprite"

--scripts
import "scripts/gameScene"
import "scripts/player"
import "scripts/enemySpawner"
import "scripts/enemy"
import "scripts/building"

local pd <const> = playdate
local gfx <const> = playdate.graphics


GameScene()
startSpawner()
playdate.ui.crankIndicator:start()
function playdate.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    playdate.drawFPS(380, 0) -- FPS widget

    gfx.setColor(gfx.kColorBlack)

    gfx.drawText("Score: " .. _G.score, 2, 2)

    currentMilliseconds = playdate.getCurrentTimeMilliseconds()
    elapsedTime = playdate.getElapsedTime()
    remainingTime = 60 - elapsedTime
    if remainingTime <= 0 then
        remainingTime = 0
    end

    gfx.drawText("time: " .. math.floor(remainingTime), 2, 20)

    if pd.isCrankDocked() then
        pd.ui.crankIndicator:update()
    end
end
