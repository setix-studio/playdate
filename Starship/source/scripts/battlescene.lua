local pd <const> = playdate
local gfx <const> = playdate.graphics

class('BattleScene').extends(Room)

function BattleScene:enter()
    gfx.sprite.removeAll()

    gfx.setDrawOffset(0, 0)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    BattleSceneImage()
    playerTurn = true
    battlecopy = ""
    -- BattleVisual()
    -- PlayerBattleImage()
    EnemyBattleImage()
    battleTrack = math.random(1, 5)
    battlemusic = pd.sound.fileplayer.new('assets/sounds/battle_' .. battleTrack .. '')
    battlemusic:play(0)
    battlemusic:setVolume(.5)

    battlemusicend = pd.sound.fileplayer.new('assets/sounds/battleend')

    playerhit = pd.sound.fileplayer.new('assets/sounds/playermelee')

    enemyInit()

    enemyType = "Gather"


    enemyMaxHP = enemyHP

    if enemyType == "Creature" then
        actionType = "Attack"
    elseif enemyType == "Gather" then
        actionType = "Attack"
    end
    battleoptions = { tostring(actionType), "Item", "Wait", "Run" }
    itemoptions = { "Heal" }
    options = battleoptions



    battlecopyRun = false
    totalDamage = 0
    itemAdded = false
    print(enemyHP)
end

function BattleScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorWhite)

    PlayerRound()
    EnemyRound()
    textbox.currentText = battlecopy
    textbox:add()
    if enemyHP > 0 then
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(265, 10, 105, 110)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRect(266, 11, 103, 108)
        gfx.drawRect(362, 11, 7, 108)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(362, 11, 7, 108)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)

        gfx.setFont(fontHud)
        --player healthbar
        gfx.drawRect(275, 78, 74, 9)
        gfx.drawRect(348, 78, 6, 9)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(348, 78, 6, 9)
        gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(277, 80, 70, 5)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(277, 80, playerHP / playerMaxHP * 70, 5)
        gfx.drawTextAligned("Cosmo", 275, 65, kTextAlignment.left)

        --player level bar
        gfx.drawRect(275, 86, 54, 7)
        gfx.drawRect(328, 86, 5, 7)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(328, 86, 5, 7)
        gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(277, 88, 50, 3)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(277, 88, playerXP / playerNextLevel * 50, 3)
        gfx.drawTextAligned("lv " .. playerLevel, 348, 65, kTextAlignment.right)

        --enemy healthbar
        gfx.drawRect(275, 38, 74, 9)
        gfx.drawRect(348, 38, 6, 9)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(348, 38, 6, 9)
        gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(277, 40, 70, 5)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(277, 40, enemyHP / enemyMaxHP * 70, 5)
        gfx.drawTextAligned(enemyName, 275, 25, kTextAlignment.left)
        -- gfx.drawTextAligned(playerLevel, 15, 25, kTextAlignment.left)
        -- gfx.drawTextAligned(playerXP, 15, 45, kTextAlignment.left)
        -- gfx.drawTextAligned(playerNextLevel, 15, 65, kTextAlignment.left)
    end

    if playerHP <= 0 then
        playerHP = 0
        exitBattle()
    end
end

playerBattleMenu = pd.ui.gridview.new(90, 20)

class('BattleVisual').extends(gfx.sprite)

function BattleVisual:init()
    local battleImage = gfx.image.new("assets/images/battlemask")

    self.x = 200
    self.y = -7
    self:moveTo(self.x, self.y)


    self:setImage(battleImage)
    self:setZIndex(-5)
    self:setCenter(0, 0)
    self:add()
end

function BattleVisual:update()

end

class('BattleSceneImage').extends(gfx.sprite)
function BattleSceneImage:init()
    local bgImage = gfx.image.new("assets/images/testbattle")
    self.speed = .25
    self.x = 0
    self.y = 0
    self:moveTo(self.x, self.y)


    self:setImage(bgImage)
    self:setZIndex(-10)
    self:setCenter(0, 0)
    self:add()
end

function BattleSceneImage:update()
    self.x -= self.speed

    if enemyAttack == true then
        self:setScale(math.random(1, 2))
    else
        self:setScale(1)
    end
    if self.x <= -16 then
        self.x = 0
    end

    self:moveTo(self.x, self.y)
end

--Top Section

