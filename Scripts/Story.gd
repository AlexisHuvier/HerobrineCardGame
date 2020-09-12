extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0

onready var text = get_node("Text")

func _process(_delta):
	if text.rect_position.y > -text.rect_size.y+800:
		time += 1
		if time >= 2:
			time = 0
			text.rect_position.y -= 1
	
	if Input.is_action_just_pressed("ui_accept"):
		if get_tree().change_scene("res://Scenes/Game.tscn") != OK:
			push_error("[Error] Loading Scene failed (Game)")
			get_tree().quit()
