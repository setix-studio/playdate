local pd <const> = playdate
local gfx <const> = playdate.graphics


class('HomeScene').extends(Room)
import "scripts/gameScene"
import "scripts/player"
import "scripts/enemySpawner"
import "scripts/enemy"
function HomeScene:init()
    HomeSceneImage()
    music:setVolume(0.8)
    music:play(0)
    currentScore = 0
end

function HomeScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorWhite)
    gfx.setColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font1)
    gfx.drawTextAligned("High Score: " .. HIGH_SCORE, 383, 5, kTextAlignment.right)
    gfx.drawTextAligned("demo by setix studio", 383, 169, kTextAlignment.right)
end

function HomeScene:AButtonDown()
    gfx.sprite.removeAll()
    manager:push(LoadingScene())
end

class('HomeSceneImage').extends(gfx.sprite)
function HomeSceneImage:init(x, y)
    homeImage = gfx.image.new("assets/images/mainhomescene")


    self:setImage(homeImage)

    self:setCenter(0, 0)
    self:add()
end
