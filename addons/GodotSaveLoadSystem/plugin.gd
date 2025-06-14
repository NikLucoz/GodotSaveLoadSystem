@tool
extends EditorPlugin

const AUTOLOAD_NAME = "SaveLoadSystem"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/GodotSaveLoadSystem/save_load_system.gd")

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
