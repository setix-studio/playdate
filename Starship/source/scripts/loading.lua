local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk

class('LoadingScene').extends(Room)

function LoadingScene:init()
    ShipTakeoff()
    gfx.sprite.removeAll()
    if levelNum == nil then
        levelNum = 0
    end
    if levelNum == 0 then
        ldtk.load("levels/world.ldtk")
        levelScene = GameScene()
    elseif levelNum == 1 then
        ldtk.load("levels/planet_lima.ldtk")
        levelScene = Lima()
    elseif levelNum == 2 then
        ldtk.load("levels/planet_laven.ldtk")
        levelScene = Laven()
    end
   
    shipTimer = pd.timer.performAfterDelay(500, function()
        
        manager:enter(levelScene)
    end)
end

function LoadingScene:update()
    -- gfx.setColor(gfx.kColorBlack)
    -- gfx.fillRect(0, 0, 400, 240)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    width = 400
    gfx.setFont(font2)

    --gfx.drawTextAligned("Loading", width / 2, 60, kTextAlignment.center)
end

class('ShipTakeoff').extends(AnimatedSprite)

function ShipTakeoff:init(x, y)
    local shipImageTable = gfx.imagetable.new("assets/images/shiptakeoff-table-400-240")
    Ship.super.init(self, shipImageTable)
    self:addState("idle", 1, 15, { tickStep = 8 })
    self.currentState = "idle"
    self:setZIndex(Z_INDEXES.Textbox)


    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Ship)
end

function ShipTakeoff:update()
    self:updateAnimation()
end
