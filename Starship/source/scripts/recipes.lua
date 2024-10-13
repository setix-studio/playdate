local pd <const> = playdate
local gfx <const> = pd.graphics

class('Recipes').extends(gfx.sprite)

function Recipes:init(x, y)
    imageIndex = 1
    recipeImage = gfx.image.new("assets/images/recipes" .. imageIndex)



    self:setImage(recipeImage)

    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    self:setZIndex(900)
    for _, recipe in pairs(recipes) do
        if recipe.found then
            recipe.name = recipe.name
            recipe.description = recipe.description
            recipe.requiredItems = recipe.requiredItems
            recipe.index = recipe.index
        else
            recipe.name = "??????"
            recipe.description = "??????"
            recipe.requiredItems = " ?? ?????"
            recipe.index = 1
        end
    end
end

function Recipes:update()
    if showImage == true then
        recipeImage = gfx.image.new("assets/images/recipes" .. imageIndex)
        self:setImage(recipeImage)
    elseif showImage == false then
        recipeImage = gfx.image.new("assets/images/recipes1")
        self:setImage(recipeImage)

        
    end
    if removeRecipes == true then
        self:remove()
    end
end

function Recipes:checkQuantity()
    for i in pairs(recipes) do
        itemName = recipes[i]["name"]
        totalItems = recipes[i]["quantity"]
    end
end

