local messages = {}
local offset = 0.125
local chat = false -- if you want messages to be duplicated in chat
local messagesColor = {164, 98, 193, 215} -- r,g,b,a

local function DrawText3D(x ,y, z, text, color)
	local r,g,b,a = {255, 255, 255, 215}
	if color then
		r,g,b,a = table.unpack(color)
	end
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local p = GetGameplayCamCoords()
  local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
  local scale = (1 / distance) * 2
  local fov = (1 / GetGameplayCamFov()) * 100
  local scale = scale * fov
  if onScreen then
		SetTextScale(0.5, 0.5)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(r, g, b, a)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		-- local factor = (string.len(text)) / 370
		-- DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    end
end


local function AddMessage(type, msg, color, owner, timeout)
	if not messages[owner] then
		messages[owner] = {}
	end

	table.insert(messages[owner], {
		type = type,
		msg = msg,
		color = color
	})
	SetTimeout(timeout, function()
		table.remove(messages[owner], 1)
		if #messages[owner] == 0 then
			messages[owner] = nil
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		for k,v in pairs(messages) do
			for i,d in pairs(messages[k]) do
				local x,y,z = table.unpack(GetEntityCoords(k))
				z = z + 0.9 + offset*i
				DrawText3D(x, y, z, d.type..' | '..d.msg, d.color)
			end
		end
		
		Wait(0)
	end
end)

RegisterNetEvent('sendMessageMe')
AddEventHandler('sendMessageMe', function(id, name, message)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
		if chat then
			TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 me | " .. name .."  ".."^6  " .. message )
		end
		AddMessage('me', message, messagesColor, PlayerPedId(), 10000)
	elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(sonid)), true) < 7.01 and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(sonid), 17) == 1 then
		if chat then
			TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 me | " .. name .."  ".."^6  " .. message )
		end
		AddMessage('me', message, messagesColor, GetPlayerPed(sonid), 10000)
	end
end)

RegisterNetEvent('sendMessageDo')
AddEventHandler('sendMessageDo', function(id, name, message)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
		if chat then
			TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 do | " .. message .."  ".."^6 ((" .. name .. "))")
		end
		AddMessage('do', message, messagesColor, PlayerPedId(), 10000)
	elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(sonid)), true) < 7.01 and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(sonid), 17) == 1 then
		if chat then
			TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 do | " .. message .."  ".."^6 ((" .. name .. "))")
		end
		AddMessage('do', message, messagesColor, GetPlayerPed(sonid), 10000)
	end
end)

RegisterNetEvent('sendMessageTry')
AddEventHandler('sendMessageTry', function(id, name, message, result)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	local resultMessages = {"^2Success", "^1Failure"}
	local resultMessage = resultMessages[result]
	if sonid == monid then
		if chat then
			TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 try | " .. name .."  ".."^6  " .. message .. " ((".. resultMessage .."^6))")
		end
		AddMessage('try', message.." (("..string.sub(resultMessage, 3).."))", messagesColor, PlayerPedId(), 10000)
	elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(sonid)), true) < 7.01 and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(sonid), 17) == 1 then
		if chat then
			TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 try | " .. name .."  ".."^6  " .. message .. " ((".. resultMessage .."^6))")
		end
		AddMessage('try', message.." (("..string.sub(resultMessage, 3).."))", messagesColor, GetPlayerPed(sonid), 10000)
	end
end)

RegisterNetEvent('sendMessageOOC')
AddEventHandler('sendMessageOOC', function(id, name, message)
	local monid = PlayerId()
	local sonid = GetPlayerFromServerId(id)
	if sonid == monid then
		TriggerEvent('chatMessage', "", {255, 0, 0}, "^9 OOC | ^7" .. name ..": " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(sonid)), true) < 7.01 and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(sonid), 17) == 1 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, "^9 OOC | ^7" .. name ..": " .. message)
	end
end)