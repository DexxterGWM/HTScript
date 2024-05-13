local gEnv = getgenv and getgenv()
local fEnv = getfenv and getfenv()

for _, value in next, game.GetChildren(game) do
        gEnv[value.ClassName] = value
end

gEnv.fireproximityprompt = fireproximityprompt
gEnv.pcall, gEnv.coroutine =  pcall, coroutine
gEnv.task = task
gEnv.table, gEnv.rawget, gEnv.rawset = table, rawget, rawset
gEnv.next = next
gEnv.string, gEnv.math = string, math

-- fEnv.SimpleSpy = SimpleSpy

do if (not (game:IsLoaded())) then
        repeat task.wait() until game:IsLoaded() end
end
do if (not (game.GameId == 2800687919)) then
        warn('HT Test(s): game not supported'); return end
end

local client = game.Players.LocalPlayer
local loadTime = tick()
local timeOut = 90

do
        if shared.__unload then pcall(shared.__unload) end

        function shared.__unload()
                for i = 1, #shared.Threads do
                        task.spawn(shared.Threads[i])
                end
                for i = 1, #shared.Connections.Others do
                        task.spawn(shared.Connections.Others[i])
                end
                for i = 1, #shared.Connections.Childs do
                        task.spawn(shared.Connections.Childs[i])
                end
        end

        shared.Threads = {}
        shared.Connections = {}
        shared.Connections.Others = {}
        shared.Connections.Childs = {}

        -- gEnv.Toggles = {}
        fEnv.Toggles = {}
end

