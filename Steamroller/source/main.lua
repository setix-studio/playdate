-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"


-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"

--scripts
import "scripts/HomeScene"
import "scripts/loading"
import "scripts/intro"


import "scripts/sceneManager"

import "scripts/saveLoadData"
import "scripts/screenShake"
screenShakeSprite = ScreenShake()

function setShakeAmount(amount)
    screenShakeSprite:setShakeAmount(amount)
end

import "scripts/gameScene"
import "scripts/player"
import "scripts/enemySpawner"
import "scripts/enemy"
local pd <const> = playdate
local gfx <const> = playdate.graphics
font1 = gfx.font.new("font/calistoga")
music = pd.sound.fileplayer.new('assets/sounds/mainsong')

manager = Manager()
manager:hook()
manager:enter(IntroScene())

loadGameData()
menuImage = gfx.image.new("assets/images/menu")
pd.setMenuImage(menuImage)
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    manager:emit('update')

    -- playdate.drawFPS(0, 220) -- FPS widget
end

local sysMenu = playdate.getSystemMenu()
local menuItem, error = sysMenu:addMenuItem("Reset Score", function()
    HIGH_SCORE = 0
end)
