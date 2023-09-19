-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"

-- Game
import "scripts/player"
import "scripts/gameScene"
import "scripts/ability"
import "scripts/spike"
import "scripts/spikeball"
import "scripts/camera"
import "scripts/door"
import "scripts/movingplatform"
import "scripts/pdDialogue"
-- import "scripts/menu"

-- import "scripts/hud"

local pd <const> = playdate
local gfx <const> = playdate.graphics
font1 = gfx.font.new("assets/fonts/Moonwalker")
font2 = gfx.font.new("assets/fonts/Krull")
font3 = gfx.font.new("assets/fonts/Moonwalker")
GameScene()

-- Menu()
pdDialogue.setup({
    font = font1,

    onClose = function()
        directionText = "✛"
    end
})
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pdDialogue.update()
    HUD()
end

function HUD()
    gfx.setColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font1)
    gfx.drawText("Keys: " .. _G.keyTotal, 2, 2)
    if _G.AlphaKey == true then
        gfx.drawText("A", 2, 15)
    end
    if _G.BetaKey == true then
        gfx.drawText("B", 17, 15)
    end
    if _G.SigmaKey == true then
        gfx.drawText("S", 33, 15)
    end
    if _G.GammaKey == true then
        gfx.drawText("G", 48, 15)
    end
end
