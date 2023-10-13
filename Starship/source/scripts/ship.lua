local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Ship').extends(AnimatedSprite)

function Ship:init(x, y)
    local shipImageTable = gfx.imagetable.new("assets/images/ship2-table-96-96")
    Ship.super.init(self, shipImageTable)
    self:addState("idle", 1, 4, { tickStep = math.random(4, 6) })
    self.currentState = "idle"
    self:setZIndex(Z_INDEXES.Ship)


    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    self:setCollideRect(0, 0, 96, 90)
    self:playAnimation()
    self:setTag(TAGS.Ship)
    newX = 0
    newY = 0
end

function Ship:collisionResponse(other)
    return "overlap"
end

function Ship:update()
    self:updateAnimation()

    sightLine = pd.geometry.distanceToPoint(self.x - 128, self.y - 64, newX, newY)

    if sightLine <= 40 then
        showIntBtn = true
    else
        showIntBtn = false
    end
end


