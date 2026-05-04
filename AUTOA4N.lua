
--PLUGINS NEEDED--
--vnavmesh : Movement (https://puni.sh/api/repository/veyn)
--SND (SomethingNeedDoing): (https://love.puni.sh/ment.json)
--RotationSolverReborn : (https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json)
--PandorasBox (https://love.puni.sh/ment.json)

local LoopsToRun = 300

local A4N_ID = 115
local NORMAL = 1
local Item = {
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

local function Check()
    while true do
        local qs = Instances.DutyFinder.QueueState
        if not (qs and qs.InConten) then
             KaliLog("Waiting to enter ..")
             SimpleWait(NORMAL)
        else
            KaliLog("InContent .. start fight")
            break
        end
    end
    yield("/echo [SND] Timer finished. Cleaning up...")
    yield("/vnavmesh moveto -2 10.5 -5.5")
    SimpleWait(1)
    yield("/vnavmesh moveto 2 10.5 -5.5")
    SimpleWait(1)
    yield("/rotation off")
    SimpleWait(2)
    yield("/pdfleave") 
    yield("/echo [SND] Leaving... Waiting for loading screen")
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
--entering is kinda as.. gotta fix that
    SimpleWait(10)
end

local function Fight()
    yield("/rotation manual")
    yield("/vnavmesh moveto -0.0 10.5 -8.4")
    SimpleWait(1)
    yield("/tenemy")
    SimpleWait(1)
    yield("/tenemy")

    local rawTime = InstancedContent.ContentTimeLeft
    local time = math.floor(rawTime)
    local prev_count = Inventory.GetItemCount(item.PGS.ID)
    item.PGS.COUNT = prev_count
    
    while prev_count == items.PGS.COUNT do
        yield("/tenemy")
        local target = Entity.Target
        rawTime = InstancedContent.ContentTimeLeft
        time = math.floor(rawTime)
        if (target or time >5365)  then
            KaliLog("Combat..")
        else
            KaliLog("NoTarget .. EndFight()")
            break
        end
        items.PGS.COUNT = Inventory.GetItemCount(item.PGS.ID)
        SimpleWait(NORMAL)
        KaliLog(time)
    end
    KaliLog("FightEnd..")
    SimpleWait(NORMAL)
end

local function EndFight()
    SimpleWait(2)
    yield("/vnavmesh moveto -2 10.5 -5.5")
    SimpleWait(NORMAL)
    yield("/vnavmesh moveto 2 10.5 -5.5")
    SimpleWait(NORMAL)
    yield("/rotation off")
    SimpleWait(3)
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