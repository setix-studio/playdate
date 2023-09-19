local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ability').extends(AnimatedSprite)

function Ability:init(x, y, entity)
    self.fields = entity.fields
    if self.fields.pickedUp then
        return
    end

    self.abilityName = self.fields.ability

    if self.abilityName == "DoubleJump" then
        imagetable = gfx.imagetable.new("images/DoubleJump-table-16-16")
    elseif self.abilityName == "Dash" then
        imagetable = gfx.imagetable.new("images/Dash-table-16-16")
    elseif self.abilityName == "Key" then
        imagetable = gfx.imagetable.new("images/Key-table-16-16")
    elseif self.abilityName == "PlatformSwitch" then
        imagetable = gfx.imagetable.new("images/switchoff-table-16-16")
    else
        imagetable = gfx.imagetable.new("images/interactUp-table-16-16")
    end
    Ability.super.init(self, imagetable)
    self:addState("idle", 1, 4, { tickStep = math.random(6, 8) })
    self.currentState = "idle"
    self.platformOn = false
    self:setImage(image)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:playAnimation()


    self:setZIndex(Z_INDEXES.Pickup)
    self:setTag(TAGS.Pickup)
    self:setCollideRect(2, 2, 10, 12)
    self:interactable()

    _G.keyType = self.fields.KeyType
    if self.fields.Hidden == true then
        self:setZIndex(-900)
    end
end

function Ability:update()
    self:updateAnimation()
end

function Ability:interactable()
    if self.abilityName == "TextBox" then
        self:setCenter(0, 0)
        self:moveTo(self.x, self.y - 15)
        self:setCollideRect(0, 20, 12, 12)
        self:add()
    end
end

function Ability:pickUp(player)
    if self.abilityName == "DoubleJump" then
        player.doubleJumpAbility = true
        self.fields.pickedUp = true
        pdDialogue.say("GOT DOUBLE JUMP! NOW YOU CAN GET THE KEY!",
            { width = 260, height = 40, x = 70, y = 190, padding = 10 })
        self:remove()
    elseif self.abilityName == "Dash" then
        player.dashAbility = true
        self.fields.pickedUp = true
        pdDialogue.say("GOT DASH! NOW YOU MOVE FAST FOR SHORT SPRINTS!",
            { width = 260, height = 40, x = 70, y = 190, padding = 10 })
        self:remove()
    elseif self.abilityName == "Key" then
        player.hasKey = true
        _G.keyTotal += 1
        _G.keyType = self.fields.KeyType
        self.fields.pickedUp = true
        if _G.keyType == "Alpha" then
            player.hasAlphaKey = true
            _G.AlphaKey = true
            print("got Alpha key")
        elseif _G.keyType == "Beta" then
            player.hasBetaKey = true
            _G.BetaKey = true
            print("got Beta key")
        elseif _G.keyType == "Sigma" then
            player.hasSigmaKey = true
            _G.SigmaKey = true
        elseif _G.keyType == "Gamma" then
            player.hasGammaKey = true
            _G.GammaKey = true
        end
        self:remove()
    end

    if self.abilityName == "TextBox" then
        if pd.buttonIsPressed(pd.kButtonUp) then
            pdDialogue.say(self.fields.Copy,
                { width = 260, height = 40, x = 70, y = 190, padding = 10 })
        end
    end
    if self.abilityName == "PlatformSwitch" then
        if pd.buttonIsPressed(pd.kButtonUp) then
            if self.fields.platformOn == false then
                pdDialogue.say("Platform Activated!",
                    { width = 260, height = 40, x = 70, y = 190, padding = 10 })
                self.fields.platformOn = true
                self.platformOn = true
                self.imagetable = gfx.imagetable.new("images/switchon-table-16-16")
                if self.platformOn == true then
                    _G.isMoving = true
                end
            else
                pdDialogue.say("Platform Deactivated!",
                    { width = 260, height = 40, x = 70, y = 190, padding = 10 })
                self.fields.platformOn = false
                self.platformOn = false
                self.imagetable = gfx.imagetable.new("images/switchoff-table-16-16")
                if self.platformOn == false then
                    _G.isMoving = false
                end
            end
        end
    end
end
