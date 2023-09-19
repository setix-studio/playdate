local pd <const> = playdate
local gfx <const> = playdate.graphics


TAGS = {
    Pickup = 1,
    Player = 2,
    Enemy = 3,
    Building = 4,
    Textbox = 5,
}

Z_INDEXES = {
    BG = -100,
    BGProp = 0,
    Enemy = 20,
    Pickup = 50,
    Player = 100,
    Building = 200,
    Textbox = 900
}



class('GameScene').extends(AnimatedSprite)

function GameScene:init()
    self.spawnX = 200
    self.spawnY = 180
    self:setZIndex(-100)
    self.player = Player(self.spawnX, self.spawnY, self)
    _G.score = 0
    _G.angle = 0
    Building()
    
end

function GameScene:countdownTimer()
    self.cdtimer:start()
end

function GameScene:resetPlayer()
    self.player:moveTo(self.spawnX, self.spawnY)
end

function GameScene:update()
  
	
end
