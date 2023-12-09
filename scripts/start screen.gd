extends Control

onready var two_d_rouge = $two_d_rouge
onready var three_d_rouge = $three_d_rouge
onready var credits = $credits
onready var back = $credits_screen/back


func _process(delta):
	if two_d_rouge.yclicked: get_tree().change_scene("res://scenes/roguelike.tscn")
	if three_d_rouge.yclicked: get_tree().change_scene("res://scenes/3droguelike.tscn")
	if credits.yclicked: 
		$credits_screen.visible = true  
		credits.yclicked = false
	if back.yclicked: 
		$credits_screen.visible = false
		back.yclicked = false
	pass