do
        -- gEnv.questTabl = {['NormalHard'] = {['gameVal'] = 20}}
        fEnv.questTabl = {['NormalHard'] = {['gameVal'] = 20}}

        local success, bool = pcall(function()
                -- gEnv.giftsTabl = {
                fEnv.giftsTabl = {
                        ['[1] Gold Getter']   = {['Tag'] = 'GoldGift',       ['gameVal'] = 90, ['playerVal'] = function() return client:GetAttribute('Eggs')       end},

                        ['[2] Gold Getter']   = {['Tag'] = 'TreeGoldGift',   ['gameVal'] = 1,  ['playerVal'] = function() return client:GetAttribute('GoldEggs')   end},
                        ['[2] Silver Getter'] = {['Tag'] = 'TreeSilverGift', ['gameVal'] = 1,  ['playerVal'] = function() return client:GetAttribute('SilverEggs') end},
                        ['[2] Bronze Getter'] = {['Tag'] = 'TreeBronzeGift', ['gameVal'] = 1,  ['playerVal'] = function() return client:GetAttribute('BronzeEggs') end}
                }

                -- for index, tabl in next, gEnv.giftsTabl do
                for index, tabl in next, fEnv.giftsTabl do
                        assert(tabl['playerVal'](), ('HT Test(s): setts n.1 error with %s'):format(index))
                end
                return true
        end)

        if (not (success)) then
                return warn(('HT Test(s): %s'):format(tostring(bool)))
        end
end

-- do local connection; local success, bool = pcall(function() connection = game.CoreGui.ChildAdded:Connect(function() if (game.CoreGui:FindFirstChild('SimpleSpy2')) then game.CoreGui.SimpleSpy2.Enabled = false; connection:Disconnect() end end); task.spawn(loadstring(game:HttpGet('https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua'))); task.wait() end); if (not (success)) then connection:Disconnect(); return warn(('HT Test(s): %s'):format(tostring(bool))) end end

do
        local success, bool = pcall(function()
                Library = loadstring(Game:HttpGet('https://raw.githubusercontent.com/DexxterGWM/HTScript/main/Scripts%20Folder/Library.lua'))()
                task.wait()
                assert(Library, 'HT Test(s): setts n.3 error')
                return true
        end)
        if (not (success)) then
                return warn(('HT Test(s): %s'):format(tostring(bool)))
        end
end

local HackingController = require(game.ReplicatedStorage.Source.Controllers.HackingController)

local Services, RE = game.ReplicatedStorage.Packages._Index['sleitnick_knit@1.4.7'].knit.Services
local RE1, RE2, RE3 = Services.HackingService.RE, Services.XmasQuestService.RE, Services.XmasShopService.RE

local StartedPhoneHack, FinishedPhoneHack = RE1.StartedPhoneHack, RE1.FinishedPhoneHack
local claimQuest, PurchaseItem = RE2.ClaimQuest, RE3.PurchaseItem

local getQuest = function(questStr)
        return tonumber(
                string.gmatch(client:GetAttribute('EventQuests') or '', (tostring(questStr) .. '%p+(%d+)'))()
        )
end

-- local npcIndex = function(npc) return tonumber(string.gmatch(npc.Name, '%u+%p(%d+)')()) end
-- local function firePrompt(prompt, npc) print('firing'); local conn1, conn2, waitFor; fireproximityprompt(prompt, 1, true); for i = 1, 2 do local waitFor = false; conn1 = SimpleSpy:GetRemoteFiredSignal(FinishedPhoneHack):Connect(function() conn1:Disconnect(); waitFor = true end); conn2 = SimpleSpy:GetRemoteFiredSignal(StartedPhoneHack):Connect(function() conn2:Disconnect(); FinishedPhoneHack:FireServer(0) end); StartedPhoneHack:FireServer(npc.Name); repeat wait(1) until ((not (npcGetter)) or waitFor); if (conn1) then conn1:Disconnect() end; if (conn2) then conn2:Disconnect() end end; print('got fired') --; return end

do
        local connection = (function()
                return client.PlayerGui.PhoneHackDialog.Holder:GetPropertyChangedSignal('Visible'):Connect(function()
                        task.wait()
                        if (Toggles.NPCGetter) then
                                pcall(function()
                                        return HackingController.CancelAndCleanFromOutside()
                                end)
                        end
                end)
        end)()
        table.insert(shared.Connections.Others, function()
                return connection:Disconnect()
        end)
end

do
        local connection = (function()
                return client:GetAttributeChangedSignal('EventQuests'):Connect(function()
                        task.wait()
                        if (Toggles.NPCGetter) then
                                if (getQuest('NormalHard') >= rawget(questTabl['NormalHard'], 'gameVal')) then
                                        claimQuest:FireServer('NormalHard')
                                end
                        end
                end)
        end)()
        table.insert(shared.Connections.Others, function()
                return connection:Disconnect()
        end)
end

do
        local npcsTabl = {}
        local setNpc = function(npc)
                if (npc:FindFirstChildOfClass('Humanoid')) then
                        if (table.find(npcsTabl, npc)) then return end

                        table.insert(npcsTabl, npc)
                        local connection = npc.AncestryChanged:Connect(function(npc, parent)
                                if (not (npc.Parent)) then
                                        table.remove(npcsTabl, table.find(npcsTabl, npc))
                                end
                        end)
                        table.insert(shared.Connections.Childs, function()
                                return connection:Disconnect()
                        end)
                end
        end

        local setNpcs = function()
                for _, npc in next, game.Workspace.NPC:GetChildren() do
                        task.wait(); task.spawn(setNpc, npc)
                end
                for _, npc in next, game.Lighting.UnloadedNPC:GetChildren() do
                        task.wait(); task.spawn(setNpc, npc)
                end
        end

        local thread = task.spawn(function()
                while (true) do
                        task.wait()
                        if (Toggles.NPCGetter) then
                                task.spawn(setNpcs)
                                local connection = game.Workspace.NPC.ChildAdded:Connect(function(npc) task.wait(); task.spawn(setNpc, npc) end)
                                table.insert(shared.Connections.Childs, function() return connection:Disconnect() end)

                                local index, npc
                                repeat
                                        task.wait(); npcsTabl = npcsTabl
                                        local success, err = pcall(function()
                                                index, npc = next(npcsTabl, index)
                                                if (not (index or npc)) then
                                                        index, npc = next(npcsTabl)
                                                        if (not (index or npc)) then
                                                                return ('wrong npc/index:\n\tindex: %s\n\tnpc: \"%s\"'):format(tostring(index), tostring(npc))
                                                        end
                                                end
                                                return true
                                        end)

                                        if (success) then
                                                local timer, prompt = coroutine.create(function()
                                                        local time = 0
                                                        while ((not (prompt)) or Toggles.NPCGetter) do
                                                                if (time >= timeOut) then break
                                                                else
                                                                        time = time + 1; coroutine.yield(time)
                                                                end
                                                        end
                                                        if (time >= timeOut) then coroutine.yield(true)
                                                        else coroutine.yield(time) end
                                                end)

                                                local timeCheck
                                                repeat
                                                        if (not (npc or npc:IsA('Model') or tonumber(timeCheck))) then break end

                                                        local _; _, timeCheck = coroutine.resume(timer)
                                                        task.wait()
                                                        if (npc:FindFirstChild('HumanoidRootPart') and (not (prompt))) then
                                                                if (client.PlayerGui.PhoneHackDialog.Holder.Visible) then
                                                                        HackingController.CancelAndCleanFromOutside()
                                                                end
                                                                prompt = npc.HumanoidRootPart:FindFirstChild('ProximityPrompt')
                                                                if (client.Character and npc:FindFirstChild('HumanoidRootPart')) then
                                                                        client.Character:PivotTo(npc.HumanoidRootPart:GetPivot())
                                                                end
                                                        end
                                                        if (prompt or (not (npc.Parent))) then break end
                                                until (not (Toggles.NPCGetter))

                                                if (tonumber(timeCheck)) then
                                                        local success, err = xpcall(
                                                                function() return prompt and fireproximityprompt(prompt, 1, true) end,
                                                                function(err) return err end
                                                        )
                                                        if (success) then
                                                                StartedPhoneHack:FireServer(npcName); FinishedPhoneHack:FireServer(0); task.wait()
                                                                StartedPhoneHack:FireServer(npcName); FinishedPhoneHack:FireServer(0); task.wait()
                                                        else
                                                                warn(('HT Test(s): prompt error with \"%s\":\n\tproximityprompt: %s\n\terror: %s'):format(
                                                                        tostring((npc:IsA('Model') and npc.Name) or npc), tostring(prompt), tostring(err)
                                                                ))
                                                        end
                                                else
                                                        warn(('HT Test(s): time out with \"%s\" prompt'):format(tostring(npc)))
                                                end
                                        else
                                                warn(('HT Test(s): error with next key:\n\terror: %s'):format(tostring(err)))
                                                task.spawn(setNpcs)
                                        end
                                until (not (Toggles.NPCGetter))

                                for i = 1, #shared.Connections.Childs do
                                        task.spawn(shared.Connections.Childs[i])
                                end
                                Toggles.NPCGetter = false
                        end
                end
        end)

        -- gEnv.npc = function(bool)
        fEnv.NPC = function(bool)
                Toggles.NPCGetter = bool
                npcsTabl = (Toggles.NPCGetter and npcsTabl) or {}
                return print(('HT Test(s): npc getter: %s'):format(((not (Toggles.NPCGetter)) and 'OFF') or 'ON'))
        end

        table.insert(shared.Threads, function()
                return pcall(task.cancel, thread)
        end)
end

do
        local lastGiftGetter

        local thread = task.spawn(function()
                while (true) do
                        task.wait()
                        if (Toggles.GIFTGetter) then
                                local giftName, canBuy = Toggles.GIFTGetter
                                repeat
                                        task.wait()
                                        canBuy = giftsTabl[giftName]['playerVal']() >= canBuy['gameVal']
                                        if (canBuy and Toggles.GIFTGetter) then
                                                local tagToSend = giftsTabl[giftName]['Tag']
                                                PurchaseItem:FireServer(tagToSend)
                                        else
                                                break
                                        end
                                until (not (Toggles.GIFTGetter))

                                Toggles.GIFTGetter = false
                        end
                end
        end)

        fEnv.GIFT = function(text)
                lastGiftGetter = Toggles.GIFTGetter or lastGiftGetter

                if (not (text == lastGiftGetter and Toggles.GIFTGetter)) then
                        Toggles.GIFTGetter = false
                        task.wait()
                        Toggles.GIFTGetter = text
                elseif (text == lastGiftGetter and Toggles.GIFTGetter) then
                        Toggles.GIFTGetter = false
                end

                return print(('HT Test(s): gift getter: %s\n'):format(((not (Toggles.GIFTGetter)) and 'OFF') or 'ON'))
        end

        table.insert(shared.Threads, function()
                return pcall(task.cancel, thread)
        end)
end

print(('HT Test(s): infos:\n\t%s\n\t%s'):format(
        ('loaded script in: %.4f second(s)'):format(tick() - loadTime),
        ('client\'s system: %s [%s]'):format(
                (identifyexecutor and identifyexecutor()) or 'Unknown', game:GetService('UserInputService'):GetPlatform().Name
        )
))

local Window = Library:NewWindow('HT Test(s)')

do
        do
                local MainSection = Window:NewSection('[MAIN] SECTION')
                MainSection:CreateToggle('NPC Getter', function(bool)
                        return NPC(bool)
                end)
        end

        do
                local EventSection = Window:NewSection('[EVENT] SECTION')

                EventSection:CreateDropdown('NORMAL Gifts', {'[1] Gold Getter'}, 1, function(text)
                        return GIFT(text)
                end)
                EventSection:CreateDropdown('EGGS Gifts', {'[2] Gold Getter', '[2] Silver Getter', '[2] Bronze Getter'}, 1, function(text)
                        return GIFT(text)
                end)
        end

        Window:NewSection('MADE BY: Dexxter')
end