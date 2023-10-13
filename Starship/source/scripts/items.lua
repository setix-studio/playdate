local pd <const> = playdate
local gfx <const> = pd.graphics

class('Items').extends(AnimatedSprite)

function Items:init(x, y, entity)
    self.fields = entity.fields
    if self.fields.pickedUp then
        return
    end

    self.itemName = self.fields.item

    if self.itemName == "KebuMeat" then
        imagetable = gfx.imagetable.new("images/DoubleJump-table-16-16")
    elseif self.itemName == "Beans" then
        imagetable = gfx.imagetable.new("images/Dash-table-16-16")
    elseif self.itemName == "Key" then
        imagetable = gfx.imagetable.new("images/Key-table-16-16")
    elseif self.itemName == "PlatformSwitch" then
        imagetable = gfx.imagetable.new("images/switchoff-table-16-16")
    else
        imagetable = gfx.imagetable.new("images/interactUp-table-16-16")
    end
    Items.super.init(self, imagetable)
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

function Items:update()
    self:updateAnimation()
end

function Items:interactable()
    if self.itemName == "TextBox" then
        self:setCenter(0, 0)
        self:moveTo(self.x, self.y - 15)
        self:setCollideRect(0, 20, 12, 12)
        self:add()
    end
end

function Items:pickUp(chef)
    if self.itemName == "KebuMeat" then
        for i in pairs(items) do
            if items[i]["ID"] == "Kebu Meat" then
                items[i]["found"] = true
                items[i]["name"] = "Kebu Meat"
                items[i]["quantity"] = items[i]["quantity"] + 1
            end
        end
        self.fields.pickedUp = true
        self:remove()
    elseif self.itemName == "Beans" then
        for i in pairs(items) do
            if items[i]["ID"] == "Beans" then
                items[i]["found"] = true
                items[i]["name"] = "Beans"
                items[i]["quantity"] = items[i]["quantity"] + 1
            end
        end
        self.fields.pickedUp = true
        self:remove()
    elseif self.itemName == "Key" then
        chef.hasKey = true
        _G.keyTotal += 1
        _G.keyType = self.fields.KeyType
        self.fields.pickedUp = true
        if _G.keyType == "Alpha" then
            chef.hasAlphaKey = true
            _G.AlphaKey = true
            print("got Alpha key")
        elseif _G.keyType == "Beta" then
            chef.hasBetaKey = true
            _G.BetaKey = true
            print("got Beta key")
        elseif _G.keyType == "Sigma" then
            chef.hasSigmaKey = true
            _G.SigmaKey = true
        elseif _G.keyType == "Gamma" then
            chef.hasGammaKey = true
            _G.GammaKey = true
        end
        self:remove()
    end

    if self.itemName == "TextBox" then
        if pd.buttonIsPressed(pd.kButtonUp) then
            pdDialogue.say(self.fields.Copy,
                { width = 260, height = 40, x = 70, y = 190, padding = 10 })
        end
    end
end

--inventory

items = {
    { ["category"] = "food", ["found"] = true,  ["name"] = "Salt",         ["ID"] = "Salt",         ["quantity"] = 5 },
    { ["category"] = "food", ["found"] = false, ["name"] = "Beans",        ["ID"] = "Beans",        ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Hot Spices",   ["ID"] = "Hot Spices",   ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Tangy Spices", ["ID"] = "Tangy Spices", ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Kebu Meat",    ["ID"] = "Kebu Meat",    ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Tortilla",     ["ID"] = "Tortilla",     ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Flying Fish",  ["ID"] = "Flying Fish",  ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Cheese",       ["ID"] = "Cheese",       ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Lime",         ["ID"] = "Lime",         ["quantity"] = 0 },
    { ["category"] = "food", ["found"] = true,  ["name"] = "Tortilla",     ["ID"] = "Tortilla",     ["quantity"] = 0 },

}
