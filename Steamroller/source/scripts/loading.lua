local pd <const> = playdate
local gfx <const> = playdate.graphics
import "scripts/gameScene"
import "scripts/libraries/LDtk"
local ldtk <const> = LDtk
class('LoadingScene').extends(Room)

function LoadingScene:init()
    gfx.sprite.removeAll()
    LoadingSceneImage()
    music:stop()

    score = currentScore
    spawnTimer = pd.timer.performAfterDelay(6000, function()
        if levelNum >= 0 and levelNum <= 9 then
            ldtk.load("levels/world.ldtk")
        elseif levelNum >= 10 and levelNum <= 19 then
                ldtk.load("levels/world3.ldtk")
            elseif levelNum >= 20 and levelNum <= 29 then
                    ldtk.load("levels/world4.ldtk")
        elseif levelNum >= 30 and levelNum <= 59 then
            ldtk.load("levels/world2.ldtk")
        end
        manager:enter(GameScene())
    end)
end

function LoadingScene:update()
    -- gfx.setColor(gfx.kColorBlack)
    -- gfx.fillRect(0, 0, 400, 240)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    width = 400

    gfx.drawTextAligned("Loading", width / 2, 120, kTextAlignment.center)
end

class('LoadingSceneImage').extends(AnimatedSprite)
function LoadingSceneImage:init(x, y)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    local loadingImage = gfx.imagetable.new("assets/images/loadingroller-table-80-80")
    LoadingSceneImage.super.init(self, loadingImage)

    self:addState("idle", 1, 4, { tickStep = 4 })

    self.currentState = "idle"
    self:playAnimation()

    self.speed = 3
    self.x = -60
    self:moveTo(self.x, 140)
    self:setCenter(0, 0)
    self:add()
end

function LoadingSceneImage:update()
    self:updateAnimation()
    self.x += self.speed
    self.y = 150 + math.random(0, 1)
    if self.y > 151 then
        self.y = 151
    elseif self.y < 149 then
        self.y = 149
    end
    self:moveTo(self.x, self.y)
end
