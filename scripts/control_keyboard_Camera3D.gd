extends Camera

var curPos
var speed = 5

var desiredFov = 90
var fovStep = 3
var maxFov = 210 
var minFov = 30

func _ready():
	
	curPos = transform.origin
	set_process_input(true)
	set_process(true)
	pass

func _input(event):
	if(event is InputEventKey):
		if event.pressed and event.scancode == KEY_W: curPos.z = curPos.z - speed
		if event.pressed and event.scancode == KEY_S: curPos.z = curPos.z + speed
		if event.pressed and event.scancode == KEY_A: curPos.x = curPos.x - speed
		if event.pressed and event.scancode == KEY_D: curPos.x = curPos.x + speed
				
	if Input.is_action_pressed("minus"):
		desiredFov = desiredFov + fovStep	
	if Input.is_action_pressed("plus"):
		desiredFov = desiredFov - fovStep
	desiredFov = clamp(desiredFov, minFov, maxFov)
	self.set_fov(desiredFov)

func _process(delta):
	transform.origin = curPos
	pass
	
	
