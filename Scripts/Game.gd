extends Node2D

var current_level = 2
var sm = 2

onready var deck = load_json("res://Data/player.json")

onready var hand_node = get_node("Hand")
onready var ennemies_node = get_node("Ennemies")
onready var played_node = get_node("Played")
onready var sm_node = get_node("SM")

func _ready():
	for i in range(0, 7):
		var nb = rand_range(0, deck.deck.size())
		hand_node.add_child(create_card(deck.cards[deck.deck[nb]], 200 + i* 150, 650))
		deck.deck.remove(nb)
	load_level(current_level)
	sm_node.text = "SM : "+str(sm)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			for cardid in range(hand_node.get_child_count()):
				var card = hand_node.get_child(cardid)
				var pos = card.position - (card.get_node("Sprite").texture.get_size() * 0.25)
				if Rect2(pos, card.get_node("Sprite").texture.get_size() * 0.5).has_point(event.position):
					if sm > 0:
						sm -= 1
						played_node.add_child(create_card(card.card, 200 + played_node.get_child_count() * 150, 400, 0.45))
						card.queue_free()
						sm_node.text = "SM : "+str(sm)
					break

func load_level(level):
	for child in ennemies_node.get_children():
		child.queue_free()
	
	var levels = load_json("res://Data/levels.json")
	for i in range(0, levels[level].size()):
		ennemies_node.add_child(create_card(levels[level][i], 200+i*150, 200, 0.45))

func create_card(name, x, y, scale=0.5, rotation=0):
	var card = load("res://Scenes/Card.tscn").instance()
	card.card = name
	card.position = Vector2(x, y)
	card.scale = Vector2(scale, scale)
	card.rotation_degrees = rotation
	return card

func load_json(jsonfile):
	var file = File.new()
	if file.open(jsonfile, file.READ) != OK:
		push_error("[Error] Opening File failed ("+jsonfile+")")
		get_tree().quit()
	else:
		var text = file.get_as_text()
		file.close()
		var json = JSON.parse(text)
		if json.error != OK:
			push_error("[Error] JSON Parsing failed : (" + json.error_line + ") " + json.error_string)
			get_tree().quit()
		else:
			return json.result
