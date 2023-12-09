extends Node

#add to code like this:
#var ye = load("res://yframework2d.gd").new()



func ymove_by(that,x,y,delta):
	var motion = Vector2()
	motion.x +=x
	motion.y +=y
		
	that.move_and_slide(motion *delta)
#end ymove_by

func yrotate(that,x,y,z):
	that.rotate_y(deg2rad(y))
	that.rotate_x(deg2rad(x))
	that.rotate_z(deg2rad(z))

func hit_test(that,ytype):
	for i in that.get_slide_count():
		var collision = that.get_slide_collision(i)
		if collision.collider.is_in_group(ytype):
			return collision.collider
			
#end hit_test

func mouce_pos(that):
	return that.get_viewport().get_mouse_position()
#end mouce_pos


func get_object_under_mouse(that,cam,ray_len):
	var mouse_pos = that.get_viewport().get_mouse_position()
	var ray_from = cam.project_ray_origin(mouse_pos)
	var ray_to = ray_from + cam.project_ray_normal(mouse_pos) * ray_len
	var space_state = that.get_tree().root.get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
#end get_object_under_mouse

func get_object_under_mouse_rand(that,cam,ray_len,x,y):
	var mouse_pos = that.get_viewport().get_mouse_position()
	mouse_pos.x +=x
	mouse_pos.y +=y
	var ray_from = cam.project_ray_origin(mouse_pos)
	var ray_to = ray_from + cam.project_ray_normal(mouse_pos) * ray_len
	var space_state = that.get_tree().root.get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection
#end get_object_under_mouse


func get_ray(that,from,to):
	var space_state = that.get_tree().root.get_world().direct_space_state
	var selection = space_state.intersect_ray(from, to)
	return selection
#end get_ray

func get_by_type(that,type):
	return that.get_parent().get_tree().get_nodes_in_group(type)

func make_timer(that,time,callback_name,ystart):
	var ytimer = Timer.new()
	ytimer.set_wait_time(time)
	ytimer.connect("timeout",that, callback_name)

	if ystart:
		ytimer.start()
	that.add_child(ytimer)
	return ytimer
#end make_timer

func deep_copy_dict(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy_dict(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy_dict(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v
#end deeo copy dict
