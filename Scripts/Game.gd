extends Node2D

var current_level = Database.player["current_level"]
var sm = 2
var life_ennemy = 1
var life_player = 20
var player_state = true
var player_move = {}
var current_select = null
var level_ennemies = null
var rnd = 0

onready var deck = load_deck()

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
	for _i in range(0, 7):
		var nb = rand_range(0, deck.size())
		hand_node.add_child(create_card(deck[nb], 200 + hand_node.get_child_count() * 150, 650))
		deck.remove(nb)
	load_level()
	sm_node.text = "SM : "+str(sm)
	lvl_node.text = "Niveau : "+str(current_level)
	life_player_node.text = "Vie : "+str(life_player)
	
func render():
	for i in range(hand_node.get_child_count()):
		hand_node.get_child(i).position.x = 200 + i * 150
	for i in range(played_node.get_child_count()):
		played_node.get_child(i).position.x = 200 + i * 150
	for i in range(ennemies_node.get_child_count()):
		ennemies_node.get_child(i).position.x = 200 + i * 150

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and event.doubleclick:
		for cardid in range(hand_node.get_child_count()):
			var card = hand_node.get_child(cardid)
			if card_collide_pos(event.position, card):
				if sm >= card.card_json["SM"] && player_state && played_node.get_child_count() < 7:
					sm -= card.card_json["SM"]
					played_node.add_child(create_card(card.card, 200 + played_node.get_child_count() * 150, 400, 0.45))
					hand_node.remove_child(card)
					card.queue_free()
					sm_node.text = "SM : "+str(sm)
					render()
				return
		for cardid in range(played_node.get_child_count()):
			var card = played_node.get_child(cardid)
			if card_collide_pos(event.position, card):
				if player_state:
					if current_select == card:
						card.get_node("SpriteCard").modulate = Color(1, 1, 1)
						card.get_node("BackSprite").modulate = Color(1, 1, 1)
						current_select = null
					else:
						card.get_node("SpriteCard").modulate = Color(1.5, 1.5, 1.5)
						card.get_node("BackSprite").modulate = Color(1.5, 1.5, 1.5)
						if current_select != null:
							current_select.get_node("SpriteCard").modulate = Color(1, 1, 1)
							current_select.get_node("BackSprite").modulate = Color(1, 1, 1)
						current_select = card
				return
		for cardid in range(ennemies_node.get_child_count()):
			var card = ennemies_node.get_child(cardid)
			if card_collide_pos(event.position, card):
				if player_state:
					if current_select != null:
						player_move[current_select] = card
						current_select.get_node("SpriteCard").modulate = Color(1, 1, 1)
						current_select.get_node("BackSprite").modulate = Color(1, 1, 1)
						current_select = null 
				return
				
func card_collide_pos(event_position, card):
	var pos = card.position - (card.get_node("Sprite").texture.get_size() * (card.scale.x / 2))
	if Rect2(pos, card.get_node("Sprite").texture.get_size() * card.scale.x).has_point(event_position):
		return true
	return false

func load_level():
	for child in ennemies_node.get_children():
		child.queue_free()
	
	var level = Database.db.select_rows("levels", "id = "+str(current_level), ["*"])[0]
	level_ennemies = []
	for i in Database.db.select_rows("levels_cards", "id_level = "+str(current_level), ["*"]):
		var ennemies = []
		if i["id_card_1"] != 0:
			ennemies.append(i["id_card_1"])
		if i["id_card_2"] != 0:
			ennemies.append(i["id_card_2"])
		if i["id_card_3"] != 0:
			ennemies.append(i["id_card_3"])
		level_ennemies.append(ennemies)
	name_node.text = level["name"]
	name_node.rect_position = Vector2(640 - name_node.rect_size.x / 2, 14)
	life_ennemy = level["life"]
	life_ennemy_node.text = "Vie : "+str(life_ennemy)
	load_ennemies()
	
