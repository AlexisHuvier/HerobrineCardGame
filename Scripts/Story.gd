extends Node2D

onready var text = get_node("Text")

func _process(delta):
	if text.rect_position.y > -text.rect_size.y+780:
		text.rect_position.y -= 50 * delta
			
	
	if Input.is_action_just_pressed("ui_accept"):
		if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
			push_error("[Error] Loading Scene failed (Game)")
			get_tree().quit()
