extends Camera2D

var curPos
var speed = 5
func _ready():
	
	curPos = self.position
	set_process_input(true)
	set_process(true)
	pass

func _input(event):
	if(event is InputEventKey):
		if event.pressed and event.scancode == KEY_W: curPos.y = curPos.y - speed
		if event.pressed and event.scancode == KEY_S: curPos.y = curPos.y + speed
		if event.pressed and event.scancode == KEY_A: curPos.x = curPos.x - speed
		if event.pressed and event.scancode == KEY_D: curPos.x = curPos.x + speed


func _process(delta):
	#self.position = curPos
	pass

