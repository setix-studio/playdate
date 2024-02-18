local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk

class('LoadingScene').extends(Room)

function LoadingScene:init()
    gfx.sprite.removeAll()

    if levelNum == nil then
        levelNum = 0
    end
    if levelNum == 0 then
        ldtk_file = "levels/world.ldtk"
        use_ldtk_fastloading = true
        levelScene = GameScene()
    elseif levelNum == 1 then
        use_ldtk_fastloading = true
        ldtk_file = "levels/world_lima.ldtk"
        levelScene = Lima()
        levelName = "Level_1"
    elseif levelNum == 2 then
        ldtk_file = "levels/planet_laven.ldtk"
        use_ldtk_fastloading = true
        levelScene = Laven()
    elseif levelNum == 5 then
        ldtk_file = "levels/ship.ldtk"
        use_ldtk_fastloading = true
        levelScene = InteriorShip()
    elseif levelNum == 6 then
        ldtk_file = "levels/interiors.ldtk"
        use_ldtk_fastloading = true
        levelScene = InteriorBuildings()
    elseif levelNum == 7 then
        ldtk_file = "levels/ship.ldtk"
        use_ldtk_fastloading = true
        levelScene = CampfireScene()
    end


    changeTimer = pd.timer.performAfterDelay(000, function()
        if not use_ldtk_fastloading then
            LDtk.load(ldtk_file)

            -- To speed up loading times, you can export you levels as lua files and load them precompiled
        else
            if playdate.isSimulator then
                -- In the simulator, we load the ldtk file and export the levels as lua files
                -- You need to copy the lua files in your project
                LDtk.load(ldtk_file)
                LDtk.export_to_lua_files()
            else
                -- On device, we tell the library to load using the lua files
                LDtk.load(ldtk_file, use_ldtk_fastloading)
            end
        end
        manager:enter(levelScene)
    end)
end

function LoadingScene:update()
    -- gfx.setColor(gfx.kColorBlack)
    -- gfx.fillRect(0, 0, 400, 240)
    -- gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    -- width = 400
    -- gfx.setFont(font2)


    --gfx.drawTextAligned("Loading", width / 2, 60, kTextAlignment.center)
end

class('ShipLand').extends(AnimatedSprite)

function ShipLand:init(x, y)
    local shipImageTable = gfx.imagetable.new("assets/images/shipland-table-400-240")
    Ship.super.init(self, shipImageTable)
    self:addState("idle", 1, 13, { tickStep = 12 })
    self.currentState = "idle"
    self:setZIndex(1000)

    self:moveTo(newX, newY)
    self:setCenter(0, 0)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Ship)
end

function ShipLand:update()
    self:updateAnimation()
    shipTimer = pd.timer.performAfterDelay(3000, function()
        self:remove()
    end)
end
