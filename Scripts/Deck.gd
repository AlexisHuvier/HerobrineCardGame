extends Node2D

onready var deck = load_deck()
onready var cards = get_node("Cards")
onready var deckcards = get_node("DeckCards")


# Called when the node enters the scene tree for the first time.
func _ready():
	render()

func render():
	for child in cards.get_children():
		cards.remove_child(child)
		child.queue_free()
	for child in deckcards.get_children():
		deckcards.remove_child(child)
		child.queue_free()
	
	for cardid in range(deck.size()):
		var card = create_card(deck[cardid], 115 + cardid % 5 * 175, 200 + cardid / 5 * 225)
		var player_card = Database.db.select_rows("player_card", "id = "+str(cardid+1), ["deck"])[0]
		if player_card["deck"]:
			card.get_node("SpriteCard").modulate = Color(0.5, 0.5, 0.5)
			card.get_node("BackSprite").modulate = Color(0.5, 0.5, 0.5)
			deckcards.add_child(create_card(deck[cardid], 1100, 200 + deckcards.get_child_count() * 75))
		cards.add_child(card)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.doubleclick:
			for cardid in range(cards.get_child_count()):
				var card = cards.get_child(cardid)
				var pos = card.position - (card.get_node("BackSprite").texture.get_size() * (card.scale.x / 2))
				pos.y += cards.position.y
				if Rect2(pos, card.get_node("BackSprite").texture.get_size() * card.scale.x).has_point(event.position):
					var player_card = Database.db.select_rows("player_card", "id = "+str(cardid+1), ["*"])[0]
					Database.db.update_rows("player_card", "id = "+str(player_card["id"]), {"deck": 0 if player_card["deck"] else 1})
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
	cards = []
	for i in Database.db.select_rows("player_card", "", ["id_card"]):
		cards.append(i["id_card"])
	return cards

func create_card(id, x = null, y = null, scale=0.5, rotation=0):
	var card = load("res://Scenes/Card.tscn").instance()
	card.card = id
	if x != null || y != null:
		card.position = Vector2(x, y)
	card.scale = Vector2(scale, scale)
	card.rotation_degrees = rotation
	return card


func _on_Button_pressed():
	if get_tree().change_scene("res://Scenes/Main.tscn")!= OK:
		push_error("[Error] Loading Scene failed (Main)")
		get_tree().quit()
