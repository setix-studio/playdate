local pd <const> = playdate
local gfx <const> = playdate.graphics

class('GameOverScene').extends(Room)

function GameOverScene:init(self)
    gfx.sprite.removeAll()
end

function GameOverScene:update()
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRoundRect(215, 140, 22, 22, 50)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    width = 400
    gfx.setFont(font1)
    gfx.drawTextAligned("Game Over", width / 2, 80, kTextAlignment.center)

    gfx.drawTextAligned("Press   A ", width / 2, 140, kTextAlignment.center)
end

function GameOverScene:AButtonDown()
  
    manager:enter(GameScene())
end
