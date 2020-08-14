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
		if !(load_texture()):
			get_node("Title").set_text(card_json["name"])
		else:
			get_node("Title").set_text("")

func load_card(name): #load data from JSON
	var file = File.new()
	var json_card_path = "res://Data/Cards/"+name+".json"
	if file.open(json_card_path, file.READ) != OK:
		push_error("[Error] Opening File failed (" + json_card_path + ")")
		get_tree().quit()
	else:
		var text = file.get_as_text()
		var json = JSON.parse(text)
		if json.error != OK:
			push_error("[Error] JSON Parsing failed : (" + json.error_line + ") " + json.error_string)
			get_tree().quit()
		else:
			return json.result

func load_texture():
	var texture = ImageTexture.new()
	if ("texture" in card_json && card_json["texture"] != null):
		var image_path = "res://Assets/" + card_json["texture"] + ".png"
		texture = load(image_path)
		if texture == null:
			push_error("[Error] Opening File failed (" + image_path + ")")
			get_tree().quit()
		else:
			get_node("Sprite").set_texture(texture)
			return (1)
	return (0)


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

func _unhandled_input(event):
	if event is InputEventMouseButton && mouse_subjective_position == "in_info":
		var info = load("res://Scenes/TabsBox.tscn").instance()
		if ("infos_display" in card_json):
			info.load_info(card_json["infos_display"])
			get_parent().add_child(info)