function Recipes:addRecipe(recipeItem)
    self.itemPName = recipeItem

    local recipeData = {
        ["Meatball Special"] = { ID = "MEATBALL SPECIAL", name = "Meatball Special", description = "Just like grandma used to make. Pasta in rich toma sauce with meatballs.", requiredItems = "/ 5 Meaty Chunks\n/ 10 Tomas\n/ 1 Noodles\n/ 2 Mozzerell\n/ 1 Spicy", index = 2 },
        ["Grilled Fish"] = { ID = "GRILLED FISH", name = "Grilled Fish", description = "Straight from the Air to the grill, lemmy fresh.", requiredItems = "/ 4 Flying Fish\n/ 2 Lemmies\n/ 1 Savory", index = 3 },
        ["Fried Chop"] = { ID = "FRIED CHOP", name = "Fried Chop", description = "Fried to pork-fection.", requiredItems = "/ 2 Big Chop\n/ 1 Savory", index = 4 },
        ["Meaty Sando"] = { ID = "MEATY SANDO", name = "Meaty Sando", description = "Chunks of meat, tomas and cheddah in a savory sando.", requiredItems = "/ 5 Meaty Chunks\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Savory", index = 5 },
        ["Veggie Sando"] = { ID = "VEGGIE SANDO", name = "Veggie Sando", description = "Brussels, tomas and cheddah in a spicy sando.", requiredItems = "/ 3 Brussels\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Spicy", index = 6 },
        ["Meaty Pizza"] = { ID = "MEATY PIZZA", name = "Meaty Pizza", description = "Chunks of meat, tomas, shrooma and mozzerell on a thin crust.", requiredItems = "/ 4 Meaty Chunks\n/ 3 Tomas\n/ 3 Shrooma\n/ 4 Mozzerell\n/ 2 Doughball", index = 7 },
        ["Cheesy Pizza"] = { ID = "CHEESY PIZZA", name = "Cheesy Pizza", description = "Cheddah, mozzerell and tomas on a thin crust.", requiredItems = "/ 4 Cheddah\n/ 4 Mozzerell\n/ 3 Tomas\n/ 2 Doughball", index = 8 },
        ["Mac n Cheese"] = { ID = "MAC N CHEESE", name = "Mac n Cheese", description = "Little noodles in a creamy, cheesy sauce", requiredItems = "/ 10 Noodles\n/ 4 Cheddah\n/ 2 Crema", index = 9 },
        ["Mushroom Soup"] = { ID = "MUSHROOM SOUP", name = "Mushroom Soup", description = "Savory shroomas in a creamy soup.", requiredItems = "/ 10 Shrooma\n/ 5 Crema\n/ 1 Savory", index = 10 },
        ["Meaty Stew"] = { ID = "MEATY STEW", name = "Meaty Stew", description = "Savory stew to warm any tum", requiredItems = "/ 5 Meaty Chunks\n/ 3 Brussels\n/ 5 Shrooma\n/ 1 Savory", index = 11 },
        ["Toma Soup"] = { ID = "TOMA SOUP", name = "Toma Soup", description = "Savory tomas in a creamy soup", requiredItems = "/ 10 Tomas\n/ 5 Crema\n/ 1 Savory", index = 12 },
        ["Ramen"] = { ID = "RAMEN", name = "Ramen", description = "Rich broth with noodles, meat, shrooma and topped with eggies", requiredItems = "/ 4 Meaty Chunks\n/ 4 Shrooma\n/ 10 Noodles\n/ 2 Eggies\n/ 1 Savory", index = 13 },
        ["Berry Tart"] = { ID = "BERRY TART", name = "Berry Tart", description = "Baked to berry perfection.", requiredItems = "/ 10 Berries\n/ 2 Doughball\n/ 1 Sweet", index = 14 },
        ["Cookies"] = { ID = "COOKIES", name = "Cookies", description = "Warm and chewy", requiredItems = "/ 12 Doughball\n/ 1 Sweet", index = 15 },
        ["Nanner Puddin"] = { ID = "NANNER PUDDIN", name = "Nanner Puddin", description = "Chunks of nanners in a creamy pudding", requiredItems = "/ 10 Nanners\n/ 4 Crema\n/ 1 Sweet", index = 16 },
        ["Fries"] = { ID = "FRIES", name = "Fries", description = "Fried Taters with savory seasoning", requiredItems = "/ 10 Taters\n/ 1 Savory", index = 17 },
        ["Trail Mix"] = { ID = "TRAIL MIX", name = "Trail Mix", description = "Spicy mix of various snacks", requiredItems = "/ 5 Meaty Chunks\n/ 5 Nuts\n/ 5 Berries\n/ 5 Nanners\n/ 1 Spicy", index = 18 },
        ["Brussel Bites"] = { ID = "BRUSSEL BITES", name = "Brussel Bites", description = "Fried Brussels topped with mozzerell and savory seasoning", requiredItems = "/ 10 Brussels\n/ 5 Mozzerrel\n/ 1 Savory", index = 19 }
    }

    local recipe = recipeData[self.itemPName]

    if recipe then
        for i, data in pairs(recipes) do
            if data["ID"] == recipe.ID then
                recipes[i]["found"] = true
                recipes[i]["name"] = recipe.name
                recipes[i]["description"] = recipe.description
                recipes[i]["requiredItems"] = recipe.requiredItems
                recipes[i]["index"] = recipe.index
                break
            end
        end
    end
end

function Recipes:useItem(recipeItem)
    for i in pairs(recipes) do
        if recipes[i]["name"] == recipeItem then
            if recipes[i]["quantity"] > 0 then
                recipes[i]["quantity"] = recipes[i]["quantity"] - 1
            end
        end
    end
end

