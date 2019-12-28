AddEventHandler('chatMessage', function(source, n, msg)
  if string.find(msg,'/me') then
    CancelEvent()
    TriggerClientEvent('sendMessageMe', -1, source, GetPlayerName(source), string.sub(msg,4))
  elseif string.find(msg,'/try') then
    CancelEvent()
    local result = math.random(1, 2)
    TriggerClientEvent('sendMessageTry', -1, source, GetPlayerName(source), string.sub(msg,5), result)
  elseif string.find(msg,'/do') then
    CancelEvent()
    TriggerClientEvent('sendMessageDo', -1, source, GetPlayerName(source), string.sub(msg,4))
  else
    CancelEvent()
    TriggerClientEvent('sendMessageOOC', -1, source, GetPlayerName(source), msg)
  end
end)
