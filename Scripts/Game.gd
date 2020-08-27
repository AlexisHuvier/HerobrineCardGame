extends Node2D

var current_level = 0
var sm = 2
var life_ennemy = 1
var life_player = 20
var player_state = true
var player_move = {}
var current_select = null

onready var deck = load_json("res://Data/player.json")

onready var hand_node = get_node("Hand")
onready var ennemies_node = get_node("Ennemies")
onready var played_node = get_node("Played")
onready var sm_node = get_node("SM")
onready var lvl_node = get_node("LVL")
onready var name_node = get_node("Name")
onready var life_ennemy_node = get_node("LifeEnnemy")
onready var life_player_node = get_node("LifePlayer")
onready var endtourbutton_node = get_node("EndTourButton")

func _ready():
	for i in range(0, 7):
		var nb = rand_range(0, deck.deck.size())
		hand_node.add_child(create_card(deck.cards[deck.deck[nb]], 200 + i* 150, 650))
		deck.deck.remove(nb)
	load_level(current_level)
	sm_node.text = "SM : "+str(sm)
	lvl_node.text = "Niveau : "+str(current_level+1)
	life_player_node.text = "Vie : "+str(life_player)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			for cardid in range(hand_node.get_child_count()):
				var card = hand_node.get_child(cardid)
				if card_collide_pos(event.position, card):
					if sm > 0 && player_state:
						sm -= 1
						played_node.add_child(create_card(card.card, 200 + played_node.get_child_count() * 150, 400, 0.45))
						card.queue_free()
						sm_node.text = "SM : "+str(sm)
					return
			for cardid in range(played_node.get_child_count()):
				var card = played_node.get_child(cardid)
				if card_collide_pos(event.position, card):
					if player_state:
						if current_select == card:
							card.get_node("Sprite").modulate = Color(1, 1, 1)
							current_select = null
						else:
							card.get_node("Sprite").modulate = Color(1.5, 1.5, 1.5)
							if current_select != null:
								current_select.get_node("Sprite").modulate = Color(1, 1, 1)
							current_select = card
					return
			for cardid in range(ennemies_node.get_child_count()):
				var card = ennemies_node.get_child(cardid)
				if card_collide_pos(event.position, card):
					if player_state:
						if current_select != null:
							player_move[current_select] = card
							current_select.get_node("Sprite").modulate = Color(1, 1, 1)
							current_select = null 
					return
				
func card_collide_pos(event_position, card):
	var pos = card.position - (card.get_node("Sprite").texture.get_size() * 0.25)
	if Rect2(pos, card.get_node("Sprite").texture.get_size() * 0.5).has_point(event_position):
		return true
	return false

func load_level(level):
	for child in ennemies_node.get_children():
		child.queue_free()
	
	var levels = load_json("res://Data/levels.json")
	for i in range(0, levels[level].ennemies.size()):
		ennemies_node.add_child(create_card(levels[level].ennemies[i], 200+i*150, 200, 0.45))
	name_node.text = levels[level].name
	name_node.rect_position = Vector2(640 - name_node.rect_size.x / 2, 14)
	life_ennemy = levels[level].life
	life_ennemy_node.text = "Vie : "+str(life_ennemy)

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

func _on_EndTourButton_pressed():
	if player_state:
		player_state = false
		endtourbutton_node.disabled = true
		
		#Apply Player Moves
		for i in player_move:
			player_move[i].card_json.defense -= i.card_json.attack
			if player_move[i].card_json.defense <= 0:
				ennemies_node.remove_child(player_move[i])
				player_move[i].queue_free()
				
		#Attack Ennemy if he doesn't have played cards
		if ennemies_node.get_child_count() == 0:
			for i in played_node.get_children():
				if not player_move.has(i):
					life_ennemy -= i.card_json.attack
					life_ennemy_node.text = "Vie : "+str(life_ennemy)
				
		if life_ennemy <= 0:
			get_node("Victoire").visible = true
		elif life_player <= 0:
			get_node("Defaite").visible = true
		else:
			player_move = {}
			player_state = true
			endtourbutton_node.disabled = false
