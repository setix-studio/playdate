local pd <const> = playdate
local gfx <const> = playdate.graphics

class('GameOverScene').extends(Room)

function GameOverScene:init()
    gfx.sprite.removeAll()
    sfxMole:stop()
    spawnTimer = pd.timer.performAfterDelay(5000, function()
        GameOverSceneImage()
    end)
end

function GameOverScene:update()
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRoundRect(218, 147, 22, 22, 50)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    width = 400
    gfx.setFont(font2)
    gfx.drawTextAligned("Game Over", width / 2, 70, kTextAlignment.center)
    gfx.drawTextAligned("High Score: " .. HIGH_SCORE, width / 2, 100, kTextAlignment.center)
    gfx.drawTextAligned("Your Score: " .. score, width / 2, 120, kTextAlignment.center)
    gfx.drawTextAligned("Press  A ", width / 2, 150, kTextAlignment.center)
end

function GameOverScene:AButtonDown()
    spawnTimer = pd.timer.performAfterDelay(1000, function()
        manager:enter(HomeScene())
    end)
end

class('GameOverSceneImage').extends(gfx.sprite)
function GameOverSceneImage:init(x, y)

end
