local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Ship').extends(AnimatedSprite)

function Ship:init(x, y)
    shipImageTable = gfx.imagetable.new("assets/images/bus-table-96-96")

    Ship.super.init(self, shipImageTable)
    self:addState("idle", 1, 4, { tickStep = math.random(4, 6) })
    self.currentState = "idle"
    self:setZIndex(10)




    self:setCenter(0.5, 0.5)
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
    sightLine = pd.geometry.distanceToPoint(self.x, self.y, newX, newY)
    if sightLine <= 32 then
        showIntBtn = true
    else
        showIntBtn = false
    end

    cosmoSortOrder(self)
end
