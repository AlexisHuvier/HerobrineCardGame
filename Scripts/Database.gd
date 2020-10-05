extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db

func _ready():
	db = SQLite.new()
	db.path = "res://data.db"
	db.open_db()

func stop():
	db.close_db()
