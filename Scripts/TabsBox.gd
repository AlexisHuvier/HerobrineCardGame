extends Node2D

func _ready():
	pass

func load_tabs_window(card_json):
	var new_tab
	var tabs_data = card_json["infos_display"]
	for tab_name in tabs_data.keys():
		new_tab = get_node("TabContainer/Tabs").duplicate()
		new_tab.name = tab_name
		get_node("TabContainer").add_child(new_tab)
		load_para(tab_name, tabs_data[tab_name], card_json)
	get_node("TabContainer/Tabs").queue_free()

func load_para(tab_name, paragraphs_data, card_json):
	var new_para
	var text
	for i in range(len(paragraphs_data)):
		name = tab_name+"_"+str(i)
		text = paragraphs_data[i].replace("%a%", card_json["attack"]).replace("%d%", card_json["defense"]).replace("%i%", card_json["initiative"]).replace("%sm%", card_json["SM"])
		new_para = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").duplicate()
		new_para.name = name
		get_node("TabContainer/" + tab_name + "/TabVBoxContainer").add_child(new_para)
		get_node("TabContainer/" + tab_name + "/TabVBoxContainer/" + name + "/Text").set_text(text)
	get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").queue_free()

func _on_Button_pressed():
	self.queue_free()
