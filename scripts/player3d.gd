extends KinematicBody


var speed = 700
var velocity= Vector3()
var direction
# mouse look
var cam_accel = 40 
var mouse_sense = 0.1 #mouse sensitivity 



# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()
# components
onready var yhead  = $head
onready var camera : Camera = $head/Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _process(delta):
	mouse_look(delta)
	move(delta)
  

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		mouse_look(event)
	pass
	#return mouse control
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		change_cam()
#end _input

func mouse_look(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		yhead.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		yhead.rotation.x = clamp(yhead.rotation.x, deg2rad(-89), deg2rad(89))
#end mouse_look

func move(delta):
	#get keyboard input
	direction = Vector3.ZERO
	velocity = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var h_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
		#make it move
	velocity = velocity.linear_interpolate(direction * speed, delta)

	#print(gravity_vec)
	move_and_slide(velocity, Vector3.UP)
	
	pass
#end move
func change_cam():
	camera.current = !camera.current 
	if camera.current: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
