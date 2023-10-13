local pd <const> = playdate
local gfx <const> = playdate.graphics
import "scripts/gameScene2"

class('LoadingScene2').extends(Room)

function LoadingScene2:init()
    gfx.sprite.removeAll()
    LoadingSceneImage()
    music:stop()

    score = currentScore
    spawnTimer = pd.timer.performAfterDelay(6000, function()
        manager:push(GameScene2())
    end)
end

function LoadingScene2:update()
    -- gfx.setColor(gfx.kColorBlack)
    -- gfx.fillRect(0, 0, 400, 240)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    width = 400

    gfx.drawTextAligned("Loading", width / 2, 120, kTextAlignment.center)
end

class('LoadingSceneImage2').extends(AnimatedSprite)
function LoadingSceneImage2:init(x, y)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    local loadingImage = gfx.imagetable.new("assets/images/loadingroller-table-80-80")
    LoadingSceneImage2.super.init(self, loadingImage)

    self:addState("idle", 1, 4, { tickStep = 4 })

    self.currentState = "idle"
    self:playAnimation()

    self.speed = 3
    self.x = -60
    self:moveTo(self.x, 140)
    self:setCenter(0, 0)
    self:add()
end

function LoadingSceneImage2:update()
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