function Recipes:addInventory(recipeItem)
     function checkAndRemoveItems(itemIndex, requiredQuantities)
        for itemID, requiredQuantity in pairs(requiredQuantities) do
            if items[itemID].quantity < requiredQuantity then
                return false
            end
        end

        for itemID, requiredQuantity in pairs(requiredQuantities) do
            Items:addItem(items[itemID].name, -requiredQuantity)
      
        end

        recipes[itemIndex].quantity = recipes[itemIndex].quantity + 1
        print("success")
        return true
    end

     function checkAndExecute(recipeIndex, requiredItems)
        if recipes[recipeIndex].index == recipeIndex and recipes[recipeIndex].found then
            return checkAndRemoveItems(recipeIndex, requiredItems)
        end
        return false
    end

     function tryRecipe(recipeIndex, requiredItems)
        if checkAndExecute(recipeIndex, requiredItems) then
            return true
        end
        return false
    end

    if recipeItem == "Meatball Special" then
        return tryRecipe(2, { [1] = 5, [10] = 10, [27] = 1, [31] = 2, [40] = 1 })
    elseif recipeItem == "Grilled Fish" then
        return tryRecipe(3, { [2] = 4, [13] = 2, [42] = 1 })
    elseif recipeItem == "Fried Chop" then
        return tryRecipe(4, { [3] = 2, [42] = 1 })
    elseif recipeItem == "Meaty Sando" then
        return tryRecipe(5, { [1] = 5, [10] = 3, [30] = 2, [26] = 2, [42] = 1 })
    elseif recipeItem == "Veggie Sando" then
        return tryRecipe(6, { [9] = 3, [10] = 3, [30] = 2, [26] = 2, [42] = 1 })
    elseif recipeItem == "Meaty Pizza" then
        return tryRecipe(7, { [1] = 4, [10] = 3, [8] = 3, [26] = 4, [31] = 2 })
    elseif recipeItem == "Cheesy Pizza" then
        return tryRecipe(8, { [30] = 4, [31] = 4, [10] = 3, [26] = 2 })
    elseif recipeItem == "Mac n Cheese" then
        return tryRecipe(9, { [27] = 10, [30] = 4, [29] = 2 })
    elseif recipeItem == "Mushroom Soup" then
        return tryRecipe(10, { [8] = 10, [31] = 5, [42] = 1 })
    elseif recipeItem == "Meaty Stew" then
        return tryRecipe(11, { [1] = 5, [9] = 3, [8] = 5, [42] = 1 })
    elseif recipeItem == "Toma Soup" then
        return tryRecipe(12, { [10] = 10, [29] = 5, [42] = 1 })
    elseif recipeItem == "Ramen" then
        return tryRecipe(13, { [1] = 4, [8] = 4, [27] = 10, [28] = 2, [42] = 1 })
    elseif recipeItem == "Berry Tart" then
        return tryRecipe(14, { [6] = 10, [26] = 2, [41] = 1 })
    elseif recipeItem == "Cookies" then
        return tryRecipe(15, { [26] = 12, [41] = 1 })
    elseif recipeItem == "Nanner Puddin" then
        return tryRecipe(16, { [11] = 10, [29] = 4, [41] = 1 })
    elseif recipeItem == "Fries" then
        return tryRecipe(17, { [12] = 12, [42] = 1 })
    elseif recipeItem == "Trail Mix" then
  
        return tryRecipe(18, { [1] = 5, [15] = 5, [6] = 5, [11] = 5, [40] = 1 })
        
    elseif recipeItem == "Brussel Bites" then
        return tryRecipe(19, { [9] = 10, [31] = 5, [42] = 1 })
    else
    
        print("fail")
    end
end

--testing Recipes:addInventory("Meatball Special")


--recipes

