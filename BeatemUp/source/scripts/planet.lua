local pd <const> = playdate
local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry
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

    self.fields = entity.fields
    self.planetX = self.fields.xPos + 32
    self.planetY = self.fields.yPos + 32
    self.staticX = self.planetX
    self.staticY = self.planetY
    self.planetName = self.fields.planetName
    if self.planetName == "Lima" then
        planetImage = gfx.imagetable.new("assets/images/lima-table-128-128")
    elseif self.planetName == "Laven" then
        planetImage = gfx.imagetable.new("assets/images/laven-table-160-160")
    elseif self.planetName == "Garliel" then
        planetImage = gfx.imagetable.new("assets/images/garliel-table-288-288")
    elseif self.planetName == "Mushroo" then
        planetImage = gfx.imagetable.new("assets/images/mushroo-table-120-120")
    else
        planetImage = gfx.imagetable.new("assets/images/lima-table-128-128")
    end
    Planet.super.init(self, planetImage)

    self:addState("spin", 1, 50, { tickStep = 4 })



    self.currentState = "spin"
    self:playAnimation()

    self:setCollideRect(0, 0, self:getSize())

    self:setTag(TAGS.Planet)
    self:setZIndex(self.y)
    self:setCenter(0.5, 0.5)

    inOrbit = false




    location = "SPACE"
    self:moveTo(self.planetX, self.planetY)
    self:add()


    limaText = false
    lavenX = 0
    lavenY = 0
    limaX = 0
    limaY = 0
    garlielX = 0
    garlielY = 0
    mushrooX = 0
    mushrooY = 0

    playerVector = geo.vector2D.new(newX, newY)
    limaVector = geo.vector2D.new(limaX, limaY)
end

function Planet:update()
    self:updateAnimation()
    sightLine = pd.geometry.distanceToPoint(self.staticX - 64, self.staticY - 64, newX, newY)
    if sightLine <= 100 then
        inOrbit = true
    else
        inOrbit = false
        showBtn = false
        location = "SPACE"
    end


    lavenAngle = math.deg(math.atan2(lavenY - newY, lavenX - newX)) % 360

    limaAngle = math.deg(math.atan2(limaY - newY, limaX - newX)) % 360

    garlielAngle = math.deg(math.atan2(garlielY - newY, garlielX - newX)) % 360

    mushrooAngle = math.deg(math.atan2(mushrooY - newY, mushrooX - newX)) % 360


    if self.fields.planetName == "Laven" then
        lavenX = self.staticX - 260
        lavenY = self.staticY - 150
    elseif self.fields.planetName == "Lima" then
        limaX = self.staticX - 150
        limaY = self.staticY - 128
    elseif self.fields.planetName == "Garliel" then
        garlielX = self.staticX - 182
        garlielY = self.staticY - 128
    elseif self.fields.planetName == "Mushroo" then
        mushrooX = self.staticX - 182
        mushrooY = self.staticY - 128
    end


    limaLine = pd.geometry.distanceToPoint(limaX, limaY, newX, newY)
    if limaLine <= 400 then
        limaText = true
        limasightRadius = 300
        nearestPlanet = limaAngle
    else
        limasightRadius = 75
        limaText = false
    end


    lavenLine = pd.geometry.distanceToPoint(lavenX, lavenY, newX, newY)
    if lavenLine <= 400 then
        lavenText = true
        lavensightRadius = 300
        nearestPlanet = lavenAngle
    else
        lavensightRadius = 75
        lavenText = false
    end

    garlielLine = pd.geometry.distanceToPoint(garlielX, garlielY, newX, newY)
    if garlielLine <= 400 then
        garlielText = true
        garlielsightRadius = 300
        nearestPlanet = garlielAngle
    else
        garlielsightRadius = 75
        garlielText = false
    end

    mushrooLine = pd.geometry.distanceToPoint(mushrooX, mushrooY, newX, newY)
    if mushrooLine <= 400 then
        mushrooText = true
        mushroosightRadius = 300
        nearestPlanet = mushrooAngle
    else
        mushroosightRadius = 75
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
