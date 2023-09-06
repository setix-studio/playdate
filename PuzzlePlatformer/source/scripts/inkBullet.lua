local pd <const> = playdate
local gfx <const> = pd.graphics

class('inkBullet').extends(gfx.sprite)

function inkBullet:init(x, y, speed)
    local bulletSize = 4
    local bulletImage = gfx.image.new(bulletSize * 2, bulletSize * 2)
    gfx.pushContext(bulletImage)
        gfx.drawCircleAtPoint(bulletSize, bulletSize, bulletSize)
    gfx.popContext()
    self:setImage(bulletImage)

    self:setCollideRect(0, 0, self:getSize())
    self.speed = speed
    
    self:moveTo(x, y)
    self:add()
end

function inkBullet:update(direction)
    dir = -self.x

    local actualX, actualY, collisions,  length = self:moveWithCollisions(dir + self.speed, self.y)
    
    if direction == "right" then 
        dir = -self.x
    else
       dir = -self.x
    end
    if length > 0 then
        for index, collision in ipairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Enemy) then
                collidedObject:remove()
               
            end
        end
        self:remove()
    elseif actualX > 400 then
        self:remove()
    end
end