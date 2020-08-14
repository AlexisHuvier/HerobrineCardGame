extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var names = ["lyos", "sylkabe", "eleisya", "fiano", "hugo"]
	for i in range(0, 3):
		for j in range(0, 5):
			add_child(create_card(names[randi() % names.size()], 200 + j* 220, 200 + i * 220, 0.5, rand_range(-90, 90)))

func create_card(name, x, y, scale=0.5, rotation=0):
	var card = load("res://Scenes/Card.tscn").instance()
	card.card = name
	card.position = Vector2(x, y)
	card.scale = Vector2(scale, scale)
	card.rotation_degrees = rotation
	return card