func load_ennemies():
	if rnd < level_ennemies.size():
		for i in range(0, level_ennemies[rnd].size()):
			ennemies_node.add_child(create_card(level_ennemies[rnd][i], 200 + ennemies_node.get_child_count() * 150, 200, 0.45))

func create_card(name, x, y, scale=0.5, rotation=0):
	var card = load("res://Scenes/Card.tscn").instance()
	card.card = name
	card.position = Vector2(x, y)
	card.scale = Vector2(scale, scale)
	card.rotation_degrees = rotation
	return card

func load_deck():
	var cards = []
	for i in Database.db.select_rows("player_card", "", ["*"]):
		if i["deck"]:
			cards.append(i["id_card"])
	return cards

func _on_EndTourButton_pressed():
	if player_state:
		player_state = false
		endtourbutton_node.disabled = true
		
		var moves = []
		var dont_use = []
		
		for i in ennemies_node.get_children():
			if played_node.get_child_count() != 0:
				moves.append([i, played_node.get_children()[0]])
			else:
				life_player -= i.card_json.attack
				life_player_node.text = "Vie : "+str(life_player)
		
		for i in player_move:
			moves.append([i, player_move[i]])
		
		for initiative in range(10, 0, -1):
			for move in moves:
				if move[0].card_json.initiative == initiative and not dont_use.has(move[0]):
					move[1].card_json.defense -= move[0].card_json.attack
					if move[1].card_json.defense <= 0:
						move[1].queue_free()
						if move[1].card_json.initiative != initiative:
							dont_use.append(move[1])
				
		#Attack Ennemy if he doesn't have played cards
		if ennemies_node.get_child_count() == 0:
			for i in played_node.get_children():
				if not player_move.has(i):
					life_ennemy -= i.card_json.attack
					life_ennemy_node.text = "Vie : "+str(life_ennemy)

		render()
				
		if life_ennemy <= 0:
			get_node("Victoire").visible = true
			get_node("NextButton").visible = true
		elif life_player <= 0:
			get_node("Defaite").visible = true
			get_node("MenuButton").visible = true
		else:
			player_move = {}
			player_state = true
			endtourbutton_node.disabled = false
			rnd += 1
			sm = rnd + 2
			if sm > 10:
				sm = 10
			sm_node.text = "SM : "+str(sm)
			if hand_node.get_child_count() < 7 and deck.size():
				var nb = rand_range(0, deck.size())
				hand_node.add_child(create_card(deck[nb], 200 + hand_node.get_child_count() * 150, 650))
				deck.remove(nb)
			load_ennemies()
			render()

func _on_MenuButton_pressed():
	if get_tree().change_scene("res://Scenes/Main.tscn")!= OK:
		push_error("[Error] Loading Scene failed (Main)")
		get_tree().quit()

func _on_NextButton_pressed():
	Database.db.update_rows("player", "current_level = "+str(current_level), {"current_level": current_level+1})
	current_level += 1
	if current_level != 4:
		for child in hand_node.get_children():
			hand_node.remove_child(child)
			child.queue_free()
		for child in played_node.get_children():
			played_node.remove_child(child)
			child.queue_free()
		for child in ennemies_node.get_children():
			ennemies_node.remove_child(child)
			child.queue_free()
		
		get_node("Victoire").visible = false
		get_node("NextButton").visible = false
		sm = 2
		life_ennemy = 1
		life_player = 20
		player_state = true
		endtourbutton_node.disabled = false
		player_move = {}
		current_select = null
		level_ennemies = null
		rnd = 0
		deck = load_deck()
		
		for _i in range(0, 7):
			var nb = rand_range(0, deck.size())
			hand_node.add_child(create_card(deck[nb], 200 + hand_node.get_child_count() * 150, 650))
			deck.remove(nb)
		load_level()
		sm_node.text = "SM : "+str(sm)
		lvl_node.text = "Niveau : "+str(current_level)
		life_player_node.text = "Vie : "+str(life_player)
	else:
		get_node("NextButton").disabled = true
