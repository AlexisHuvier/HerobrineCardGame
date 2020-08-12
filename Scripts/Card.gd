extends Node2D

export var card = "sylkabe"

func _ready():
	var card_json = load_card(card)
	if card_json != null:
		get_node("Title").set_text(card_json["name"])
	
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
