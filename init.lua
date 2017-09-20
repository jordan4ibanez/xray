--if you use this in a server, you're an asshole

local ores = {
"default:stone_with_coal",
"default:stone_with_copper",
"default:stone_with_diamond",
"default:stone_with_gold",
"default:stone_with_iron",
"default:stone_with_mese",
"default:stone_with_tin",
}

local xray_formspec_items = "size[6,6]" ..
		
		"bgcolor[#000000;false]" ..
		
		"button_exit[5.2,-0.15;1,0.7;close;×]" ..
		
		"label[0.6,0;XRAY]" ..
		
		
		--visible setting
		"label[0.1,1.1;Marked Ore:]" ..
		"dropdown[0.1,2;6;ore;,"
		
for _,i in pairs(ores) do
	xray_formspec_items = xray_formspec_items .. i .. ","
end
		
xray_formspec_items = xray_formspec_items..";1]"


local ore_detecting = ""
local nearest_ore

---MODIFYING


minetest.register_chatcommand("xray", {
	description = "Find ores",
	func = function()
		--print("test")
		show_xray_formspec()
end})

function show_xray_formspec()
	minetest.show_formspec("xray", 
		xray_formspec_items
	)
end

--recieve fields
minetest.register_on_formspec_input(function(formname, fields)
	if formname == "xray" and not fields.quit then
		if fields.ore then
			ore_detecting = fields.ore
		end
	end
end)


---

local localplayer
minetest.register_on_connect(function()
	localplayer = minetest.localplayer
	show_xray_formspec()
end)

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 0.3 then
		timer = 0
		if localplayer then
			if ore_detecting ~= "" then
				nearest_ore = minetest.find_node_near(localplayer:get_pos(), 50, ore_detecting, true)
			end
			
			if nearest_ore then
				local distance = vector.distance(localplayer:get_pos(), nearest_ore)
				
				local real_distance = vector.subtract(localplayer:get_pos(), nearest_ore)
				
				minetest.display_chat_message("DISTANCE:"..distance.."\nExact Distance:\nX:"..real_distance.x.."\nY:"..real_distance.y.."\nZ:"..real_distance.z.."\n\n")
			end
				
		end
	end

end)

