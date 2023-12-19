local pd <const> = playdate
local gfx <const> = pd.graphics

class('Items').extends(AnimatedSprite)

function Items:init(x, y, entity)
    self.fields = entity.fields

    if self.fields.pickedUp then
        return
    end

    self.itemName = self.fields.item


    if self.itemName == "MeatyStalk" then
        itemChance = 50
        imagetable = gfx.imagetable.new("assets/images/meatstalk-table-16-16")
        self:setCollideRect(2, 2, 10, 12)

        self.enemyName = "Meaty"
    elseif self.itemName == "Berries" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/crema-table-32-32")
        self:setCollideRect(6, 11, 20, 10)

        self.enemyName = "Bush"
    elseif self.itemName == "Tomas" then
        itemChance = 70
        imagetable = gfx.imagetable.new("assets/images/tomas-table-16-16")
        self:setCollideRect(2, 2, 10, 12)

        self.enemyName = "Tilly Toma"
    else
        imagetable = gfx.imagetable.new("images/interactUp-table-16-16")
    end
    self.chance = math.random(0, 100)

    if itemChance == nil then
        itemChance = 50
    end
    if self.chance <= itemChance then
        self.fields.Hidden = true
    end
    Items.super.init(self, imagetable)
    self:addState("idle", 1, 4, { tickStep = math.random(6, 8) })
    self.currentState = "idle"

    self:setImage(image)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:playAnimation()

    textMove = 20

    self:setZIndex(Z_INDEXES.Pickup)
    self:setTag(TAGS.Pickup)
    self:interactable()

    _G.keyType = self.fields.KeyType
    if self.fields.Hidden == true then
        self:setZIndex(-900)
        self:remove()
    end



    hudItemTable = {}
end

function Items:update()
    self:updateAnimation()
    cosmoSortOrder(self)
end

function Items:interactable()
    if self.itemName == "TextBox" then
        self:setCenter(0, 0)
        self:moveTo(self.x, self.y - 20)
        self:setCollideRect(0, 20, 12, 12)
        self:add()
    end
end

function Items:hudItemText()
    textMove += 1

    gfx.drawTextAligned(itemName .. " + 1", cosmoX, cosmoY - textMove, kTextAlignment.center)
    if textMove == 40 then
        table.remove(hudItemTable, v)

        textMove = 20
    end
end

function Items:pickUp()
    limamusic:stop()
    lavenmusic:stop()
    paused = true
    BattleFadeImage()
    BattleTimer()
    enemyName = self.enemyName
    enemyItem = self.itemName
    self.fields.pickedUp = true

    self:remove()
end

function Items:addItem(enemyItem, itemQty)
    self.itemName = enemyItem


    if self.itemName == "MeatyStalk" then
        for i in pairs(items) do
            if items[i]["ID"] == "MEATY STALK" then
                items[i]["found"] = true
                items[i]["name"] = "MEATY STALK"
                items[i]["description"] = "Nice stalk of meat, probably beef."
                items[i]["quantity"] = items[i]["quantity"] + itemQty
                itemName = items[i]["name"]
            end
        end



        table.insert(hudItemTable, self)
    elseif self.itemName == "Berries" then
        for i in pairs(items) do
            if items[i]["ID"] == "Berries" then
                items[i]["found"] = true
                items[i]["name"] = "Berries"
                items[i]["description"] = "Sweet and Juicy"

                items[i]["quantity"] = items[i]["quantity"] + itemQty
                itemName = items[i]["name"]
            end
        end


        table.insert(hudItemTable, self)
    elseif self.itemName == "Tomas" then
        for i in pairs(items) do
            if items[i]["ID"] == "TOMAS" then
                items[i]["found"] = true
                items[i]["name"] = "TOMAS"
                items[i]["description"] = "ROUND, RED, and ROBUST FLAVOR. USED AS TOPPING"

                items[i]["quantity"] = items[i]["quantity"] + itemQty
                itemName = items[i]["name"]
            end
        end

        table.insert(hudItemTable, self)
    end
end

--inventory

items = {
    {
        ["category"] = "toppings",
        ["found"] = false,
        ["name"] = "Berries",
        ["ID"] = "Berries",
        ["description"] = "Sweet and juicy.",
        ["quantity"] = 0
    },
    {
        ["category"] = "spices",
        ["found"] = false,
        ["name"] = "HOT SPICES",
        ["ID"] = "HOT SPICES",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "spices",
        ["found"] = false,
        ["name"] = "TANGY SPICES",
        ["ID"] = "TANGY SPICES",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "meat",
        ["found"] = false,
        ["name"] = "MEATY STALK",
        ["ID"] = "MEATY STALK",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "meat",
        ["found"] = false,
        ["name"] = "SHROOMAS",
        ["ID"] = "SHROOMAS",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "meat",
        ["found"] = false,
        ["name"] = "FLYING FISH",
        ["ID"] = "FLYING FISH",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "toppings",
        ["found"] = false,
        ["name"] = "CHEESE",
        ["ID"] = "CHEESE",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "toppings",
        ["found"] = false,
        ["name"] = "LIME",
        ["ID"] = "LIME",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },
    {
        ["category"] = "toppings",
        ["found"] = false,
        ["name"] = "TOMAS",
        ["ID"] = "TOMAS",
        ["description"] = "SMALL, BULBOUS, BEEFY MORSLES. USED AS MEAT SUBSTITUTE.",
        ["quantity"] = 0
    },

}
