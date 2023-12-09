extends Node2D


var map_gen =  load("res://scripts/new_map_gen.gd").new()

onready var genrate = $player/genrate
onready var three_d_view = $player/three_d_view
onready var tilemap = $Navigation2D/TileMap
onready var player = $player
onready var navigation = $Navigation2D
onready var cam = $Camera2D
var player_start_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	gen_map_again()
	player.nav2d = navigation
	player.tilemap = tilemap

	#$Camera2D.position = pos
	pass # Replace with function body.

func _process(delta):
	#gui btns clicked handle
	if genrate.yclicked: 
		gen_map_again()
		genrate.yclicked = false
	if three_d_view.yclicked: 
		get_tree().change_scene("res://scenes/3droguelike.tscn")
		three_d_view.yclicked = false
	pass
	
func gen_map_again():
	#put map into tilmap
	map_gen.genrate()
	var tstmap = map_gen.map
	for x in range(tstmap.size()-1):
	  for y in range(tstmap[x].size()-1):
			 tilemap.set_cell( x,y, tstmap[x][y])
	#end put map into tilmap
	#set player pos
	player_rnd_start_pos()
	pass #end

func player_rnd_start_pos():
	#get random point in first room
	player_start_pos = map_gen.get_random_tile_room1()
	
	#remove floor (for debug)
	#tilemap.set_cell(player_start_pos.x,player_start_pos.y,0) 
	#get tilemap xy to screen xy
	player_start_pos = tilemap.map_to_world (player_start_pos)
	
	#adjust to tile scale
	player_start_pos.x *= tilemap.scale.x
	player_start_pos.y *= tilemap.scale.x
	#add tile width hieght
	player_start_pos.x += tilemap.cell_size.x*tilemap.scale.x 
	player_start_pos.y += tilemap.cell_size.y*tilemap.scale.y 
	
	#set player pos
	player.position = player_start_pos
