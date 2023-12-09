extends KinematicBody2D

export (int) var speed = 400
export (int) var zoom_speed = 0.25

var velocity = Vector2()

var movment_type = "navigation"#"normal" #grid #navigation

	
var tilepos #player pos on tile (vector2d)

#grid movment
var grid_move_delay_timer = 0.3
var grid_move_delay_timer_count = 0
var can_grid_move
var grid_pos_multiply = 60 

#pathfinding navigation
var nav2d
var tilemap
var nav_points = []
const eps = 5 # at which distance to stop moving
var move_to


		
func get_input():
	if movment_type == "normal":normal_move()
	#if movment_type == "grid":normal_move()
	if movment_type == "navigation": nav_move_click()
		
		
	if Input.is_action_pressed("minus"):
		$Camera2D.zoom.x += zoom_speed
		$Camera2D.zoom.y += zoom_speed
	if Input.is_action_pressed("plus"):
		$Camera2D.zoom.x -= zoom_speed
		$Camera2D.zoom.y -= zoom_speed

func _physics_process(delta):
	get_input()
	
	if movment_type == "normal":move_and_slide(velocity)
	if movment_type == "navigation":nav_move()
	if movment_type == "grid":grid_move(delta)
	
	if !tilemap:return
	tilepos = tilemap.world_to_map(tilemap.to_local(global_position))
	#test tilepos
	#tilemap.set_cell(tilepos.x,tilepos.y,0) 
	#print(global_position)
	#print(tilepos)
	
func set_pos_to_tile(map,mx,my):
	self.position =  map.map_to_world(Vector2(mx,my))
	pass #end
	
func normal_move():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	#if Input.is_action_pressed("ui_select"):
	#	$Camera2D.current = true
	pass#end normal_move
	
func grid_move(delta):
	
	#delay timer
	grid_move_delay_timer_count +=delta
	if grid_move_delay_timer_count >= grid_move_delay_timer:
		grid_move_delay_timer_count = 0
		can_grid_move = true
	if ! can_grid_move:return

	#move by tile sie
	var tile_size_w = tilemap.cell_size.x*tilemap.scale.x 
	var tile_size_h = tilemap.cell_size.y*tilemap.scale.y 
	
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += tile_size_w
		can_grid_move = false
	if Input.is_action_pressed('ui_left'):
		velocity.x -= tile_size_w
		can_grid_move = false
	if Input.is_action_pressed('ui_down'):
		velocity.y += tile_size_h
		can_grid_move = false
	if Input.is_action_pressed('ui_up'):
		velocity.y -= tile_size_h
		can_grid_move = false

	move_and_slide(velocity*grid_pos_multiply)
	pass#end normal_move

func nav_move():
	if(!nav2d || !move_to):return
	# refresh the points in the path
	nav_points = nav2d.get_simple_path(get_global_position(), move_to, false)
	#print(nav_points)
	# if the path has more than one point
	if nav_points.size() > 1:
		var distance = nav_points[1] - get_global_position()
		var direction = distance.normalized() # direction of movement
		if distance.length() > eps or nav_points.size() > 2:
			move_and_slide(direction*speed)
		else:
			move_and_slide(Vector2(0, 0)) # close enough - stop moving
			move_to = null
		update() # we update the node so it has to draw it self again
	pass

func nav_move_click():
	if Input.is_action_pressed("mouse_button_left"):
		move_to = get_global_mouse_position()
		print("click")
			

func _draw():
	
	if movment_type != "navigation": return
	# if there are points to draw red dots
	if nav_points.size() > 1:
		for p in nav_points:
			draw_circle(p - get_global_position(), 8, Color(1, 0, 0)) # we draw a circle (convert to global position first)

