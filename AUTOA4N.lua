--Author: KaliKiu


--PLUGINS NEEDED--
--vnavmesh : Movement (https://puni.sh/api/repository/veyn)
--SND (SomethingNeedDoing): (https://love.puni.sh/ment.json)
--RotationSolverReborn : (https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json)
--PandorasBox (https://love.puni.sh/ment.json)

local LoopsToRun = 300

local A4N_ID = 115
local NORMAL = 1

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
    SimpleWait(2)
    local rawTime = InstancedContent.ContentTimeLeft
    local time = math.floor(rawTime)
    for i = 1, 300 do
        yield("/tenemy")
        local target = Entity.Target
        rawTime = InstancedContent.ContentTimeLeft
        time = math.floor(rawTime)
        if (target or time >5365)  then
            Dalamud.Log("Fighting.. ")
        else
            Dalamud.Log("NoTarget .. EndFight()")
            break
        end
        SimpleWait(NORMAL)
        if time < 5350 then
            break
        end
        KaliLog(time)
    end
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