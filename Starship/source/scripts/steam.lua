local pd <const> = playdate
local gfx <const> = pd.graphics

class('Steam').extends(AnimatedSprite)

function Steam:init(x, y)
    local steamImage = gfx.imagetable.new("assets/images/steam-table-48-48")
    Steam.super.init(self, steamImage)

    self:addState("idle", 1, 6, { tickStep = 3 })

    self.currentState = "idle"
    self:playAnimation()

    self:moveTo(Player.x, Player.y)
    self:setCenter(0, 0)
    self:add()
end

function Steam:update()
    self:updateAnimation()
    self:moveTo(Player.x, Player.y)
    -- spawnTimer = pd.timer.performAfterDelay(4000, function()
    --     self:remove()
    -- end)
end
