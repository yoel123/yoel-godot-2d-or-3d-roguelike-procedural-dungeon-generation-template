extends Spatial

var map_gen =  load("res://scripts/new_map_gen.gd").new()

onready var genrate = $Control/genrate
onready var two_d_view = $Control/two_d_view
onready var change_cam = $Control/change_cam
onready var yGridMap = $Navigation/NavigationMeshInstance/GridMap
onready var navigation = $Navigation
onready var navigationMeshInstance = $Navigation/NavigationMeshInstance
onready var player3d = $player3d
onready var follow_pet = $follow_pet

var player_start_pos

func _ready():
	update_grid_map()
	follow_pet.navigation   = navigation
	follow_pet.player   = player3d
	
	pass # end ready


func _process(delta):
	#gui btns click handle
	if genrate.yclicked: 
		update_grid_map()
		genrate.yclicked = false
	if two_d_view.yclicked: 
		get_tree().change_scene("res://scenes/roguelike.tscn")
		two_d_view.yclicked = false
	if change_cam.yclicked: 
		player3d.change_cam()
		change_cam.yclicked = false
	pass
	pass



func update_grid_map():
	#put map into tilmap
	map_gen.bigger_coridor = true
	map_gen.genrate()
	var tstmap = map_gen.map
	for x in range(tstmap.size()-1):
		for y in range(tstmap[x].size()-1):
			#if  tstmap[x][y] ==2: tstmap[x][y] = 0
			yGridMap.set_cell_item(x, 0, y, tstmap[x][y])
	player_rnd_start_pos()
	
	#in debug tick "visable navegation" so you can see the new navmash
	#or even better implament your own pathfinding algorithm to traverse
	#the 2d array and convert the cords to 3d (like i did in player_rnd_start_pos func)
	navigationMeshInstance.bake_navigation_mesh(false)

#end update_grid_map			
			
func player_rnd_start_pos():
	#get random point in first room
	player_start_pos = map_gen.get_random_tile_room1()
	
	#remove floor (for debug)
	#yGridMap.set_cell_item (player_start_pos.x,0,player_start_pos.y,0) 
	
	#get tilemap xy to screen xy
	player_start_pos = yGridMap.to_global(yGridMap.map_to_world(player_start_pos.x,0,player_start_pos.y) ) 
	
	#adjust to tile scale
	player_start_pos.x *= yGridMap.cell_scale 
	player_start_pos.z *= yGridMap.cell_scale 
	#add tile width hieght
	#player_start_pos.x += yGridMap.cell_size.x*yGridMap.cell_scale
	#player_start_pos.z += yGridMap.cell_size.z*yGridMap.cell_scale
	
	#set player pos
	player3d.transform.origin = player_start_pos
	
	#do the same for follow pet
	
	var pet_start_pos = map_gen.get_random_tile_room1()
	
	pet_start_pos = yGridMap.to_global(yGridMap.map_to_world(pet_start_pos.x,0,pet_start_pos.y) ) 
	
	follow_pet.transform.origin = pet_start_pos
	follow_pet.transform.origin.z-2