class('PlayerBattleImage').extends(AnimatedSprite)

function PlayerBattleImage:init()
    playerBattleImageTable = gfx.imagetable.new("assets/images/playerbattle-table-200-120")

    -- State Machine

    PlayerBattleImage.super.init(self, playerBattleImageTable)

    self:addState("idle", 1, 4, { tickStep = 6 })
    self:addState("moving", 1, 1, { tickStep = 2 })

    self.currentState = "idle"
    self:playAnimation()
    self:setZIndex(900)
    self.speed = 5
    self.x = 80
    self.y = 0
    self:moveTo(self.x, self.y)
    self:setCenter(0, 0)
    print(enemyName)
end

function PlayerBattleImage:update()
    self:updateAnimation()
    self.x += self.speed

    if self.x >= 210 then
        self.x = 210
    end

    self:moveTo(self.x, self.y)
end

class('EnemyBattleImage').extends(AnimatedSprite)

function EnemyBattleImage:init()
    enemyBattleImageTable = gfx.imagetable.new("assets/images/enemies-table-200-120")

    -- State Machine

    EnemyBattleImage.super.init(self, enemyBattleImageTable)

    self:addState("Bush", 1, 4, { tickStep = 6 })
    self:addState("Meaty", 5, 8, { tickStep = 6 })
    self:addState("Brusselfly", 9, 12, { tickStep = 6 })
    self:addState("Timid Toma", 13, 16, { tickStep = 6 })
    self:addState("Cool Shroom", 17, 20, { tickStep = 6 })


    self.currentState = enemyName
    self:playAnimation()
    self:setZIndex(-4)

    self.speed = 5
    self.x = 200
    self.y = 0
    self:moveTo(self.x, self.y)
    self:setCenter(0, 0)
end

function EnemyBattleImage:update()
    self:updateAnimation()
    if enemyHP >= 1 then
        self.x -= self.speed
        if self.x <= 40 then
            self.x = 40
        end
    end
    if enemyHP <= 0 then
        self.x -= 10
        if self.x <= -240 then
            self:remove()
        end
    end
    self.currentState = enemyName
    self:moveTo(self.x, self.y)
end

-- Bottom Section+



textbox = gfx.sprite.new()
textbox:setSize(400, 88)
textbox:moveTo(0, 136)
textbox:setCenter(0, 0)
textbox:setZIndex(900)
gfx.setFont(font2)

textbox.text = ""       -- this is blank for now; we can set it at any point
textbox.currentChar = 1 -- we'll use these for the animation
textbox.currentText = ""
textbox.typing = true


-- this function will calculate the string to be used.
-- it won't actually draw it; the following draw() function will.
function textbox:update()
    self.currentChar = self.currentChar + 1
    if self.currentChar > #self.text then
        self.currentChar = #self.text
    end

    if self.typing and self.currentChar <= #self.text then
        textbox.currentText = string.sub(self.text, 1, self.currentChar)
        self:markDirty() -- this tells the sprite that it needs to redraw
    end

    -- end typing
    if self.currentChar == #self.text then
        self.currentChar = 1
        self.typing = false
    end
end

-- this function defines how this sprite is drawn
function textbox:draw()
    -- pushing context means, limit all the drawing config to JUST this block
    -- that way, the colors we set etc. won't be stuck
    gfx.pushContext()
    -- border

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 88)

    -- draw the box				

    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 1, 400, 86)




    -- draw the text!
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    gfx.drawTextInRect(self.currentText, 10, 10, 250, 160)


    gfx.popContext()
end

