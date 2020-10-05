extends Node2D

#Name of the card:
export var card = "sylkabe"
#Global for card data from JSON:
var card_json = null
#Actual cursor position compared to the card:
var mouse_subjective_position = "out"
#Save general scale:
var save_card_scale
#Save info_button scale:
var save_info_button_scale = null

func _ready():
	save_card_scale = get_scale()
	save_info_button_scale = get_node("Sprite/InfoButtonSprite").get_scale()
	card_json = load_card(card)
	if card_json != null:
		load_texture()
		get_node("Label").set_text(str(card_json["SM"]))

func load_card(name): #load data from JSON
	return Database.db.select_rows("cards", "id = "+str(name), ["*"])[0]

func load_texture():
	var texture = ImageTexture.new()
	if (card_json["texture"] != null && card_json["texture"] != ""):
		var image_path = "res://Assets/Images/Cards/" + card_json["texture"] + ".png"
		print(image_path)
		texture = load(image_path)
		if texture == null:
			push_error("[Error] Opening File failed (" + image_path + ")")
			get_tree().quit()
		else:
			get_node("SpriteCard").set_texture(texture)
			get_node("SpriteCard").scale = Vector2(card_json["texture_scale"], card_json["texture_scale"])
			return 1
	return 0


func _on_Area2D_mouse_entered(): #mouse enter card area
	var multi = 1.2
	var scale = save_card_scale
	scale.x *= multi
	scale.y *= multi
	mouse_subjective_position = "in_card"
	set_scale(scale)

func _on_Area2D_mouse_exited(): #mouse exit card area
	var scale = save_card_scale
	mouse_subjective_position = "out"
	set_scale(scale)


func _on_InfoButtonArea2D_mouse_entered():
	var node = get_node("Sprite/InfoButtonSprite")
	var multi = 1.2
	var scale = save_info_button_scale
	scale.x *= multi
	scale.y *= multi
	mouse_subjective_position = "in_info"
	node.set_scale(scale)

func _on_InfoButtonArea2D_mouse_exited():
	var node = get_node("Sprite/InfoButtonSprite")
	var scale = save_info_button_scale
	mouse_subjective_position = "in_card"
	node.set_scale(scale)

func _input(event):
	if event is InputEventMouseButton && mouse_subjective_position == "in_info":
		var info = load("res://Scenes/TabsBox.tscn").instance()
		if ("infos_display" in card_json):
			info.load_tabs_window(card_json)
			get_parent().get_parent().add_child(info)
