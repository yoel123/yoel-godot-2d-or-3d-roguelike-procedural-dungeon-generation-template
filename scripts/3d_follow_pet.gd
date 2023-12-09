extends KinematicBody

#we get these from ready in 3drouglike script
var navigation
var player

var speed = 250

var dir 
var velocity = Vector3()

func _ready():
	pass 

func _process(delta):
	get_dir()
	move(delta)
	
func get_dir():

	dir = Vector3()
	var player_pos = player.transform.origin #player positiom
	var my_pos = transform.origin #this charecter pos (the follow pet_
	
	var points = navigation.get_simple_path(my_pos, player_pos)
	if points.size() > 1:
		var distance = (my_pos - player_pos).length()
		if distance > 1:
			dir = (points[1] - my_pos)
#end get_dir

func move(delta):
	dir.y = 0
	velocity = dir.normalized() * speed * delta
	move_and_slide(velocity , Vector3.UP)
