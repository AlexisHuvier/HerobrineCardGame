extends Node2D

var hand_cards = []
var current_level = 2

onready var deck = load_json("res://Data/player.json")

onready var hand_node = get_node("Hand")
onready var ennemies_node = get_node("Ennemies")

func _ready():
	for _i in range(0, 7):
		var nb = rand_range(0, deck.deck.size())
		hand_cards.append(deck.cards[deck.deck[nb]])
		deck.deck.remove(nb)
	update_hand()
	load_level(current_level)
	
func update_hand():
	for child in hand_node.get_children():
		child.queue_free()
	
	for cardid in range(0, hand_cards.size()):
		hand_node.add_child(create_card(hand_cards[cardid], 200 + cardid* 150, 650))

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
