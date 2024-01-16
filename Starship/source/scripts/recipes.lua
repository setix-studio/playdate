local pd <const> = playdate
local gfx <const> = pd.graphics

class('Recipes').extends(AnimatedSprite)

function Recipes:init(x, y, entity)
    for i in pairs(recipes) do
        if recipes[i]["ID"] == "MEATBALL SPECIAL" then
            recipeImagetable = gfx.imagetable.new("assets/images/meatstalk-table-16-16")
            self.itemPName = "Meatball Special"
        else
            recipeImagetable = gfx.imagetable.new("images/interactUp-table-16-16")
            self.itemPName = "Unknown"
        end
    end
    self.chance = math.random(0, 100)


    Recipes.super.init(self, recipeImagetable)
    self:addState("idle", 1, 4, { tickStep = math.random(6, 8) })
    self.currentState = "idle"

    self:setImage(image)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:playAnimation()
    for i in pairs(recipes) do
        if recipes[i]["found"] == true then
            recipes[i]["name"] = recipes[i]["name"]
            recipes[i]["description"] = recipes[i]["description"]
            recipes[i]["requiredItems"] = recipes[i]["requiredItems"]

        elseif recipes[i]["found"] == false then
            recipes[i]["name"] = "??????"
            recipes[i]["description"] = "??????"
            recipes[i]["requiredItems"] = "??????"
        end
    end

end

function Recipes:update()
    self:updateAnimation()
end

function Recipes:checkQuantity()
    for i in pairs(recipes) do
        itemName = recipes[i]["name"]
        totalItems = recipes[i]["quantity"]
    end
end

function Recipes:addRecipe(recipeItem)
    self.itemPName = recipeItem


    if self.itemPName == "Meatball Special" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "MEATBALL SPECIAL" then
                recipes[i]["found"] = true
                recipes[i]["name"] = "Meatball Special"
                recipes[i]["description"] = "Just like grandma used to make. Pasta in rich toma sauce with meatballs."
            end
        end

    elseif self.itemPName == "Grilled Fish" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "GRILLED FISH" then
                recipes[i]["found"] = true
                recipes[i]["name"] = "Grilled Fish"
                recipes[i]["description"] = "Straight from the Air to the grill, lemmy fresh."
            end
        end
    elseif self.itemPName == "Berry Tart" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "BERRY TART" then
                recipes[i]["found"] = true
                recipes[i]["name"] = "Berry Tart"
                recipes[i]["description"] = "Baked to berry perfection."
            end
        end

    end
end

--testing Recipes:addInventory("Meatball Special")
function Recipes:addInventory(recipeItem)
    self.itemPName = recipeItem

    if self.itemPName == "Meatball Special" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "MEATBALL SPECIAL" then
                if recipes[i]["found"] == true then
                    for j in pairs(items) do
                        if items[j]["name"] == "Meaty Chunks" then
                            if items[j]["quantity"] >= 5 then
                                for k in pairs(items) do
                                    if items[k]["name"] == "Tomas" then
                                        if items[k]["quantity"] >= 10 then
                                            for l in pairs(items) do
                                                if items[l]["name"] == "Noodles" then
                                                    if items[l]["quantity"] >= 1 then
                                                        for m in pairs(items) do
                                                            if items[m]["name"] == "Mozzerell" then
                                                                if items[m]["quantity"] >= 2 then
                                                                    for n in pairs(items) do
                                                                        if items[n]["name"] == "Spicy" then
                                                                            if items[n]["quantity"] >= 1 then
                                                                                recipes[i]["quantity"] = recipes[i]
                                                                                    ["quantity"] + 1
                                                                                print("Success")
                                                                                Items:addItem("Meaty Chunks", -5)
                                                                                Items:addItem("Tomas", -10)
                                                                                Items:addItem("Noodles", -1)
                                                                                Items:addItem("Mozzerell", -2)
                                                                                Items:addItem("Spicy", -1)
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif self.itemPName == "Grilled Fish" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "GRILLED FISH" then
                if recipes[i]["found"] == true then
                    for j in pairs(items) do
                        if items[j]["name"] == "Flying Fish" then
                            if items[j]["quantity"] >= 4 then
                                for k in pairs(items) do
                                    if items[k]["name"] == "Lemmies" then
                                        if items[k]["quantity"] >= 2 then
                                            for l in pairs(items) do
                                                if items[l]["name"] == "Savory" then
                                                    if items[l]["quantity"] >= 1 then
                                                        recipes[i]["quantity"] = recipes[i]["quantity"] + 1
                                                        print("Success")
                                                        Items:addItem("Flying Fish", -4)
                                                        Items:addItem("Lemmies", -2)
                                                        Items:addItem("Savory", -1)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif self.itemPName == "Berry Tart" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "BERRY TART" then
                if recipes[i]["found"] == true then
                    for j in pairs(items) do
                        if items[j]["name"] == "Berries" then
                            if items[j]["quantity"] >= 10 then
                                for k in pairs(items) do
                                    if items[k]["name"] == "Doughball" then
                                        if items[k]["quantity"] >= 2 then
                                            for l in pairs(items) do
                                                if items[l]["name"] == "Sweet" then
                                                    if items[l]["quantity"] >= 1 then
                                                        recipes[i]["quantity"] = recipes[i]["quantity"] + 1
                                                        print("Success")
                                                        Items:addItem("Berries", -10)
                                                        Items:addItem("Doughball", -2)
                                                        Items:addItem("Sweet", -1)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        print("fail")
    end
end

--recipes

recipes = {
    {
        ["categoryID"] = 1,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meatball Special",
        ["ID"] = "MEATBALL SPECIAL",
        ["description"] = "Just like grandma used to make. Pasta in rich toma sauce with meatballs.",
        ["quantity"] = 0,
        ["requiredItems"] = "5 Meaty Chunks, 10 Tomas, 1 Noodles, 2 Mozzerell, 1 Spicy",
    },
    {
        ["categoryID"] = 1,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Grilled Fish",
        ["ID"] = "GRILLED FISH",
        ["description"] = "Straight from the air to the grill, lemmy fresh.",
        ["quantity"] = 0,
        ["requiredItems"] = "4 Flying Fish, 2 Lemmies, 1 Savory",
    },
    {
        ["categoryID"] = 3,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Berry Tart",
        ["ID"] = "BERRY TART",
        ["description"] = "Baked to berry perfection",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Berries, 2 Doughball, 1 Sweet",
    },

}
