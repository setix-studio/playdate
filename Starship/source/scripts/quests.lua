local pd <const> = playdate
local gfx <const> = pd.graphics


quests = {
    {
        ["ID"] = 1,
        ["intro"] = false,
        ["found"] = false,
        ["inProgress"] = false,
        ["complete"] = false,
        ["type"] = "gather",
        ["title"] = "Gather Berries",
        ["owner"] = "Junlop",
        ["introCopy"] = "Hello, I need to make a Berry Tart, but I am out of Berries, can you bring me 10 Berries?",
        ["inProgressCopy"] = "In case you forgot, I need 10 Berries to make a Berry Tart.",
        ["turninCopy"] = "Thank you, just one minute......  .. .. There! Have a Berry Tart for your troubles.",
        ["completeCopy"] = "Thank you!",
        ["description"] = "Junlop is looking to make a Berry Tart, but is out of berries. Help him gather 10 berries.",
        ["gatherItemID"] = 6,
        ["gatherItem"] = "Berries",
        ["quantity"] = 10,
        ["reward"] = "Berry Tart",
        ["rewardQty"] = 1,
        ["rewardReceived"] = false,
        ["recipeReceived"] = false,

    },
    {
        ["ID"] = 2,
        ["found"] = false,
        ["intro"] = false,
        ["inProgress"] = false,
        ["complete"] = false,
        ["type"] = "craft",
        ["title"] = "Berry Tarts for all!",
        ["owner"] = "Daryl",
        ["introCopy"] = "I'm looking for a good Berry Tart, you wouldnt happen to have one would you?",
        ["inProgressCopy"] = "I'm craving a Berry Tart.",
        ["turninCopy"] = "Thank you, heres some credits for your troubles. Now I can clear the road!",
        ["completeCopy"] = "Thank you!",
        ["description"] = "Daryl is looking for someone that can make a Berry Tart for him, are you up to the task?",
        ["gatherItem"] = "Berry Tart",
        ["quantity"] = 1,
        ["rewardCredits"] = 40,
        ["rewardReceived"] = false,
        ["recipeReceived"] = true,


    },
    {
        ["ID"] = 3,
        ["intro"] = false,
        ["found"] = false,
        ["inProgress"] = false,
        ["complete"] = false,
        ["type"] = "gather",
        ["title"] = "Nanner Nanners",
        ["owner"] = "Eulo",
        ["introCopy"] =
        "I'm looking to make some Nanner Puddin, but I'm all out of Nanners. Can you go an fetch me some?",
        ["inProgressCopy"] = "I need 10 Nanners for my puddin.",
        ["turninCopy"] = "Thank you, let's get some down with puddin! Here's the recipe for your troubles.",
        ["completeCopy"] = "Puddin!",
        ["description"] =
        "Eulo is looking to make some Nanner Puddin, but is fresh out of Nanners. Bring back 10 Nanners to commence puddin time... whatever that is.",
        ["gatherItemID"] = 11,
        ["gatherItem"] = "Nanners",
        ["quantity"] = 10,
        ["reward"] = "Nanner Puddin",
        ["rewardQty"] = 1,
        ["rewardReceived"] = false,
        ["recipeReceived"] = false,

    },

}
