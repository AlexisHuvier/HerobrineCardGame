extends Node2D

onready var deck = load_deck()
onready var cards = get_node("Cards")
onready var deckcards = get_node("DeckCards")


# Called when the node enters the scene tree for the first time.
func _ready():
	render()

func render():
	for child in cards.get_children():
		child.queue_free()
	for child in deckcards.get_children():
		child.queue_free()
	
	for cardid in deck.cards.size():
		var card = create_card(deck.cards[cardid], 115 + cardid % 5 * 175, 200 + cardid / 5 * 225)
		if cardid in deck.deck:
			card.get_node("SpriteCard").modulate = Color(0.5, 0.5, 0.5)
			card.get_node("BackSprite").modulate = Color(0.5, 0.5, 0.5)
		cards.add_child(card)
		
	for cardid in deck.deck.size():
		deckcards.add_child(create_card(deck.cards[deck.deck[cardid]], 1100, 200 + cardid * 75))

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			for cardid in range(cards.get_child_count()):
				var card = cards.get_child(cardid)
				var pos = card.position - (card.get_node("BackSprite").texture.get_size() * (card.scale.x / 2))
				pos.y += cards.position.y
				if Rect2(pos, card.get_node("BackSprite").texture.get_size() * card.scale.x).has_point(event.position):
					var find = false
					for cid in range(deck.deck.size()):
						if deck.deck[cid] == cardid:
							deck.deck.remove(cid)
							find = true
							break
					if not find:
						deck.deck.append(cardid)
						deck.deck.sort()
					render()
					break
		elif event.button_index == BUTTON_WHEEL_UP:
			if event.position.x < 1000:
				if cards.position.y < 0:
					cards.position.y += 10
			else:
				if deckcards.position.y < 0:
					deckcards.position.y += 10
		elif event.button_index == BUTTON_WHEEL_DOWN:
			if event.position.x < 1000:
				if 800 < cards.get_child(cards.get_child_count() - 1).position.y + (420 * 0.25) + cards.position.y + 10 :
					cards.position.y -= 10
			else:
				if 800 < deckcards.get_child(deckcards.get_child_count() - 1).position.y + (420 * 0.25) + deckcards.position.y + 10:
					deckcards.position.y -= 10

func load_deck():
	var file = File.new()
	if file.open("res://Data/player.json", file.READ) != OK:
		push_error("[Error] Opening File failed (res://Data/player.json)")
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

func create_card(name, x = null, y = null, scale=0.5, rotation=0):
	var card = load("res://Scenes/Card.tscn").instance()
	card.card = name
	if x != null || y != null:
		card.position = Vector2(x, y)
	card.scale = Vector2(scale, scale)
	card.rotation_degrees = rotation
	return card


func _on_Button_pressed():
	if get_tree().change_scene("res://Scenes/Main.tscn")!= OK:
		push_error("[Error] Loading Scene failed (Main)")
		get_tree().quit()


func _on_Button2_pressed():
	if deck.deck.size() >= 15: 
		var file = File.new()
		if file.open("res://Data/player.json", file.WRITE) != OK:
			push_error("[Error] Opening File failed (res://Data/player.json)")
			get_tree().quit()
		else:
			var text = JSON.print(deck)
			file.store_string(text)
			file.close()
	else:
		OS.alert("Votre deck n'a pas assez de cartes.\nIl faut 15 cartes au minimum.", "Deck incomplet")
