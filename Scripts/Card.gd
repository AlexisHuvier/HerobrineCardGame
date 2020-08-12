extends Node2D

export var card = "sylkabe"

func _ready():
	var card_json = load_card(card)
	if card_json != null:
		get_node("Title").set_text(card_json["name"])
		load_texture(card_json)
	
func load_card(name):
	var file = File.new()
	if file.open("res://Data/Cards/"+name+".json", file.READ) != OK:
		push_error("[Error] Opening File failed (" + "res://Data/Cards/"+name+".json" + ")")
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
		if texture.load("res://Assets/" + card_json["texture"] + ".png") != OK:
			push_error("[Error] Opening File failed (" + "res://Assets/" + card_json["texture"] + ".png" + ")")
			get_tree().quit()
		else:
			return(get_node("Sprite").set_texture(texture))
		return (false)
