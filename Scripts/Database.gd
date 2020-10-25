extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var player

func _ready():
	db = SQLite.new()
	db.path = "res://data.db"
	db.open_db()
	player = db.select_rows("player", "", ["*"])[0]

func stop():
	db.close_db()
