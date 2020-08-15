extends Node2D

func _ready():
	pass

func load_tabs_window(tabs_data):
	var new_tab
	for tab_name in tabs_data.keys():
		new_tab = get_node("TabContainer/Tabs").duplicate()
		new_tab.name = tab_name
		get_node("TabContainer").add_child(new_tab)
		load_para(tab_name, tabs_data[tab_name])
	get_node("TabContainer/Tabs").queue_free()

func load_para(tab_name, paragraphs_data):
	var new_para
	for paragraph_name in paragraphs_data.keys():
		new_para = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").duplicate()
		new_para.name = paragraph_name
		get_node("TabContainer/" + tab_name + "/TabVBoxContainer").add_child(new_para)
		load_text(tab_name, paragraph_name, paragraphs_data[paragraph_name])
	get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").queue_free()

func load_text(tab_name, paragraph_name, text_data):
	var title = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/" + paragraph_name + "/Title")
	var text = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/" + paragraph_name + "/Text")
	title.set_text(paragraph_name)
	text.set_text(text_data)
	text.set_scale(Vector2(1.2, 1.2))
