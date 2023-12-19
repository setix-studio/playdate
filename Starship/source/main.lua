-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/nineslice"
import "CoreLibs/animation"


-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"

--scripts

import "scripts/items"


import "scripts/PauseScene"

import "scripts/HomeScene"
import "scripts/loading"
import "scripts/intro"
import "scripts/battlescene"

import "scripts/player"
import "scripts/Lima"
import "scripts/laven"
import "scripts/gameScene"
import "scripts/enemy"
import "scripts/enemySpawner"
import "scripts/cosmo"
import "scripts/saveLoadData"
import "scripts/planet"
import "scripts/building"
import "scripts/pdDialogue"
import "scripts/underscore"
import "scripts/pdParticles"
import "scripts/ship"
import "scripts/insideShip"
import "scripts/gameOverScene"
import "scripts/objects"

import "scripts/sceneManager"

__ = Underscore:new() -- double underscore
local pd <const> = playdate
local gfx <const> = playdate.graphics
font1 = gfx.font.new("font/Nontendo-Light")
font2 = gfx.font.new("font/Nontendo-Bold")
font2:setLeading(3)
font2:setTracking(2)
fontHud = gfx.font.new("font/Nontendo-Bold")


manager = Manager()
manager:hook()
manager:enter(IntroScene())


--audio
spacemusic = pd.sound.fileplayer.new('assets/sounds/space2')
limamusic = pd.sound.fileplayer.new('assets/sounds/lima')
lavenmusic = pd.sound.fileplayer.new('assets/sounds/laven')
battlestartmusic = pd.sound.fileplayer.new('assets/sounds/battleintrosound')


textbg = gfx.nineSlice.new("assets/images/textBackground", 7, 7, 18, 18)


pdDialogue.setup({
    font = font2,

    onClose = function()
        directionText = "✛"
    end
})
-- loadGameData()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()

    pdDialogue.update()
    --playdate.drawFPS(0, 0) -- FPS widget
    manager:emit('update')
end

local sysMenu = playdate.getSystemMenu()

local menuItem, error = sysMenu:addMenuItem("Save Data", function()
    saveData = true
    saveGameData()
end)

local menuItem, error = sysMenu:addMenuItem("Clear Data", function()
    saveData = false
    pd.datastore.delete(data)
end)
