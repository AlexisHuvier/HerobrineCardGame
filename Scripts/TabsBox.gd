extends Node2D

func _ready():
	pass

func load_info(tabs_data):
	var new_tab
	for tab_name in tabs_data.key:
		new_tab = get_node("TabContainer/Tabs").duplicate()
		new_tab.name = tab_name
		load_para(tab_name, tabs_data[tab_name])

func load_para(tab_name, paragraphs_data):
	var new_para
	for paragraph_name in paragraphs_data.key:
		new_para = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer").duplicate()
		new_para.name = paragraph_name
		load_text(tab_name, paragraph_name, paragraphs_data[paragraph_name])

func load_text(tab_name, paragraph_name, text_data):
	var title = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer" + text_data + "/Title")
	var text = get_node("TabContainer/" + tab_name + "/TabVBoxContainer/ParagraphVBoxContainer" + text_data + "/Text")
	title.Text = paragraph_name.set_text(text_data[0])
	title.Text = paragraph_name.set_text(text_data[1])
