extends Node2D

onready var btn = $btn

export var reference_path = ""
export(bool) var start_focused = false
var yclicked = false
export var ytxt = "tst2" 

func _ready():
	btn.text = ytxt
	if(start_focused):
		btn.grab_focus()
		
	btn.connect("mouse_entered",self,"_on_Button_mouse_entered")
	btn.connect("pressed",self,"_on_Button_Pressed")

func _on_Button_mouse_entered():
	btn.grab_focus()

func _on_Button_Pressed():
	yclicked = true
	#print("click")
	#	get_tree().change_scene(reference_path)
	#	get_tree().quit()
