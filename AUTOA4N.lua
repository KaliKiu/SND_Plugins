
--PLUGINS NEEDED--
--vnavmesh : Movement (https://puni.sh/api/repository/veyn)
--SND (SomethingNeedDoing): (https://love.puni.sh/ment.json)
--RotationSolverReborn : (https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json)
--PandorasBox (https://love.puni.sh/ment.json)

local LoopsToRun = 300

local A4N_ID = 115
local NORMAL = 1
local item = {
    PGS = {ID = 13587, COUNT = 0}
}

local function SimpleWait(seconds)
    yield("/wait " .. seconds)
end

local function KaliLog(loggin)
    Dalamud.Log("[SND_AUTA4N]" .. loggin)
end

local function Setup()
    while true do
        if not Instances.DutyFinder.IsUnrestrictedParty then
            KaliLog("RestrictedParty.. pls unsync")
            SimpleWait(NORMAL)
        else
            KaliLog("UnrestrictedParty")
            SimpleWait(NORMAL)
            break
        end
    end
    
end

local function Q()
    Setup()
    Instances.DutyFinder:QueueDuty(115)
    while not Addons.GetAddon("ContentsFinderConfirm").Ready do
        SimpleWait(NORMAL)
        KaliLog("waiting..")
    end
    SimpleWait(NORMAL)
    KaliLog("Entering Instance..")
    yield("/pcall ContentsFinderConfirm true 8")
    SimpleWait(4)
end

local function Fight()
    yield("/vnavmesh moveto -0.0 10.5 -8.4")
    SimpleWait(NORMAL)
    yield("/tenemy")
    SimpleWait(NORMAL)
    yield("/tenemy")
    yield("/rotation manual")

    local time = math.floor(InstancedContent.ContentTimeLeft)
    local prev_count = Inventory.GetItemCount(item.PGS.ID)
    item.PGS.COUNT = prev_count

    while prev_count == item.PGS.COUNT do
        KaliLog(prev_count .. " " .. item.PGS.COUNT)
        yield("/tenemy")
        yield("/rotation manual")
        local target = Entity.Target
        rawTime = InstancedContent.ContentTimeLeft
        time = math.floor(rawTime)
        if (target or time >5350)  then
        else
            KaliLog("FightBuged .. EndFight()")
            break
        end
        item.PGS.COUNT = Inventory.GetItemCount(item.PGS.ID)
        SimpleWait(NORMAL)
        KaliLog(time)
    end
    KaliLog("FightEnd..")
    SimpleWait(NORMAL)
end

local function EndFight()
    SimpleWait(NORMAL)
    yield("/vnavmesh moveto -2 10.5 -5.5")
    SimpleWait(NORMAL)
    yield("/vnavmesh moveto 2 10.5 -5.5")
    SimpleWait(NORMAL)
    yield("/rotation off")
    InstancedContent.LeaveCurrentContent()
end

-- ==========================================
for i = 1, LoopsToRun do
    Q()
    KaliLog("RUN " .. i)
    Fight()
    EndFight()
    SimpleWait(5)
end
KaliLog("---.FINISHED.---" .. LoopsToRun)