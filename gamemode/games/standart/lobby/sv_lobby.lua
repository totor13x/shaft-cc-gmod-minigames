util.AddNetworkString( "ct" )

net.Receive("ct", function(len, ply)
	local t = net.ReadInt(4)
	if not (team.NumPlayers(t)<team.NumPlayers(ply:Team())) then
		ply:SendLua([[cooldown = true timer.Destroy("CDelay")]])
		if t == ply:Team() then ply:SendLua([[notification.AddLegacy("You are already in this team!",1,3)]]) return else 
		ply:SendLua([[notification.AddLegacy("There is too much players in this team!",1,3)]]) return end end
	ply:SetTeam(t)
	ply:KillSilent()
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[notification.AddLegacy("Player ]] .. ply:Nick() .. [[ chaged team",0,3)]])
	end
end)