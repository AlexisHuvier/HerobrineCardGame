extends Node2D

export var card = "sylkabe"
var card_json = null

func _ready():
	card_json = load_card(card)
	if card_json != null:
		if !(load_texture(card_json)):
			get_node("Title").set_text(card_json["name"])
		else:
			get_node("Title").set_text("")

func load_card(name):
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

func load_texture(card_json):
	var texture = ImageTexture.new()
	if ("texture" in card_json):
		var image_path = "res://Assets/" + card_json["texture"] + ".png"
		if texture.load(image_path) != OK:
			push_error("[Error] Opening File failed (" + image_path + ")")
			get_tree().quit()
		else:
			get_node("Sprite").set_texture(texture)
			return (1)
	return (0)
