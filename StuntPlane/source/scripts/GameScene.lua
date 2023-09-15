local pd <const> = playdate
local gfx <const> = playdate.graphics


TAGS = {
    Pickup = 1,
    Player = 2,
    Hazard = 3,
    Prop = 4,
    Textbox = 5,
}

Z_INDEXES = {
    BG = -100,
    BGProp = 0,
    Hazard = 20,
    Pickup = 50,
    Player = 100,
    Textbox = 900
}



class('GameScene').extends(AnimatedSprite)

function GameScene:init()
   
    self.spawnX = 50
    self.spawnY = 110
    self:setZIndex(-100)
    self.player = Player(self.spawnX, self.spawnY, self)
    if playdate.isCrankDocked then
        playdate.ui.crankIndicator:start()
    end
    SkyBG()
    Cloud()
    Cloud()
end

function GameScene:resetPlayer()
    self.player:moveTo(self.spawnX, self.spawnY)
end

function GameScene:update()


    playdate.ui.crankIndicator:update()
end

