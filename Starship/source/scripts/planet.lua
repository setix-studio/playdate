local pd <const> = playdate
local gfx <const> = playdate.graphics
import 'CoreLibs/animator'
import 'CoreLibs/graphics'



class('Planet').extends(AnimatedSprite)
function Planet:init(x, y, entity)
    gfx.setColor(gfx.kColorWhite)
    if newX == nil then
        newX = 0
    end
    if newY == nil then
        newY = 0
    end
    local planetImage = gfx.imagetable.new("assets/images/planet1-table-128-128")
    Planet.super.init(self, planetImage)

    self:addState("lima", 2, 2)
    self:addState("laven", 3, 3)
    self:addState("garliel", 4, 4)
    self:addState("mushroo", 5, 5)


    self.currentState = "lima"
    self:playAnimation()

    self:setCollideRect(0, 0, 128, 128)
    self:setTag(TAGS.Planet)
    self:setZIndex(Z_INDEXES.Planet)
    self:setCenter(0, 0)

    inOrbit = false


    self.fields = entity.fields
    self.planetX = self.fields.xPos + 32
    self.planetY = self.fields.yPos + 32
    self.staticX = self.planetX
    self.staticY = self.planetY

    self.planetName = self.fields.planetName
    location = "Space"
    self:moveTo(self.planetX, self.planetY)
    self:add()
    
    if self.planetName == "Lima" then
        self:changeState("lima")
    elseif self.planetName == "Laven" then
        self:changeState("laven")
    elseif self.planetName == "Garliel" then
        self:changeState("garliel")
    elseif self.planetName == "Mushroo" then
        self:changeState("mushroo")
    else
        self:changeState("lima")  
    end  

    limaText = false
    lavenX = 0
    lavenY = 0
    limaX = 0
    limaY = 0
    garlielX = 0
    garlielY = 0
    mushrooX = 0
    mushrooY = 0
end

function Planet:update()
    self:updateAnimation()
    sightLine = pd.geometry.distanceToPoint(self.staticX - 64, self.staticY - 64, newX, newY)
    if sightLine <= 100 then
        inOrbit = true
    else
        inOrbit = false
        showBtn = false
        location = "Space"
    end

    if self.fields.planetName == "Laven" then
        lavenX = self.staticX - 128
        lavenY = self.staticY - 64
    elseif self.fields.planetName == "Lima" then
        limaX = self.staticX - 128
        limaY = self.staticY - 64
    elseif self.fields.planetName == "Garliel" then
        garlielX = self.staticX - 128
        garlielY = self.staticY - 64
    elseif self.fields.planetName == "Mushroo" then
        mushrooX = self.staticX - 128
        mushrooY = self.staticY - 64
    end


    limaLine = pd.geometry.distanceToPoint(limaX, limaY, newX, newY)
    if limaLine <= 200 then
        limaText = true
    else
        limaText = false
    end


    lavenLine = pd.geometry.distanceToPoint(lavenX, lavenY, newX, newY)
    if lavenLine <= 200 then
        lavenText = true
    else
        lavenText = false
    end

    garlielLine = pd.geometry.distanceToPoint(garlielX, garlielY, newX, newY)
    if garlielLine <= 200 then
        garlielText = true
    else
        garlielText = false
    end

    mushrooLine = pd.geometry.distanceToPoint(mushrooX, mushrooY, newX, newY)
    if mushrooLine <= 200 then
        mushrooText = true
    else
        mushrooText = false
    end
    -- if inOrbit == true then
    --     minSpeed = -1
    --     maxSpeed = 1
    --     if shipSpeed > 1 then
    --         shipSpeed = 1
    --     end
    --     if shipSpeed < -1 then
    --         shipSpeed = 1
    --     end
    -- elseif inOrbit == false then
    --     maxSpeed = 4
    --     minSpeed = -4
    -- end
end

function Planet:collisionResponse(other)
    return "overlap"
end
