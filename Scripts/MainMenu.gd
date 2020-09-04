extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

var current = 1
var time = 0

onready var bg1 = get_node("BG1")
onready var bg2 = get_node("BG2")
onready var bg3 = get_node("BG3")

#	pass
func _ready():
	bg1.modulate = Color(1, 1, 1, 1)
	bg2.modulate = Color(1, 1, 1, 0)
	bg3.modulate = Color(1, 1, 1, 0)
	
func _process(_delta):
	time += 1
	if time >= 70:
		if current == 1:
			bg1.modulate = Color(1, 1, 1, (100 - time) / 30.0)
			bg2.modulate = Color(1, 1, 1, (time - 70) / 30.0)
		elif current == 2:
			bg2.modulate = Color(1, 1, 1, (100 - time) / 30.0)
			bg3.modulate = Color(1, 1, 1, (time - 70) / 30.0)
		else:
			bg3.modulate = Color(1, 1, 1, (100 - time) / 30.0)
			bg1.modulate = Color(1, 1, 1, (time - 70) / 30.0)
		if time == 100:
			time = 0
			current += 1
			if current == 4:
				current = 1

func _on_Button_pressed():
	if get_tree().change_scene("res://Game.tscn") != OK:
		push_error("[Error] Loading Scene failed (Game)")
		get_tree().quit()


func _on_Button2_pressed():
	if get_tree().change_scene("res://Scenes/Deck.tscn")!= OK:
		push_error("[Error] Loading Scene failed (Scenes/Deck)")
		get_tree().quit()


func _on_Button3_pressed():
	get_tree().quit()
