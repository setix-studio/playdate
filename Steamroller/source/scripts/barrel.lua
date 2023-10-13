local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Barrel').extends(AnimatedSprite)

function Barrel:init(x, y)
    if levelNum >= 40 and levelNum <= 49 then
        barrelImageTable = gfx.imagetable.new("assets/images/barrel2-table-32-32")
        Barrel.super.init(self, barrelImageTable)
        else
            barrelImageTable = gfx.imagetable.new("assets/images/barrel-table-32-32")
            Barrel.super.init(self, barrelImageTable)
        end
    
    self:addState("idle", 1, 1)
    self:addState("destroy", 2, 3, { tickStep = 4 })
    self.currentState = "idle"
    self:setZIndex(Z_INDEXES.Prop)
    self:setImage(barrelImage)
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Prop)

    self:setCollideRect(10, 7, 12, 17)
    sfxBarrelHit = pd.sound.fileplayer.new('assets/sounds/barrelhit')
    sfxBarrelDestroy = pd.sound.fileplayer.new('assets/sounds/barreldestroy')
end

function Barrel:collisionResponse(other)
    return "overlap"
end

function Barrel:update()
    self:updateAnimation()
end

function Barrel:changetoDestroyState()
    self:changeState("destroy")
    score      -= 1
    enemyState = -3
    self:setCollideRect(-100, -70, -12, -17)

    spawnTimer = pd.timer.performAfterDelay(1000, function()
        self:remove()
    end)
    levelTime  += enemyState
end
