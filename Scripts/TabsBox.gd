extends Node2D

func _ready():
	pass

func load_tabs_window(info_json, card_json):
	var info_tab = get_node("TabContainer/Tabs").duplicate()
	info_tab.name = "Informations"
	get_node("TabContainer").add_child(info_tab)
	load_tab("Informations", info_json["informations"], card_json)
	var stats_tab = get_node("TabContainer/Tabs").duplicate()
	stats_tab.name = "Statistiques"
	get_node("TabContainer").add_child(stats_tab)
	load_tab("Statistiques", info_json["statistiques"], card_json)
	get_node("TabContainer/Tabs").queue_free()

func load_tab(tab_name, data, card_json):
	var new_para
	var text
	name = tab_name+"_data"
	text = data.replace("%a%", card_json["attack"]).replace("%d%", card_json["defense"]).replace("%i%", card_json["initiative"]).replace("%sm%", card_json["SM"])
	new_para = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").duplicate()
	new_para.name = name
	get_node("TabContainer/" + tab_name + "/TabVBoxContainer").add_child(new_para)
	get_node("TabContainer/" + tab_name + "/TabVBoxContainer/" + name + "/Text").set_text(text)
	get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").queue_free()

func _on_Button_pressed():
	self.queue_free()