function PlayerRound()
    playerAttacked = false
    if playerTurn == true then
        gfx.setFont(font2)



        playerBattleMenu:drawInRect(265, 130, 105, 100)

        playerBattleMenu:setNumberOfRows(#options)
        playerBattleMenu:setCellPadding(2, 2, 2, 2)

        playerBattleMenu.backgroundImage = gfx.nineSlice.new("assets/images/gridBackground", 6, 6, 18, 18)
        playerBattleMenu:setContentInset(2, 2, 2, 2)


        function playerBattleMenu:drawCell(section, row, column, selected, x, y, width, height)
            if selected then
                gfx.setColor(gfx.kColorBlack)

                gfx.fillRoundRect(x, y, width, height, 2)
                gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
                gfx.setImageDrawMode(gfx.kDrawModeNXOR)
            else
                gfx.setImageDrawMode(gfx.kDrawModeNXOR)
            end


            local fontHeight = gfx.getSystemFont():getHeight()
            gfx.drawTextInRect(options[row], x, y + (height / 2 - fontHeight / 2) + 3, width, height, nil, nil,
                kTextAlignment.center)
        end

        if pd.buttonJustPressed(pd.kButtonUp) then
            playerBattleMenu:selectPreviousRow(true)
        elseif pd.buttonJustPressed(pd.kButtonDown) then
            playerBattleMenu:selectNextRow(true)
        end
        if options == itemoptions then
            if pd.buttonJustPressed(pd.kButtonB) then
                options = battleoptions
            end
        end
        if enemyHP > 0 then
            if playerBattleMenu:getSelectedRow() == 1 then
                if options == battleoptions then
                    if enemyType == "Creature" then
                        battlecopy = "Attack the enemy."
                    elseif enemyType == "Gather" then
                        battlecopy = "Gather ingredients."
                    end
                elseif options == itemoptions then
                    battlecopy = "Recover a small amount of HP"
                end
            elseif playerBattleMenu:getSelectedRow() == 2 then
                battlecopy = "Use an item."
            elseif playerBattleMenu:getSelectedRow() == 3 then
                battlecopy = "Wait it out."
            elseif playerBattleMenu:getSelectedRow() == 4 then
                if battlecopyRun == true then
                    battlecopy = "Ran away, but lost any items you gathered."
                else
                    battlecopy = "Run away, leaving any items gathered."
                end
            end
        else

        end
        if pd.buttonJustReleased(pd.kButtonA) then
            if playerBattleMenu:getSelectedRow() == 1 then
                if options == battleoptions then
                    if enemyHP > 0 then
                        playerDamage = math.random(math.random(0, 1 + (math.ceil(playerLevel / 2))),
                            math.random(2 + (math.ceil(playerLevel / 2)), 5 + (math.ceil(playerLevel / 2))))
                        enemyHP = enemyHP - playerDamage

                        if playerDamage > 0 then
                            playerhit:play(1)
                            if playerDamage > 1 then
                                battlecopy = "You picked " .. playerDamage .. " " .. enemyItem .. "!"
                            else
                                battlecopy = "You picked 1 " .. enemyItem .. "!"
                            end
                            totalDamage = totalDamage + playerDamage
                            if totalDamage > enemyMaxHP then
                                totalDamage = enemyMaxHP
                            end
                        else
                            battlecopy = "You miss!"
                        end
                        playerAttacked = true
                    end
                elseif options == itemoptions then
                    if playerHP >= playerMaxHP then
                        playerHP = playerMaxHP
                        battlecopy = "Full  Health!"
                    else
                        playerHP = playerHP + 5
                        playerheal:play(1)
                        playerAttacked = true
                    end
                end



                if playerAttacked == true then
                    playerEndTimer()
                    if enemyHP > 0 then
                        enemyStartTimer()
                    else
                        battleEndTimer()
                    end
                end
            elseif playerBattleMenu:getSelectedRow() == 2 then
                if options == battleoptions then
                    playerBattleMenu:selectPreviousRow(true)
                    options = itemoptions
                end
            elseif playerBattleMenu:getSelectedRow() == 3 then
                enemyTurn = true

                enemyAttacked = false
            elseif playerBattleMenu:getSelectedRow() == 4 then
                battlecopyRun = true
                runEndTimer()
            end
        end



        local crankTicks = pd.getCrankTicks(2)
        if crankTicks == 1 then
            playerBattleMenu:selectNextColumn(true)
        elseif crankTicks == -1 then
            playerBattleMenu:selectPreviousColumn(true)
        end
    end
end

function EnemyRound()
    if enemyTurn == true then

    end
end

function enemyStartTimer()
    playerTurn = false
    options = battleoptions

    local randomTime = math.random(1000, 2000)
    enemyStart = pd.timer.performAfterDelay(randomTime, function()
        battlecopy = "The " ..
            enemyName .. enemyStartCopy
        enemyThinkTimer()
    end)
end

function enemyThinkTimer()
    local randomTime = math.random(1000, 2000)
    enemyThinkStart = pd.timer.performAfterDelay(randomTime, function()
        battlecopy = "The " ..
            enemyName .. enemyThinkCopy
        enemyAttackTimer()
    end)
end

function enemyAttackTimer()
    local randomTime = math.random(1000, 2000)
    enemyAttackStart = pd.timer.performAfterDelay(randomTime, function()
        if enemyAttacked == false then
            enemyChance = math.random(0, 100)

            if enemyChance >= enemyAttackChance then
                battlecopy = "The " ..
                    enemyName .. " attacks!"
                    playerhit:play(1)

                playerHP = playerHP - 3
            end
            enemyAttacked = true
        end
        if enemyAttacked == true then
            battlecopyRun = true

            enemyEndTimer()
        end
    end)
end

function enemyEndTimer()
    local randomTime = math.random(1000, 2000)
    enemyEnd = pd.timer.performAfterDelay(randomTime, function()
        enemyTurn = false
        enemyAttack = false
        enemyAttacked = false
        startMessage = false
        playerTurn = true
        playerAttacked = false
    end)
end

function playerEndTimer()
    playerEnd = pd.timer.performAfterDelay(1000, function()
        playerTurn = false

        enemyAttacked = false

        enemyTurn = true
    end)
end

function battleEndTimer()
    if levelNum == 0 then
        gfx.setBackgroundColor(playdate.graphics.kColorBlack)
    end
    battlemusic:stop()
    battlemusicend:play(1)
    playerXP = playerXP + enemyMaxHP * 8
    if playerNextLevel - playerXP <= 0 then
        battlecopy = "Level up! You are now level " ..
            playerLevel + 1 ..
            "!\nThe " ..
            enemyName .. " has been defeated! You picked a total of " .. totalDamage .. " " .. enemyItem .. "!"
    else
        battlecopy = "The " ..
            enemyName .. " has been defeated! You picked a total of " .. totalDamage .. " " .. enemyItem .. "!"
    end

    if itemAdded == false then
        itemQty = enemyMaxHP
        if itemQty > enemyMaxHP then
            itemQty = enemyMaxHP
        end
        Items:addItem(enemyItem, itemQty)
        itemAdded = true
    end

    battleTimerEndStart = pd.timer.performAfterDelay(3500, function()
        exitBattle()
    end)
end

function runEndTimer()
    if levelNum == 0 then
        gfx.setBackgroundColor(playdate.graphics.kColorBlack)
    end
    battlemusic:stop()
    battlecopy = "Ran away, but lost the items you gathered."


    battleTimerEndStart = pd.timer.performAfterDelay(3500, function()
        exitBattle()
    end)
end

function exitBattle()
    battlemusic:stop()

    if levelNum == 0 then
        gfx.setBackgroundColor(playdate.graphics.kColorBlack)
    end

    limamusic:setVolume(0.5)
    lavenmusic:setVolume(0.5)
    spacemusic:setVolume(0.5)


    gfx.setImageDrawMode(gfx.kDrawModeCopy)


    paused = false


    cosmoX = returnX
    cosmoY = returnY
    roomNumber = returnRoomNumber
    manager:push(levelScene)
end

-- enemies
function enemyInit()
    if enemyName == "Meaty" then
        enemyType = "Gather"
        enemyHP = math.random(8, 10)
        enemyAttackChance = math.random(30,50)
        enemyStartCopy = " narrows its gaze."
        enemyThinkCopy = " is wobbling carelessly."
    elseif enemyName == "Bush" then
        enemyType = "Gather"
        enemyHP = math.random(6, 10)
        enemyAttackChance = math.random(40,60)
        enemyStartCopy = " readies its stance."
        enemyThinkCopy = " is rustling cautiously."
    elseif enemyName == "Timid Toma" then
        enemyType = "Gather"
        enemyHP = math.random(4, 6)
        enemyAttackChance = math.random(30,60)
        enemyStartCopy = " shakes in suspicion."
        enemyThinkCopy = " hopes nothing happens."
    elseif enemyName == "Brusselfly" then
        enemyType = "Gather"
        enemyHP = math.random(7, 9)
        enemyAttackChance = math.random(30,60)
        enemyStartCopy = " flutters around."
        enemyThinkCopy = " strategizes its plan."
    elseif enemyName == "Cool Shroom" then
        enemyType = "Gather"
        enemyHP = math.random(4, 6)
        enemyAttackChance = math.random(40,60)
        enemyStartCopy = " narrows its gaze."
        enemyThinkCopy = " is wobbling carelessly."
    end
end