recipes = {

    {
        ["categoryID"] = 1,
        ["index"] = 1,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "...",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["requiredItems"] = "",
        ["border"] = true,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 2,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meatball Special",
        ["ID"] = "MEATBALL SPECIAL",
        ["description"] = "Just like grandma used to make. Pasta in rich toma sauce with meatballs.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 10 Tomas\n/ 1 Noodles\n/ 2 Mozzerell\n/ 1 Spicy",
        ["border"] = false,

    },
    {
        ["categoryID"] = 1,
        ["index"] = 3,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Grilled Fish",
        ["ID"] = "GRILLED FISH",
        ["description"] = "Straight from the air to the grill, lemmy fresh.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Flying Fish\n/ 2 Lemmies\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 4,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Fried Chop",
        ["ID"] = "FRIED CHOP",
        ["description"] = "Fried to pork-fection.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 2 Big Chop\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 5,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meaty Sando",
        ["ID"] = "MEATY SANDO",
        ["description"] = "Chunks of meat, tomas and cheddah in a savory sando.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 6,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Veggie Sando",
        ["ID"] = "VEGGIE SANDO",
        ["description"] = "Brussels, tomas and cheddah in a spicy sando.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 3 Brussels\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Spicy",
        ["border"] = false,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 7,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meaty Pizza",
        ["ID"] = "MEATY PIZZA",
        ["description"] = "Chunks of meat, tomas, shrooma and mozzerell on a thin crust.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Meaty Chunks\n/ 3 Tomas\n/ 3 Shrooma\n/ 4 Mozzerell\n/ 2 Doughball",
        ["border"] = false,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 8,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Cheesy Pizza",
        ["ID"] = "CHEESY PIZZA",
        ["description"] = "Cheddah, mozzerell and tomas on a thin crust.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Cheddah\n/ 4 Mozzerell\n/ 3 Tomas\n/ 2 Doughball",
        ["border"] = false,
    },
    {
        ["categoryID"] = 1,
        ["index"] = 9,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Mac n Cheese",
        ["ID"] = "MAC N CHEESE",
        ["description"] = "Little noodles in a creamy, cheesy sauce",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Noodles\n/ 4 Cheddah\n/ 2 Crema",
        ["border"] = false,
    },
    {
        ["categoryID"] = 2,
        ["index"] = 10,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Mushroom Soup",
        ["ID"] = "MUSHROOM SOUP",
        ["description"] = "Savory shroomas in a creamy soup",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Shrooma\n/ 5 Crema\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 2,
        ["index"] = 11,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Meaty Stew",
        ["ID"] = "MEATY STEW",
        ["description"] = "Savory stew to warm any tum",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 3 Brussels\n/ 5 Shrooma\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 2,
        ["index"] = 12,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Toma Soup",
        ["ID"] = "TOMA SOUP",
        ["description"] = "Savory tomas in a creamy soup",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Tomas\n/ 5 Crema\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 2,
        ["index"] = 13,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Ramen",
        ["ID"] = "RAMEN",
        ["description"] = "Rich broth with noodles, meat, shrooma and topped with eggies",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Meaty Chunks\n/ 4 Shrooma\n/ 10 Noodles\n/ 2 Eggies\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 3,
        ["index"] = 14,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Berry Tart",
        ["ID"] = "BERRY TART",
        ["description"] = "Baked to berry perfection",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Berries\n/ 2 Doughball\n/ 1 Sweet",
        ["border"] = false,
    },
    {
        ["categoryID"] = 3,
        ["index"] = 15,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Cookies",
        ["ID"] = "COOKIES",
        ["description"] = "Warm and chewy",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 12 Doughball\n/ 1 Sweet",
        ["border"] = false,
    },
    {
        ["categoryID"] = 3,
        ["index"] = 16,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Nanner Puddin",
        ["ID"] = "NANNER PUDDIN",
        ["description"] = "Chunks of nanners in a creamy pudding",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Nanners\n/ 4 Crema\n/ 1 Sweet",
        ["border"] = false,
    },
    {
        ["categoryID"] = 4,
        ["index"] = 17,
        ["category"] = "Snacks",
        ["found"] = false,
        ["name"] = "Fries",
        ["ID"] = "FRIES",
        ["description"] = "Fried Taters with savory seasoning",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Taters\n/ 1 Savory",
        ["border"] = false,
    },
    {
        ["categoryID"] = 4,
        ["index"] = 18,
        ["category"] = "Snacks",
        ["found"] = true,
        ["name"] = "Trail Mix",
        ["ID"] = "TRAIL MIX",
        ["description"] = "Spicy mix of various snacks",
        ["quantity"] = 10,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 5 Nuts\n/ 5 Berries\n/ 5 Nanners\n/ 1 Spicy",
        ["border"] = false,
    },
    {
        ["categoryID"] = 4,
        ["index"] = 19,
        ["category"] = "Snacks",
        ["found"] = false,
        ["name"] = "Brussel Bites",
        ["ID"] = "BRUSSEL BITES",
        ["description"] = "Fried Brussels topped with mozzerell and savory seasoning",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Brussels\n/ 5 Mozzerrel\n/ 1 Savory",
        ["border"] = false,

    },
    {
        ["categoryID"] = 1,
        ["index"] = 20,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "...",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["requiredItems"] = "",
        ["border"] = true,

    },

}
