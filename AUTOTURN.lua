--AUTHOR: KaliKiu

--vnavmesh : Movement (https://puni.sh/api/repository/veyn)
--SND (SomethingNeedDoing): (https://love.puni.sh/ment.json)
--PandorasBox (https://love.puni.sh/ment.json)
--AutoRetainer (https://love.puni.sh/ment.json)
--Lifestream (https://github.com/NightmareXIV/MyDalamudPlugins/raw/main/pluginmaster.json)


--ITEMS ID + COUNT
local Tarnished = {
    TGB = {id=12680, count},
    TGC = {id=12676, count},
    TGSP = {id=12677, count},
    TGSH = {id=12675, count},
    TGP = {id=12678, count}
}

--CONSTANTS
local INVENTORY_MIN_SPACE = 40
local NORMAL = 0.4
local ITEM_MIN_COUNT = 60
local run = true

local function SimpleWait(seconds)
    yield("/wait " .. seconds)
end

local function KaliLog(loggin)
    Dalamud.Log("[SND_AE]" .. loggin)
end

local function Pre()
    for key, item in pairs(Tarnished) do
        item.count = Inventory.GetItemCount(item.id)
        KaliLog(key .. " count: " .. item.count)
    end
    local meow = 0;
    for key, item in pairs(Tarnished) do
        if item.count > meow then
            if item.id == 12680 then
                goto continue
            end
            meow = item.count
        end
        ::continue::
    end
    if meow < 30 then
        KaliLog("Not enough items")
        run = false
        yield("/snd stop AUTO")
    end

    if Inventory.GetFreeInventorySlots() < INVENTORY_MIN_SPACE then
        KaliLog("Not enough space in Inventory")
        return false
    end
    return true
end

local function Tp()
    KaliLog("Traveling to Idyllshire...")
    IPC.Lifestream.Teleport(75, 0)

    while IPC.Lifestream.GetRealTerritoryType() ~= 478 do
        SimpleWait(NORMAL)
        KaliLog("waiting..")
    end
    SimpleWait(5)
end

local function SabinaSetup()
    KaliLog("Walking to Sabina...")
    yield("/vnavmesh moveto -19.45 211 -36.3")
    SimpleWait(10)

    while Player.IsMoving do
        KaliLog("Walk..")
        SimpleWait(1)
    end
    yield("/target Sabina")
    yield("/interact")
    while not Addons.GetAddon("SelectIconString").Ready do
        SimpleWait(NORMAL)
        KaliLog("waiting..")
    end
    yield("/callback SelectIconString true 0")
    while not Addons.GetAddon("SelectString").Ready do
        SimpleWait(NORMAL)
        KaliLog("waiting..")
    end
end

local function Exchange(index)
    KaliLog("Exchange " .. index .. "meow")
    local cases = {
        [0] = 22,
        [1] = 13,
        [2]  =17,
    }
    local runs = cases[index]
    yield("/callback SelectString true ".. index)
    while not Addons.GetAddon("ShopExchangeItem").Ready do
        SimpleWait(NORMAL)
        KaliLog("waiting..")
    end
    SimpleWait(NORMAL)
    for i = 2, runs do
        yield("/callback ShopExchangeItem true 0 " .. i .. " 1")
        SimpleWait(NORMAL)
        yield("/click ShopExchangeItemDialog Exchange")
        SimpleWait(1)
    end
    yield("/pcall ShopExchangeItem true -1")
    SimpleWait(3)
end

local function SetupSerpent()
    yield("/pcall SelectString true -1")
    SimpleWait(2)
    yield("/pcall SelectString true -1")
    SimpleWait(90)
end

local function RunSeals()
    SimpleWait(2)
    SetupSerpent()
end

while(run) do
    if Pre() then
        Tp()
        SabinaSetup()
        Exchange(0)
        Exchange(1)
        Exchange(2)
        KaliLog("FINISHED")
        RunSeals()
    end
end