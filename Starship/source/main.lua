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
import "scripts/recipes"


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
import "scripts/playout"
import "scripts/pdParticles"
import "scripts/ship"
import "scripts/insideShip"
import "scripts/gameOverScene"
import "scripts/objects"
import "scripts/NPC"
import "scripts/quests"
import "scripts/questScene"

import "scripts/sceneManager"


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
shipmusic = pd.sound.fileplayer.new('assets/sounds/shipmusic')
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



TAGS               = {
    Pickup = 1,
    Player = 5,
    Cosmo = 5,
    Prop = 6,
    Enemy = 3,
    Planet = 21,
    Collision = 5,
    Textbox = 10,
    Ship = 7,
    Building = 8,
    Shop = 9,
    Object = 11,
    Door = 12,
    DoorOpen = 13,
    NPC = 14
}

Z_INDEXES          = {
    BG = -100,
    Prop = 5,
    Enemy = 5,
    Pickup = 500,
    Player = 11,
    Steam = 800,
    Planet = 10,
    Ship = 10,
    Textbox = 900
}

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
