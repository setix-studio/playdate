local pd <const> = playdate
local gfx <const> = playdate.graphics

-- IMPORT:
-- Panels is included as a submodule in this repo
-- if you don't see any files in libraries/panels
-- you may need to initialize the submodule
import "libraries/panels/Panels"

-- SETTINGS:
-- change any settings before calling `startCutscene()`
Panels.Settings.snapToPanels = false

-- CUTSCENE SEQUENCES:
-- look in the `cutscenes` folder for the data files
import "cutscenes/1-simple-comic.lua"
import "cutscenes/2-animation.lua"
import "cutscenes/3-image-transitions.lua"
import "cutscenes/4-custom-functions.lua"
import "cutscenes/5-audio.lua"
import "cutscenes/6-branched-endings.lua"

class('Comic1Scene').extends(Room)
function Comic1Scene:init()
     cutsceneIsPlaying = false

      x = 100
      y = 100
      speed = 5
     
if currentLevel == nil then
    currentLevel = 1
else
    currentLevel = currentLevel
end


Panels.Settings.showMenuOnLaunch = false
end
function Comic1Scene:update()

     -- update the screen
     playdate.graphics.clear()
     playdate.graphics.drawText("*Level " .. currentLevel .. "*", 20, 10)
     playdate.graphics.drawText("Press A to complete level", 20, 210)
     playdate.graphics.drawRect(x, y, 10, 10)
 
     -- button input
     if (playdate.buttonIsPressed(playdate.kButtonUp)) then
         y = y - speed
     elseif playdate.buttonIsPressed(playdate.kButtonDown) then
         y = y + speed
     end
     if playdate.buttonIsPressed(playdate.kButtonRight) then
         x = x + speed
     elseif playdate.buttonIsPressed(playdate.kButtonLeft) then
         x = x - speed
     end
 
     -- press the A button to complete the level
     if playdate.buttonJustReleased(playdate.kButtonA) then
         startCutscene()
     end

    if cutsceneIsPlaying then
        Panels.update()
    else
        paused = false
    end
end

-- COMICDATA FOR CUTSCENES
-- these are the tables we'll send to Panels for the cutscenes
-- they contain sequences imported from the files above
 cutscene1Data = {
    scene1 -- single SEQUENCE
}

-- a list of all the cutscenes
 cutscenes = {
    cutscene1Data
}


-- -------------------------------
-- MAIN GAME
-- -------------------------------



-- FUNCTIONS

-- called when Panels finishes playing the current cutscene
function cutsceneDidFinish(target)

    if target then 
        -- Optional
        -- for sequences with multiple choice branching endings, 
        -- Panels will return the `target` of the chosen input
        print("User chose option: " .. target)
    end

    -- flip the flag OFF
    cutsceneIsPlaying = false
    limamusic:setVolume(0.5)
    lavenmusic:setVolume(0.5)
    spacemusic:setVolume(0.5)


    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    fromPop = true
    paused = false


    cosmoX = returnX
    cosmoY = returnY
    roomNumber = returnRoomNumber
    manager:push(LoadingScene())
    -- reapply inputHandlers for main game (if used)
    -- playdate.inputHandlers.push(gameInputHandlers)

    -- increment the level
    -- currentLevel = currentLevel + 1
    -- if currentLevel > #cutscenes then currentLevel = 1 end -- loop around to the first level
end

-- called when a level is completed
function startCutscene()
    -- flip the flag ON
    cutsceneIsPlaying = true
paused = true
    -- choose the cutscene data based on the current level
     cutsceneNum = currentLevel
     comicData = cutscenes[currentLevel]

    -- remove inputHandlers for the main game (if used)
    -- playdate.inputHandlers.pop()

    -- tell Panels to start the cutscene (with callback)
    Panels.startCutscene(comicData, cutsceneDidFinish)
end



-- button callbacks still get called when Panels is active
-- probably best to trap for `cutsceneIsPlaying` to prevent
-- unwanted side effects in your game
function playdate.downButtonDown()
    if not cutsceneIsPlaying then
        print("down")
    end
end

-- function playdate.cranked()
--     print("crank")
-- end






